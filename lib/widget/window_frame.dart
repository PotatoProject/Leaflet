import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/providers.dart';

class WindowFrame extends StatelessWidget {
  final Widget child;

  const WindowFrame({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (!DeviceInfo.isDesktop) return child;

    return Stack(
      children: [
        MediaQuery(
          data: context.mediaQuery.copyWith(
            padding: context.padding.copyWith(top: 32),
          ),
          child: Positioned.fill(child: child),
        ),
        Positioned(
          top: 0,
          height: 32,
          width: context.mSize.width,
          child: _WindowTitlebar(),
        ),
      ],
    );
  }
}

class _WindowTitlebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    late final double opacity;

    if (context.theme.brightness == Brightness.light) {
      opacity = 0.1;
    } else {
      opacity = 0.05;
    }

    return SizedBox.expand(
      child: AnimatedContainer(
        color: deviceInfo.uiSizeFactor < 4
            ? context.theme.disabledColor.withOpacity(opacity)
            : Colors.transparent,
        duration: const Duration(milliseconds: 200),
        curve: decelerateEasing,
        child: Material(
          type: MaterialType.transparency,
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onPanStart: (details) => appWindow.startDragging(),
                  onDoubleTap: appWindow.maximizeOrRestore,
                ),
              ),
              _TitlebarButton(
                onTap: appWindow.minimize,
                child: const Icon(Icons.remove),
              ),
              _TitlebarButton(
                onTap: appWindow.maximizeOrRestore,
                child: appWindow.isMaximized
                    ? const Icon(Icons.flip_to_front_outlined)
                    : const Icon(Icons.crop_square),
              ),
              _TitlebarButton(
                onTap: appWindow.close,
                child: const Icon(Icons.close),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TitlebarButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _TitlebarButton({
    required this.child,
    this.onTap,
  });

  @override
  _TitlebarButtonState createState() => _TitlebarButtonState();
}

class _TitlebarButtonState extends State<_TitlebarButton> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    final Color _fgColor = context.theme.disabledColor.withOpacity(0.1);
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox.fromSize(
        size: Size.square(constraints.maxHeight),
        child: InkWell(
          onTap: widget.onTap,
          onHover: (value) => setState(() => hovering = value),
          splashColor: _fgColor,
          highlightColor: _fgColor,
          focusColor: _fgColor,
          hoverColor: _fgColor,
          child: IconTheme.merge(
            data: IconThemeData(
              size: 20,
              color: hovering
                  ? context.theme.iconTheme.color!.withOpacity(1)
                  : context.theme.iconTheme.color!.withOpacity(0.5),
            ),
            child: widget.child,
          ),
        ),
      );
    });
  }
}
