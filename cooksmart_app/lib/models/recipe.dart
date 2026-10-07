class RecipeIngredient {
  final String name;
  final double amountPerServing;
  final String unit;
  bool isChecked;

  RecipeIngredient({
    required this.name,
    required this.amountPerServing,
    required this.unit,
    this.isChecked = false,
  });

  String formatAmount(int servings) {
    final total = amountPerServing * servings;
    if (total == total.roundToDouble()) {
      return '${total.toInt()} $unit'.trim();
    }
    return '${total.toStringAsFixed(1)} $unit'.trim();
  }
}

class RecipeStep {
  final String stepNumber;
  final String title;
  final String instruction;
  final int? timerSeconds;

  RecipeStep({
    required this.stepNumber,
    required this.title,
    required this.instruction,
    this.timerSeconds,
  });
}

class Recipe {
  final String id;
  final String title;
  final String cuisine;
  final int cookTimeMinutes;
  final int defaultServings;
  final int calories;
  final double rating;
  final String reviewCount;
  final String tag;
  final String imageUrl;
  final int matchPercentage;
  final List<RecipeIngredient> ingredients;
  final List<RecipeStep> steps;

  Recipe({
    required this.id,
    required this.title,
    required this.cuisine,
    required this.cookTimeMinutes,
    required this.defaultServings,
    required this.calories,
    required this.rating,
    required this.reviewCount,
    required this.tag,
    required this.imageUrl,
    required this.matchPercentage,
    required this.ingredients,
    required this.steps,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    final rawIngredients = json['ingredients'] as List? ?? [];
    final parsedIngredients = rawIngredients.map((item) {
      if (item is Map<String, dynamic>) {
        final name = item['name']?.toString() ?? 'Ingredient';
        final rawAmount = item['amountPerServing'];
        double amount = 0.5;
        if (rawAmount is num) {
          amount = rawAmount.toDouble();
        } else if (rawAmount is String) {
          amount = double.tryParse(rawAmount) ?? 0.5;
        }
        final unit = item['unit']?.toString() ?? '';
        return RecipeIngredient(
          name: name,
          amountPerServing: amount,
          unit: unit,
        );
      }
      return RecipeIngredient(
        name: item.toString(),
        amountPerServing: 0.5,
        unit: '',
      );
    }).toList();

    final rawSteps = json['steps'] as List? ?? [];
    final parsedSteps = rawSteps.asMap().entries.map((entry) {
      final idx = entry.key;
      final step = entry.value;
      if (step is Map<String, dynamic>) {
        final stepNum = step['stepNumber']?.toString() ??
            (idx + 1).toString().padLeft(2, '0');
        final title = step['title']?.toString() ?? 'Step ${idx + 1}';
        final instruction = step['instruction']?.toString() ?? '';
        final rawTimer = step['timerSeconds'];
        int? timerSeconds;
        if (rawTimer is num && rawTimer > 0) {
          timerSeconds = rawTimer.toInt();
        }
        return RecipeStep(
          stepNumber: stepNum,
          title: title,
          instruction: instruction,
          timerSeconds: timerSeconds,
        );
      }
      return RecipeStep(
        stepNumber: (idx + 1).toString().padLeft(2, '0'),
        title: 'Step ${idx + 1}',
        instruction: step.toString(),
      );
    }).toList();

    return Recipe(
      id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
      title: json['title']?.toString() ?? 'Custom AI Recipe',
      cuisine: json['cuisine']?.toString() ?? 'Chef Creation',
      cookTimeMinutes: (json['cookTimeMinutes'] is num)
          ? (json['cookTimeMinutes'] as num).toInt()
          : 25,
      defaultServings: (json['servings'] is num)
          ? (json['servings'] as num).toInt()
          : 4,
      calories: (json['calories'] is num)
          ? (json['calories'] as num).toInt()
          : 450,
      rating: (json['rating'] is num)
          ? (json['rating'] as num).toDouble()
          : 4.9,
      reviewCount: json['reviewCount']?.toString() ?? 'AI Recipe',
      tag: json['tag']?.toString() ?? 'AI Gourmet',
      imageUrl: (json['imageUrl']?.toString().isNotEmpty == true)
          ? json['imageUrl'].toString()
          : 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?auto=format&fit=crop&w=800&q=80',
      matchPercentage: (json['matchPercentage'] is num)
          ? (json['matchPercentage'] as num).toInt()
          : 98,
      ingredients: parsedIngredients,
      steps: parsedSteps,
    );
  }

  static Recipe get tuscanChicken => Recipe(
        id: 'tuscan_chicken',
        title: 'Creamy Tuscan Garlic Chicken',
        cuisine: 'Italian Pan Classic',
        cookTimeMinutes: 25,
        defaultServings: 4,
        calories: 520,
        rating: 4.9,
        reviewCount: '1.2k',
        tag: "Chef's Choice",
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBknD8KDBoXyng73T9FPX70e2GWYV4-CwxXptotH13dvv42Cd8b9Ui56uPiuGMlcK9Rqlgggys7FG4JPNDcAOx7UXmAl74jqBulvCEo6TapVgw2Ho5YqwuvNx375WVfs-9Eh1Lc3SMD549myupVEs-uRD2UK9-PdWcBbKi6reUINBINrC1mZ9GISWiDmvDvooO4mmXNiBzVn8GBKfkrMolEkXwNtlOCN7IJjoBHZXpAcTYfe5JGXWyuw0-5gr4KlplTZHYcqkwVeGE',
        matchPercentage: 98,
        ingredients: [
          RecipeIngredient(name: 'Large Chicken Breasts (sliced)', amountPerServing: 0.5, unit: ''),
          RecipeIngredient(name: 'Garlic Cloves (minced)', amountPerServing: 1.0, unit: 'cloves'),
          RecipeIngredient(name: 'Fresh Baby Spinach', amountPerServing: 0.5, unit: 'cups'),
          RecipeIngredient(name: 'Heavy Cream', amountPerServing: 0.25, unit: 'cups'),
          RecipeIngredient(name: 'Sun-Dried Tomatoes (sliced)', amountPerServing: 0.125, unit: 'cups'),
          RecipeIngredient(name: 'Grated Parmesan Cheese', amountPerServing: 0.125, unit: 'cups'),
          RecipeIngredient(name: 'Extra Virgin Olive Oil', amountPerServing: 0.5, unit: 'tbsp'),
        ],
        steps: [
          RecipeStep(
            stepNumber: '01',
            title: 'Sear the Chicken',
            instruction:
                'Season sliced chicken generously with sea salt and Italian herbs. Heat olive oil in skillet over medium-high and sear chicken for 6-8 minutes until golden brown. Transfer to warm plate.',
            timerSeconds: 360,
          ),
          RecipeStep(
            stepNumber: '02',
            title: 'Sauté Aromatics',
            instruction:
                'In the same skillet, add minced garlic cloves and sliced sun-dried tomatoes. Sauté for 1-2 minutes until fragrant and oil turns amber.',
            timerSeconds: 90,
          ),
          RecipeStep(
            stepNumber: '03',
            title: 'Simmer Cream Sauce',
            instruction:
                'Pour in heavy cream and chicken stock. Bring to a gentle simmer over medium-low heat, deglazing caramelized fond from skillet for 3 minutes until velvety.',
            timerSeconds: 180,
          ),
          RecipeStep(
            stepNumber: '04',
            title: 'Fold & Combine',
            instruction:
                'Stir in baby spinach and parmesan until spinach wilts and sauce thickens. Return chicken to skillet and spoon warm sauce over top. Garnish with fresh basil.',
          ),
        ],
      );

  static List<Recipe> get sampleRecipes => [
        tuscanChicken,
        Recipe(
          id: 'thai_beef',
          title: 'Spicy Thai Basil Beef',
          cuisine: 'Asian Wok Sizzle',
          cookTimeMinutes: 18,
          defaultServings: 2,
          calories: 460,
          rating: 4.8,
          reviewCount: '890',
          tag: 'Quick & Easy',
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuCIwTbNHda-mPrRPQPZmrm5d4yNNi3PGaPkbImOq0Q3iFE_xaKgOd6Pl-hos1QsE49awMD3_MNAmfiGwLnsnspYG0_kx_Zw-LYLkCBQJEO_6YhznyFwc5jtyUqzQITNE_or6DBH7L4YdlsuQBNDNyAPCmsxaxTKo-h8q-cSrWecPNTYIgvgOticw951VnapqbS_qgcGFZlI-MISLtOF19MMTH8iAs-WE2_9mE1ObkgZunTvYG9qfr2_U43B1OGlZzpSQxA6AGEvyuI',
          matchPercentage: 92,
          ingredients: [
            RecipeIngredient(name: 'Minced Sirloin Beef', amountPerServing: 150, unit: 'g'),
            RecipeIngredient(name: 'Thai Holy Basil leaves', amountPerServing: 0.5, unit: 'cup'),
            RecipeIngredient(name: 'Bird’s Eye Chilies', amountPerServing: 2, unit: 'chilies'),
            RecipeIngredient(name: 'Garlic & Oyster Sauce', amountPerServing: 1, unit: 'tbsp'),
          ],
          steps: [
            RecipeStep(
              stepNumber: '01',
              title: 'Wok Flash Fry',
              instruction: 'Pound garlic and chilies. Sizzle in smoking hot wok, add beef, stir-fry fast.',
              timerSeconds: 180,
            ),
            RecipeStep(
              stepNumber: '02',
              title: 'Basil Fold',
              instruction: 'Turn off heat, toss in holy basil until wilted. Serve over jasmine rice.',
            ),
          ],
        ),
        Recipe(
          id: 'avocado_quinoa',
          title: 'Avocado Citrus Quinoa Bowl',
          cuisine: 'California Clean',
          cookTimeMinutes: 15,
          defaultServings: 2,
          calories: 380,
          rating: 4.7,
          reviewCount: '450',
          tag: 'Vegan',
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuAa9032vW1a1rZ_gQPRYXwDt_T0lhpr8qlkoKjD5rCdM4-c_9Ivq_0PJ2Y33OTS98DE-jDEPyil62t0wrAOJEU9q62hjJMf1CirsMXjc-71KHj9so2Te_rf7zHT-j8hheTH75JRAQhxofotb4Ow42vVie7-rNYQV7VUEK-gsUP0WIieBZQGSC4-zILOdzUeIVzDTUEXR3lp80bc-7D7TxTUoBs2_16Lkt3l5LIOjj4GAoeJOmFbWZuSHbFP5PX7arrybzC1HBZqcbc',
          matchPercentage: 88,
          ingredients: [
            RecipeIngredient(name: 'Cooked Tri-Color Quinoa', amountPerServing: 1, unit: 'cup'),
            RecipeIngredient(name: 'Hass Avocado (sliced)', amountPerServing: 0.5, unit: ''),
            RecipeIngredient(name: 'Ruby Grapefruit segments', amountPerServing: 0.5, unit: 'cup'),
            RecipeIngredient(name: 'Lime Vinaigrette', amountPerServing: 1, unit: 'tbsp'),
          ],
          steps: [
            RecipeStep(
              stepNumber: '01',
              title: 'Assemble Bowl',
              instruction: 'Layer fluffy quinoa as base, arrange avocado slices and citrus gems.',
            ),
          ],
        ),
        Recipe(
          id: 'wild_risotto',
          title: 'Wild Mushroom Risotto',
          cuisine: 'Northern Italian',
          cookTimeMinutes: 35,
          defaultServings: 4,
          calories: 540,
          rating: 4.9,
          reviewCount: '780',
          tag: 'Gourmet',
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuBUzKnx7KUM38Sxotmmy31lQFwLrgSqO2HVJUnq88HEZxTSvEWXcT5dmvQiZkn_PHzElfytmsQ5Ee1_lfDE2i3X43iiT-sPlPkTAGE6SWXhlONAUyOrHaDXbUA9CnYynznBKaT0IZ2b0TNlqlt9hMNxM8aqRf-aqKlMnQ4sWRFDV6xUKEpivGrFwPJxsl3QXmklctXaLK2n04WSE_fJZJv_x-ellV8ZgrZfrdAyciWiTrwa8N2oFRlc42G07zloKZufDsq26OnNEa0',
          matchPercentage: 85,
          ingredients: [
            RecipeIngredient(name: 'Carnaroli or Arborio Rice', amountPerServing: 75, unit: 'g'),
            RecipeIngredient(name: 'Mixed Wild Chanterelles', amountPerServing: 60, unit: 'g'),
            RecipeIngredient(name: 'Shallots & White Wine', amountPerServing: 1, unit: 'splash'),
            RecipeIngredient(name: 'Black Truffle Butter', amountPerServing: 10, unit: 'g'),
          ],
          steps: [
            RecipeStep(
              stepNumber: '01',
              title: 'Toasting Rice',
              instruction: 'Toast arborio with shallots until translucent at edges. Deglaze with dry white wine.',
              timerSeconds: 240,
            ),
            RecipeStep(
              stepNumber: '02',
              title: 'Simmer & Mantecatura',
              instruction: 'Ladle hot broth incrementally while stirring. Finish with butter and truffles.',
              timerSeconds: 1200,
            ),
          ],
        ),
        Recipe(
          id: 'crispy_salmon',
          title: 'Crispy Salmon & Asparagus',
          cuisine: 'Nordic Pan Sear',
          cookTimeMinutes: 20,
          defaultServings: 2,
          calories: 490,
          rating: 4.9,
          reviewCount: '920',
          tag: 'Keto',
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDvdmhPZ2CJG_o547VCWaN73dKznjKWlB5lzCkse5_9Lb_KUfx8jNoPIQvs5pzneI7pnNLzDO0gZTGQJSRnG67iteqDCuHA52zPXkvQ3iVD4SS85qAWSqPK7Qe7NlAe7zB9FZNssHGwWrqCxnB8Ql1gf0W-YMSxBKzJohKCMrhcyyMuFQPMQxMo7d4RynX2sLMRbFhyigadZw8bNlhv1Q2oe1o15a6tGaO37UhS-S3oEclgAQBdhprbo9vyrPZbLoIBz4zpWCi6_kE',
          matchPercentage: 94,
          ingredients: [
            RecipeIngredient(name: 'Fresh Atlantic Salmon Fillet', amountPerServing: 180, unit: 'g'),
            RecipeIngredient(name: 'Young Asparagus Spears', amountPerServing: 6, unit: 'spears'),
            RecipeIngredient(name: 'Lemon Herb Butter', amountPerServing: 1, unit: 'tbsp'),
          ],
          steps: [
            RecipeStep(
              stepNumber: '01',
              title: 'Skin Crisp',
              instruction: 'Press salmon skin-side down in smoking hot cast iron for 4 minutes until glass-crisp.',
              timerSeconds: 240,
            ),
            RecipeStep(
              stepNumber: '02',
              title: 'Baste with Butter',
              instruction: 'Flip gently, add asparagus and butter. Spoon foamy butter over fillet.',
              timerSeconds: 180,
            ),
          ],
        ),
        Recipe(
          id: 'shrimp_pasta',
          title: 'Garlic Butter Shrimp Pasta',
          cuisine: 'Mediterranean Coastal',
          cookTimeMinutes: 22,
          defaultServings: 3,
          calories: 510,
          rating: 4.8,
          reviewCount: '640',
          tag: 'Comfort Food',
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDixLv2uHrqVPiCzPNwlNQudUwGFnuXDgsQj27p3-ltR3_k256zb1akOqBwao6SOQFJWDZrN1FdU9wkegf3yG-bUVzrrmL0RqfgH5jf8Jzl6ras4OJmKgaLVCK-u3NKqkN7f8I64SSUNZgtexnvp_QeFIytXll7rwyHd_H9472CUA3cAbfvWI-HnkfIm8rm9FM3wv5S3X35WPDR4BaRoCxVpPFgOuq85L9fCinIvGRJjXpAZ1i4_dL5rF5o5nUKZyT8_VvKM7HIefE',
          matchPercentage: 90,
          ingredients: [
            RecipeIngredient(name: 'Jumbo Tiger Prawns', amountPerServing: 5, unit: 'shrimp'),
            RecipeIngredient(name: 'Angel Hair Capellini', amountPerServing: 80, unit: 'g'),
            RecipeIngredient(name: 'Garlic Butter & White Wine', amountPerServing: 1.5, unit: 'tbsp'),
          ],
          steps: [
            RecipeStep(
              stepNumber: '01',
              title: 'Sear Prawns',
              instruction: 'Sear prawns in garlic butter for 2 mins per side until pink and curled.',
              timerSeconds: 240,
            ),
            RecipeStep(
              stepNumber: '02',
              title: 'Toss with Pasta',
              instruction: 'Toss al dente pasta into garlic pan sauce with chopped parsley and chili flakes.',
            ),
          ],
        ),
      ];
}
