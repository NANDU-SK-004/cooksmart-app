# Site Constitution: CookSmart Mobile App

## 1. Core Identity
- **Project Name**: CookSmart
- **Stitch Project ID**: `8288663649002588035`
- **Mission**: CookSmart helps home cooks transform available pantry ingredients into delicious, gourmet meals with an AI-assisted ingredient-to-recipe generator and smart recipe bookmarking.
- **Target Audience**: Home cooks, busy foodies, and culinary enthusiasts looking for quick, beautiful recipe inspiration.
- **Voice**: Modern, appetizing, sleek, inspiring, and intuitive.

## 2. Visual Language
- **Vibes**: Dark-mode Culinary Modernism, High Contrast, Tactile Warmth.
- **Aesthetic**: Deep charcoal/obsidian background, vibrant warm orange action elements, crisp white typography, and softly rounded card surfaces.

## 3. Architecture & File Structure
```
site/public/
├── index.html         # Screen 1: Home screen (featured recipes, categories, search)
├── ingredients.html   # Screen 2: Ingredient input screen (type ingredients, tags, generate CTA)
├── recipe.html        # Screen 3: Recipe result screen (name, ingredients, steps, save button)
└── saved.html         # Screen 4: Saved recipes grid (bookmarked recipes, filter tags)
```
- **Navigation Flow**:
  - Global bottom navigation bar across all 4 screens (Home, Ingredients, Recipe, Saved).
  - Screen 1 -> Click recipe card -> Screen 3 (Recipe view)
  - Screen 1 -> Click "Cook with Ingredients" or bottom nav -> Screen 2 (Ingredients input)
  - Screen 2 -> Click "Generate Recipe" -> Screen 3 (Recipe view)
  - Screen 3 -> Click "Save Recipe" -> Toast feedback & link to Screen 4 (Saved recipes)
  - Screen 4 -> Click saved recipe -> Screen 3 (Recipe view)

## 4. Live Sitemap
- [x] `index.html` - Home screen (Featured recipes, food categories, search bar)
- [x] `ingredients.html` - Ingredient input screen (Interactive tag input, generate button)
- [x] `recipe.html` - Recipe result screen (Hero image, ingredients checklist, step-by-step cooking method, save button)
- [x] `saved.html` - Saved recipes grid (Grid cards with time/tags, easy access)

## 5. The Roadmap (Backlog)
- **High Priority**:
  - [x] Iteration 1: Screen 1 - Home Screen (`index.html`)
  - [x] Iteration 2: Screen 2 - Ingredient Input Screen (`ingredients.html`)
  - [x] Iteration 3: Screen 3 - Recipe Result Screen (`recipe.html`)
  - [x] Iteration 4: Screen 4 - Saved Recipes Grid (`saved.html`)
- **Medium Priority**:
  - [x] Inter-screen navigation linking & active tab states
  - [x] Interactive ingredient tagging and mock recipe generation
  - [x] Save recipe bookmark toggle state
- **Low Priority**:
  - [x] Haptic-feeling animations and responsive mobile frame
  - [ ] Dietary preference customization drawer

## 6. Creative Freedom Guidelines
- Use food photography placeholders or appetizing food avatars.
- Ensure bottom navigation has distinct active states matching the current page.
- Maintain mobile viewport dimensions (`max-w-md mx-auto` or `w-[390px]`) for authentic app feel.
