# Motion Patterns Reference

**Purpose:** Established animation patterns for consistent motion design across projects.

**Last Updated:** 27 December 2025
**Source:** Extracted from Ramp Spotlights project learnings

---

## Quick Reference: Standard Spring Values

Use these exact values. Don't invent new ones unless absolutely necessary.

| Element | Spring Values | Notes |
|---------|---------------|-------|
| Avatar/card entry | `spring(350, 15)` | Bouncy, with initial rotate + scale |
| Text reveal | `spring(200, 20)` | Smooth y-slide, stagger 0.1s |
| Button entry | `spring(400, 25)` | Quick pop |
| Button tap | `scale: 0.92, duration: 0.05` | HARD snap, no soft ease |
| Ticker digits | `spring(500, 40, 0.8)` | Mechanical snap |
| Sheet/modal slide | `spring(300, 30)` | y: '100%' → '0%' |
| Card flip | `spring(200, 25)` | With preserve-3d |
| Chat bubble | `spring(400, 30)` | y: 30, scale: 0.9 |
| Badge pop | `spring(300, 20)` | scale 0 → 1, with delay |
| Success checkmark | `spring(400, 15)` | Rotate + scale |
| Quest card entry | `spring(400, 25)` | y: 50, stagger 0.1s |
| iOS notification | `spring(300, 30)` | y: -120 → 0 |
| Phone frame exit | `spring(300, 25)` | scale: 1.2, y: -50 |
| Progress bar fill | `spring(200, 25)` | Width animation |

---

## Duration Rules

| Rule | Value | Reasoning |
|------|-------|-----------|
| **Transitions** | 150-300ms | Quick, snappy feel |
| **Springs** | Let physics determine | Don't override with duration |
| **Stagger** | 0.08-0.1s | Creates rhythm without feeling slow |
| **Ambient/loop** | 4-7s cycles | Varied per element to prevent sync |

### Anti-Patterns

- ❌ Linear easing for UI elements
- ❌ Slow fades (>500ms opacity transitions)
- ❌ All elements animating at once (no stagger)
- ❌ Same duration for all floating elements (they sync up)

---

## Emotional Timing Guide

| Feel | Stiffness | Damping | When to Use |
|------|-----------|---------|-------------|
| Bouncy/playful | 300-400 | 15-20 | Avatars, celebrations, fun moments |
| Smooth/elegant | 200-250 | 20-25 | Text reveals, content entry |
| Snappy/responsive | 400-500 | 25-40 | Buttons, immediate feedback |
| Heavy/mechanical | 500+ | 40+ | Tickers, counters, precision UI |

### Emotional Arc Timing

| Phase | Recommended Approach |
|-------|---------------------|
| Build-up | Slower springs (stiffness ~200) |
| Impact moment | Snappy springs (stiffness ~400+) |
| Resolution | Return to calm, settled state |

---

## Code Patterns

### Bouncy Entry (Avatars, Cards, Hero Elements)

```tsx
<motion.div
  initial={{ scale: 0, rotate: -15, y: 50 }}
  animate={{ scale: 1, rotate: 0, y: 0 }}
  transition={{ type: 'spring', stiffness: 350, damping: 15 }}
>
  <Avatar />
</motion.div>
```

### Text Reveal (Masked Y-Slide)

```tsx
<div className="overflow-hidden">
  <motion.p
    initial={{ y: '110%' }}
    animate={{ y: '0%' }}
    transition={{ type: 'spring', stiffness: 200, damping: 20 }}
  >
    Revealed text
  </motion.p>
</div>
```

### Stagger Reveal

```tsx
const container = {
  animate: { transition: { staggerChildren: 0.08 } }
}
const child = {
  initial: { opacity: 0, y: 20 },
  animate: { opacity: 1, y: 0 }
}

<motion.div variants={container} initial="initial" animate="animate">
  {items.map((item, i) => (
    <motion.div key={i} variants={child}>
      {item}
    </motion.div>
  ))}
</motion.div>
```

### Button Tap Feedback

```tsx
<motion.button
  whileTap={{ scale: 0.92 }}
  transition={{ duration: 0.05 }}  // HARD snap
>
  Click me
</motion.button>
```

### Screen Transitions

```tsx
<AnimatePresence mode="wait">
  {currentScreen === 'welcome' && (
    <motion.div
      key="welcome"
      initial={{ opacity: 0, x: 20 }}
      animate={{ opacity: 1, x: 0 }}
      exit={{ opacity: 0, x: -20 }}
      transition={{ duration: 0.2 }}
    >
      <WelcomeScreen />
    </motion.div>
  )}
</AnimatePresence>
```

### Floating/Ambient Animation

```tsx
<motion.div
  animate={{ y: [0, -15, 0], rotate: [0, 8, 0] }}
  transition={{
    duration: 4,  // Use 4-7s, varied per element
    repeat: Infinity,
    ease: 'easeInOut'
  }}
>
  <FloatingElement />
</motion.div>
```

### Ticker Digit (Counter Animation)

```tsx
<motion.div
  initial={{ y: '-100%' }}
  animate={{ y: '0%' }}
  transition={{ type: 'spring', stiffness: 500, damping: 40, mass: 0.8 }}
>
  {digit}
</motion.div>
```

### Card Flip (3D)

```tsx
<div style={{ perspective: '1000px' }}>
  <motion.div
    style={{ transformStyle: 'preserve-3d' }}
    animate={{ rotateY: isFlipped ? 180 : 0 }}
    transition={{ type: 'spring', stiffness: 200, damping: 25 }}
  >
    <div style={{ backfaceVisibility: 'hidden' }}>Front</div>
    <div style={{ backfaceVisibility: 'hidden', transform: 'rotateY(180deg)', position: 'absolute', inset: 0 }}>
      Back
    </div>
  </motion.div>
</div>
```

### Progress Bar with Completion Pop

```tsx
<motion.div
  animate={{
    scale: isCompleted ? [1, 1.05, 1] : 1,
  }}
  transition={{
    scale: { duration: 0.2, times: [0, 0.5, 1], ease: 'easeOut' },
  }}
>
  <motion.div
    className="h-full bg-primary rounded-full"
    animate={{ width: `${progress}%` }}
    transition={{ type: 'spring', stiffness: 200, damping: 25 }}
  />
</motion.div>
```

### Typing Indicator (Chat)

```tsx
{[0, 1, 2].map((dot) => (
  <motion.div
    key={dot}
    className="w-3 h-3 bg-gray-400 rounded-full"
    animate={{ opacity: [0.4, 1, 0.4] }}
    transition={{
      duration: 1,
      repeat: Infinity,
      delay: dot * 0.2,
      ease: 'easeInOut',
    }}
  />
))}
```

### Typewriter Effect

```tsx
function TypewriterText({ text, speed = 18, onComplete }) {
  const [displayedText, setDisplayedText] = useState('')
  const [currentIndex, setCurrentIndex] = useState(0)

  useEffect(() => {
    if (currentIndex < text.length) {
      const timeout = setTimeout(() => {
        setDisplayedText((prev) => prev + text[currentIndex])
        setCurrentIndex((prev) => prev + 1)
      }, speed)
      return () => clearTimeout(timeout)
    } else if (onComplete) {
      onComplete()
    }
  }, [currentIndex, text, speed, onComplete])

  return <p>{displayedText}</p>
}
```

---

## Celebration Effects

### Confetti with Brand Colors

```tsx
import confetti from 'canvas-confetti'

confetti({
  particleCount: 30,
  spread: 60,
  origin: { y: 0.5, x: 0.5 },
  colors: ['#28e85f', '#1ea846', '#6736ff', '#5029cc', '#ffffff', '#e5e5e5'],
  startVelocity: 55,
  gravity: 2.8,    // Heavy drop like coins
  decay: 0.88,
  scalar: 1.6,     // Large, chunky particles
  flat: true,      // Neo-brutalist flat look
  shapes: ['circle', 'square'],
})
```

---

## Protection/Trust Messaging

### Calmer Pulse (Not Alarming)

For protection indicators, use slower timing:

```tsx
<motion.div
  animate={{ scale: [1, 1.15, 1], opacity: [0.6, 1, 0.6] }}
  transition={{ duration: 1.0, repeat: Infinity, ease: 'easeInOut' }}
>
  <ShieldIcon />
</motion.div>
```

**Note:** 0.6s pulse feels "alarming". 1.0s feels "protective".

---

## Phase Transitions

### Multi-Phase State Machine

```tsx
type Phase = 'intro' | 'main' | 'outro'
const [phase, setPhase] = useState<Phase>('intro')

useEffect(() => {
  const timers: NodeJS.Timeout[] = []
  timers.push(setTimeout(() => setPhase('main'), 2000))
  timers.push(setTimeout(() => setPhase('outro'), 6000))
  return () => timers.forEach(clearTimeout)
}, [])
```

### Shrink Into Place Effect

For hero elements that shrink to fit into a container:

```tsx
const INTRO_SIZE = 560
const TARGET_SIZE = 248
const exitScale = TARGET_SIZE / INTRO_SIZE  // 0.44

<motion.div
  exit={{ scale: exitScale, y: -120 }}
  transition={{ type: 'spring', stiffness: 300, damping: 25 }}
>
  <HeroCard />
</motion.div>
```

---

## When to Add New Patterns

Only add new spring values when:
1. None of the existing patterns fit the use case
2. You've tested multiple combinations
3. The new pattern is significantly better
4. You document it here for reuse

**Process:**
1. Try existing patterns first
2. If none work, experiment with variations
3. Test visually (not just in code)
4. If successful, add to this file with:
   - Element type
   - Spring values
   - When to use
   - Code example

---

*Motion patterns extracted from Ramp Spotlights project, December 2025*
