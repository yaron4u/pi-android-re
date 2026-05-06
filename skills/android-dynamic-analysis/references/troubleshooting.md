# Dynamic Analysis Troubleshooting

## Hook Does Not Fire

Check in order:

1. Wrong process/package.
2. Hook installed after the method already ran; use spawn mode.
3. Class is loaded by a non-default class loader.
4. Wrong overload signature.
5. App uses another library path than the one you hooked.
6. Code is native/Flutter/React Native, not Java.

Useful commands:

```bash
frida-ps -Uai
frida -U -f <package> -l script.js
frida -U -n <process> -l script.js
```

## Class Not Found

Use runtime enumeration scripts from `03_StaticAnalysis/` and filter by app package. If static analysis found a class but Frida cannot, it may be dynamically loaded. Enumerate class loaders and set `Java.classFactory.loader` to the loader that can resolve it.

## Wrong Overload

Temporarily enumerate overloads:

```javascript
Target.method.overloads.forEach((overload) => {
  console.log(`${overload.returnType.className} method(${overload.argumentTypes.map((t) => t.className).join(', ')})`);
});
```

Then replace discovery with explicit `.overload(...)` hooks.

## App Crashes After Injection

Remove these first:

- Global `java.io.File.exists` hooks
- Global `String.contains`/`equals` hooks
- Noisy crypto hooks emitting every block
- Native pointer reads without null checks
- Native path replacement with `ptr(0)`
- Hooks that fail to call original methods in observer mode

## SSL Still Fails

Static-check the networking stack again:

- OkHttp pinner may be generated or Kotlin method `check$okhttp`.
- Conscrypt may verify chain below Java-level pinners.
- Flutter uses native TLS in `libflutter.so`.
- React Native/Hermes may involve native layers.
- Network Security Config can combine with custom pinning.

Use a layered pinning bypass only after identifying which layer exists.

## Root Still Detected

Find the exact detector:

- RootBeer: hook its methods directly.
- Proprietary checks: trace calls to `Runtime.exec`, `ProcessBuilder`, `SystemProperties.get`, package manager, and file checks.
- Native checks: inspect `open`, `access`, `stat`, `fopen`, `strstr`, and `/proc` reads.

Do not blindly hook every filesystem call forever. Use observers to identify the path, then write a narrow bypass.

## Output Is Too Noisy

- Add package/class filters.
- Emit only on interesting values.
- Buffer and flush summaries.
- Use `send()` for structured events and parse on host.
- Do not print every native function call.
