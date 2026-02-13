import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kappa/kappa.dart';
import 'package:kappa/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:kappa/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:kappa/src/features/auth/presentation/bloc/auth_state.dart';
import 'package:kappa/src/presentation/widgets/common/kappa_button.dart';
import 'package:kappa/src/presentation/widgets/common/kappa_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoAnimation;
  bool _showForm = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    // Explicit Animation cho Logo
    _logoController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _logoAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    // Kích hoạt hiển thị form sau một khoảng trễ nhỏ
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _showForm = true);
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            KappaUI.showError(state.message);
          }
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Theme.of(context).primaryColor, Colors.white],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 50),
                // Logo với Explicit Animation
                ScaleTransition(
                  scale: _logoAnimation,
                  child: const FlutterLogo(size: 100),
                ),
                const SizedBox(height: 20),
                const Text(
                  'KAPPA FRAMEWORK',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                // Form với Implicit Animation (AnimatedContainer)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.fastOutSlowIn,
                  transform: Matrix4.translationValues(0, _showForm ? 0 : 500, 0),
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Welcome Back', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      KappaTextField(
                        controller: _emailController,
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                      ),
                      const SizedBox(height: 16),
                      KappaTextField(
                        controller: _passwordController,
                        labelText: 'Password',
                        obscureText: true,
                        prefixIcon: const Icon(Icons.lock),
                      ),
                      const SizedBox(height: 30),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return KappaButton(
                            text: 'LOGIN',
                            isLoading: state is AuthLoading,
                            onPressed: () {
                              context.read<AuthBloc>().add(LoginRequested(
                                email: _emailController.text,
                                password: _passwordController.text,
                              ));
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
