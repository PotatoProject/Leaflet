import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:potato_notes/internal/constants.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/widget/illustrations.dart';
import 'package:potato_notes/widget/settings_category.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleStrings.about.title),
      ),
      extendBodyBehindAppBar: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ListView(
            padding: EdgeInsets.only(
              top: context.padding.top,
            ),
            children: <Widget>[
              Container(
                width: constraints.maxWidth,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                ),
                child: Column(
                  children: <Widget>[
                    const CircleAvatar(
                      radius: 48,
                      backgroundColor: Color(0xFF212C21),
                      child: Illustration.leaflet(
                        height: 48,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Leaflet",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      "${appInfo.packageInfo.version}+${appInfo.packageInfo.buildNumber}",
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              SettingsCategory(
                header: LocaleStrings.about.contributors,
                children: List.generate(
                  Constants.contributors.length,
                  (index) =>
                      contributorTile(context, Constants.contributors[index]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget contributorTile(BuildContext context, ContributorInfo info) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(info.avatarUrl)),
      title: Text(info.name),
      subtitle: Text(info.role),
      onTap: () => openLinkBottomSheet(context, info.socialLinks),
    );
  }

  void openLinkBottomSheet(BuildContext context, List<SocialLink> links) {
    Utils.showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            child: Text(
              LocaleStrings.about.links,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          ...List.generate(
            links.length,
            (index) => ListTile(
              leading: Icon(
                getIconForSocialLink(links[index].type),
              ),
              title: Text(
                links[index].username,
              ),
              subtitle: Text(
                getSocialNameForSocialLink(links[index].type),
              ),
              onTap: () async {
                final String link = getLinkForSocialLink(links[index]);
                final bool result = await Utils.launchUrl(link);

                if (result) {
                  context.pop();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData getIconForSocialLink(SocialLinkType type) {
    switch (type) {
      case SocialLinkType.twitter:
        return MdiIcons.twitter;
      case SocialLinkType.github:
        return MdiIcons.github;
      case SocialLinkType.instagram:
        return MdiIcons.instagram;
      case SocialLinkType.steam:
        return MdiIcons.steam;
      default:
        throw ArgumentError.notNull("type");
    }
  }

  String getSocialNameForSocialLink(SocialLinkType type) {
    switch (type) {
      case SocialLinkType.twitter:
        return "Twitter";
      case SocialLinkType.github:
        return "Github";
      case SocialLinkType.instagram:
        return "Instagram";
      case SocialLinkType.steam:
        return "Steam";
      default:
        throw ArgumentError.notNull("type");
    }
  }

  String getLinkForSocialLink(SocialLink link) {
    switch (link.type) {
      case SocialLinkType.twitter:
        return "https://twitter.com/${link.username}";
      case SocialLinkType.github:
        return "https://github.com/${link.username}";
      case SocialLinkType.instagram:
        return "https://instagram.com/${link.username}";
      case SocialLinkType.steam:
        return "https://https://steamcommunity.com/id/${link.username}";
      default:
        throw ArgumentError.notNull("type");
    }
  }
}

@immutable
class ContributorInfo {
  final String name;
  final String role;
  final String avatarUrl;
  final List<SocialLink> socialLinks;

  const ContributorInfo({
    required this.name,
    required this.role,
    required this.avatarUrl,
    required this.socialLinks,
  });
}

@immutable
class SocialLink {
  final SocialLinkType type;
  final String username;

  const SocialLink(this.type, this.username);
}

enum SocialLinkType {
  twitter,
  github,
  instagram,
  steam,
}
