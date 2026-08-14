import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/user_cubit.dart';
import 'repository/user_repository.dart';
import 'screens/search_screen.dart';

void main() {
  final repository = UserRepository();

  runApp(
    MyApp(repository: repository),
  );
}

class MyApp extends StatelessWidget {
  final UserRepository repository;

  const MyApp({
    super.key,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profile Explorer',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: BlocProvider(
        create: (_) => UserCubit(repository),
        child: const SearchScreen(),
      ),
    );
  }
}