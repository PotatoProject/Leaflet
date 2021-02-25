# Leaflet

<img src="https://i.imgur.com/4Fm8gSc.png">

POSP official notes application, written in flutter, beautiful, fast and secure.

<a href='https://play.google.com/store/apps/details?id=com.potatoproject.notes&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1'><img alt='Get it on Google Play' src='https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png' height="80px"/></a>

## Main features
- Material design
- Multi device online sync
- List/grid view for notes
- Multiple note extras, such as lists, images and remainders
- Lock notes with a pin or password for hiding them on main menu
- Search notes for content/title with various filters
- Complete theme personalization
- Local backup/restore functionality
- Trash and archive for notes

## Planned features
- [x] Note tags
- [ ] Launcher widget
- [ ] Quick note QS tile
- [ ] Partial markdown support
- [x] Multiple image loading
- [ ] Voice notes
- [x] Drawings

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
~$ flutter build apk     # release build (fat apk)
```

## Generating locales
After adding or updating the locales, run the following command from Leaflet root dir:
```
dart bin/locale_gen.dart locales lib/internal/locales
```

This will generate and update the required files

## Contributing
The entire app and even the [online sync api](https://github.com/broodroosterdev/potatosync-rust) is completely open source.  
Feel free to open a PR to suggest fixes, features or whatever you want, just remember that PRs are subjected to manual review so you gotta wait for actual people to look at your contributions

For translations, head over to our [Crowdin](https://crowdin.com/project/potatonotes).

If you want to receive the latest news head over to our [Telegram channel](https://t.me/potatonotesnews), if you want to chat we even got the [Telegram group](https://t.me/potatonotes).
