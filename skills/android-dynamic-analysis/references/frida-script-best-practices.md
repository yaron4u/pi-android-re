# Frida Script Best Practices

This is the cleanup checklist for enhancing uploaded scripts or writing new ones.

## Required Skeleton

```javascript
"use strict";
// Usage: frida -U -f <package> -l script.js

setImmediate(() => {
  Java.perform(() => {
    // hooks
  });
});
```

Use `setImmediate` for Java hooks that should install as early as possible after script load. Do not hide class-loader races with random `setTimeout` values.

## Java Hooking

- Wrap every `Java.use()` in `try/catch`.
- Specify overloads explicitly.
- Use regular `function` for `.implementation` when calling the original through `this`.
- Use arrow functions for wrappers and iteration.
- Enumerate overloads only when building discovery scripts.
- For late-loaded classes, use class-loader enumeration and switch `Java.classFactory.loader`.

## Observer vs Bypass

Observer:

```javascript
Target.method.overload('java.lang.String').implementation = function (arg) {
  const result = this.method(arg);
  send({ type: 'observer', target: 'Target.method', arg: `${arg}`, result: `${result}` });
  return result;
};
```

Bypass:

```javascript
Target.isBlocked.overload().implementation = function () {
  console.log('[+] Target.isBlocked -> false');
  return false;
};
```

Do not mix them without naming the behavior clearly.

## Byte Arrays

Never concatenate Java byte arrays into strings. Convert or send binary:

```javascript
const jsArray = Java.array('byte', result);
const buffer = new Uint8Array(jsArray).buffer;
send({ type: 'bytes', source: 'Cipher.doFinal' }, buffer);
```

## Native Hooks

- Prefer exported symbols over offsets.
- If using offsets, document architecture and library version.
- Use `Process.arch` and `Process.pointerSize`.
- Check `.isNull()` before reading pointers.
- Wrap memory reads in `try/catch`.
- Use `ptr.readUtf8String()` rather than removed static `Memory.readUtf8String` style for Frida 17 readiness.
- Use `readVolatile()` when dumping memory that may disappear.

## Logging

Use compact, parseable logs:

| Prefix | Meaning |
|---|---|
| `[+]` | Hook installed or bypass succeeded |
| `[ ]` | Target class/method absent |
| `[-]` | Error |
| `[*]` | Information |
| `[!]` | Warning |

Use `send()` for data and `console.log()` for human status.

## Performance

- No expensive formatting in hot hooks.
- Cache `args[n]` once.
- Throttle or buffer repeated events.
- Do not hook framework-wide methods unless absolutely necessary.
- Move native hot-path filtering to `CModule` when JavaScript overhead is too high.

## Upgrade Checklist for Uploaded Scripts

1. Add strict skeleton and usage header.
2. Remove global variables and global helper names where possible.
3. Split compound scripts into independent `try/catch` blocks.
4. Replace implicit overload hooks with explicit signatures.
5. Convert `send("text")` to structured objects.
6. Keep binary payloads binary.
7. Narrow broad hooks using static-analysis evidence.
8. Add Android version and library version notes when relevant.
