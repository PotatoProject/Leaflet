import 'package:flutter/material.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:window_manager/window_manager.dart';

class WindowFrame extends StatelessWidget {
  final Widget child;

  const WindowFrame({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (!DeviceInfo.isDesktop) return child;

    late final double toolbarHeight;
    if (UniversalPlatform.isLinux) {
      toolbarHeight = 0;
    } else if (UniversalPlatform.isMacOS) {
      toolbarHeight = 28;
    } else {
      toolbarHeight = 32;
    }

    return Stack(
      children: [
        MediaQuery(
          data: context.mediaQuery
              .copyWith(padding: context.padding.copyWith(top: toolbarHeight)),
          child: Positioned.fill(child: child),
        ),
        Positioned(
          top: 0,
          height: toolbarHeight,
          width: context.mSize.width,
          child: _WindowTitlebar(),
        ),
      ],
    );
  }
}

class _WindowTitlebar extends StatefulWidget {
  @override
  State<_WindowTitlebar> createState() => _WindowTitlebarState();
}

class _WindowTitlebarState extends State<_WindowTitlebar> with WindowListener {
  bool maximized = false;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void onWindowMaximize() {
    maximized = true;
  }

  @override
  void onWindowUnmaximize() {
    maximized = false;
  }

  @override
  Widget build(BuildContext context) {
    late final double opacity;

    if (context.theme.brightness == Brightness.light) {
      opacity = 0.1;
    } else {
      opacity = 0.05;
    }

    final bool showButtons =
        !UniversalPlatform.isMacOS && !UniversalPlatform.isLinux;

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
            textDirection: TextDirection.ltr,
            children: [
              Expanded(
                child: GestureDetector(
                  onPanStart: (details) => windowManager.startDragging(),
                  onDoubleTap: maximized
                      ? windowManager.unmaximize
                      : windowManager.maximize,
                ),
              ),
              if (showButtons)
                _TitlebarButton(
                  onTap: windowManager.minimize,
                  child: const Icon(Icons.remove),
                ),
              if (showButtons)
                _TitlebarButton(
                  onTap: maximized
                      ? windowManager.unmaximize
                      : windowManager.maximize,
                  child: maximized
                      ? const Icon(Icons.flip_to_front_outlined)
                      : const Icon(Icons.crop_square),
                ),
              if (showButtons)
                _TitlebarButton(
                  onTap: windowManager.close,
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
    return LayoutBuilder(
      builder: (context, constraints) {
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
      },
    );
  }
}
