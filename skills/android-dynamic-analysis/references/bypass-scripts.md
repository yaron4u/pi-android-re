# Bypass Scripts

Bypass scripts intentionally change app decisions. Use the narrowest bypass that matches the static evidence. Broad bypasses are fallback tools, not the first move.

## Certificate Pinning

| Evidence | Use |
|---|---|
| `okhttp3.CertificatePinner` | `CertificatePinning/android-okhttp-pinning-bypass*.js` |
| `SSLContext.init`, custom TrustManager | `CertificatePinning/android-trustmanager-pinning-bypass*.js` |
| Conscrypt `TrustManagerImpl` | `CertificatePinning/android-multiple-pinning-bypass*.js` |
| TrustKit classes | Multiple pinning bypass or TrustKit-specific hook from variants |
| `libflutter.so` | `CertificatePinning/flutter-*.js` |
| PhoneGap/Cordova | `phonegap-pinning-bypass.js` or WebView/Cordova variants |

Production pinning bypasses should be layered, with each target isolated:

```javascript
try {
  const Pinner = Java.use('okhttp3.CertificatePinner');
  Pinner.check.overload('java.lang.String', 'java.util.List').implementation = function () {};
  console.log('[+] okhttp3.CertificatePinner.check(String, List)');
} catch (e) {
  console.log('[ ] okhttp3.CertificatePinner.check(String, List)');
}
```

## Root / Jailbreak / Emulator

| Evidence | Use |
|---|---|
| RootBeer library | `RootDetection/android-rootbeer-bypass*.js` |
| Flutter plus RootBeer | `RootDetection/android-rootbeer--flutter-bypass*.js` |
| Mixed checks: packages, binaries, props, exec | `RootDetection/android-multiple-root-bypass*.js` |
| Xamarin root checks | Xamarin variants |
| `Build.FINGERPRINT`, `ro.kernel.qemu`, emulator strings | `DebugMode_Emulator/android-emulator-detection-bypass.js` |
| ADB/debug checks | `android-adb-detection-bypass.js`, `android-debug-bypass.js` |

Prefer hooking the detection library result method. Only hook OS APIs when no library-level target exists.

## Biometric

Use biometric bypass variants when auth callbacks gate local features. Cover both:

- `android.hardware.biometrics.BiometricPrompt` for API 28+
- `android.hardware.fingerprint.FingerprintManager` for API 23-27

Keep callback references alive with `Java.retain()` and invoke callbacks on the main thread.

## WebView / UI / Device State

| Goal | Script |
|---|---|
| Screenshots despite `FLAG_SECURE` | `FlagSecure/android-flagsecure.js` |
| Enable WebView debugging | `WebView/android-enable-webview-debug.js` |
| Force/alter SDK version | `android-sdk-version-change.js` |
| Spoof location | `Location/android-location-spoofing.js` |
| Bypass WiFi checks | `WiFi/android-wifi-check-bypass.js` |
| Stop defensive app termination | `android-system_exit_bypass.js` |

## Hardening Old Bypass Scripts

The uploaded scripts are useful references, but many use older style. Before generating a new script:

- Add `"use strict";`.
- Replace `var` with `const`/`let`.
- Use explicit `.overload(...)`.
- Use regular `function` for implementations that need `this`.
- Wrap each hook family in its own `try/catch`.
- Log `[+]` for installed hooks and `[ ]` for absent hooks.
- Avoid giant global OS hooks unless static analysis proves they are needed.
- Return the correct type: primitive boolean vs `java.lang.Boolean` object.

## Safety Rules

- Native bypasses must check pointers before reading.
- Redirect suspicious file paths to allocated dummy strings, never `NULL`.
- Keep allocated replacement strings alive on `this` or outer scope.
- Do not spam logs from `strstr`, `open`, `connect`, or crypto hot paths.
