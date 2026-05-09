# Extracted Style Notes: Android/Linux Reverse-Engineering Reports

Validation status: reviewed and aligned with scraped source set in `examples/liked-reports/`.

Sources examined:

- Gal Beniamini, Bits Please, “Effectively bypassing kptr_restrict on Android”
- Di Shen, BlackHat EU 2016 whitepaper, “Rooting Every Android From Extension To Exploitation”
- Quarkslab, “A Deep Dive Into Samsung's TrustZone” Part 1 and Part 3
- Quarkslab, “CVE-2020-0069: Autopsy of the Most Stable MediaTek Rootkit”

---

## 1. Section order

### Common high-quality order

The strongest reports do not begin with raw exploit details. They build a ladder:

1. **Title + metadata**
   - Date, author, category, tags, affected technology.
   - Helps the reader understand whether the report is a blog post, whitepaper, exploit write-up, or reverse-engineering note.

2. **One-paragraph promise**
   - State what the report explains.
   - Good pattern: “In this article we will explain X, show how Y works, and demonstrate Z at a high level.”

3. **Motivation / why this matters**
   - Why the component exists.
   - Why the bug class matters.
   - Why the reader should care before they see code.

4. **Scope and assumptions**
   - Device, kernel version, firmware version, SoC, Android version, privilege assumptions, patch status.
   - This is what makes the report trustworthy.

5. **Background primer**
   - Explain the mechanism before the bug.
   - Examples: kptr_restrict, TrustZone, TEE, DMA, IOCTL, Binder, WEXT, CMDQ.
   - The goal is not to teach everything; it is to teach only what the reader needs for this report.

6. **System architecture / component map**
   - Show where the vulnerable component sits.
   - This is where architecture diagrams are useful.

7. **Attack surface / entry point**
   - Describe how input reaches the component.
   - Keep this focused on understanding and auditability, not on encouraging misuse.

8. **Relevant data structures / command format / binary format**
   - Add struct snippets, field layouts, packed command diagrams, memory maps, or file-format diagrams.
   - Use this before the root-cause explanation if the bug depends on fields, offsets, or layout.

9. **Root cause / vulnerability analysis**
   - Explain the actual mistake: missing check, wrong trust boundary, unsafe lifetime, weak mitigation, unchecked command, race window, broken assumption.
   - This section should answer: “What did the developer believe was safe, and why was that belief false?”

10. **Evidence block**
    - Code snippet, patch diff, log, screenshot, crash trace, debugger view, or binary-analysis output.
    - Evidence should immediately follow the claim it supports.

11. **Exploitability / impact, at a safe level**
    - Explain what security boundary is crossed and what capability results.
    - Avoid turning the report into a copy-paste exploitation guide unless the intended audience and disclosure context make that appropriate.

12. **Patch / mitigation / vendor response**
    - What changed.
    - What defense would have blocked the issue.
    - What remains risky.

13. **Conclusion**
    - Restate the lesson.
    - Connect the specific bug to a broader engineering/security theme.

14. **References / disclosure timeline / acknowledgements**
    - Quarkslab-style reports often end with references and, for vulnerability write-ups, disclosure timeline details.

### Differences between the reports

- **Bits Please style**: starts with a plain-English question, then breaks the report into “Method #1 / Method #2 / Method #3.” This is very readable because each method has its own mini-problem, evidence, and takeaway.
- **Quarkslab Part 1 style**: formal table-of-contents structure: motivations, introduction, architecture primer, component-by-component reverse engineering, conclusion, references. Best for deep systems explanations.
- **Quarkslab Part 3 style**: vulnerability-chain structure: introduction, revocation/design issue, code execution in trustlet, code execution in secure driver, higher-privilege abuse, conclusion, disclosure timeline, references. Best when the report follows privilege boundaries.
- **Quarkslab MediaTek style**: short intro, CVE context, vulnerable driver, command model, read/write capability demonstration, conclusion. Best when the key idea is a driver interface and its command grammar.
- **BlackHat whitepaper style**: case-study sequence. Each case has bug context, vulnerable code, patch/evidence, trigger path, race or impact explanation, then mitigation. Best for conference material and exploit-chain storytelling.

---

## 2. Tone

### Overall tone

Use **teacherly confidence**:

- confident enough to guide the reader;
- careful enough to state assumptions;
- technical enough to earn trust;
- plain enough that a strong reader can follow even if the component is new.

### Tone patterns from the reports

- **Bits Please**: conversational, direct, slightly playful. It uses rhetorical questions like “So how does this work?” and then answers them step-by-step.
- **Quarkslab**: formal, measured, research-lab style. It avoids unnecessary hype and explains architecture before exploitation.
- **BlackHat whitepaper**: blunt and case-driven. It uses direct claims and evidence quickly, because the format is closer to a talk companion.
- **MediaTek rootkit report**: concise, practical, and skeptical. It says what is known, what is unknown, what was tested, and what the patch-management lesson is.

### Best tone to copy

For your own reports, use this mix:

- **Quarkslab for structure**
- **Bits Please for readability**
- **BlackHat for visualizing races and patches**
- **MediaTek report for compact driver/command analysis**

Good tone sentence:

> Before looking at the bug, we need to understand the object lifetime that the driver assumes.

Bad tone sentence:

> This is a crazy bug and now we will pwn everything.

---

## 3. Sentence style

### The common rhythm

Strong reports often use this sentence rhythm:

1. **Claim**: “The driver accepts commands from userland.”
2. **Context**: “Those commands are copied into a command buffer and interpreted by hardware.”
3. **Evidence**: code snippet, diagram, log, patch, or screenshot.
4. **Meaning**: “This matters because the validation is performed after trust has already been given to the field.”
5. **Transition**: “Now that the command format is clear, we can look at the missing check.”

### Style rules

- Define acronyms the first time: “Trusted Execution Environment, or TEE.”
- Use code formatting for identifiers: `ioctl`, `struct`, `tlApiWaitNotification`, `CMDQ_CODE_WRITE`.
- Prefer one main idea per paragraph.
- Use short signpost sentences before hard sections:
  - “Now that the architecture is clear, let’s look at the driver.”
  - “The important field is the length field.”
  - “The patch reveals the broken assumption.”
- After dense code, always add a plain-English interpretation.
- Avoid unexplained jumps from “here is the code” to “therefore code execution.” Add the missing conceptual bridge.

### Useful phrase patterns

- “The important detail is…”
- “This matters because…”
- “From the reader’s point of view…”
- “At this point, we know three things…”
- “The patch is small, but it reveals the root cause…”
- “The diagram is not meant to show every field; it shows the fields that affect the bug.”

---

## 4. Evidence format

### Best evidence pattern

Use this order:

> **Claim → evidence → interpretation → next step**

Example format:

```markdown
The command buffer is trusted before all relevant fields are validated.

[small code snippet or diagram]

The important part is not the whole function. The important part is that `field_x` is consumed before the boundary check. That makes the following state reachable.
````

### Evidence types and when to use them

| Evidence type         | Use it when                                                                | Report pattern                                                                   |
| --------------------- | -------------------------------------------------------------------------- | -------------------------------------------------------------------------------- |
| Code snippet          | A condition, branch, lock, permission check, or object lifetime is the key | BlackHat and Quarkslab use code blocks heavily                                   |
| Patch diff            | The fix reveals the bug more clearly than the vulnerable code              | BlackHat uses patch evidence before explaining the race branch                   |
| Terminal/log output   | Timing, permissions, crash, or observed behavior matters                   | Bits Please and MediaTek reports use command/log output as proof                 |
| Binary/hex screenshot | Offset, marker, compressed table, or file format matters                   | Bits Please uses binary-region evidence for kernel symbol-table reasoning        |
| Architecture diagram  | The reader must understand boundaries first                                | Quarkslab Part 1 uses many system diagrams                                       |
| Data-layout diagram   | Fields, bits, offsets, or command words matter                             | MediaTek CMDQ report uses command-format diagrams                                |
| Timeline/swimlane     | Two actors or threads interleave                                           | BlackHat uses branch/race visuals for the UAF case                               |
| Table                 | Many small facts must be compared exactly                                  | Bits Please uses marker tables; Quarkslab uses structured component descriptions |

### Evidence hygiene

* Crop screenshots to the relevant lines.
* Highlight only the fields or branches being discussed.
* Do not paste huge code blocks without explaining what to look at.
* Put evidence immediately after the claim it supports.
* Add a “reader lens” sentence after evidence: “The reader should notice X.”
* Do not rely on screenshots when a clean text snippet would be easier to read.

---

## 5. Figure caption style

### What good captions do

A good caption is not just a label. It tells the reader what the figure is doing in the argument.

Weak caption:

> CMDQ diagram

Strong caption:

> Figure 3 — CMDQ command-word layout. The important point is that the command code selects how the remaining fields are interpreted.

### Caption formula

Use this formula:

> **Figure N — Object being shown. Why the reader should care.**

Examples:

* **Figure 1 — TrustZone world separation. This anchors the rest of the report by showing which components run in Normal World and which run in Secure World.**
* **Figure 2 — Trustlet lifecycle. User-controlled TCI data becomes relevant at the command-handler stage.**
* **Figure 3 — Vulnerable object lifetime during the race. Thread 1 frees the object before Thread 2 reaches the later dereference.**
* **Figure 4 — Packed command layout. The diagram shows which bits select the operation and which bits are interpreted as register or address fields.**
* **Figure 5 — Patch diff. The removed call shows which state transition the fix prevents.**

### When to add a figure

Add a figure when the reader would otherwise need to mentally simulate one of these:

* more than three components;
* a trust boundary;
* a call chain crossing processes or worlds;
* a race between two threads;
* a packed binary structure;
* a memory layout or object lifetime;
* a patch that changes control flow;
* a sequence where the order matters.

Do **not** add a figure for a fact that can be stated in one sentence.

---

## 6. Severity language

### Use precise severity language

Good reports do not just say “bad” or “critical.” They explain:

* **who** can trigger the issue;
* **what privilege** is required;
* **what boundary** is crossed;
* **what capability** is gained;
* **what versions/devices** are affected;
* **whether a patch exists**;
* **what assumptions** the result depends on.

### Severity vocabulary

Use words like:

* “local privilege escalation”
* “kernel memory disclosure”
* “arbitrary read/write of system memory”
* “code execution in a higher-privileged component”
* “requires access to the vulnerable device node”
* “requires a specific vendor kernel configuration”
* “patched in…”
* “not a full-chain exploit”
* “tested on…”
* “we did not verify…”

### Avoid vague hype

Avoid:

* “full pwn”
* “unstoppable”
* “works everywhere”
* “universal root” unless the report proves broad coverage and states limits
* “critical” without explaining impact and preconditions

### Good severity sentence

> This is high severity because a local unprivileged app can reach a driver interface that eventually gives read/write access to system memory on the tested vulnerable device.

### Even better severity sentence

> On the tested device and kernel build, the vulnerable driver interface is reachable from an unprivileged local context, and the resulting primitive crosses the user/kernel boundary. The conclusion should not be generalized to devices where the node permissions, kernel configuration, or vendor patch level differ.

---

## 7. Strategy for writing “banger” RE reports

Your note to yourself was:

> Find someone who has a history of making banger reports and understand how he is crafting them: what strategy, when to add graphs, what kind of graphs, how to explain a specific topic, what is relevant to the reader, how to make the reader understand something new or unique while reading it.

Here is the practical strategy.

### Step 1: Pick the role model by report type

Do not copy one author for everything. Pick based on the report you are writing:

* For **deep architecture RE**, copy the Quarkslab Part 1 structure.
* For **bug-to-impact vulnerability analysis**, copy the Quarkslab Part 3 structure.
* For **readable mitigation-bypass storytelling**, copy the Bits Please style.
* For **race condition and case-study storytelling**, copy the BlackHat whitepaper style.
* For **driver command grammar and small technical proof**, copy the MediaTek CMDQ report style.

### Step 2: Build the reader’s mental model before the bug

The reader should never reach the vulnerability section while still asking:

* “What component are we in?”
* “Who controls this input?”
* “What privilege level is this?”
* “What does this structure represent?”
* “Why does this function matter?”

If the reader lacks one of those answers, add a short primer, diagram, or table before continuing.

### Step 3: Explain only what is relevant

A report is not a textbook. Explain the minimum system background needed to understand the vulnerability.

Good relevance filter:

* Include it if it changes the reader’s understanding of the bug.
* Include it if it explains a security boundary.
* Include it if it explains why the exploitability claim is true.
* Remove it if it is just interesting but does not support the report’s argument.

### Step 4: Use graphs as cognitive tools

Every visual should reduce mental load.

| Reader confusion                 | Best graph/visual                       |
| -------------------------------- | --------------------------------------- |
| “Where is this component?”       | Architecture diagram                    |
| “Who talks to whom?”             | Data-flow / IPC diagram                 |
| “What happens first?”            | Flowchart                               |
| “Which thread does what?”        | Timeline / swimlane                     |
| “What does this field mean?”     | Bit-field / struct diagram              |
| “Where is the object in memory?” | Memory-layout diagram                   |
| “What changed in the fix?”       | Patch diff screenshot or annotated diff |
| “How do we know this happened?”  | Log or terminal evidence                |
| “How do these methods compare?”  | Table                                   |

### Step 5: Make the reader feel progress

A great report gives the reader frequent small wins:

* Start each hard section with a plain-language goal.
* End each hard section with a summary of what is now known.
* Reuse the same names for actors/components throughout.
* Do not introduce five new identifiers at once.
* When introducing a diagram, tell the reader what to look at.
* After a dense snippet, translate it into one or two human sentences.

Example:

```markdown
At this point, we know the driver accepts a command buffer, that the command words encode both operation and register selection, and that the address register can later influence a memory access. The next question is whether the driver validates that address before the hardware consumes it.
```

### Step 6: The “banger report” skeleton

```markdown
# Title: specific, technical, not clickbait

## Summary
One paragraph: what was analyzed, what was found, why it matters.

## Environment and scope
Device / version / component / assumptions / patch status.

## Background needed for this bug
Only the concepts needed to understand the rest.

## Architecture
Diagram: components, privilege levels, trust boundaries.

## Attack surface
How input reaches the component, described safely and precisely.

## Data structures or command format
Structs, fields, bit layouts, memory layout.

## Root cause
The broken assumption and the exact place it appears.

## Evidence
Code, diff, logs, screenshots, crash trace, or RE notes.

## Impact
What boundary is crossed, under what assumptions.

## Patch / mitigation
What changed and what lesson it teaches.

## Conclusion
One broader lesson.

## References
Links, advisories, prior research, patches.
```

---

## 8. Final checklist before publishing

Before publishing a reverse-engineering report, check:

* Did I state the tested device/version/build?
* Did I explain the relevant component before the bug?
* Did I identify the trust boundary?
* Did I prove every important claim with evidence?
* Did I explain the evidence after showing it?
* Did every figure have a job?
* Did every figure caption tell the reader what to notice?
* Did I avoid unnecessary exploit details when impact can be explained safely?
* Did I distinguish confirmed facts from assumptions?
* Did I include patch status, mitigation, or disclosure context?
* Did I end with the security lesson, not just the technical trick?

---

## 9. One-sentence rule

A strong Android/Linux RE report is not just “I found a bug.” It is:

> “Here is the system model, here is the broken assumption, here is the evidence, here is the boundary crossed, and here is the lesson that helps the next reader audit similar code.”

Reference source:
- https://bits-please.blogspot.com/2015/08/effectively-bypassing-kptrrestrict-on.html
