# Static-to-Dynamic Workflow

Replicate the static-analysis approach: static evidence chooses dynamic hooks. Do not spray random Frida scripts at the app like a clown.

## 1. Start With Static Findings

From jadx/static references collect:

- Package name and launch activity
- Network stack: Retrofit, OkHttp, Volley, `HttpURLConnection`, WebView, native/Flutter
- Pinning libraries: OkHttp `CertificatePinner`, TrustKit, Conscrypt, Netty, custom TrustManager, Flutter TLS
- Root/emulator libraries: RootBeer, proprietary checks, Magisk strings, `SystemProperties`, `Runtime.exec`
- Crypto APIs: `Cipher`, `Mac`, `MessageDigest`, `KeyStore`, `SecretKeyFactory`, PBE classes
- Storage APIs: SharedPreferences, EncryptedSharedPreferences, SQLite, SQLCipher, files
- Dynamic loading: DexClassLoader, PathClassLoader, native `System.loadLibrary`

## 2. Map Static Evidence to Canonical IDs

Use `script-metadata.manifest.json` routing rules first. Then map evidence to canonical IDs:

| Static Evidence | Preferred Canonical ID | Fallback |
|---|---|---|
| `okhttp3.OkHttpClient`, interceptors | `observer.network.okhttp.logger` | `observer.network.okhttp.proxy` |
| `okhttp3.CertificatePinner` | `bypass.ssl.okhttp` | `bypass.ssl.multi`, `bypass.ssl.trustmanager` |
| `javax.net.ssl.SSLContext.init` | `bypass.ssl.trustmanager` | `bypass.ssl.multi` |
| `com.android.org.conscrypt.TrustManagerImpl` | `bypass.ssl.multi` | `bypass.ssl.trustmanager` |
| `libflutter.so` | `bypass.ssl.flutter` | `bypass.ssl.multi` |
| `com.scottyab.rootbeer.RootBeer` | `bypass.root.rootbeer` | `bypass.root.multi`, `bypass.exit.system` |
| `Runtime.exec`, `ProcessBuilder`, `getprop`, `which su` | `bypass.root.multi` | `bypass.exit.system` |
| `System.exit` after a security check | `bypass.exit.system` | `bypass.root.multi` |
| `Cipher.getInstance`, `doFinal`, `Mac`, `MessageDigest` | `observer.crypto.core` | `observer.crypto.java` |
| `EncryptedSharedPreferences` | `observer.storage.sharedprefs.encrypted` | `observer.storage.sharedprefs` |
| `SQLiteDatabase`, `SQLiteOpenHelper` | `observer.storage.sqlite` | `observer.storage.filesystem` |
| `net.sqlcipher.database.SQLiteDatabase` | `observer.storage.sqlcipher.password` | `observer.storage.sqlite` |
| `WebView.setWebContentsDebuggingEnabled` | `bypass.webview.debug` | `bypass.ui.flagsecure` |

## 3. Choose Spawn vs Attach

Use spawn when the target logic runs during startup:

```bash
frida -U -f <package> -l script.js
```

Use attach when observing behavior after the app is already stable:

```bash
frida -U -n <process-name> -l script.js
```

If classes are loaded late, wrap hooks in `setImmediate(() => Java.perform(...))` and add class-loader handling instead of blind `setTimeout` delays.

## 4. Build a Field Script

1. Copy only the hook families needed by static evidence.
2. Add `"use strict";` and a usage header.
3. Wrap every `Java.use()` in its own `try/catch`.
4. Specify overloads explicitly.
5. Call originals in observer scripts.
6. Suppress or replace return values only in bypass scripts.
7. Emit structured `send({ type, target, data })` for machine parsing.
8. Keep hot hooks quiet; log only decisions and summaries.

## 5. Validate

- Confirm each hook prints `[+]` once at load.
- Trigger the app feature and verify the hook fires.
- If it does not fire, confirm class loader, overload signature, and timing.
- If the app crashes, remove broad hooks first: `File.exists`, `String.contains`, hot crypto loops, native string hooks.
