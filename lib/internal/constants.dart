import 'package:flutter/material.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/routes/about_page.dart';

class Constants {
  Constants._();

  static const double cardBorderRadius = 4;
  static const EdgeInsets cardPadding = EdgeInsets.all(4);
  static const Color defaultAccent = Color(0xFF66BB6A);

  static final List<ContributorInfo> contributors = [
    ContributorInfo(
      name: "Davide Bianco",
      role: LocaleStrings.about.contributorsHrx,
      avatarUrl: "https://avatars.githubusercontent.com/u/29352339",
      socialLinks: const [
        SocialLink(SocialLinkType.github, "HrX03"),
        SocialLink(SocialLinkType.instagram, "b_b_biancoboi"),
        SocialLink(SocialLinkType.twitter, "HrX2003"),
      ],
    ),
    ContributorInfo(
      name: "Bas Wieringa (broodrooster)",
      role: LocaleStrings.about.contributorsBas,
      avatarUrl: "https://avatars.githubusercontent.com/u/31385368",
      socialLinks: const [
        SocialLink(SocialLinkType.github, "broodroosterdev"),
      ],
    ),
    ContributorInfo(
      name: "Nico Franke",
      role: LocaleStrings.about.contributorsNico,
      avatarUrl: "https://avatars.githubusercontent.com/u/23036430",
      socialLinks: const [
        SocialLink(SocialLinkType.github, "ZerNico"),
        SocialLink(SocialLinkType.instagram, "z3rnico"),
        SocialLink(SocialLinkType.twitter, "Z3rNico"),
      ],
    ),
    ContributorInfo(
      name: "SphericalKat",
      role: LocaleStrings.about.contributorsKat,
      avatarUrl: "https://avatars.githubusercontent.com/u/31761843",
      socialLinks: const [
        SocialLink(SocialLinkType.github, "ATechnoHazard"),
      ],
    ),
    ContributorInfo(
      name: "Rohit K.Parida",
      role: LocaleStrings.about.contributorsRohit,
      avatarUrl: "https://avatars.githubusercontent.com/u/18437518",
      socialLinks: const [
        SocialLink(SocialLinkType.twitter, "paridadesigns"),
      ],
    ),
    ContributorInfo(
      name: "RshBfn",
      role: LocaleStrings.about.contributorsRshbfn,
      avatarUrl:
          "https://pbs.twimg.com/profile_images/1306121394241953792/G0zeUpRb.jpg",
      socialLinks: const [
        SocialLink(SocialLinkType.twitter, "RshBfn"),
      ],
    ),
    const ContributorInfo(
      name: "Elias Gagnef",
      role: "Leaflet brand name",
      avatarUrl: "https://avatars.githubusercontent.com/u/46574798",
      socialLinks: [
        SocialLink(SocialLinkType.twitter, "EliasGagnef"),
        SocialLink(SocialLinkType.github, "EliasGagnef"),
        SocialLink(SocialLinkType.steam, "Gagnef"),
      ],
    ),
  ];

  static const String defaultApiUrl = "https://sync.potatoproject.co/api/v2";
}
