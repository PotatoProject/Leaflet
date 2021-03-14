import 'package:animations/animations.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/routes/setup/finish_page.dart';
import 'package:potato_notes/routes/setup/basic_customization_page.dart';
import 'package:potato_notes/routes/setup/welcome_page.dart';
import 'package:potato_notes/widget/flat_icon_button.dart';

class SetupPage extends StatefulWidget {
  @override
  _SetupPagetate createState() => _SetupPagetate();
}

class _SetupPagetate extends State<SetupPage> {
  final List<Widget> pages = [
    WelcomePage(),
    BasicCustomizationPage(),
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
        body: GestureDetector(
          onHorizontalDragEnd: (details) {
            final double sign = textDirection == TextDirection.rtl
                ? -details.primaryVelocity!.sign
                : details.primaryVelocity!.sign;

            if (details.primaryVelocity!.abs() > 320) {
              if (sign == 1) {
                if (pageIndex != 0) {
                  prevPage();
                }
              } else {
                if (pageIndex != (pages.length - 1)) {
                  nextPage();
                }
              }
            }
          },
          child: PageTransitionSwitcher(
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
        ),
        bottomNavigationBar: Material(
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            margin: EdgeInsets.only(
              bottom: context.padding.bottom,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  tooltip: LocaleStrings.setup.buttonBack,
                  onPressed: pageIndex != 0 ? prevPage : null,
                ),
                const Spacer(),
                FlatIconButton(
                  onPressed: pageIndex != (pages.length - 1)
                      ? nextPage
                      : () {
                          prefs.welcomePageSeen = true;
                          context.pop();
                        },
                  text: Text(
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
