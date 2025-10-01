# Playwright MCP Integration Guide

Complete guide for using Playwright MCP tools in Agent 5 (Visual Verification)

## Overview

Playwright MCP provides browser automation tools that enable Agent 5 to:
- Capture screenshots at different viewports
- Test interactive states (hover, focus, click)
- Navigate pages and wait for elements
- Verify visual implementation quality

**Key Documentation**: https://executeautomation.github.io/mcp-playwright/docs/intro

## Available MCP Tools

### Navigation Tools

#### `mcp_playwright_navigate`
Navigate to a specific URL.

**Usage:**
```typescript
mcp_playwright_navigate({ 
  url: "http://localhost:3001/dashboard" 
})
```

**Parameters:**
- `url` (string, required): Full URL to navigate to

**When to use:**
- Starting visual verification of a feature
- Moving between pages to test different views

#### `mcp_playwright_waitForSelector`
Wait for an element to appear before proceeding.

**Usage:**
```typescript
mcp_playwright_waitForSelector({ 
  selector: ".dashboard-card",
  state: "visible",
  timeout: 5000 
})
```

**Parameters:**
- `selector` (string, required): CSS selector for element
- `state` (string, optional): "visible", "hidden", "attached" (default: "visible")
- `timeout` (number, optional): Max wait time in ms (default: 30000)

**When to use:**
- After navigation to ensure page loaded
- Before capturing screenshots to ensure content ready
- Before interacting with dynamic elements

### Screenshot Tools

#### `mcp_playwright_screenshot`
Capture a screenshot of the page or element.

**Usage:**
```typescript
// Full page screenshot
mcp_playwright_screenshot({ 
  path: "screenshots/dashboard-full.png",
  fullPage: true 
})

// Element screenshot
mcp_playwright_screenshot({ 
  path: "screenshots/card.png",
  selector: ".dashboard-card" 
})

// With clip region
mcp_playwright_screenshot({ 
  path: "screenshots/header.png",
  clip: { x: 0, y: 0, width: 1920, height: 100 }
})
```

**Parameters:**
- `path` (string, required): Path to save screenshot
- `fullPage` (boolean, optional): Capture full scrollable page (default: false)
- `selector` (string, optional): Capture specific element only
- `clip` (object, optional): Capture specific region `{ x, y, width, height }`

**When to use:**
- Primary tool for visual verification
- Capturing different viewport sizes
- Documenting interactive states
- Creating visual reports

### Viewport Management

#### `mcp_playwright_setViewport`
Set the browser viewport size for responsive testing.

**Usage:**
```typescript
// Mobile
mcp_playwright_setViewport({ 
  width: 375, 
  height: 667 
})

// Tablet
mcp_playwright_setViewport({ 
  width: 768, 
  height: 1024 
})

// Desktop
mcp_playwright_setViewport({ 
  width: 1920, 
  height: 1080 
})
```

**Parameters:**
- `width` (number, required): Viewport width in pixels
- `height` (number, required): Viewport height in pixels

**Common Sizes:**
| Device | Width | Height | Notes |
|--------|-------|--------|-------|
| Mobile (iPhone SE) | 375 | 667 | Small mobile baseline |
| Mobile (iPhone 12) | 390 | 844 | Modern mobile |
| Tablet (iPad) | 768 | 1024 | Tablet portrait |
| Desktop (Laptop) | 1440 | 900 | Common laptop |
| Desktop (Full HD) | 1920 | 1080 | Standard desktop |
| Desktop (4K) | 2560 | 1440 | Large desktop |

**When to use:**
- Testing responsive layouts
- Verifying breakpoint behavior
- Ensuring mobile usability

### Interaction Tools

#### `mcp_playwright_click`
Click an element.

**Usage:**
```typescript
mcp_playwright_click({ 
  selector: ".button-primary" 
})

// With options
mcp_playwright_click({ 
  selector: ".dropdown-toggle",
  clickCount: 1,
  delay: 100
})
```

**Parameters:**
- `selector` (string, required): CSS selector for element
- `clickCount` (number, optional): Number of clicks (default: 1)
- `delay` (number, optional): Delay between clicks in ms

**When to use:**
- Testing button interactions
- Opening dropdowns/modals
- Triggering state changes before screenshot

#### `mcp_playwright_hover`
Hover over an element.

**Usage:**
```typescript
mcp_playwright_hover({ 
  selector: ".card" 
})
```

**Parameters:**
- `selector` (string, required): CSS selector for element

**When to use:**
- Testing hover states
- Verifying hover animations
- Capturing hover overlays

#### `mcp_playwright_focus`
Focus on an element.

**Usage:**
```typescript
mcp_playwright_focus({ 
  selector: "input.email" 
})
```

**Parameters:**
- `selector` (string, required): CSS selector for element

**When to use:**
- Testing focus rings
- Verifying input focus states
- Testing keyboard navigation

#### `mcp_playwright_type`
Type text into an input.

**Usage:**
```typescript
mcp_playwright_type({ 
  selector: "input.search",
  text: "Search query" 
})

// With delay
mcp_playwright_type({ 
  selector: "textarea.content",
  text: "Content here",
  delay: 50  // ms between keystrokes
})
```

**Parameters:**
- `selector` (string, required): CSS selector for input element
- `text` (string, required): Text to type
- `delay` (number, optional): Delay between keystrokes in ms

**When to use:**
- Testing form states
- Verifying input styling
- Testing dynamic content updates

### Element Query Tools

#### `mcp_playwright_querySelector`
Get information about an element.

**Usage:**
```typescript
mcp_playwright_querySelector({ 
  selector: ".error-message" 
})
```

**Returns:** Element info or null if not found

**When to use:**
- Checking if element exists
- Debugging selector issues
- Verifying element visibility

## Complete Visual Verification Workflow

### 1. Initial Setup

```typescript
// Navigate to feature
mcp_playwright_navigate({ 
  url: "http://localhost:3001/feature-path" 
})

// Wait for main content
mcp_playwright_waitForSelector({ 
  selector: ".main-content",
  state: "visible",
  timeout: 5000 
})
```

### 2. Desktop View Testing

```typescript
// Set desktop viewport
mcp_playwright_setViewport({ 
  width: 1920, 
  height: 1080 
})

// Capture default state
mcp_playwright_screenshot({ 
  path: "screenshots/desktop-default.png",
  fullPage: true 
})

// Test hover state
mcp_playwright_hover({ 
  selector: ".interactive-card" 
})
mcp_playwright_screenshot({ 
  path: "screenshots/desktop-card-hover.png" 
})

// Test focus state
mcp_playwright_focus({ 
  selector: "input.primary" 
})
mcp_playwright_screenshot({ 
  path: "screenshots/desktop-input-focus.png" 
})

// Test active state
mcp_playwright_click({ 
  selector: ".tab-button" 
})
mcp_playwright_screenshot({ 
  path: "screenshots/desktop-tab-active.png" 
})
```

### 3. Tablet View Testing

```typescript
// Set tablet viewport
mcp_playwright_setViewport({ 
  width: 768, 
  height: 1024 
})

// Wait for layout to adjust
mcp_playwright_waitForSelector({ 
  selector: ".main-content",
  state: "visible",
  timeout: 2000 
})

// Capture tablet view
mcp_playwright_screenshot({ 
  path: "screenshots/tablet-view.png",
  fullPage: true 
})
```

### 4. Mobile View Testing

```typescript
// Set mobile viewport
mcp_playwright_setViewport({ 
  width: 375, 
  height: 667 
})

// Wait for layout to adjust
mcp_playwright_waitForSelector({ 
  selector: ".main-content",
  state: "visible",
  timeout: 2000 
})

// Capture mobile view
mcp_playwright_screenshot({ 
  path: "screenshots/mobile-view.png",
  fullPage: true 
})

// Test mobile menu if applicable
mcp_playwright_click({ 
  selector: ".mobile-menu-toggle" 
})
mcp_playwright_screenshot({ 
  path: "screenshots/mobile-menu-open.png" 
})
```

## Common Patterns

### Pattern 1: Test All Interactive States

```typescript
const testInteractiveStates = (selector: string, name: string) => {
  // Default state
  mcp_playwright_screenshot({ 
    path: `screenshots/${name}-default.png` 
  })
  
  // Hover state
  mcp_playwright_hover({ selector })
  mcp_playwright_screenshot({ 
    path: `screenshots/${name}-hover.png` 
  })
  
  // Focus state (if focusable)
  mcp_playwright_focus({ selector })
  mcp_playwright_screenshot({ 
    path: `screenshots/${name}-focus.png` 
  })
  
  // Active state
  mcp_playwright_click({ selector })
  mcp_playwright_screenshot({ 
    path: `screenshots/${name}-active.png` 
  })
}

// Usage
testInteractiveStates(".primary-button", "button-primary")
```

### Pattern 2: Responsive Snapshot

```typescript
const captureResponsive = (path: string) => {
  // Desktop
  mcp_playwright_setViewport({ width: 1920, height: 1080 })
  mcp_playwright_screenshot({ 
    path: `screenshots/${path}-desktop.png`,
    fullPage: true 
  })
  
  // Tablet
  mcp_playwright_setViewport({ width: 768, height: 1024 })
  mcp_playwright_screenshot({ 
    path: `screenshots/${path}-tablet.png`,
    fullPage: true 
  })
  
  // Mobile
  mcp_playwright_setViewport({ width: 375, height: 667 })
  mcp_playwright_screenshot({ 
    path: `screenshots/${path}-mobile.png`,
    fullPage: true 
  })
}

// Usage
captureResponsive("dashboard")
```

### Pattern 3: Form Interaction Test

```typescript
// Navigate to form
mcp_playwright_navigate({ 
  url: "http://localhost:3001/form" 
})

// Fill form fields
mcp_playwright_type({ 
  selector: "input[name='email']",
  text: "test@example.com" 
})

mcp_playwright_type({ 
  selector: "input[name='password']",
  text: "password123" 
})

// Capture filled state
mcp_playwright_screenshot({ 
  path: "screenshots/form-filled.png" 
})

// Test validation (leave field empty)
mcp_playwright_click({ 
  selector: "input[name='email']" 
})
mcp_playwright_type({ 
  selector: "input[name='email']",
  text: "" 
})
mcp_playwright_click({ 
  selector: "input[name='password']" 
})

// Capture validation state
mcp_playwright_screenshot({ 
  path: "screenshots/form-validation.png" 
})
```

## Troubleshooting

### Issue: Screenshot shows blank page

**Problem:** Page not fully loaded before screenshot
**Solution:**
```typescript
// Add wait for key element
mcp_playwright_waitForSelector({ 
  selector: ".main-content",
  state: "visible",
  timeout: 5000 
})

// Then take screenshot
mcp_playwright_screenshot({ path: "screenshot.png" })
```

### Issue: Element not found

**Problem:** Selector incorrect or element doesn't exist
**Solution:**
```typescript
// Test if element exists first
mcp_playwright_querySelector({ 
  selector: ".my-element" 
})

// If null, element doesn't exist - check selector
// Try more specific selector or wait for dynamic content
```

### Issue: Hover state not captured

**Problem:** Screenshot taken before hover effect applies
**Solution:**
```typescript
// Hover element
mcp_playwright_hover({ selector: ".card" })

// Small delay for CSS transitions (if using terminal)
// Or immediately screenshot (Playwright waits for stability)
mcp_playwright_screenshot({ path: "hover-state.png" })
```

### Issue: Mobile layout looks broken

**Problem:** Viewport set incorrectly or layout not responsive
**Solution:**
```typescript
// Ensure viewport set BEFORE navigation
mcp_playwright_setViewport({ width: 375, height: 667 })
mcp_playwright_navigate({ url: "http://localhost:3001/page" })

// Wait for layout to adjust
mcp_playwright_waitForSelector({ 
  selector: ".content",
  timeout: 3000 
})
```

### Issue: Interactive element not responding

**Problem:** Element covered by another element or not clickable
**Solution:**
```typescript
// Scroll element into view first
mcp_playwright_click({ 
  selector: ".button",
  force: true  // Force click even if covered (if available)
})

// Or wait for element to be clickable
mcp_playwright_waitForSelector({ 
  selector: ".button",
  state: "visible"
})
```

## Best Practices

### 1. Always Wait for Stability
```typescript
// ❌ Bad - immediate screenshot
mcp_playwright_navigate({ url: "..." })
mcp_playwright_screenshot({ path: "..." })

// ✅ Good - wait for content
mcp_playwright_navigate({ url: "..." })
mcp_playwright_waitForSelector({ selector: ".content" })
mcp_playwright_screenshot({ path: "..." })
```

### 2. Use Descriptive Screenshot Names
```typescript
// ❌ Bad - unclear naming
mcp_playwright_screenshot({ path: "1.png" })
mcp_playwright_screenshot({ path: "test.png" })

// ✅ Good - descriptive names
mcp_playwright_screenshot({ path: "screenshots/dashboard-desktop-default.png" })
mcp_playwright_screenshot({ path: "screenshots/button-hover-state.png" })
```

### 3. Test All Breakpoints
```typescript
// ✅ Always test these three
const viewports = [
  { width: 375, height: 667, name: "mobile" },
  { width: 768, height: 1024, name: "tablet" },
  { width: 1920, height: 1080, name: "desktop" }
]

// Capture each viewport
viewports.forEach(viewport => {
  mcp_playwright_setViewport(viewport)
  mcp_playwright_screenshot({ 
    path: `screenshots/${viewport.name}-view.png` 
  })
})
```

### 4. Capture Interactive States Systematically
```typescript
// ✅ Test all states for interactive elements
const states = ["default", "hover", "focus", "active"]

// Document each state
states.forEach(state => {
  // Apply state...
  mcp_playwright_screenshot({ 
    path: `screenshots/button-${state}.png` 
  })
})
```

### 5. Use Full Page Screenshots for Layout Verification
```typescript
// ✅ Full page shows layout issues
mcp_playwright_screenshot({ 
  path: "screenshots/page-full.png",
  fullPage: true  // Captures entire scrollable area
})
```

## Integration with Agent 5

Agent 5 uses these tools in this order:

1. **Navigate** → Page load
2. **Wait** → Ensure content ready
3. **Set Viewport** → Responsive testing
4. **Screenshot** → Default state
5. **Interact** → Hover/focus/click
6. **Screenshot** → Interactive states
7. **Analyze** → Visual quality check
8. **Fix** → Minor corrections if needed
9. **Document** → Create visual report

See `5-design-visual-verification.md` for complete workflow.
