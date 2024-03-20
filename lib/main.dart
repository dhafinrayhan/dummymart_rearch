import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'features/profile/models/profile.dart';
import 'services/router.dart';
import 'services/settings.dart';

Future<void> main() async {
  HttpOverrides.global = _HttpOverrides();

  // Initialize Hive.
  await Future(() async {
    await Hive.initFlutter();

    // Register adapters.
    Hive.registerAdapter(ProfileAdapter());
    Hive.registerAdapter(GenderAdapter());

    // Open boxes.
    await [
      Hive.openBox<Profile>('profile'),
      Hive.openBox<String>('token'),
      Hive.openBox<String>('settings'),
    ].wait;
  });

  runApp(ProviderScope(
    observers: [_ProviderObserver()],
    child: const RearchBootstrapper(child: DummyMartApp()),
  ));
}

class DummyMartApp extends ConsumerWidget {
  const DummyMartApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(currentThemeModeProvider);

    return MaterialApp.router(
      title: 'DummyMart',
      themeMode: themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
      ),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

class _ProviderObserver extends ProviderObserver {
  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    debugPrint('Provider $provider was initialized with $value');
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    debugPrint('Provider $provider was disposed');
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    debugPrint('Provider $provider updated from $previousValue to $newValue');
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    debugPrint('Provider $provider threw $error at $stackTrace');
  }
}

class _HttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (_, __, ___) => true;
  }
}
