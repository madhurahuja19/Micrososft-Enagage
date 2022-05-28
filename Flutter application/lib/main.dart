import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_app/providers/movies_provider.dart';
import 'package:flutter_movie_app/screens/login.dart';
import 'package:flutter_movie_app/screens/screens.dart';
import 'package:flutter_movie_app/screens/signup.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });
  runApp(AppState());
}

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MoviesProvider(),
          lazy: false,
        ),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Movie App',
        initialRoute:
            FirebaseAuth.instance.currentUser == null ? 'signin' : 'home',
        routes: {
          'signin': (BuildContext context) => SigninScreen(),
          'login': (BuildContext context) => LoginScreen(),
          'home': (BuildContext context) => HomeScreen(),
          'details': (BuildContext context) => DetailsScreen(),
        },
        theme: ThemeData.dark().copyWith(
          appBarTheme: AppBarTheme(color: Colors.black54),
        ));
  }
}
