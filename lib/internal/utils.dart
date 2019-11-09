import 'package:flutter/material.dart';
import 'package:potato_notes/internal/localizations.dart';

class Utils {
  static parseErrorMessage(BuildContext context, String errorMessage) {
    AppLocalizations locales = AppLocalizations.of(context);

    switch(errorMessage) {
      case("MalformedEmailError"):
        return locales.sync_malformedEmailError;
        break;
      case("UsernameOutOfBoundsError"):
        return locales.sync_usernameOutOfBoundsError;
        break;
      case("PassOutOfBoundsError"):
        return locales.sync_passOutOfBoundsError;
        break;
      case("DbConnectionError"):
        return locales.sync_dbConnectionError;
        break;
      case("EmailAlreadyExistsError"):
        return locales.sync_emailAlreadyExistsError;
        break;
      case("UsernameAlreadyExistsError"):
        return locales.sync_usernameAlreadyExistsError;
        break;
      case("InvalidCredentialsError"):
        return locales.sync_invalidCredentialsError;
        break;
      case("NotFoundError"):
        return locales.sync_notFoundError;
        break;
      case("UserNotFoundError"):
        return locales.sync_userNotFoundError;
        break;
      case("OutOfBoundsError"):
        return locales.sync_outOfBoundsError;
        break;
      case("AccNotFoundError"):
        return locales.sync_accNotFoundError;
        break;
      case("MissingNoteIdError"):
        return locales.sync_missingNoteIdError;
        break;
      default:
        return errorMessage;
        break;
    }
  }
}