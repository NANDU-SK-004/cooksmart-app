import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../state/app_state.dart';

class RecipeScreen extends StatefulWidget {
  final AppState state;
  const RecipeScreen({super.key, required this.state});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final Map<int, Timer?> _timers = {};
  final Map<int, int> _timerRemaining = {};
  final Map<int, bool> _timerRunning = {};

  void _toggleTimer(int stepIndex, int totalSeconds) {
    if (_timerRunning[stepIndex] == true) {
      _timers[stepIndex]?.cancel();
      setState(() {
        _timerRunning[stepIndex] = false;
      });
    } else {
      setState(() {
        _timerRunning[stepIndex] = true;
        _timerRemaining[stepIndex] = _timerRemaining[stepIndex] ?? totalSeconds;
      });

      _timers[stepIndex] = Timer.periodic(const Duration(seconds: 1), (timer) {
        if ((_timerRemaining[stepIndex] ?? 0) > 0) {
          setState(() {
            _timerRemaining[stepIndex] = _timerRemaining[stepIndex]! - 1;
          });
        } else {
          timer.cancel();
          setState(() {
            _timerRunning[stepIndex] = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    for (var t in _timers.values) {
      t?.cancel();
    }
    super.dispose();
  }

  void _showSaveFeedback() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.surfaceElevated,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.primaryOrange.withOpacity(0.5)),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 80),
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primaryOrange.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.bookmark_added_rounded, color: AppColors.primaryOrange, size: 20),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Recipe Saved!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  Text('Added to your CookSmart collection', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                widget.state.setTab(3); // Switch to Saved tab
              },
              child: const Text('View →', style: TextStyle(color: AppColors.primaryOrange, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.state.currentRecipe;
    final isSaved = widget.state.isRecipeSaved(recipe.id);
    final servings = widget.state.servings;

    return Stack(
      children: [
        // Main Content
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Hero Image Section
              Stack(
                children: [
                  SizedBox(
                    height: 290,
                    width: double.infinity,
                    child: Image.network(
                      recipe.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.surfaceElevated,
                        child: const Icon(Icons.restaurant, size: 64, color: AppColors.textDim),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.55),
                            Colors.transparent,
                            AppColors.background.withOpacity(0.95),
                            AppColors.background,
                          ],
                          stops: const [0.0, 0.35, 0.85, 1.0],
                        ),
                      ),
                    ),
                  ),
                  // Back & Actions Top Row
                  Positioned(
                    top: 12,
                    left: 16,
                    right: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => widget.state.setTab(1), // Back to Ingredients
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white24),
                            ),
                            child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white24),
                              ),
                              child: const Icon(Icons.share_rounded, color: Colors.white, size: 18),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                widget.state.toggleSaveRecipe(recipe.id, onSaved: _showSaveFeedback);
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white24),
                                ),
                                child: Icon(
                                  isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                                  color: isSaved ? AppColors.primaryOrange : Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Title and match chip overlay
                  Positioned(
                    bottom: 0,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryOrange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.primaryOrange.withOpacity(0.4)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.auto_awesome_rounded, color: AppColors.primaryOrange, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                '${recipe.matchPercentage}% PANTRY MATCH',
                                style: const TextStyle(
                                  color: AppColors.primaryOrange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          recipe.title,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                height: 1.2,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 2. Quick Stats Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    _buildStatCard(Icons.schedule_rounded, '${recipe.cookTimeMinutes} min', 'Prep & Cook', AppColors.secondaryAmber),
                    const SizedBox(width: 8),
                    _buildStatCard(Icons.restaurant_rounded, '$servings portions', 'Portion', AppColors.primaryOrange),
                    const SizedBox(width: 8),
                    _buildStatCard(Icons.local_fire_department_rounded, '${recipe.calories} kcal', 'Per serving', AppColors.primaryOrange),
                    const SizedBox(width: 8),
                    _buildStatCard(Icons.star_rounded, '${recipe.rating}', '(${recipe.reviewCount})', AppColors.secondaryAmber),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 3. Ingredients Section with Servings Stepper
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ingredients',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    // Stepper
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLow,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => widget.state.adjustServings(-1),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                              child: Icon(Icons.remove, size: 16, color: AppColors.textMuted),
                            ),
                          ),
                          Text(
                            '$servings',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                          ),
                          GestureDetector(
                            onTap: () => widget.state.adjustServings(1),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                              child: Icon(Icons.add, size: 16, color: AppColors.primaryOrange),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Ingredients Checklist
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: recipe.ingredients.map((ing) {
                    return GestureDetector(
                      onTap: () => widget.state.toggleIngredientChecked(ing),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: ing.isChecked ? AppColors.surfaceLow.withOpacity(0.5) : AppColors.surfaceLow,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: ing.isChecked ? AppColors.success.withOpacity(0.3) : AppColors.border,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ing.isChecked ? AppColors.success : Colors.transparent,
                                border: Border.all(
                                  color: ing.isChecked ? AppColors.success : AppColors.border,
                                  width: 2,
                                ),
                              ),
                              child: ing.isChecked
                                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                ing.name,
                                style: TextStyle(
                                  color: ing.isChecked ? AppColors.textDim : Colors.white,
                                  fontSize: 13,
                                  decoration: ing.isChecked ? TextDecoration.lineThrough : null,
                                ),
                              ),
                            ),
                            Text(
                              ing.formatAmount(servings),
                              style: TextStyle(
                                color: ing.isChecked ? AppColors.textDim : AppColors.secondaryAmber,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 24),

              // 4. Step-by-Step Cooking Instructions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Step-by-Step Method',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${recipe.steps.length} Steps',
                      style: const TextStyle(color: AppColors.textDim, fontSize: 12),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: recipe.steps.asMap().entries.map((entry) {
                    final index = entry.key;
                    final step = entry.value;
                    final isRunning = _timerRunning[index] ?? false;
                    final remaining = _timerRemaining[index] ?? (step.timerSeconds ?? 0);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLow,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryOrange.withOpacity(0.18),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        step.stepNumber,
                                        style: const TextStyle(
                                          color: AppColors.primaryOrange,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        step.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Timer pill if step has timer
                              if (step.timerSeconds != null)
                                GestureDetector(
                                  onTap: () => _toggleTimer(index, step.timerSeconds!),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: isRunning
                                          ? AppColors.primaryOrange.withOpacity(0.2)
                                          : AppColors.surfaceElevated,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isRunning ? AppColors.primaryOrange : AppColors.border,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          isRunning ? Icons.pause_rounded : Icons.schedule_rounded,
                                          color: isRunning ? AppColors.primaryOrange : AppColors.secondaryAmber,
                                          size: 13,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          isRunning
                                              ? '${(remaining ~/ 60)}:${(remaining % 60).toString().padLeft(2, '0')}'
                                              : '${(step.timerSeconds! ~/ 60)}m timer',
                                          style: TextStyle(
                                            color: isRunning ? AppColors.primaryOrange : Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            step.instruction,
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 13,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),

        // Sticky Bottom Action Bar with Save Button
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.background.withOpacity(0.0),
                  AppColors.background.withOpacity(0.95),
                  AppColors.background,
                ],
              ),
            ),
            child: Row(
              children: [
                // Secondary Save Button
                GestureDetector(
                  onTap: () {
                    widget.state.toggleSaveRecipe(recipe.id, onSaved: _showSaveFeedback);
                  },
                  child: Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: isSaved ? AppColors.primaryOrange : AppColors.border,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                          color: isSaved ? AppColors.primaryOrange : Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isSaved ? 'Saved' : 'Save',
                          style: TextStyle(
                            color: isSaved ? AppColors.primaryOrange : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Primary Start Cook Mode Button
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('🍳 Cook Mode Activated! Follow the steps.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                        elevation: 8,
                        shadowColor: AppColors.primaryOrange.withOpacity(0.5),
                      ),
                      child: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.soup_kitchen_rounded, size: 20),
                            SizedBox(width: 8),
                            Text('Start Cook Mode', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label, Color iconColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 18),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(color: AppColors.textDim, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
