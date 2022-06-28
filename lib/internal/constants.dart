import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:potato_notes/internal/custom_icons.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/routes/about_page.dart';

class Constants {
  Constants._();

  static const double cardPadding = 4;
  static const Color defaultAccent = Color(0xFF66BB6A);
  static const double drawerClosedWidth = 72.0;
  static const double drawerOpenedWidth = 300.0;
  static const Duration drawerAnimationDuration = Duration(milliseconds: 200);
  static const String leafletLogoFontFamily = "ValeraRound";

  static List<ContributorInfo> get contributors => [
        ContributorInfo(
          name: "Davide Bianco",
          role: strings.about.contributorsHrx,
          avatarUrl: "https://avatars.githubusercontent.com/u/29352339",
          socialLinks: const [
            SocialLink(SocialLinkType.github, "HrX03"),
            SocialLink(SocialLinkType.instagram, "b_b_biancoboi"),
            SocialLink(SocialLinkType.twitter, "HrX2003"),
          ],
        ),
        ContributorInfo(
          name: "Bas Wieringa (broodrooster)",
          role: strings.about.contributorsBas,
          avatarUrl: "https://avatars.githubusercontent.com/u/31385368",
          socialLinks: const [
            SocialLink(SocialLinkType.github, "broodroosterdev"),
          ],
        ),
        ContributorInfo(
          name: "Nico Franke",
          role: strings.about.contributorsNico,
          avatarUrl: "https://avatars.githubusercontent.com/u/23036430",
          socialLinks: const [
            SocialLink(SocialLinkType.github, "ZerNico"),
            SocialLink(SocialLinkType.instagram, "z3rnico"),
            SocialLink(SocialLinkType.twitter, "Z3rNico"),
          ],
        ),
        ContributorInfo(
          name: "Akshit Garg",
          role: strings.about.contributorsAkshit,
          avatarUrl: "https://avatars.githubusercontent.com/u/15605299",
          socialLinks: const [
            SocialLink(SocialLinkType.github, "gargakshit"),
            SocialLink(SocialLinkType.twitter, "thepotatokitty"),
          ],
        ),
        ContributorInfo(
          name: "SphericalKat",
          role: strings.about.contributorsKat,
          avatarUrl: "https://avatars.githubusercontent.com/u/31761843",
          socialLinks: const [
            SocialLink(SocialLinkType.github, "ATechnoHazard"),
          ],
        ),
        ContributorInfo(
          name: "Rohit K.Parida",
          role: strings.about.contributorsRohit,
          avatarUrl: "https://avatars.githubusercontent.com/u/18437518",
          socialLinks: const [
            SocialLink(SocialLinkType.twitter, "paridadesigns"),
          ],
        ),
        ContributorInfo(
          name: "RshBfn",
          role: strings.about.contributorsRshbfn,
          avatarUrl:
              "https://pbs.twimg.com/profile_images/1306121394241953792/G0zeUpRb.jpg",
          socialLinks: const [
            SocialLink(SocialLinkType.twitter, "RshBfn"),
          ],
        ),
        ContributorInfo(
          name: "Elias Gagnef",
          role: strings.about.contributorsElias,
          avatarUrl: "https://avatars.githubusercontent.com/u/46574798",
          socialLinks: const [
            SocialLink(SocialLinkType.twitter, "EliasGagnef"),
            SocialLink(SocialLinkType.github, "EliasGagnef"),
            SocialLink(SocialLinkType.steam, "Gagnef"),
          ],
        ),
      ];

  static const String defaultApiUrl = "https://sync.potatoproject.co/api/v2";

  static const List<IconData> folderDefaultIcons = [
    Icons.folder_outlined,
    Icons.home_outlined,
    Icons.delete_outline,
    MdiIcons.archiveOutline,
    CustomIcons.notes,
    Icons.star_border,
    Icons.emoji_events_outlined,
    Icons.local_cafe_outlined,
    Icons.spa_outlined,
    Icons.videogame_asset_outlined,
    Icons.favorite_outline,
    MdiIcons.incognito,
    Icons.local_bar_outlined,
    Icons.sports_soccer_outlined,
    Icons.school_outlined,
    Icons.bar_chart_outlined,
    Icons.local_airport_outlined,
    Icons.work_outline,
    Icons.question_answer_outlined,
    Icons.notifications_none_outlined,
    Icons.smart_toy_outlined,
    Icons.campaign_outlined,
    Icons.people_alt_outlined,
    Icons.person_outlined,
  ];
}
