import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../state/app_state.dart';

class SavedScreen extends StatefulWidget {
  final AppState state;
  const SavedScreen({super.key, required this.state});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  String selectedFilter = 'All';
  final filters = ['All', 'Quick (<30m)', 'High Protein', 'Italian', 'Favorites', 'Vegetarian'];

  @override
  Widget build(BuildContext context) {
    final savedRecipes = widget.state.savedRecipes;

    // Filter recipes
    final filteredList = savedRecipes.where((r) {
      if (selectedFilter == 'All') return true;
      if (selectedFilter == 'Quick (<30m)') return r.cookTimeMinutes <= 25;
      if (selectedFilter == 'High Protein') return r.tag == 'High Protein' || r.calories >= 480;
      if (selectedFilter == 'Italian') return r.cuisine.toLowerCase().contains('italian');
      if (selectedFilter == 'Favorites') return true;
      if (selectedFilter == 'Vegetarian') return r.tag == 'Vegan' || r.tag == 'Healthy';
      return true;
    }).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 110),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => widget.state.setTab(0), // Back to Home
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLow,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                  ),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.bookmark_rounded, color: AppColors.primaryOrange, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          'Saved Recipes',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${savedRecipes.length} recipes',
                        style: const TextStyle(color: AppColors.secondaryAmber, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLow,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(Icons.search_rounded, color: AppColors.textMuted, size: 20),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLow,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(Icons.swap_vert_rounded, color: AppColors.textMuted, size: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 2. Filter Carousel
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final f = filters[index];
                final isSelected = f == selectedFilter;
                return GestureDetector(
                  onTap: () => setState(() => selectedFilter = f),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryOrange : AppColors.surfaceLow,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: isSelected ? AppColors.primaryOrange : AppColors.border,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.primaryOrange.withOpacity(0.35),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        f,
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textMuted,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Sub-headline sort info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.tune_rounded, size: 14, color: AppColors.secondaryAmber),
                      SizedBox(width: 4),
                      Text('Sorted by: ', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                      Flexible(
                        child: Text(
                          'Recently Saved',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Showing ${filteredList.length}',
                  style: const TextStyle(color: AppColors.textDim, fontSize: 12),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 3. 2-Column Bento Grid
          if (filteredList.isEmpty)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(32),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.surfaceLow,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  const Icon(Icons.bookmark_border_rounded, size: 48, color: AppColors.textDim),
                  const SizedBox(height: 12),
                  const Text('No saved recipes in this category', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text('Bookmark recipes from Home to view them here.', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => widget.state.setTab(0),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Explore Recipes'),
                  ),
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.74,
                ),
                itemBuilder: (context, index) {
                  final recipe = filteredList[index];

                  return GestureDetector(
                    onTap: () => widget.state.openRecipe(recipe),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLow,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.border),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Thumbnail
                          Stack(
                            children: [
                              SizedBox(
                                height: 115,
                                width: double.infinity,
                                child: Image.network(
                                  recipe.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: AppColors.surfaceElevated,
                                    child: const Icon(Icons.restaurant, color: AppColors.textDim),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    recipe.tag,
                                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: () {
                                    widget.state.toggleSaveRecipe(recipe.id);
                                  },
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryOrange,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primaryOrange.withOpacity(0.4),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.bookmark_rounded,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Details
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        recipe.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.5,
                                          height: 1.25,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.star_rounded, color: AppColors.secondaryAmber, size: 14),
                                          const SizedBox(width: 3),
                                          Text(
                                            '${recipe.rating}',
                                            style: const TextStyle(
                                              color: AppColors.secondaryAmber,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                            ),
                                          ),
                                          const SizedBox(width: 3),
                                          Text(
                                            '(${recipe.reviewCount})',
                                            style: const TextStyle(color: AppColors.textDim, fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.schedule_rounded, color: AppColors.primaryOrange, size: 13),
                                          const SizedBox(width: 3),
                                          Text(
                                            '${recipe.cookTimeMinutes}m',
                                            style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width: 22,
                                        height: 22,
                                        decoration: BoxDecoration(
                                          color: AppColors.surfaceElevated,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.arrow_forward_rounded, size: 12, color: AppColors.textMuted),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

          const SizedBox(height: 20),

          // 4. Ready to Cook Pantry Helper Banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              onTap: () => widget.state.setTab(1), // Go to ingredients
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.primaryOrange.withOpacity(0.35)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primaryOrange.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.auto_awesome_rounded, color: AppColors.primaryOrange, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Ready to Cook?',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryOrange.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  '4 Ready',
                                  style: TextStyle(color: AppColors.primaryOrange, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          const Text(
                            'Have ingredients? Match what you can make now.',
                            style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                          ),
                          const SizedBox(height: 6),
                          const Row(
                            children: [
                              Text(
                                'Match with My Pantry',
                                style: TextStyle(color: AppColors.primaryOrange, fontWeight: FontWeight.bold, fontSize: 11),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward_rounded, color: AppColors.primaryOrange, size: 12),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
