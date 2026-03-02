What this file does: Project-specific context for all design agents. Describes the TBLA Practice Intelligence Dashboard — a data-heavy, information-dense dashboard for an accounting practice. Agents should prioritise data clarity over visual polish.

# Project Context for Design Agents

## Project
- **Name:** TBLA Practice Intelligence Dashboard
- **Description:** Unified client view across 6 disconnected accounting systems — per-client view is the primary interface

## Philosophy
> **"See the client as a whole problem, not discrete tasks."**

This dashboard presents each client as a complete picture — billing, bookkeeping status, debt, services, accounts data, team assignments — unified from multiple systems. The UI should embody this by making data the hero, not the interface.

## Tech Stack
- **Framework:** React 19 + TanStack Router + Vite (SPA)
- **UI Library:** shadcn/ui (primary), TanStack Table (data tables)
- **Styling:** Tailwind CSS v4
- **Backend:** Supabase (PostgreSQL + auth + edge functions)
- **Live API:** FreeAgent OAuth 2.0
- **Dev Server Port:** 5173 (Vite default)
- **Build:** Vite
- **Hosting:** Vercel

## Project Type: Data Dashboard
This is NOT a marketing site or design-focused prototype. It is a **production data dashboard** with:
- ~400 real client records across multiple data sources
- CSV import pipelines with AI-powered client matching
- Live FreeAgent API integration (billing + bookkeeping data)
- Real data only — no mock data in production paths

### What This Means for Agents
- **Data is the hero** — information density matters more than visual delight
- **Loading states are critical** — every data view needs skeleton/loading states
- **Empty states matter** — views must handle "no data imported yet" gracefully
- **Error states are required** — API failures, CSV parse errors, match conflicts
- **Tables are a primary component** — not secondary. Sorting, filtering, search are core UX
- **Animation is minimal** — functional transitions only (loading spinners, state changes). No bouncy springs, no hero animations, no stagger reveals
- **Mobile is secondary** — Dad uses this on desktop primarily. Mobile should work but isn't the focus

## Visual Direction
- **Primary Reference:** Information-dense dashboards (Linear, Stripe Dashboard)
- **Visual References:** N/A — data-first, not design-driven
- **Key Style:** "Invisible UI" — interface recedes, data is hero
  - Light borders (gray-200), minimal shadows
  - High data density with generous container padding
  - Status badges/indicators for at-a-glance scanning
  - Compact typography (text-sm/text-xs for data, text-base for headings)

## Data Sources & Views

### Per-Client View (Primary Interface)
The most important screen. Shows everything about a single client:
- Services (from BrightManager CSV)
- Account manager assignment (from BrightManager CSV)
- Billing status — recurring invoice amount (from FreeAgent API)
- Debt status — outstanding balance, overdue duration (from FreeAgent API)
- Bookkeeping completeness — reconciliation status (from FreeAgent API)
- Accounts production — turnover, profit, last filed (from TaxCalc CSV)
- Data coverage — which systems have data, match confidence

### Client List
- ~400 clients, searchable and sortable
- Data coverage indicators per client
- Quick-scan status badges

### Data Import Pipeline
- CSV upload UI for BrightManager, TaxCalc, QuickBooks, Xero
- AI-powered client matching across systems
- Match review queue (confirm/reject uncertain matches)
- Import status and data freshness indicators

## Component Priorities (Dashboard-Specific)

### Critical Components
| Component | Use Case | Source |
|-----------|----------|--------|
| Table / DataTable | Client list, import results, match review | shadcn/ui + TanStack Table |
| Card | Per-client summary panels | shadcn/ui |
| Badge | Status indicators (matched, unmatched, overdue) | shadcn/ui |
| Sheet / Dialog | Client detail drilldown, import config | shadcn/ui |
| Skeleton | Loading states for all data views | shadcn/ui |
| Progress | Import progress, data coverage | shadcn/ui |
| Tabs | Per-client view sections | shadcn/ui |
| Input + Select | Search, filters, dropdowns | shadcn/ui |
| Alert | Import errors, API failures, match warnings | shadcn/ui |
| Toast | Success/failure notifications | shadcn/ui |

### Not Needed (for this project)
- AI SDK Elements (no chat interface)
- React Flow (no workflow graphs)
- Motion Primitives / Cult-UI (no animation-heavy UI)
- Tailark marketing blocks (not a marketing site)
- KokonutUI AI Loading (simple skeletons suffice)

## Working Directories
- **Status Board:** agents/status.md
- **Task Files:** agents/doing/
- **Page References:** agents/page-references/
- **Project Plan:** documentation/project-plan.md
