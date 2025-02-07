import 'package:esab/di/injector.dart';
import 'package:esab/features/add_device/presentation/screens/add_device_screen.dart';
import 'package:esab/features/adf_settings/presentation/screens/adf_settings_screen.dart';
import 'package:esab/features/arc_duration/presentation/screens/arc_duration.dart';
import 'package:esab/features/arc_service/presentation/screens/arc_service.dart';
import 'package:esab/features/arc_service/presentation/screens/arc_service_lense_adjust.dart';
import 'package:esab/features/auth/presentation/screens/create_account_screen.dart';
import 'package:esab/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:esab/features/home/presentation/screens/home_screen.dart';
import 'package:esab/features/memory/presentation/screens/memory_screen.dart';
import 'package:esab/features/onboard/presentation/onboard_screen.dart';
import 'package:esab/features/parts/presentation/screens/parts_details_screen.dart';
import 'package:esab/features/settings/presentation/screens/setting_screen.dart';
import 'package:esab/features/settings/presentation/screens/tutorial_screen.dart';
import 'package:esab/firebase_options.dart';
import 'package:esab/features/auth/presentation/screens/account_create_success.dart';
import 'package:esab/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:esab/features/auth/presentation/screens/verify_email_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'features/arc_service/presentation/screens/replacement_log.dart';
import 'features/settings/presentation/screens/about_screen.dart';
import 'features/settings/presentation/screens/contact_us_screen.dart';
import 'features/settings/presentation/screens/dealer_location.dart';
import 'features/settings/presentation/screens/edit_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initSingletons();

  // Check onboarding status and user authentication before launching the app
  final String initialRoute = await determineInitialRoute();
  runApp(ProviderScope(child: MyApp(initialRoute: initialRoute)));
}

Future<String> determineInitialRoute() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  if (isFirstLaunch) {
    return '/onboard';
  } else if (currentUser != null) {
    return '/home';
  } else {
    return '/signIn';
  }
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WELD OPS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('es'), // Spanish
      ],
      initialRoute: initialRoute,
      routes: {
        '/onboard': (context) => const OnboardScreen(),
        '/home': (context) => const HomeScreen(),
        '/createAccount': (context) => const CreateAccountScreen(),
        '/verifyEmail': (context) => const VerifyEmailScreen(),
        '/signIn': (context) => const SignInScreen(),
        '/accountCreateSuccess': (context) => const AccountCreateSuccess(),
        '/addDevice': (context) => const AddDeviceScreen(),
        '/arcDuration': (context) => const ArcDuration(),
        '/forgotPassword': (context) => const ForgotPassword(),
        '/tutotials': (context) => const TutorialScreen(),
        '/about': (context) => const AboutScreen(),
        '/contact-us': (context) => const ContactUsScreen(),
        '/dealerLocation': (context) => const DealerLocationScreen(),
        '/editProfile': (context) => const EditProfile(),
        // '/replacementLog': (context) => ReplacementLogScreen(lensId: len,),

      },
      onGenerateRoute: (settings) {
        if (settings.name == '/adfSettings') {
          final args = settings.arguments as Map<String, dynamic>?;
          final device = args?['device'] ?? {};
          return MaterialPageRoute(
            builder: (context) => AdfSettingsScreen(device: device),
          );
        }
        if (settings.name == '/serviceLensAdjust') {
          final args = settings.arguments as Map<String, dynamic>?;
          final hours = args?['hours'];
          final imageUrl = args?['imageUrl'];
          final percentage = args?['percentage'];
          final title = args?['title'];
          final id = args?['id'];
          return MaterialPageRoute(
            builder: (context) => AdjustLensPercentageScreen(
              hours: hours,
              imageUrl: imageUrl,
              percentage: percentage,
              title: title, id: id,
            ),
          );
        }
        if (settings.name == '/adfService') {
          final args = settings.arguments as Map<String, dynamic>?;
          final device = args?['device'] ?? {};
          return MaterialPageRoute(
            builder: (context) => AdfService(device: device),
          );
        }
        if (settings.name == '/partDetails') {
          final args = settings.arguments as Map;
          final device = args['part'] ?? {};
          return MaterialPageRoute(
            builder: (context) => PartDetailsScreen(part: device),
          );
        }
        if (settings.name == '/replacementLog') {
          final args = settings.arguments as Map<String, dynamic>?;
          final id = args?['id'];
          return MaterialPageRoute(
            builder: (context) => ReplacementLogScreen(id: id),
          );
        }
        if (settings.name == '/memorySetting') {
          final args = settings.arguments as Map<String, dynamic>?;

          if (args == null ||
              !args.containsKey('device') ||
              !args.containsKey('adfSetting')) {
            throw ArgumentError(
                'Missing required arguments: device or adfSetting');
          }

          final device = args['device'];
          final adfSetting = args['adfSetting'];
          final currentSetting = args['currentSetting'];
          return MaterialPageRoute(
            builder: (context) => MemoryScreen(
              device: device,
              adfSetting: adfSetting,
              currentSetting: currentSetting,
            ),
          );
        }
        return null;
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
