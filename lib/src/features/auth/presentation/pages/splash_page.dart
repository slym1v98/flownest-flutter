import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kappa/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:kappa/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:kappa/src/features/auth/presentation/bloc/auth_state.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            // Navigate to home page
            // TODO: Replace with actual navigation (e.g., GoRouter)
            Navigator.of(context).pushReplacementNamed('/home');
          } else if (state is Unauthenticated) {
            // Navigate to login page
            // TODO: Replace with actual navigation (e.g., GoRouter)
            Navigator.of(context).pushReplacementNamed('/login');
          } else if (state is AuthError) {
            // Show error and navigate to login or error page
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Authentication Error: ${state.message}')),
            );
            Navigator.of(context).pushReplacementNamed('/login'); // Fallback to login
          }
        },
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Checking Authentication Status...'),
            ],
          ),
        ),
      ),
    );
  }
}
