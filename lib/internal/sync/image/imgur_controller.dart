import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:potato_notes/data/model/saved_image.dart';
import 'package:http/http.dart' as http;

class ImgurController {
  static const String UPLOAD_URL = "https://api.imgur.com/3/image";

  static Future<SavedImage> uploadImage(
      SavedImage savedImage, File file) async {
    Response uploadResponse = await http.post(
      "https://api.imgur.com/3/image",
      body: await file.readAsBytes(),
      headers: {"Authorization": "Client-ID f856a5e4fd5b2af"},
    );
    if (uploadResponse.statusCode == 200) {
      String url = json.decode(uploadResponse.body)["data"]["link"];
      savedImage.uri = Uri.parse(url);
    }
    print(uploadResponse.body);
    return savedImage;
  }
}
