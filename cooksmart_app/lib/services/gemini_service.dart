import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/recipe.dart';

class GeminiService {
  static String get apiKey {
    const envKey = String.fromEnvironment('GEMINI_API_KEY');
    if (envKey.isNotEmpty) return envKey;
    return ApiConfig.geminiApiKey;
  }

  // Primary and fallback models for high availability
  static const List<String> candidateModels = [
    'gemini-flash-lite-latest',
    'gemini-3.1-flash-lite',
    'gemini-3.8-flash',
  ];

  static final List<String> fallbackImages = [
    'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1512058564366-18510be2db19?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1551183053-bf91a1d81141?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=800&q=80',
  ];

  /// Calls Google Gemini API to craft a custom gourmet recipe based on user's exact pantry ingredients.
  static Future<Recipe> generateRecipe({
    required List<String> ingredients,
    List<String> preferences = const [],
  }) async {
    if (ingredients.isEmpty) {
      throw Exception('Please add at least one ingredient to generate a recipe.');
    }

    if (apiKey.isEmpty || apiKey == 'YOUR_GEMINI_API_KEY_HERE') {
      throw Exception(
        'Gemini API key is not configured. Please set your API key in lib/config/api_config.dart',
      );
    }

    final ingredientsListStr = ingredients.join(', ');
    final prefsStr =
        preferences.isNotEmpty ? ' Preferences: ${preferences.join(', ')}.' : '';

    final prompt = '''
You are CookSmart AI, a world-class executive chef. Create an authentic, delicious, and realistic recipe specifically crafted around these available ingredients: $ingredientsListStr.$prefsStr

You must return ONLY a raw JSON object with NO markdown formatting, NO backticks, and NO commentary.
Use this exact JSON schema:
{
  "title": "Creative, appetizing recipe title (e.g. Garlic Butter Glazed Chicken & Spinach)",
  "tag": "Short badge tag (e.g. AI Chef Special, 20-Min Pantry, High Protein)",
  "cuisine": "Cuisine style (e.g. Mediterranean, Italian Pan, Asian Fusion, Rustic American)",
  "cookTimeMinutes": 25,
  "calories": 450,
  "matchPercentage": 96,
  "servings": 4,
  "rating": 4.9,
  "reviewCount": "1.2k",
  "ingredients": [
    {
      "name": "Ingredient name with prep note (e.g. Chicken Breast, sliced)",
      "amountPerServing": 0.5,
      "unit": "units, cups, cloves, tbsp, etc."
    }
  ],
  "steps": [
    {
      "stepNumber": "01",
      "title": "Step summary (e.g. Season & Sear Chicken)",
      "instruction": "Clear, detailed cooking technique instructions.",
      "timerSeconds": 300
    }
  ]
}

Ensure the steps have realistic timerSeconds (in seconds, e.g. 180 for 3 mins, 300 for 5 mins, or 0 if no timer is needed).
''';

    final requestBody = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': prompt}
          ]
        }
      ],
      'generationConfig': {
        'responseMimeType': 'application/json',
      }
    });

    String lastErrorMessage = 'Unknown error';

    for (final model in candidateModels) {
      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey',
      );

      try {
        final response = await http
            .post(
              url,
              headers: {'Content-Type': 'application/json'},
              body: requestBody,
            )
            .timeout(const Duration(seconds: 22));

        if (response.statusCode == 200) {
          final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
          final candidates = jsonMap['candidates'] as List?;
          if (candidates != null && candidates.isNotEmpty) {
            final content = candidates[0]['content'] as Map<String, dynamic>?;
            final parts = content?['parts'] as List?;
            if (parts != null && parts.isNotEmpty) {
              final rawText = parts[0]['text']?.toString() ?? '';
              final recipeData = _extractJson(rawText);
              if (recipeData != null) {
                // Pick an appetizing image
                final imageIndex =
                    recipeData['title'].toString().length % fallbackImages.length;
                recipeData['imageUrl'] = fallbackImages[imageIndex];
                return Recipe.fromJson(recipeData);
              }
            }
          }
          lastErrorMessage = 'Could not parse recipe from AI response.';
        } else {
          final errBody = response.body;
          try {
            final errJson = jsonDecode(errBody) as Map<String, dynamic>;
            final message = errJson['error']?['message'] ?? 'Status ${response.statusCode}';
            lastErrorMessage = message.toString();
          } catch (_) {
            lastErrorMessage = 'Server returned HTTP ${response.statusCode}';
          }
        }
      } catch (e) {
        lastErrorMessage = e.toString();
      }
    }

    throw Exception('Failed to generate recipe from AI: $lastErrorMessage');
  }

  static Map<String, dynamic>? _extractJson(String text) {
    var cleaned = text.trim();
    if (cleaned.startsWith('```json')) {
      cleaned = cleaned.substring(7);
    } else if (cleaned.startsWith('```')) {
      cleaned = cleaned.substring(3);
    }
    if (cleaned.endsWith('```')) {
      cleaned = cleaned.substring(0, cleaned.length - 3);
    }
    cleaned = cleaned.trim();

    try {
      final decoded = jsonDecode(cleaned);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {
      // Fallback: locate first '{' and last '}'
      final start = cleaned.indexOf('{');
      final end = cleaned.lastIndexOf('}');
      if (start != -1 && end != -1 && end > start) {
        final substring = cleaned.substring(start, end + 1);
        try {
          final decoded = jsonDecode(substring);
          if (decoded is Map<String, dynamic>) {
            return decoded;
          }
        } catch (_) {}
      }
    }
    return null;
  }
}
