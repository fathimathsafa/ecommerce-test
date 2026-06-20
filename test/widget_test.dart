import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:ewire/main.dart';
import 'package:ewire/presentation/cart/controller/cart_controller.dart';
import 'package:ewire/presentation/home_screen/controller/home_controller.dart';
import 'package:ewire/presentation/navigation/controller/navigation_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ewire/presentation/wishlist/controller/wishlist_controller.dart';
import 'package:ewire/presentation/profile/controller/profile_controller.dart';
import 'package:ewire/presentation/splash_screen/view/splash_screen.dart';

void main() {
  testWidgets('Splash screen loads and shows brand name', (WidgetTester tester) async {
    // Override debugNetworkImageHttpClientProvider to use our MockHttpClient
    debugNetworkImageHttpClientProvider = () => MockHttpClient();
    SharedPreferences.setMockInitialValues({});

    try {
      // Build our app with providers and trigger a frame.
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => WishlistController()),
            ChangeNotifierProvider(create: (_) => CartController()),
            ChangeNotifierProvider(create: (_) => HomeController()),
            ChangeNotifierProvider(create: (_) => NavigationController()),
            ChangeNotifierProvider(create: (_) => ProfileController()),
          ],
          child: const MyApp(),
        ),
      );

      // Verify that the splash screen is shown and displays the title.
      expect(find.byType(SplashScreen), findsOneWidget);
      expect(find.text('SwiftCart'), findsOneWidget);

      // Settle splash screen timer and route transition
      await tester.pump(const Duration(seconds: 4));
      await tester.pump(const Duration(milliseconds: 800));
      await tester.pump();
    } finally {
      // Reset debugNetworkImageHttpClientProvider and clear the image cache.
      debugNetworkImageHttpClientProvider = null;
      PaintingBinding.instance.imageCache.clear();
    }
  });
}

class MockHttpClient implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) {
    return Future.value(MockHttpClientRequest());
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockHttpClientRequest implements HttpClientRequest {
  @override
  HttpHeaders get headers => MockHttpHeaders();

  @override
  Future<HttpClientResponse> close() {
    return Future.value(MockHttpClientResponse());
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockHttpHeaders implements HttpHeaders {
  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockHttpClientResponse extends StreamView<List<int>> implements HttpClientResponse {
  MockHttpClientResponse() : super(Stream<List<int>>.fromIterable([
    const [
      0x47, 0x49, 0x46, 0x38, 0x39, 0x61, 0x01, 0x00, 0x01, 0x00, 0x80, 0x00,
      0x00, 0x00, 0x00, 0x00, 0xff, 0xff, 0xff, 0x21, 0xf9, 0x04, 0x01, 0x00,
      0x00, 0x00, 0x00, 0x2c, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x01, 0x00,
      0x00, 0x02, 0x02, 0x4c, 0x01, 0x00, 0x3b
    ]
  ]));

  @override
  int get statusCode => 200;

  @override
  String get reasonPhrase => "OK";

  @override
  int get contentLength => 43;

  @override
  HttpHeaders get headers => MockHttpHeaders();

  @override
  HttpClientResponseCompressionState get compressionState => HttpClientResponseCompressionState.notCompressed;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}





