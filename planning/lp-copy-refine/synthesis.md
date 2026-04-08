# Agent 0 Synthesis — 4 Perspective Comparison

## Where All 4 Agree (High Confidence Changes)

1. **Merge Pain + Before/After into one section** — All 4 say Pain (text) and Before/After (visual) are redundant. Use Pain headline as the heading for the Before/After visual. Delete the body paragraph.

2. **Fix muted text contrast** — #888888 on #111214 fails WCAG AA. All recommend raising to ~#A0A0A0 or #A1A1AA.

3. **CTA label is ambiguous** — "Get Mac Early Access" mixes download + waitlist signals. Either "Join the Mac Beta" (waitlist) or "Download for Mac" (download). Pick one.

4. **Trim the subhead** — Three value props in one subhead means none land. Cut to one line.

5. **The Before/After visual is the page's backbone** — Preserve it. It communicates the value proposition instantly.

6. **Tool strip is valuable but should be quieter** — Keep it, but make logos monochrome/muted so they don't compete with the CTA.

7. **Dark mode aesthetic is a strong differentiator** — Preserve. It signals builder-grade tooling.

8. **The hero headline works** — "Stop checking your app in 20 tabs" is specific, felt, emotional. Keep it.

## Where 3/4 Agree

9. **Remove the Positioning section** — Claude Maeda, Gemini Maeda, Claude UX say remove. Gemini UX says keep. Resolution: Remove — it serves internal strategy, not the visitor.

10. **Add mid-page CTA after Before/After** — Claude UX, Claude Maeda (implicit via section reduction), Codex all note the gap. Only Gemini Maeda didn't flag it.

11. **Feature Card 2 needs reframing** — "Your AI organises the canvas" is vague. Show the mechanism or reframe as outcome.

12. **Waitlist form is unspecified** — Claude UX and Gemini UX flag this. The most important interaction has no design.

## Where Models Diverge

13. **Disambiguator: keep or remove?**
- Claude UX: make it more prominent, move it up
- Claude Maeda: REMOVE from hero (adds doubt at action moment)
- Gemini UX: keep it, it's brilliant
- Gemini Maeda: keep it, it's "brilliant UX writing"

Resolution: KEEP but move to footer/confirmation. 3 of 4 find value in it, but Claude Maeda's point about doubt at action moment is valid. Don't place it next to the CTA.

14. **Intent bridge (eyebrow text)?**
- Claude UX: yes, bridge the keyword gap
- Gemini UX: yes, add "Moving from Figma to Code?" eyebrow
- Claude Maeda: let the visual do the work
- Gemini Maeda: rejected, adds visual elements

Resolution: The hero screenshot IS the intent bridge. If someone sees a dark canvas with web pages, they get it. Don't add text clutter. But the subhead should acknowledge the journey: "Your AI wrote the code. Now see every screen at once."

15. **Hero media: static vs video?**
- Gemini UX: make hero a 5-sec looping video
- Others: static screenshot is fine for launch

Resolution: Static screenshot for launch (video isn't possible until Stage 3a+). Note video as a future enhancement.
