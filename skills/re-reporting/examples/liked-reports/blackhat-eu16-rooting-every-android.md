# Source: BlackHat EU 2016 — Rooting Every Android: From Extension to Exploitation

- URL: https://blackhat.com/docs/eu-16/materials/eu-16-Shen-Rooting-Every-Android-From-Extension-To-Exploitation-wp.pdf
- Scrape status: success (PDF text extracted)

## Why this report is useful
- Strong case-study segmentation by chipset/vendor path.
- Good race/UAF explanation pattern with trigger + racing + heap refill.
- Includes mitigation evolution (surface reduction in SELinux/ioctl policy).

## Style to copy
- Keep attack surface analysis before exploit details.
- Use compact code excerpts around exact unsafe operations.
- Tie each exploit stage to one primitive gain.

## Graphs this source suggests
1. Chipset-vulnerability matrix (Qualcomm/MTK/Broadcom).
2. Race timeline swimlane for UAF trigger windows.
3. Mitigation timeline (pre-fix -> policy tightening).
