import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/locale_strings.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/widget/notes_logo.dart';
import 'package:potato_notes/widget/settings_category.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleStrings.aboutPage.title),
        textTheme: Theme.of(context).textTheme,
      ),
      extendBodyBehindAppBar: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ListView(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
            ),
            children: <Widget>[
              Container(
                width: constraints.maxWidth,
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                ),
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: Color(0xFF212C21),
                      child: IconLogo(
                        height: 48,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Leaflet",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      DeviceInfo.isDesktopOrWeb
                          ? LocaleStrings.aboutPage.pwaVersion
                          : "${appInfo.packageInfo.version}+${appInfo.packageInfo.buildNumber}",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1),
              SettingsCategory(
                header: LocaleStrings.aboutPage.contributors,
                children: List.generate(
                  Utils.contributors.length,
                  (index) =>
                      contributorTile(context, Utils.contributors[index]),
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
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(() => info.avatarUrl),
      ),
      title: Text(info.name),
      subtitle: Text(info.role),
      onTap: () => openLinkBottomSheet(context, info.socialLinks),
    );
  }

  void openLinkBottomSheet(BuildContext context, List<SocialLink> links) {
    Utils.showNotesModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            child: Text(
              LocaleStrings.aboutPage.links,
              style: TextStyle(
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
                String link = getLinkForSocialLink(links[index]);
                bool canLaunchLink = await canLaunch(link);

                if (canLaunchLink) {
                  await launch(link);
                  Navigator.pop(context);
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
      case SocialLinkType.TWITTER:
        return MdiIcons.twitter;
      case SocialLinkType.GITHUB:
        return MdiIcons.github;
      case SocialLinkType.INSTAGRAM:
        return MdiIcons.instagram;
      default:
        throw ArgumentError.notNull("type");
    }
  }

  String getSocialNameForSocialLink(SocialLinkType type) {
    switch (type) {
      case SocialLinkType.TWITTER:
        return "Twitter";
      case SocialLinkType.GITHUB:
        return "Github";
      case SocialLinkType.INSTAGRAM:
        return "Instagram";
      default:
        throw ArgumentError.notNull("type");
    }
  }

  String getLinkForSocialLink(SocialLink link) {
    switch (link.type) {
      case SocialLinkType.TWITTER:
        return "https://twitter.com/${link.username}";
      case SocialLinkType.GITHUB:
        return "https://github.com/${link.username}";
      case SocialLinkType.INSTAGRAM:
        return "https://instagram.com/${link.username}";
      default:
        throw ArgumentError.notNull("type");
    }
  }
}

class ContributorInfo {
  String name;
  String role;
  String avatarUrl;
  List<SocialLink> socialLinks;

  ContributorInfo({
    this.name,
    this.role,
    this.avatarUrl,
    this.socialLinks,
  });
}

class SocialLink {
  SocialLinkType type;
  String username;

  SocialLink(this.type, this.username);
}

enum SocialLinkType {
  TWITTER,
  GITHUB,
  INSTAGRAM,
}
