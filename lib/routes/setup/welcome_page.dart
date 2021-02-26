import 'package:flutter/material.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/widget/illustrations.dart';

const double _logoHeight = 64;

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double height = deviceInfo.uiSizeFactor > 3
            ? constraints.maxHeight
            : MediaQuery.of(context).size.height;

        return Scaffold(
          body: SizedBox.expand(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  top: (height / 2) - (_logoHeight / 2),
                  child: Row(
                    children: [
                      Illustration.leaflet(
                        height: _logoHeight,
                      ),
                      SizedBox(width: 32),
                      Text(
                        "leaflet",
                        style: TextStyle(
                          fontFamily: "ValeraRound",
                          fontSize: 48,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: (height / 2) + (_logoHeight / 2) + 16,
                  child: SizedBox(
                    width: constraints.maxWidth,
                    child: Column(
                      children: <Widget>[
                        Text(
                          LocaleStrings.setup.welcomeCatchphrase,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
