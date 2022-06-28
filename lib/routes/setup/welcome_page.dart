import 'package:flutter/material.dart';
import 'package:potato_notes/internal/constants.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/widget/illustrations.dart';

const double _logoHeight = 64;

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double height = deviceInfo.uiSizeFactor > 3
            ? constraints.maxHeight
            : context.mSize.height;

        return Scaffold(
          body: SizedBox.expand(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  top: (height / 2) - (_logoHeight / 2),
                  child: Row(
                    children: [
                      SizedBox.fromSize(
                        size: const Size.square(_logoHeight),
                        child: const Center(
                          child: Illustration.leaflet(height: _logoHeight),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                          left: 16,
                        ),
                        child: Text(
                          "leaflet",
                          style: TextStyle(
                            fontFamily: Constants.leafletLogoFontFamily,
                            fontSize: 48,
                          ),
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
                          strings.setup.welcomeCatchphrase,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
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
