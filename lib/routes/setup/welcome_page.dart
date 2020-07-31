import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:potato_notes/internal/locale_strings.dart';
import 'package:potato_notes/widget/notes_logo.dart';

const double _logoHeight = 106;

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: (height / 2) - (_logoHeight / 2),
              child: NotesLogo(
                penColor: Theme.of(context).scaffoldBackgroundColor,
                height: _logoHeight,
              ),
            ),
            Positioned(
              top: (height / 2) + (_logoHeight / 2) + 16,
              child: Column(
                children: <Widget>[
                  Text(
                    "PotatoNotes",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    LocaleStrings.setupPage.welcomeCatchphrase,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
