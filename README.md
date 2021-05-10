# Leaflet

<img src="https://i.imgur.com/dvmKX8d.png">

POSP official notes application, written in flutter, beautiful, fast and secure.

<a href='https://play.google.com/store/apps/details?id=com.potatoproject.notes&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1'><img alt='Get it on Google Play' src='https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png' height="80px"/></a>

## Main features
- Material design
- Completely cross platform
- List/grid view for notes
- Multiple note extras, such as lists, images and drawings
- Lock notes with a pin or password or biometrics
- Hide notes content on the main page
- Search notes with various filters
- Complete theme personalization
- Local backup/restore functionality with encryption
- Trash and archive for notes
- Database encryption
- Tags for notes

## Planned features
- [ ] New sync api integration
- [ ] Folders
- [ ] Refined UI for desktop platforms

## Compiling the app
Before anything, be sure to have a working flutter sdk setup.

Be sure to disable signing on build.gradle or change keystore to sign the app.

For now the required flutter channel is master, so issue those two commands before starting building:
```
~$ flutter channel master
~$ flutter update
```

After that, building is simple as this:
```
~$ flutter pub get

~$ flutter run           # for debug
~$ flutter build apk --flavor dev     # release build with dev flavor (available flavors are dev, production and ci)
```

## Generating locales
After adding or updating the locales, run the following command from Leaflet root dir:
```
dart bin/locale_gen.dart
```

This will generate and update the required files

## Contributing
The entire app and even the [online sync api](https://github.com/broodroosterdev/potatosync-rust) is completely open source.  
Feel free to open a PR to suggest fixes, features or whatever you want, just remember that PRs are subjected to manual review so you gotta wait for actual people to look at your contributions

For translations, head over to our [Crowdin](https://potatoproject.crowdin.com/leaflet).

If you want to receive the latest news head over to our [Telegram channel](https://t.me/potatonotesnews), if you want to chat we even got the [Telegram group](https://t.me/potatonotes).
