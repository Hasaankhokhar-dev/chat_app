import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Login',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),
            GetBuilder<AuthController>(
              builder: (controller) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        hintText: 'example@gmail.com',
                        errorText: controller.emailError.isEmpty
                            ? null
                            : controller.emailError,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            GetBuilder<AuthController>(
              builder: (controller) {
                return TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Min 6 characters',
                    errorText: controller.passwordError.isEmpty
                        ? null
                        : controller.passwordError,
                  ),
                );
              },
            ),

            const SizedBox(height: 16),
            GetBuilder<AuthController>(
              builder: (controller) {
                if (controller.errorMessage.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    controller.errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              },
            ),

            GetBuilder<AuthController>(
              builder: (controller) {
                if (controller.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          controller.login(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                          );
                        },
                        child: const Text('Login'),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Register pe jao
                    TextButton(
                      onPressed: () {
                        controller.clearErrors();
                        Get.to(() => const RegisterScreen());
                      },
                      child: const Text("Don't have an account? Register"),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
