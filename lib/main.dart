import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:managment_system_project/app/splash_sreen/splash_screen.dart';
import 'package:managment_system_project/features/presentation/pages/home_page.dart';
import 'package:managment_system_project/features/presentation/pages/info_page.dart';
import 'package:managment_system_project/features/presentation/pages/login_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          textTheme:
              GoogleFonts.sourceSans3TextTheme(Theme.of(context).textTheme)
                  .apply()
                  .copyWith(
                    bodyText1: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    bodyText2: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    subtitle1: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                    subtitle2: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w300),
                  ),
        ),
        home: SplashScreen(
          // child: InfoPage(),
          // child: HomePage(),
          child: LoginPage(),
        ));
  }
}
