import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realtime_database/presentation/home/bloc/home_bloc.dart';
import 'package:realtime_database/presentation/home/mixin/home_mixin.dart';
import 'package:realtime_database/presentation/users/users_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with HomeMixin {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (_, state) {
        return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              return const UsersPage();
            } else {
              return Scaffold(
                backgroundColor: Colors.amber,
                body: SafeArea(
                  child: Column(
                    children: [
                      const SizedBox(height: 100),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'enter your Email...',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: passwordController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'enter your password...',
                            prefixIcon: Icon(Icons.lock_open),
                            suffixIcon: Icon(Icons.remove_red_eye_outlined),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.read<HomeBloc>().add(LoginWithEmailEvent(
                              email: emailController.text,
                              password: passwordController.text));
                        },
                        child: const Text('Login'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          context.read<HomeBloc>().add(SignUpEvent(
                              email: emailController.text,
                              password: passwordController.text));
                        },
                        child: const Text('Sign Up'),
                      ),

                      ElevatedButton(
                        onPressed: () {
                          context.read<HomeBloc>().add(const GoogleEvent());
                        },
                        child: const Text('With Google'),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}
