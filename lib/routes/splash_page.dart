import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/themes.dart';
import 'package:potato_notes/widget/illustrations.dart';
import 'package:universal_platform/universal_platform.dart';

class SplashPage extends StatefulWidget {
  final Widget child;

  SplashPage({
    this.child,
  });

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  AnimationController _elementsAc;
  AnimationController _transitionAc;

  Color initialColor;
  Color finalColor;

  bool showChildOnly = false;
  bool showChild = false;

  @override
  void initState() {
    _loadColors();
    _elementsAc = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 250,
      ),
    );
    _transitionAc = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 350,
      ),
      value: 1,
    );
    Timer(
      Duration(milliseconds: DeviceInfo.isDesktop ? 600 : 250),
      () => _elementsAc.forward(),
    );
    Timer(Duration(milliseconds: 1400), () => _transitionAc.reverse());
    _transitionAc.addListener(_transitionListener);
    _elementsAc.addListener(_elementsListener);
    super.initState();
  }

  @override
  void dispose() {
    _transitionAc.removeListener(_transitionListener);
    _elementsAc.removeListener(_elementsListener);
    _transitionAc.dispose();
    _elementsAc.dispose();
    super.dispose();
  }

  void _transitionListener() {
    if (_transitionAc.value == 0) setState(() => showChildOnly = true);
  }

  void _elementsListener() {
    if (_elementsAc.value == 1) setState(() => showChild = true);
  }

  void _loadColors() async {
    final MediaQueryData data =
        MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    final bool isDarkSystemTheme = data.platformBrightness == Brightness.dark;
    final ThemeMode themeMode = prefs.themeMode;
    final bool useAmoled = prefs.useAmoled;

    Color color = Themes.lightColor;

    if (isDarkSystemTheme)
      initialColor = Themes.darkColor;
    else
      initialColor = Themes.lightColor;

    if (themeMode == ThemeMode.system && isDarkSystemTheme ||
        themeMode == ThemeMode.dark) {
      color = useAmoled ? Themes.blackColor : Themes.darkColor;
    }

    finalColor = color;
  }

  @override
  Widget build(BuildContext context) {
    final ColorTween _colorTween = ColorTween(
      // As of now we don't have proper system theme detection on flutter
      // for linux and windows so just use the same color for begin and end.
      begin: UniversalPlatform.isLinux || UniversalPlatform.isWindows
          ? finalColor
          : initialColor,
      end: finalColor,
    );

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          if (showChild) SizedBox.expand(child: widget.child),
          if (!showChildOnly)
            _ForegroundLayer(
              backgroundColor: _colorTween,
              elementsAnimation: CurvedAnimation(
                parent: _elementsAc,
                curve: decelerateEasing,
                reverseCurve: decelerateEasing,
              ),
              transitionAnimation: _transitionAc,
            ),
        ],
      ),
    );
  }
}

class _ForegroundLayer extends StatelessWidget {
  final ColorTween backgroundColor;
  final Animation<double> transitionAnimation;
  final Animation<double> elementsAnimation;

  _ForegroundLayer({
    @required this.backgroundColor,
    @required this.transitionAnimation,
    @required this.elementsAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final ColorTween textColorTween = ColorTween(
      begin: _getContrastingColor(backgroundColor.begin),
      end: _getContrastingColor(backgroundColor.end),
    );

    return AnimatedBuilder(
      animation: transitionAnimation,
      builder: (context, child) {
        return IgnorePointer(
          ignoring: transitionAnimation.value < 0.2,
          child: Visibility(
            visible: transitionAnimation.value != 0,
            child: FadeTransition(
              opacity: transitionAnimation,
              child: child,
            ),
          ),
        );
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: elementsAnimation,
              builder: (context, _) => ColoredBox(
                color: backgroundColor.evaluate(elementsAnimation),
              ),
            ),
          ),
          Center(
            child: _LogoAnimationLayer(
              animation: elementsAnimation,
              textColorTween: textColorTween,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 32),
              child: AnimatedBuilder(
                animation: elementsAnimation,
                builder: (context, _) => Illustration.posp(
                  tint: textColorTween.evaluate(elementsAnimation),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getContrastingColor(Color base) {
    return base.computeLuminance() > 0.5 ? Colors.grey[900] : Colors.white;
  }
}

class _LogoAnimationLayer extends StatelessWidget {
  final Animation<double> animation;
  final ColorTween textColorTween;

  _LogoAnimationLayer({
    @required this.animation,
    @required this.textColorTween,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox.fromSize(
          size: Size.square(64),
          child: Center(
            child: Illustration.leaflet(height: 64),
          ),
        ),
        AnimatedBuilder(
          animation: animation,
          builder: (context, _) {
            return SizeTransition(
              axis: Axis.horizontal,
              axisAlignment: -1,
              sizeFactor: animation,
              child: Center(
                child: FadeTransition(
                  opacity: animation,
                  child: Padding(
                    child: Text(
                      "leaflet",
                      style: TextStyle(
                        fontFamily: "ValeraRound",
                        fontSize: 48,
                        color: textColorTween.evaluate(animation),
                      ),
                    ),
                    padding: EdgeInsets.only(
                      left: 16,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
