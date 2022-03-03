flutter_rust_bridge_codegen --rust-input native/src/api.rs --dart-output lib/bridge_generated.dart --c-output ios/Runner/bridge_generated.h
cp ios/Runner/bridge_generated.h macos/Runner/bridge_generated.h
