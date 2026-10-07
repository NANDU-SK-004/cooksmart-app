import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/gemini_service.dart';

class AppState extends ChangeNotifier {
  int _currentTabIndex = 0;
  int get currentTabIndex => _currentTabIndex;

  late Recipe _currentRecipe;
  Recipe get currentRecipe => _currentRecipe;

  final Set<String> _savedRecipeIds = {
    'tuscan_chicken',
    'thai_beef',
    'avocado_quinoa',
    'wild_risotto',
    'crispy_salmon',
    'shrimp_pasta',
  };

  final List<Recipe> _customRecipes = [];
  List<Recipe> get allKnownRecipes => [..._customRecipes, ...Recipe.sampleRecipes];
  List<Recipe> get savedRecipes =>
      allKnownRecipes.where((r) => _savedRecipeIds.contains(r.id)).toList();

  final List<Map<String, String>> _pantryIngredients = [
    {'name': 'Chicken Breast', 'emoji': '🍗'},
    {'name': 'Garlic Cloves', 'emoji': '🧄'},
    {'name': 'Baby Spinach', 'emoji': '🥬'},
    {'name': 'Heavy Cream', 'emoji': '🥛'},
    {'name': 'Sun-Dried Tomatoes', 'emoji': '🍅'},
  ];
  List<Map<String, String>> get pantryIngredients => List.unmodifiable(_pantryIngredients);

  int _servings = 4;
  int get servings => _servings;

  bool _isGenerating = false;
  bool get isGenerating => _isGenerating;

  String? _generationError;
  String? get generationError => _generationError;

  AppState() {
    _currentRecipe = Recipe.tuscanChicken;
  }

  void setTab(int index) {
    if (_currentTabIndex != index) {
      _currentTabIndex = index;
      notifyListeners();
    }
  }

  void openRecipe(Recipe recipe) {
    _currentRecipe = recipe;
    _servings = recipe.defaultServings;
    _currentTabIndex = 2; // Switch to Recipe tab
    notifyListeners();
  }

  bool isRecipeSaved(String id) => _savedRecipeIds.contains(id);

  void toggleSaveRecipe(String id, {VoidCallback? onSaved}) {
    if (_savedRecipeIds.contains(id)) {
      _savedRecipeIds.remove(id);
    } else {
      _savedRecipeIds.add(id);
      onSaved?.call();
    }
    notifyListeners();
  }

  void addIngredient(String name, {String emoji = '🥘'}) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    if (!_pantryIngredients.any((item) => item['name']!.toLowerCase() == trimmed.toLowerCase())) {
      _pantryIngredients.add({'name': trimmed, 'emoji': emoji});
      _generationError = null;
      notifyListeners();
    }
  }

  void removeIngredient(String name) {
    _pantryIngredients.removeWhere((item) => item['name'] == name);
    notifyListeners();
  }

  void clearIngredients() {
    _pantryIngredients.clear();
    notifyListeners();
  }

  void clearGenerationError() {
    _generationError = null;
    notifyListeners();
  }

  void adjustServings(int delta) {
    _servings = (_servings + delta).clamp(1, 12);
    notifyListeners();
  }

  void toggleIngredientChecked(RecipeIngredient ingredient) {
    ingredient.isChecked = !ingredient.isChecked;
    notifyListeners();
  }

  Future<bool> generateRecipe({BuildContext? context}) async {
    final ingredients = _pantryIngredients.map((e) => e['name']!).toList();
    if (ingredients.isEmpty) {
      _generationError = 'Please add at least one ingredient to generate a recipe.';
      notifyListeners();
      return false;
    }

    _isGenerating = true;
    _generationError = null;
    notifyListeners();

    try {
      final recipe = await GeminiService.generateRecipe(
        ingredients: ingredients,
      );
      _customRecipes.insert(0, recipe);
      _currentRecipe = recipe;
      _servings = recipe.defaultServings;
      _isGenerating = false;
      _currentTabIndex = 2; // Navigate to Recipe screen
      notifyListeners();
      return true;
    } catch (e) {
      _isGenerating = false;
      _generationError = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}
