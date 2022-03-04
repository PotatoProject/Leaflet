# Homebrew installs LLVM in a place that is not visible to ffigen.
# This explicitly specifies the place where the LLVM dylibs are kept.
llvm_path := if os() == "macos" {
    "--llvm-path /opt/homebrew/opt/llvm"
} else {
    ""
}

set windows-powershell := true

default: gen

gen:
    flutter_rust_bridge_codegen {{llvm_path}} \
        --rust-input native/src/api.rs \
        --dart-output lib/bridge_generated.dart \
        --c-output ios/Runner/bridge_generated.h
    cp ios/Runner/bridge_generated.h macos/Runner/bridge_generated.h
    flutter pub run build_runner build --delete-conflicting-outputs

lint:
    cd native ; cargo fmt
    dart format .

clean:
    flutter clean
    cd native ; cargo clean

android-native-release: gen
    cd native ; cargo ndk -t armeabi-v7a -t arm64-v8a -t x86_64 -o ../android/app/src/main/jniLibs build --release

android-native-debug: gen
    cd native ; cargo ndk -t armeabi-v7a -t arm64-v8a -t x86_64 -o ../android/app/src/main/jniLibs build

# vim:expandtab:sw=4:ts=4