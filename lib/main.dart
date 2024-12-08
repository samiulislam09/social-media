import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/features/auth/data/firebase_auth_repo.dart';
import 'package:social_media/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:social_media/features/auth/presentation/screens/login.dart';
import 'package:social_media/features/home/presentation/screens/home.dart';
import 'package:social_media/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure bindings are initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final authRepo = FirebaseAuthRepo();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(authRepo: authRepo)..checkAuthStatus(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Social Media',
        home: BlocConsumer<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (state is UnAuthenticated) {
                return Login();
              } else {
                return Home();
              }
            },
            listener: (context, state) {}),
      ),
    );
  }
}
