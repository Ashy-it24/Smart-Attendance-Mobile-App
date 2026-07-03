import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_attendance/core/constants/color_constants.dart';
import 'package:smart_attendance/core/constants/string_constants.dart';
import 'package:smart_attendance/data/datasources/auth_remote_datasource.dart';
import 'package:smart_attendance/data/repositories/auth_repository_impl.dart';
import 'package:smart_attendance/presentation/providers/auth_provider.dart';
import 'package:smart_attendance/presentation/providers/face_recognition_provider.dart';
import 'package:smart_attendance/routes/app_routes.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const SmartAttendanceApp());
}

class SmartAttendanceApp extends StatelessWidget {
  const SmartAttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Firebase Auth instance
        Provider<FirebaseAuth>(
          create: (_) => FirebaseAuth.instance,
        ),
        // Auth Remote Data Source
        ProxyProvider<FirebaseAuth, AuthRemoteDataSource>(
          create: (context) => AuthRemoteDataSourceImpl(
            context.read<FirebaseAuth>(),
          ),
          update: (context, firebaseAuth, previous) =>
              AuthRemoteDataSourceImpl(firebaseAuth),
        ),
        // Auth Repository
        ProxyProvider2<AuthRemoteDataSource, FirebaseAuth, AuthRepositoryImpl>(
          create: (context) => AuthRepositoryImpl(
            context.read<AuthRemoteDataSource>(),
            context.read<FirebaseAuth>(),
          ),
          update: (context, remoteDataSource, firebaseAuth, previous) =>
              AuthRepositoryImpl(remoteDataSource, firebaseAuth),
        ),
        // Auth Provider (State Management)
        ChangeNotifierProxyProvider<AuthRepositoryImpl, AppAuthProvider>(
          create: (context) => AppAuthProvider(context.read<AuthRepositoryImpl>()),
          update: (context, authRepository, previous) =>
              previous ?? AppAuthProvider(authRepository),
        ),
        // Face Recognition Provider
        ChangeNotifierProvider<FaceRecognitionProvider>(
          create: (_) => FaceRecognitionProvider(),
        ),
      ],
      child: MaterialApp(
        title: StringConstants.appName,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: ColorConstants.primaryColor,
          ),
          useMaterial3: true,
        ),
        initialRoute: AppRoutes.splash,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
