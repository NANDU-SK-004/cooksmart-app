import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/recipe.dart';
import '../state/app_state.dart';

class IngredientsScreen extends StatefulWidget {
  final AppState state;
  const IngredientsScreen({super.key, required this.state});

  @override
  State<IngredientsScreen> createState() => _IngredientsScreenState();
}

class _IngredientsScreenState extends State<IngredientsScreen> {
  final TextEditingController _controller = TextEditingController();
  final Set<String> activeFilters = {'Under 30 mins', 'High Protein'};

  final quickProduce = ['Onions', 'Tomatoes', 'Mushrooms', 'Lemon', 'Bell Pepper'];
  final quickDairy = ['Parmesan', 'Butter', 'Eggs', 'Greek Yogurt'];
  final quickPantry = ['Pasta', 'Olive Oil', 'Rice', 'Soy Sauce'];

  void _handleAdd() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.state.addIngredient(text);
      _controller.clear();
    }
  }

  void _handleGenerate() async {
    final success = await widget.state.generateRecipe(context: context);
    if (!success && mounted && widget.state.generationError != null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.surfaceElevated,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Colors.redAccent),
          ),
          content: Row(
            children: [
              const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.state.generationError!,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ingredients = widget.state.pantryIngredients;

    return Column(
      children: [
        // Top App Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => widget.state.setTab(0),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLow,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Icon(Icons.chevron_left_rounded, color: Colors.white, size: 24),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  'Pantry Chef',
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryOrange.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppColors.primaryOrange.withOpacity(0.35)),
                                ),
                                child: const Text(
                                  'AI PRO',
                                  style: TextStyle(
                                    color: AppColors.primaryOrange,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Text(
                            'Smart Recipe Generator',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: AppColors.textDim, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => widget.state.clearIngredients(),
                child: const Text(
                  'Clear All',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),

        // Main Scrollable Area
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Search & Add Input Box
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLow,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryOrange.withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      const Icon(Icons.kitchen_rounded, color: AppColors.textDim, size: 22),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          onSubmitted: (_) => _handleAdd(),
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          decoration: const InputDecoration(
                            hintText: 'Type an ingredient (e.g. Chicken, Basil)...',
                            hintStyle: TextStyle(color: AppColors.textDim, fontSize: 13),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _handleAdd,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryOrange,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add_rounded, size: 18),
                            SizedBox(width: 4),
                            Text('Add', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 2. Selected Ingredients Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              'Selected Ingredients',
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primaryOrange.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.primaryOrange.withOpacity(0.3)),
                            ),
                            child: Text(
                              '${ingredients.length} added',
                              style: const TextStyle(
                                color: AppColors.primaryOrange,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_rounded, color: AppColors.success, size: 14),
                        SizedBox(width: 4),
                        Text(
                          'Ready to cook',
                          style: TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Chip Cloud
                if (ingredients.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLow,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border, style: BorderStyle.solid),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.inventory_2_outlined, color: AppColors.textDim, size: 36),
                        SizedBox(height: 8),
                        Text(
                          'No ingredients added yet',
                          style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Type above or tap quick-add staples below',
                          style: TextStyle(color: AppColors.textDim, fontSize: 11),
                        ),
                      ],
                    ),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ingredients.map((item) {
                      final name = item['name']!;
                      final emoji = item['emoji'] ?? '🥘';
                      return Container(
                        padding: const EdgeInsets.only(left: 10, right: 6, top: 6, bottom: 6),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.primaryOrange.withOpacity(0.4)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(emoji, style: const TextStyle(fontSize: 14)),
                            const SizedBox(width: 6),
                            Text(
                              name,
                              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () => widget.state.removeIngredient(name),
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.black26,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close_rounded, size: 14, color: AppColors.textMuted),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                const SizedBox(height: 24),

                // 3. Quick Add Essentials
                Text(
                  'Quick Add Essentials',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Tap to add from common pantry staples',
                  style: TextStyle(color: AppColors.textDim, fontSize: 12),
                ),
                const SizedBox(height: 12),

                // Produce
                _buildQuickSection('Fresh Produce', quickProduce, '🥬'),
                const SizedBox(height: 10),
                // Dairy & Eggs
                _buildQuickSection('Dairy & Eggs', quickDairy, '🧀'),
                const SizedBox(height: 10),
                // Pantry
                _buildQuickSection('Pantry & Grains', quickPantry, '🌾'),

                const SizedBox(height: 20),

                // 4. Meal Preferences & Filters
                Text(
                  'Preferences & Filters',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    'Under 30 mins',
                    'High Protein',
                    'Gluten Free',
                    'Comfort Food',
                    'Low Carb',
                  ].map((filter) {
                    final isAct = activeFilters.contains(filter);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isAct) {
                            activeFilters.remove(filter);
                          } else {
                            activeFilters.add(filter);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isAct ? AppColors.surfaceElevated : AppColors.surfaceLow,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isAct ? AppColors.primaryOrange.withOpacity(0.6) : AppColors.border,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              filter,
                              style: TextStyle(
                                color: isAct ? Colors.white : AppColors.textMuted,
                                fontSize: 12,
                                fontWeight: isAct ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                            if (isAct) ...[
                              const SizedBox(width: 4),
                              const Icon(Icons.check_rounded, color: AppColors.primaryOrange, size: 14),
                            ],
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // 5. Match Teaser Glass Card
                GestureDetector(
                  onTap: () => widget.state.openRecipe(Recipe.tuscanChicken),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.surfaceLow,
                          AppColors.surfaceElevated,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.primaryOrange.withOpacity(0.25)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.primaryOrange.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.auto_awesome_rounded, color: AppColors.primaryOrange, size: 24),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tuscan Creamy Chicken',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Potential 98% match detected! Tap to view.',
                                style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textDim, size: 14),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),

        // Sticky Bottom CTA
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceLowest.withOpacity(0.95),
            border: const Border(top: BorderSide(color: AppColors.border)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Friendly Error Notice
              if (widget.state.generationError != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade900.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.redAccent.withOpacity(0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.state.generationError!,
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => widget.state.clearGenerationError(),
                        child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(Icons.close_rounded, size: 16, color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),

              // Active AI Generating Banner
              if (widget.state.isGenerating)
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primaryOrange.withOpacity(0.35)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryOrange),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Gemini AI is crafting your custom recipe...',
                        style: TextStyle(color: AppColors.primaryOrange, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: widget.state.isGenerating ? null : _handleGenerate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryOrange,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.primaryOrange.withOpacity(0.6),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                    elevation: 8,
                    shadowColor: AppColors.primaryOrange.withOpacity(0.5),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: widget.state.isGenerating
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                              ),
                              SizedBox(width: 10),
                              Text('Calling Gemini Chef...', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('✨', style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 8),
                              Text(
                                ingredients.isNotEmpty
                                    ? 'Generate Recipe (${ingredients.length} ingredients)'
                                    : 'Generate Recipe',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.arrow_forward_rounded, size: 18),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Powered by Google Gemini • Real-time custom recipe creation',
                style: TextStyle(color: AppColors.textDim, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickSection(String title, List<String> items, String defaultEmoji) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: items.map((name) {
            return GestureDetector(
              onTap: () => widget.state.addIngredient(name, emoji: defaultEmoji),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLow,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add, size: 13, color: AppColors.primaryOrange),
                    const SizedBox(width: 4),
                    Text(name, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
