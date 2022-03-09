# How to build

## Requirements

- [Flutter](https://flutter.dev) with its dependencies for the respective platform
- [just](https://just.systems), our build system
- [rustup](https://rustup.sh) with its nightly toolchain
- [flutter_rust_bridge](https://fzyzcjy.github.io/flutter_rust_bridge/)'s dependencies for your platform

## Windows

Run `flutter build windows`. This will automatically compile the rust
project and generate the bridge bindings.

## Android

Run `flutter build apk`. This will automatically compile the rust project and
generate the bridge bindings.

## Linux

Run `flutter build linux`. This will automatically compile the rust
project and generate the bridge bindings.

## macOS

Run `flutter build macos`. This will compile the rust project but won't generate
the bridge bindings. Manually run `just gen` to generate the bindings.

## iOS

Run `flutter build ios`. This will compile the rust project but won't generate
the bridge bindings. Manually run `just gen` to generate the bindings.
