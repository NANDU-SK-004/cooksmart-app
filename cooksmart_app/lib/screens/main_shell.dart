import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../state/app_state.dart';
import 'home_screen.dart';
import 'ingredients_screen.dart';
import 'recipe_screen.dart';
import 'saved_screen.dart';

class MainShell extends StatelessWidget {
  final AppState state;
  const MainShell({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final currentTab = state.currentTabIndex;

        final bottomNavHeight = 64.0 + MediaQuery.of(context).padding.bottom;

        final screens = [
          HomeScreen(state: state),
          IngredientsScreen(state: state),
          RecipeScreen(state: state),
          SavedScreen(state: state),
        ];

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        blurRadius: 30,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Screen body sits completely above the bottom nav bar
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: bottomNavHeight,
                        child: IndexedStack(
                          index: currentTab,
                          children: screens,
                        ),
                      ),

                      // Persistent Bottom Navigation Bar
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: bottomNavHeight,
                        child: _buildBottomNav(context, currentTab, bottomNavHeight),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNav(BuildContext context, int currentTab, double height) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      height: height,
      padding: EdgeInsets.only(bottom: bottomPadding),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest.withOpacity(0.95),
        border: const Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.cottage_rounded, 'Home', currentTab),
          _buildNavItem(1, Icons.kitchen_rounded, 'Ingredients', currentTab),
          _buildNavItem(2, Icons.restaurant_menu_rounded, 'Recipe', currentTab),
          _buildNavItem(3, Icons.bookmark_rounded, 'Saved', currentTab),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, int currentTab) {
    final isActive = currentTab == index;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => state.setTab(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.primaryOrange : AppColors.textMuted,
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.primaryOrange : AppColors.textMuted,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 3),
            // Active indicator dot
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primaryOrange : Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
