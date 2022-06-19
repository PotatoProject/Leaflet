import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

class ViewWidget<T extends ViewState> extends StatefulWidget {
  final View<T> view;
  final T state;

  /// If true the state will need to be manually disposed in order to prevent leaks.
  /// Else the state and everything associated will be disposed automatically once the widget leaves the tree
  final bool keepAliveState;

  const ViewWidget({
    required this.view,
    required this.state,
    this.keepAliveState = false,
    Key? key,
  }) : super(key: key);

  @override
  _ViewWidgetState<T> createState() => _ViewWidgetState<T>();
}

class _ViewWidgetState<T extends ViewState> extends State<ViewWidget<T>> {
  @override
  void initState() {
    super.initState();
    widget.state._view = widget.view;
    widget.state._setState = setState;
    widget.state._context = context;
    widget.view._state = widget.state;
    widget.state.initState();
  }

  @override
  void dispose() {
    if (!widget.keepAliveState) {
      widget.state.dispose();
      widget.state._setState = null;
      widget.state._view = null;
      widget.state._context = null;
    }

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ViewWidget<T> old) {
    super.didUpdateWidget(old);

    if (widget.view != old.view) {
      old.view._state = null;
      widget.state._view = widget.view;
      widget.view._state = widget.state;
      widget.state.viewReattached();
    }
  }

  @override
  void activate() {
    super.activate();
    widget.state.activate();
  }

  @override
  void deactivate() {
    super.deactivate();
    widget.state.deactivate();
  }

  @override
  void reassemble() {
    super.reassemble();
    widget.state.reassemble();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.state.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return widget.view.build(context);
  }
}

abstract class ViewState with Diagnosticable {
  @protected
  View get view => _view!;
  View? _view;

  @protected
  StateSetter get setState => _setState!;
  StateSetter? _setState;

  @protected
  BuildContext get context => _context!;
  BuildContext? _context;

  void initState() {}
  void dispose() {}
  void activate() {}
  void deactivate() {}
  void reassemble() {}
  void didChangeDependencies() {}
  void viewReattached() {}
}

abstract class View<T extends ViewState> {
  T get state => _state!;
  T? _state;

  StateSetter get setState => state.setState;

  Widget build(BuildContext context);
}

@optionalTypeArgs
mixin SingleTickerProviderViewStateMixin on ViewState
    implements TickerProvider {
  Ticker? _ticker;

  @override
  Ticker createTicker(TickerCallback onTick) {
    assert(() {
      if (_ticker == null) return true;
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary(
            '$runtimeType is a SingleTickerProviderStateMixin but multiple tickers were created.'),
        ErrorDescription(
            'A SingleTickerProviderStateMixin can only be used as a TickerProvider once.'),
        ErrorHint(
          'If a State is used for multiple AnimationController objects, or if it is passed to other '
          'objects and those objects might use it more than one time in total, then instead of '
          'mixing in a SingleTickerProviderStateMixin, use a regular TickerProviderStateMixin.',
        ),
      ]);
    }());
    _ticker = Ticker(onTick,
        debugLabel: kDebugMode ? 'created by ${describeIdentity(this)}' : null);
    _updateTickerModeNotifier();
    _updateTicker(); // Sets _ticker.mute correctly.
    return _ticker!;
  }

  @override
  void dispose() {
    assert(
      () {
        if (_ticker == null || !_ticker!.isActive) return true;
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('$this was disposed with an active Ticker.'),
          ErrorDescription(
            '$runtimeType created a Ticker via its SingleTickerProviderStateMixin, but at the time '
            'dispose() was called on the mixin, that Ticker was still active. The Ticker must '
            'be disposed before calling super.dispose().',
          ),
          ErrorHint(
            'Tickers used by AnimationControllers '
            'should be disposed by calling dispose() on the AnimationController itself. '
            'Otherwise, the ticker will leak.',
          ),
          _ticker!.describeForError('The offending ticker was'),
        ]);
      }(),
    );
    _tickerModeNotifier?.removeListener(_updateTicker);
    _tickerModeNotifier = null;
    _ticker = null;
    super.dispose();
  }

  ValueNotifier<bool>? _tickerModeNotifier;

  @override
  void activate() {
    super.activate();
    // We may have a new TickerMode ancestor.
    _updateTickerModeNotifier();
    _updateTicker();
  }

  void _updateTicker() {
    if (_ticker != null) {
      _ticker!.muted = !_tickerModeNotifier!.value;
    }
  }

  void _updateTickerModeNotifier() {
    final ValueNotifier<bool> newNotifier = TickerMode.getNotifier(context);
    if (newNotifier == _tickerModeNotifier) {
      return;
    }
    _tickerModeNotifier?.removeListener(_updateTicker);
    newNotifier.addListener(_updateTicker);
    _tickerModeNotifier = newNotifier;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    String? tickerDescription;
    if (_ticker != null) {
      if (_ticker!.isActive && _ticker!.muted) {
        tickerDescription = 'active but muted';
      } else if (_ticker!.isActive) {
        tickerDescription = 'active';
      } else if (_ticker!.muted) {
        tickerDescription = 'inactive and muted';
      } else {
        tickerDescription = 'inactive';
      }
    }
    properties.add(
      DiagnosticsProperty<Ticker>(
        'ticker',
        _ticker,
        description: tickerDescription,
        showSeparator: false,
        defaultValue: null,
      ),
    );
  }
}

@optionalTypeArgs
mixin TickerProviderViewStateMixin on ViewState implements TickerProvider {
  Set<Ticker>? _tickers;

  @override
  Ticker createTicker(TickerCallback onTick) {
    if (_tickerModeNotifier == null) {
      // Setup TickerMode notifier before we vend the first ticker.
      _updateTickerModeNotifier();
    }
    assert(_tickerModeNotifier != null);
    _tickers ??= <_WidgetTicker>{};
    final _WidgetTicker result = _WidgetTicker(onTick, this,
        debugLabel: kDebugMode ? 'created by ${describeIdentity(this)}' : null)
      ..muted = !_tickerModeNotifier!.value;
    _tickers!.add(result);
    return result;
  }

  void _removeTicker(_WidgetTicker ticker) {
    assert(_tickers != null);
    assert(_tickers!.contains(ticker));
    _tickers!.remove(ticker);
  }

  ValueNotifier<bool>? _tickerModeNotifier;

  @override
  void activate() {
    super.activate();
    // We may have a new TickerMode ancestor, get its Notifier.
    _updateTickerModeNotifier();
    _updateTickers();
  }

  void _updateTickers() {
    if (_tickers != null) {
      final bool muted = !_tickerModeNotifier!.value;
      for (final Ticker ticker in _tickers!) {
        ticker.muted = muted;
      }
    }
  }

  void _updateTickerModeNotifier() {
    final ValueNotifier<bool> newNotifier = TickerMode.getNotifier(context);
    if (newNotifier == _tickerModeNotifier) {
      return;
    }
    _tickerModeNotifier?.removeListener(_updateTickers);
    newNotifier.addListener(_updateTickers);
    _tickerModeNotifier = newNotifier;
  }

  @override
  void dispose() {
    assert(() {
      if (_tickers != null) {
        for (final Ticker ticker in _tickers!) {
          if (ticker.isActive) {
            throw FlutterError.fromParts(<DiagnosticsNode>[
              ErrorSummary('$this was disposed with an active Ticker.'),
              ErrorDescription(
                '$runtimeType created a Ticker via its TickerProviderStateMixin, but at the time '
                'dispose() was called on the mixin, that Ticker was still active. All Tickers must '
                'be disposed before calling super.dispose().',
              ),
              ErrorHint(
                'Tickers used by AnimationControllers '
                'should be disposed by calling dispose() on the AnimationController itself. '
                'Otherwise, the ticker will leak.',
              ),
              ticker.describeForError('The offending ticker was'),
            ]);
          }
        }
      }
      return true;
    }());
    _tickerModeNotifier?.removeListener(_updateTickers);
    _tickerModeNotifier = null;
    super.dispose();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Set<Ticker>>(
      'tickers',
      _tickers,
      description: _tickers != null
          ? 'tracking ${_tickers!.length} ticker${_tickers!.length == 1 ? "" : "s"}'
          : null,
      defaultValue: null,
    ));
  }
}

// This class should really be called _DisposingTicker or some such, but this
// class name leaks into stack traces and error messages and that name would be
// confusing. Instead we use the less precise but more anodyne "_WidgetTicker",
// which attracts less attention.
class _WidgetTicker extends Ticker {
  _WidgetTicker(super.onTick, this._creator, {super.debugLabel});

  final TickerProviderViewStateMixin _creator;

  @override
  void dispose() {
    _creator._removeTicker(this);
    super.dispose();
  }
}
