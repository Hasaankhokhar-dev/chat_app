import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controller/auth_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameContoller = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    nameContoller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Text(
                'Register',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _selectedImage != null
                      ? FileImage(_selectedImage!)
                      : null,
                  child: _selectedImage == null
                      ? const Icon(Icons.add_a_photo, size: 35, color: Colors.grey)
                      : null,
                ),
              ),
              const SizedBox(height: 8),
              const Text('Tap to add profile picture',
                  style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 24),
              GetBuilder<AuthController>(
                builder: (controller) {
                  return TextField(
                    controller: nameContoller,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Name',
                      hintText: 'Muhammad',
                      errorText: controller.nameError.isEmpty
                          ? null
                          : controller.nameError,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              GetBuilder<AuthController>(
                builder: (controller) {
                  return TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: 'example@gmail.com',
                      errorText: controller.emailError.isEmpty
                          ? null
                          : controller.emailError,
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Password field + Error
              GetBuilder<AuthController>(
                builder: (controller) {
                  return TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
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
                            controller.register(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                              nameContoller.text.trim(),
                              _selectedImage,
                            );
                          },
                          child: const Text('Register'),
                        ),
                      ),

                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          controller.clearErrors();
                          Get.back();
                        },
                        child: const Text('Already have an account? Login'),
                      ),

                    ],
                  );
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}