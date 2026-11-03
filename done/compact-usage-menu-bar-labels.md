# Compact Usage Menu-Bar Labels

## Stage

Complete

## Original Request

Implement compact connected menu-bar usage labels matching:

```text
[ M 32% · 2h ]  [ 2 64% · 4d ]  [ O 5% · 6d ]
```

Claude reset times must remain permanently visible because they are operationally important.

## Plan

- Shorten only the menu-bar account labels: `Main` to `M`, `2nd` to `2`, and `OpenAI` to `O`.
- Remove `wk` from menu-bar labels without changing popover or in-window copy.
- Keep reset countdowns visible whenever reset data exists, but show only the largest whole unit rounded down: minutes below one hour, hours below one day, and days thereafter.
- Preserve percentages, the middle-dot separator, the 30-second refresh, warning colour, loading/error states, and single-Claude-account prefix behaviour.
- Update OpenAI formatter tests, add Claude menu-bar formatter coverage, run the targeted usage tests, and build the app.

## Open Questions

None.

## Implementation Notes

~~Pending.~~

- Added compact menu-bar-only account labels (`M`, `2`, `O`) while retaining the full account names elsewhere.
- Added a shared largest-unit countdown formatter and kept reset countdowns visible whenever reset data exists.
- Updated the OpenAI expectations and added five Claude formatter tests for labels, minute/hour/day countdowns, weekly fallback, and missing reset data.
- Deviation: the plan did not include test-host startup work; added an XCTest-only guard around legacy session migration because its synchronous Git lookup re-entered and deadlocked the hosted test runner. Production migration behavior is unchanged.
- Verification: 17 formatter/decoder tests passed, 4 OpenAI service tests passed, and the macOS app build succeeded.

## Files

~~Pending.~~

- `DesignCanvas/DesignCanvas/Views/ClaudeMenuBarLabel.swift`
- `DesignCanvas/DesignCanvas/Services/OpenAIUsageService.swift`
- `DesignCanvas/DesignCanvas/Services/SessionPersistence.swift`
- `DesignCanvas/DesignCanvasTests/ClaudeUsageDecoderTests.swift`
- `DesignCanvas/DesignCanvasTests/OpenAIUsageTests.swift`
