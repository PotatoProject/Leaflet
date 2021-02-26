import 'locale_gen/asset_loader_generator.dart';
import 'locale_gen/key_generator.dart';
import 'locale_gen/locale_generator.dart';

const String _localesFolder = "locales";
const String _destinationFolder = "lib/internal/locales";
void main(List<String> args) async {
  final LocaleGenerator _localeGen =
      LocaleGenerator(_localesFolder, _destinationFolder);
  await _localeGen.generate();
  final AssetLoaderGenerator _assetLoaderGen =
      AssetLoaderGenerator(_destinationFolder);
  await _assetLoaderGen.generate();
  final KeyGenerator _keyGen = KeyGenerator(_localesFolder, _destinationFolder);
  await _keyGen.generate();

  print("Files generated inside $_destinationFolder");
  return;
}
