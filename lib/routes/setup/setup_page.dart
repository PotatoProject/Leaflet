import 'dart:math' as math;
import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/routes/setup/basic_customization_page.dart';
import 'package:potato_notes/routes/setup/finish_page.dart';
import 'package:potato_notes/routes/setup/restore_import_page.dart';
import 'package:potato_notes/routes/setup/welcome_page.dart';

class SetupPage extends StatefulWidget {
  @override
  _SetupPagetate createState() => _SetupPagetate();
}

class _SetupPagetate extends State<SetupPage> {
  final List<Widget> pages = [
    WelcomePage(),
    BasicCustomizationPage(),
    BackupRestorePage(),
    FinishPage(),
  ];

  int pageIndex = 0;
  bool reverse = false;

  @override
  void initState() {
    BackButtonInterceptor.add((_, __) => true, name: "antiPop");
    super.initState();
  }

  @override
  void dispose() {
    BackButtonInterceptor.removeByName("antiPop");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = context.directionality;
    String buttonText;

    if (pageIndex == 0) {
      buttonText = LocaleStrings.setup.buttonGetStarted;
    } else if (pageIndex == (pages.length - 1)) {
      buttonText = LocaleStrings.setup.buttonFinish;
    } else {
      buttonText = LocaleStrings.setup.buttonNext;
    }
    return WillPopScope(
      onWillPop: () async => pageIndex == (pages.length - 1),
      child: Scaffold(
        body: PageTransitionSwitcher(
          reverse: textDirection == TextDirection.rtl ? !reverse : reverse,
          transitionBuilder: (
            child,
            primaryAnimation,
            secondaryAnimation,
          ) =>
              SharedAxisTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            fillColor: Colors.transparent,
            child: child,
          ),
          child: pages[pageIndex],
        ),
        bottomNavigationBar: Material(
          color: context.theme.appBarTheme.backgroundColor,
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            margin: EdgeInsets.only(
              bottom: context.padding.bottom,
            ),
            child: Row(
              children: [
                AnimatedOpacity(
                  opacity: pageIndex != 0 ? 1 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: IgnorePointer(
                    ignoring: pageIndex == 0,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      tooltip: LocaleStrings.setup.buttonBack,
                      onPressed: pageIndex != 0 ? prevPage : null,
                    ),
                  ),
                ),
                const Spacer(),
                _TextButtonWithEndIcon(
                  onPressed: pageIndex != (pages.length - 1)
                      ? nextPage
                      : () {
                          prefs.welcomePageSeen = true;
                          context.pop();
                        },
                  style: TextButton.styleFrom(
                    alignment: AlignmentDirectional.centerEnd,
                  ),
                  label: Text(
                    buttonText.toUpperCase(),
                    style: const TextStyle(
                      letterSpacing: 1,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  icon: Icon(
                    pageIndex == (pages.length - 1)
                        ? Icons.check
                        : Icons.arrow_forward,
                  ),
                ),
              ],
            ),
          ),
        ),
        extendBody: true,
      ),
    );
  }

  void nextPage() {
    setState(() {
      reverse = false;
      pageIndex++;
    });
  }

  void prevPage() {
    setState(() {
      reverse = true;
      pageIndex--;
    });
  }
}

class _TextButtonWithEndIcon extends TextButton {
  _TextButtonWithEndIcon({
    Key? key,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool? autofocus,
    Clip? clipBehavior,
    required Widget icon,
    required Widget label,
  }) : super(
          key: key,
          onPressed: onPressed,
          onLongPress: onLongPress,
          style: style,
          focusNode: focusNode,
          autofocus: autofocus ?? false,
          clipBehavior: clipBehavior ?? Clip.none,
          child: _TextButtonWithIconChild(icon: icon, label: label),
        );

  @override
  ButtonStyle defaultStyleOf(BuildContext context) {
    final EdgeInsetsGeometry scaledPadding = ButtonStyleButton.scaledPadding(
      const EdgeInsets.all(8),
      const EdgeInsets.symmetric(horizontal: 4),
      const EdgeInsets.symmetric(horizontal: 4),
      MediaQuery.maybeOf(context)?.textScaleFactor ?? 1,
    );
    return super.defaultStyleOf(context).copyWith(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(scaledPadding),
        );
  }
}

class _TextButtonWithIconChild extends StatelessWidget {
  const _TextButtonWithIconChild({
    Key? key,
    required this.label,
    required this.icon,
  }) : super(key: key);

  final Widget label;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final double scale = MediaQuery.maybeOf(context)?.textScaleFactor ?? 1;
    final double gap =
        scale <= 1 ? 8 : lerpDouble(8, 4, math.min(scale - 1, 1))!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[Flexible(child: label), SizedBox(width: gap), icon],
    );
  }
}
