# Design System: CookSmart Mobile App
**Project ID:** 8288663649002588035

## 1. Visual Theme & Atmosphere
- **Atmosphere**: Sophisticated dark culinary studio. Deep obsidian canvas paired with sizzling warm orange highlights and clean high-contrast white text.
- **Platform**: Mobile app screen (target 390px - 430px width, responsive mobile frame).
- **Tone**: Clean, mouthwatering, focused, premium.

## 2. Color Palette & Roles
- **Obsidian Dark Canvas (`#0F1115`)**: Deep background for total focus and battery efficiency.
- **Surface Elevation Card (`#181B22`)**: Slightly elevated surface for recipe cards, inputs, and container blocks.
- **Surface Elevation High (`#222733`)**: Interactive pills, hover states, and input backgrounds.
- **Warm Flame Orange (`#FF6B35`)**: Primary brand color for CTAs, active tab highlights, badges, and focal elements.
- **Sunlit Gold/Amber (`#FFA630`)**: Secondary accent for cooking time tags, ratings, and step highlights.
- **Pure White (`#FFFFFF`)**: Primary typography, headline text, active icons.
- **Muted Cloud Gray (`#94A3B8`)**: Secondary typography, subtitles, inactive nav icons, placeholders.
- **Subtle Slate Border (`#272E3D`)**: Card borders and structural dividers.
- **Fresh Herb Green (`#10B981`)**: Nutrition badges, vegetarian tags, difficulty indicators.

## 3. Typography Rules
- **Font Family**: Modern clean sans-serif (`Inter`, `Plus Jakarta Sans`, system-ui).
- **Headlines**: Semi-bold to bold (font-bold/font-semibold, tracking-tight).
- **Body & Steps**: Crisp, comfortable line height (leading-relaxed) for effortless kitchen reading.
- **Meta / Badges**: Uppercase or medium weight 12px-13px for prep times, calorie counts, and categories.

## 4. Component Stylings
- **Buttons**:
  - Primary: Bold Warm Flame Orange background (`#FF6B35`), crisp white text, pill or generously rounded corners (`rounded-2xl` or `rounded-full`), smooth press feedback.
  - Secondary/Ghost: Surface Slate background (`#222733`), white text, subtle border (`border border-[#272E3D]`).
- **Cards/Containers**:
  - Rounded corners (`rounded-2xl` / 16px to 20px).
  - Background `#181B22` with a subtle 1px border `#272E3D`.
  - Appetizing edge-to-edge or inset hero imagery with dark gradient overlays.
- **Inputs & Search**:
  - Pill or `rounded-xl` container with `#181B22` or `#222733` fill, magnifying glass / plus icon, light placeholder `#64748B`.
- **Navigation**:
  - Fixed bottom navigation bar (`bg-[#121419]/90 backdrop-blur-md border-t border-[#272E3D]`), 4 icons with labels: Home, Ingredients, Recipe, Saved. Active state in `#FF6B35`.

## 5. Layout Principles
- **Mobile Container**: Centered mobile viewport layout (`max-w-md mx-auto w-full min-h-screen`).
- **Padding**: 16px to 20px horizontal margins (`px-4` / `px-5`).
- **Spacing**: Generous breathing room between recipe cards and sections (`space-y-6`).

## 6. Design System Notes for Stitch Generation
```
DESIGN SYSTEM (REQUIRED):
- Platform: Mobile App (390px width layout, dark mode)
- Theme: Dark background (#0F1115), elevated dark cards (#181B22, #222733)
- Primary Accent: Warm Flame Orange (#FF6B35) for primary action buttons, highlights, badges, and active navigation
- Secondary Accent: Golden Amber (#FFA630) for ratings and prep time chips
- Text Primary: Pure White (#FFFFFF)
- Text Secondary: Muted Silver Gray (#94A3B8)
- Borders: Subtle Slate (#272E3D)
- Geometry: Generously rounded corners (rounded-2xl, rounded-full pills)
- Navigation: Persistent bottom mobile navigation bar with 4 tabs: Home, Ingredients, Recipe, Saved
```
