import 'package:animations/animations.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/routes/setup/finish_page.dart';
import 'package:potato_notes/routes/setup/basic_customization_page.dart';
import 'package:potato_notes/routes/setup/import_page.dart';
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
    ImportPage(),
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
    TextDirection textDirection = Directionality.of(context);
    String buttonText;

    if (pageIndex == 0) {
      buttonText = LocaleStrings.setupPage.buttonGetStarted;
    } else if (pageIndex == (pages.length - 1)) {
      buttonText = LocaleStrings.setupPage.buttonFinish;
    } else {
      buttonText = LocaleStrings.setupPage.buttonNext;
    }
    return WillPopScope(
      child: Scaffold(
        body: GestureDetector(
          onHorizontalDragEnd: (details) {
            double sign = textDirection == TextDirection.rtl
                ? -details.primaryVelocity.sign
                : details.primaryVelocity.sign;

            if (details.primaryVelocity.abs() > 320) {
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
              child: child,
              fillColor: Colors.transparent,
            ),
            child: pages[pageIndex],
          ),
        ),
        bottomNavigationBar: Material(
          child: Container(
            height: 56,
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  tooltip: LocaleStrings.setupPage.buttonBack,
                  onPressed: pageIndex != 0 ? prevPage : null,
                ),
                Spacer(),
                FlatIconButton(
                  onPressed: pageIndex != (pages.length - 1)
                      ? nextPage
                      : () {
                          prefs.welcomePageSeen = true;
                          Navigator.pop(context);
                        },
                  text: Text(
                    buttonText.toUpperCase(),
                    style: TextStyle(
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
      onWillPop: () async => pageIndex == (pages.length - 1),
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
