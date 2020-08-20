import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlCard extends StatelessWidget {
  final String url;
  final bool shrink;
  final BaseCacheManager manager = DefaultCacheManager();

  UrlCard({
    Key key,
    this.shrink = false,
    @required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getMetadata(),
      builder: (context, snapshot) {
        Metadata data = snapshot.data ?? Metadata();
        bool emptyTitle = data.title == null || data.title.trim().isEmpty;
        bool emptyDesc =
            data.description == null || data.description.trim().isEmpty;

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(shrink ? 4 : 8),
            side: BorderSide(
              width: 1.5,
              color: Theme.of(context).iconTheme.color.withOpacity(0.1),
            ),
          ),
          elevation: 0,
          color: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.symmetric(
            horizontal: shrink ? 0 : 16,
            vertical: 4,
          ),
          child: InkWell(
            onTap: () async {
              if (await canLaunch(url)) {
                launch(url);
              }
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: shrink ? 30 : 48,
                  height: shrink ? 30 : 48,
                  margin: EdgeInsets.only(
                    top: shrink ? 4 : 8,
                    left: shrink ? 4 : 8,
                    bottom: shrink ? 4 : 8,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(shrink ? 2 : 3),
                    color: Theme.of(context).cardColor,
                  ),
                  foregroundDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(shrink ? 2 : 3),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(data.image ?? ""),
                      fit: BoxFit.cover,
                      onError: (exception, stackTrace) {},
                    ),
                  ),
                  child: Icon(Icons.link),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(shrink ? 4 : 12),
                    clipBehavior: Clip.none,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          emptyTitle
                              ? Uri.parse(url)?.host.toString().split('.')[0]
                              : data.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .caption
                                .color
                                .withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                            fontSize: shrink ? 12 : 16,
                          ),
                        ),
                        Text(
                          emptyDesc ? url : data.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: shrink ? 10 : 14,
                            color: Theme.of(context)
                                .textTheme
                                .caption
                                .color
                                .withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: !shrink,
                  child: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Text("Copy link"),
                        value: 'copy',
                      ),
                    ],
                    onSelected: (value) {
                      switch (value) {
                        case 'copy':
                          Clipboard.setData(ClipboardData(text: url));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Metadata> getMetadata() async {
    FileInfo cachedInfo = await manager.getFileFromCache(url);

    if (cachedInfo != null) {
      String rawJson = utf8.decode(await cachedInfo.file.readAsBytes());
      Map<dynamic, dynamic> parsedJson = json.decode(rawJson);
      return Metadata()
        ..title = parsedJson["title"]
        ..description = parsedJson["description"]
        ..image = parsedJson["image"]
        ..url = parsedJson["url"];
    }

    Response response;

    try {
      response = await get(url);
    } catch (e) {
      return null;
    }

    var document = responseToDocument(response);

    var data = MetadataParser.parse(document);
    manager.putFile(url, utf8.encode(json.encode(data.toJson())));
    return data;
  }
}
