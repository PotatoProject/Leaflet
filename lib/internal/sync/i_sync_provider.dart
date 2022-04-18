import 'package:potato_notes/internal/sync/i_auth_controller.dart';

abstract class ISyncProvider {
  IAuthController getAuthController();
}
