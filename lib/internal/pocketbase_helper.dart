import 'package:pocketbase/pocketbase.dart';
import 'package:potato_notes/internal/providers.dart';

class PocketbaseHelper {
  static String getUserId() {
    final UserModel model = pocketbase.authStore.model as UserModel;
    return model.id;
  }
}
