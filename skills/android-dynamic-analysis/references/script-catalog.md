# Dynamic Script Catalog

Reference map for `scripts/`. Use this like the static-analysis references: identify the target, pick the smallest matching script, then harden it before field use.

## Directory Model

| Folder | Purpose | Use When |
|---|---|---|
| `01_Observer/` | Runtime visibility without changing app decisions | You need to watch crypto, network, storage, logs, libraries, deep links, or permissions |
| `02_SecurityBypass/` | Change security decisions at runtime | You need to bypass pinning, root/jailbreak, biometric, emulator/debug, WebView, WiFi, location, or exit behavior |
| `03_StaticAnalysis/` | Runtime enumeration that supports static analysis | jadx output is obfuscated, incomplete, or misses dynamically loaded classes |
| `04_Other/` | Utility/injection helpers | You need helper behavior like loading Stetho or preventing deletion |
| `05_SpecificSoftware/` | App-specific bypasses | The package/product matches the script target |

## Android vs iOS

The uploaded scripts contain both Android and iOS variants. For this Android skill, prefer files whose names start with `android-`. Use iOS scripts only as pattern references, not as copy-paste material.

## Variant Naming

Files ending in `2`, `3`, etc. are alternate implementations, not guaranteed upgrades.

Use variants this way:

1. Read all variants for the feature.
2. Extract the unique hook targets from each.
3. Keep the narrowest hooks first.
4. Merge only compatible hooks.
5. Add per-target `try/catch` so one missing class does not kill the whole script.
6. Convert old style (`var`, implicit overloads, global functions) to the strict Frida standard in `SKILL.md`.

## First-Pass Selection

| Goal | Start With |
|---|---|
| See HTTP requests/responses using OkHttp | `01_Observer/Network/OkHttp/android-okhttp-logger*.js` |
| Trace raw TCP connections | `01_Observer/Network/TCP/android-tcp-trace.js` |
| Observe crypto algorithms, keys, IVs, hashes | `01_Observer/Crypto/android-crypto-observer.js`, `android-java-crypto-observer.js`, AES/PBE variants |
| Observe SharedPreferences | `01_Observer/Storage/SharedPreferences/android-sharedpreferences-observer.js` |
| Observe encrypted preferences | `01_Observer/Storage/SharedPreferences/android-encryptedsharedpreferences-observer.js` |
| Observe SQLite/SQLCipher | `01_Observer/Storage/SQLite/android-sqlite-observer.js`, `android-sqlitecipher-*` |
| Bypass SSL pinning broadly | `02_SecurityBypass/CertificatePinning/android-multiple-pinning-bypass*.js` |
| Bypass OkHttp pinning only | `02_SecurityBypass/CertificatePinning/android-okhttp-pinning-bypass*.js` |
| Bypass TrustManager pinning | `02_SecurityBypass/CertificatePinning/android-trustmanager-pinning-bypass*.js` |
| Bypass Flutter TLS pinning | `02_SecurityBypass/CertificatePinning/flutter-*.js` |
| Bypass RootBeer | `02_SecurityBypass/RootDetection/android-rootbeer-bypass.js`, RootBeer/Flutter variants |
| Bypass broad root checks | `02_SecurityBypass/RootDetection/android-multiple-root-bypass*.js` |
| Block `System.exit()` | `02_SecurityBypass/android-system_exit_bypass.js` |
| Enable WebView debugging | `02_SecurityBypass/WebView/android-enable-webview-debug.js` |
| Enumerate runtime classes/methods | `03_StaticAnalysis/android-find-all-classes*.js`, specific-class variants |
