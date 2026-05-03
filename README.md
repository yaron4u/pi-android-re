# pi-android-re

Android reverse engineering skills for the [Pi coding agent](https://pi.dev). Static analysis (decompilation, API extraction, call flow tracing) and dynamic analysis (Frida hooking, SSL pinning bypass, root detection bypass, anti-instrumentation evasion).

## Prerequisites

- [Pi coding agent](https://pi.dev) installed (`npm install -g @mariozechner/pi-coding-agent`)
- [Context7 MCP](https://github.com/upstash/context7) configured in `~/.pi/agent/settings.json` (recommended for API signature verification)

## Install

```bash
git clone https://github.com/yaron4u/pi-android-re.git
cd pi-android-re
bash install.sh
```

The installer copies skills, prompts, and AGENTS.md into `~/.pi/agent/` and creates `apk-*` CLI wrappers in `~/.local/bin/`.

## Usage

### Mode Selection

Launch Pi and type:


| Command    | Mode                                                               |
| ---------- | ------------------------------------------------------------------ |
| `/static`  | Static analysis -- decompile APKs, extract APIs, trace call flows  |
| `/dynamic` | Dynamic analysis -- Frida hooking, runtime bypass, instrumentation |


Pi also auto-detects the mode from your message. Say "decompile this APK" and it loads static. Say "write a Frida hook" and it loads dynamic.

### Static Analysis

The 5-phase workflow: **Dependencies -> Decompile -> Analyze Structure -> Trace Call Flows -> Extract APIs**.

```bash
apk-check-deps                               # verify environment
apk-install-dep java                         # install missing deps
apk-decompile app.apk                        # decompile with jadx (default)
apk-decompile --engine both --deobf app.apk  # both engines + deobfuscation
apk-find-apis output/sources/ --retrofit     # extract Retrofit endpoints
```

### Dynamic Analysis (Frida)

Covers:

- Root detection bypass (RootBeer, custom checks, System.exit)
- SSL pinning bypass (SSLContext, OkHttp, Conscrypt, TrustKit)
- Anti-Frida evasion (strstr, /proc/self/maps, port scanning)
- Biometric bypass (BiometricPrompt, FingerprintManager)
- Crypto monitoring (Cipher, SecretKey)
- Native instrumentation (Interceptor, pattern scanning, CModule)

## File Structure

```
pi-android-re/
  AGENTS.md                             # Global persona + mode selector
  install.sh                            # One-command installer
  prompts/
    static.md                           # /static prompt template
    dynamic.md                          # /dynamic prompt template
  skills/
    android-static-analysis/
      SKILL.md                          # 5-phase decompilation workflow
      scripts/
        check-deps.sh                   # Verify Java, jadx, vineflower, dex2jar
        install-dep.sh                  # Auto-install missing dependencies
        decompile.sh                    # Decompile APK/XAPK/JAR/AAR
        find-api-calls.sh               # Extract API endpoints from sources
      references/
        setup-guide.md                  # Dependency installation guide
        jadx-usage.md                   # jadx CLI reference
        fernflower-usage.md             # Fernflower/Vineflower reference
        api-extraction-patterns.md      # Grep patterns for API discovery
        call-flow-analysis.md           # Call flow tracing techniques
    android-dynamic-analysis/
      SKILL.md                          # Frida coding standards + examples
```

## Static Analysis Dependencies

Required: **Java JDK 17+**, **jadx**

Optional (recommended): **Vineflower/Fernflower**, **dex2jar**, **apktool**, **adb**

Run `apk-check-deps` after install to see what's missing. Use `apk-install-dep <name>` to install.

## Credits

- Static analysis scripts adapted from [SimoneAvogadro/android-reverse-engineering-skill](https://github.com/SimoneAvogadro/android-reverse-engineering-skill) (Apache 2.0)
- Dynamic analysis standards based on production Frida workflows

## License

Apache 2.0