# Canonical Script Set

Use this file first when selecting a baseline script. These are the preferred anchors for routing. Variants and legacy scripts remain reference-only unless explicitly needed.

## Routing Order

1. Match user intent and static evidence.
2. Apply `references/script-metadata.manifest.json` routing rules.
3. Pick the `preferred` canonical script ID.
4. If target classes are missing, try fallback canonical IDs.
5. Only then pull `legacy.*` scripts for extra hook targets.

## Canonical IDs

| Script ID | Path | Platform | Family |
|---|---|---|---|
| `bypass.adb` | `scripts/02_SecurityBypass/DebugMode_Emulator/android-adb-detection-bypass.js` | `android` | `bypass` |
| `bypass.antifrida` | `scripts/02_SecurityBypass/android-anti-frida-exposed-detection-bypass.js` | `android` | `bypass` |
| `bypass.biometric` | `scripts/02_SecurityBypass/Biometric/android-biometric-bypass-android11.js` | `android` | `bypass` |
| `bypass.debug` | `scripts/02_SecurityBypass/DebugMode_Emulator/android-debug-bypass.js` | `android` | `bypass` |
| `bypass.emulator` | `scripts/02_SecurityBypass/DebugMode_Emulator/android-emulator-detection-bypass.js` | `android` | `bypass` |
| `bypass.exit.system` | `scripts/02_SecurityBypass/android-system_exit_bypass.js` | `android` | `bypass` |
| `bypass.location` | `scripts/02_SecurityBypass/Location/android-location-spoofing.js` | `android` | `bypass` |
| `bypass.root.multi` | `scripts/02_SecurityBypass/RootDetection/android-multiple-root-bypass2.js` | `android` | `bypass` |
| `bypass.root.rootbeer` | `scripts/02_SecurityBypass/RootDetection/android-rootbeer-bypass.js` | `android` | `bypass` |
| `bypass.ssl.flutter` | `scripts/02_SecurityBypass/CertificatePinning/flutter-pinning-bypass.js` | `mixed` | `bypass` |
| `bypass.ssl.multi` | `scripts/02_SecurityBypass/CertificatePinning/android-multiple-pinning-bypass.js` | `android` | `bypass` |
| `bypass.ssl.okhttp` | `scripts/02_SecurityBypass/CertificatePinning/android-okhttp-pinning-bypass.js` | `android` | `bypass` |
| `bypass.ssl.trustmanager` | `scripts/02_SecurityBypass/CertificatePinning/android-trustmanager-pinning-bypass.js` | `android` | `bypass` |
| `bypass.ui.flagsecure` | `scripts/02_SecurityBypass/FlagSecure/android-flagsecure.js` | `android` | `bypass` |
| `bypass.webview.debug` | `scripts/02_SecurityBypass/WebView/android-enable-webview-debug.js` | `android` | `bypass` |
| `bypass.wifi` | `scripts/02_SecurityBypass/WiFi/android-wifi-check-bypass.js` | `android` | `bypass` |
| `observer.crypto.core` | `scripts/01_Observer/Crypto/android-crypto-observer.js` | `android` | `observer` |
| `observer.crypto.java` | `scripts/01_Observer/Crypto/android-java-crypto-observer.js` | `android` | `observer` |
| `observer.deeplink` | `scripts/01_Observer/DeepLink_UrlScheme/android-deeplink-observer.js` | `android` | `observer` |
| `observer.keystore` | `scripts/01_Observer/Storage/Keystore_keychain/android-keystore-monitor.js` | `android` | `observer` |
| `observer.library` | `scripts/01_Observer/Library/android-library-observer.js` | `android` | `observer` |
| `observer.network.okhttp.logger` | `scripts/01_Observer/Network/OkHttp/android-okhttp-logger.js` | `android` | `observer` |
| `observer.network.okhttp.proxy` | `scripts/01_Observer/Network/OkHttp/android-okhttp-proxy-installator.js` | `android` | `observer` |
| `observer.network.tcp.trace` | `scripts/01_Observer/Network/TCP/android-tcp-trace.js` | `android` | `observer` |
| `observer.permissions` | `scripts/01_Observer/android-permissions-observer.js` | `android` | `observer` |
| `observer.storage.filesystem` | `scripts/01_Observer/Storage/FileSystem/android-filesystem-observer.js` | `android` | `observer` |
| `observer.storage.sharedprefs` | `scripts/01_Observer/Storage/SharedPreferences/android-sharedpreferences-observer.js` | `android` | `observer` |
| `observer.storage.sharedprefs.encrypted` | `scripts/01_Observer/Storage/SharedPreferences/android-encryptedsharedpreferences-observer.js` | `android` | `observer` |
| `observer.storage.sqlcipher.password` | `scripts/01_Observer/Storage/SQLite/android-sqlitecipher-password-grabber.js` | `android` | `observer` |
| `observer.storage.sqlite` | `scripts/01_Observer/Storage/SQLite/android-sqlite-observer.js` | `android` | `observer` |
| `runtimeenum.app.env` | `scripts/03_StaticAnalysis/android-get-app-env-info.js` | `android` | `runtime-enum` |
| `runtimeenum.classes` | `scripts/03_StaticAnalysis/android-find-all-classes.js` | `android` | `runtime-enum` |
| `runtimeenum.classes.methods` | `scripts/03_StaticAnalysis/android-find-all-classes-methods.js` | `android` | `runtime-enum` |
| `runtimeenum.dex.classes` | `scripts/03_StaticAnalysis/android-dex_classes_enumeration.js` | `android` | `runtime-enum` |
| `runtimeenum.specific.class.methods` | `scripts/03_StaticAnalysis/android-find-specific-classes-methods.js` | `android` | `runtime-enum` |
| `specific.applock.auth.bypass` | `scripts/05_SpecificSoftware/AppLock-authentication-bypass.js` | `unknown` | `specific` |
| `utility.file.delete.prevent` | `scripts/04_Other/android-file-delete-prevention.js` | `android` | `utility` |
| `utility.injector` | `scripts/04_Other/android-injector.js` | `android` | `utility` |
| `utility.stetho.loader` | `scripts/04_Other/android-stetho-loader.js` | `android` | `utility` |

## Notes

- Canonical does not mean production-safe as-is. Rewrite/harden per `SKILL.md` and `frida-script-best-practices.md`.
- For Android tasks, filter out `platform: ios` and `platform: mixed` unless the user asks for cross-platform.
- Keep fallback order from the manifest to reduce random script selection.
