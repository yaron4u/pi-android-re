# Observer Scripts

Observer scripts collect evidence while preserving app behavior. They must call the original method unless the whole point is controlled instrumentation.

## When to Use Observers

Use observers when you need answers to these questions:

- What endpoint is called at runtime?
- What headers/tokens are added after static construction?
- What crypto algorithm, key, IV, plaintext, or ciphertext is used?
- What preferences, SQLite rows, files, logs, cookies, or keystore aliases are touched?
- Which libraries/classes are loaded dynamically?

## Main Families

| Family | Scripts | What They Reveal |
|---|---|---|
| Crypto | `01_Observer/Crypto/android-*` | `Cipher`, `Mac`, `MessageDigest`, PBE, random generation, AES material |
| Network/OkHttp | `01_Observer/Network/OkHttp/android-*` | Request/response body, headers, interceptors, proxy insertion |
| Network/TCP | `01_Observer/Network/TCP/android-tcp-trace.js` | Native socket destinations and raw connection behavior |
| Storage/SharedPreferences | `01_Observer/Storage/SharedPreferences/android-*` | Preference keys/values and encrypted preference usage |
| Storage/SQLite | `01_Observer/Storage/SQLite/android-*` | SQL queries and SQLCipher passwords |
| Storage/FileSystem | `01_Observer/Storage/FileSystem/android-*` | File reads/writes/deletes |
| Keystore | `01_Observer/Storage/Keystore_keychain/android-keystore-monitor.js` | AndroidKeyStore aliases and key operations |
| Deep links | `01_Observer/DeepLink_UrlScheme/android-*` | Intent URLs and route handlers |
| Runtime classes | `03_StaticAnalysis/android-*` | Loaded classes/methods when static decompilation is weak |

## Variant Handling

Many observer variants differ in scope:

- Small variants target one API and are safer.
- Large variants hook many overloads and produce more noise.
- Password grabber variants intentionally capture secrets; keep output structured and avoid console spam.
- Runtime enumeration scripts can be expensive; filter by package prefix whenever possible.

## Enhancement Rules

Before reusing an uploaded observer, fix it:

```javascript
"use strict";
// Usage: frida -U -f <package> -l observer.js

setImmediate(() => {
  Java.perform(() => {
    let Target;
    try {
      Target = Java.use('com.example.Target');
    } catch (e) {
      console.log('[ ] com.example.Target');
      return;
    }

    Target.method.overload('java.lang.String').implementation = function (value) {
      send({ type: 'observer', target: 'Target.method', value: `${value}` });
      return this.method(value);
    };

    console.log('[+] com.example.Target.method');
  });
});
```

## Do Not Do This

- Do not use `var`.
- Do not hook all overloads in hot paths unless you throttle output.
- Do not stringify Java byte arrays directly.
- Do not omit original calls in observers.
- Do not use global `File.exists` or `String.contains` hooks as a first move.
- Do not dump every loaded class without filtering by target package.

## Output Best Practice

Use structured events:

```javascript
send({
  type: 'crypto',
  api: 'Cipher.doFinal',
  algorithm: `${this.getAlgorithm()}`,
  direction: 'output'
}, buffer);
```

Use binary payloads for bytes. Use JSON only for metadata.
