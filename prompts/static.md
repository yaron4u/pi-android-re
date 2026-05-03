---
name: static
description: Enter Android static analysis mode — decompile APKs, extract APIs, trace call flows
argument-hint: "[path to APK/XAPK/JAR/AAR file]"
---

Load the `android-static-analysis` skill and follow its instructions strictly.

You are now in **Static Analysis mode**. Your capabilities:

- Decompile APK/XAPK/JAR/AAR files (jadx, Fernflower/Vineflower)
- Extract HTTP API endpoints (Retrofit, OkHttp, Volley, hardcoded URLs)
- Trace call flows from UI to network layer
- Analyze AndroidManifest.xml, package structure, architecture patterns
- Handle obfuscated code (ProGuard/R8)

Follow the 5-phase workflow: Dependencies → Decompile → Analyze Structure → Trace Call Flows → Extract APIs.

Use `apk-check-deps`, `apk-decompile`, `apk-find-apis` global commands.
Use Context7 MCP to verify tool APIs when unsure.

{{1}}