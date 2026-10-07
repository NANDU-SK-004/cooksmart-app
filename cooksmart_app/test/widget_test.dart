import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cooksmart_app/main.dart';

class _MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _MockHttpClient();
  }
}

class _MockHttpClient implements HttpClient {
  @override
  bool autoUncompress = true;
  @override
  Duration? connectionTimeout;
  @override
  Duration idleTimeout = const Duration(seconds: 15);
  @override
  int? maxConnectionsPerHost;
  @override
  String? userAgent;

  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _MockHttpClientRequest();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockHttpClientRequest implements HttpClientRequest {
  @override
  final HttpHeaders headers = _MockHttpHeaders();

  @override
  Future<HttpClientResponse> close() async => _MockHttpClientResponse();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockHttpHeaders implements HttpHeaders {
  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {}
  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {}
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockHttpClientResponse implements HttpClientResponse {
  // 1x1 transparent PNG
  static const List<int> _transparentPng = [
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
    0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
    0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
    0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
    0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
    0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
  ];

  @override
  int get statusCode => 200;
  @override
  int get contentLength => _transparentPng.length;
  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;
  @override
  final HttpHeaders headers = _MockHttpHeaders();

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream.value(_transparentPng).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUpAll(() {
    HttpOverrides.global = _MockHttpOverrides();
  });

  testWidgets('CookSmart app mounts and navigates successfully', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const CookSmartApp());
    await tester.pumpAndSettle();

    expect(find.byType(CookSmartApp), findsOneWidget);
    expect(find.text('CookSmart'), findsOneWidget);
    expect(find.text('Trending Recipes'), findsOneWidget);

    // 1. Navigate to Ingredients Tab (index 1)
    await tester.tap(find.text('Ingredients'));
    await tester.pumpAndSettle();
    expect(find.text('Pantry Chef'), findsOneWidget);
    expect(find.textContaining('Generate Recipe'), findsOneWidget);

    // 2. Navigate to Recipe Result Screen (index 2)
    await tester.tap(find.text('Recipe'));
    await tester.pumpAndSettle();
    expect(find.text('Step-by-Step Method'), findsOneWidget);

    // 3. Navigate to Saved Recipes Screen (index 3)
    await tester.tap(find.text('Saved').last);
    await tester.pumpAndSettle();
    expect(find.text('Saved Recipes'), findsOneWidget);

    // 4. Navigate back to Home Screen (index 0)
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('Trending Recipes'), findsOneWidget);
  });

  testWidgets('Recipe screen servings counter and bookmarking work', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const CookSmartApp());
    await tester.pumpAndSettle();

    // Tap on Tuscan chicken "View Recipe" button
    await tester.tap(find.text('View Recipe'));
    await tester.pumpAndSettle();

    expect(find.text('Creamy Tuscan Garlic Chicken'), findsOneWidget);

    // Test Servings Stepper: initial is 4 portions
    expect(find.text('4 portions'), findsOneWidget);
    // Tap increment '+'
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('5 portions'), findsOneWidget);

    // Tap decrement '-'
    await tester.tap(find.byIcon(Icons.remove));
    await tester.pumpAndSettle();
    expect(find.text('4 portions'), findsOneWidget);

    // Tap Bookmark/Save icon
    await tester.tap(find.byIcon(Icons.bookmark_rounded).first);
    await tester.pumpAndSettle();
  });
}
