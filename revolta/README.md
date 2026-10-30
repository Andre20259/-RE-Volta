# Retorna

Flutter app that checks whether a bottle or can is a Volta container and
keeps a wallet of the deposits you can get back.

## Requirements

- **Flutter 3.47 or newer** (Dart 3.13). Check with `flutter --version`.
- **Android:** Android Studio with an emulator, or an Android phone with
  USB debugging turned on.
- **iOS:** a Mac with Xcode. iOS builds only work on macOS.

Run `flutter doctor` and fix any errors for the platform you want to use
before going further.

## Get the code

```sh
git clone https://github.com/Andre20259/-RE-Volta.git
cd ./-RE-Volta/revolta
flutter pub get
```

The `./` matters: without it, `cd` reads `-RE-Volta` as an option and fails.

## Run

Start an emulator (or plug in a phone), then:

```sh
flutter devices           # list what's connected
flutter run               # run on the only device
flutter run -d <id>       # or pick one from `flutter devices`
```

While it's running, press `r` for hot reload, `R` for hot restart and `q` to
quit.

### Trying it out

The camera isn't connected yet. On the scanner screen, tap
**Type the code instead** and enter one of the sample codes:

| Code            | Product            |
|-----------------|--------------------|
| `5601234000016` | Água mineral 1.5 L |
| `5601234000023` | Cola lata 33 cl    |
| `5601234000054` | Vinho tinto 75 cl  |

Any other number shows "Product not found". The full sample list is in
`lib/data/placeholder_data.dart`.

## Build

### Android

```sh
flutter build apk --release
```

The APK ends up in `build/app/outputs/flutter-apk/app-release.apk`. Install it
on a connected phone with `flutter install`, or copy the file to the phone.

The release build is signed with the debug key, which is fine for testing but
won't be accepted by the Play Store.

### iOS (macOS only)

```sh
flutter build ios --release
```

Before the first build, open `ios/Runner.xcworkspace` in Xcode and pick a
team under **Signing & Capabilities**. To install on an iPhone, connect it and
use `flutter run --release`.

## Checks

```sh
flutter analyze   # lint and type errors
flutter test      # widget tests in test/
```

## Troubleshooting

- **Build fails with "file in use" or access errors on Windows:** if the
  project is inside OneDrive, pause syncing or move the project to a folder
  outside OneDrive. OneDrive locks files in `build/` and `.dart_tool/` while
  Flutter is writing them.
- **Odd errors after pulling changes:** run `flutter clean` then
  `flutter pub get`.
