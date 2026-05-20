import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app_with_firebase/models/userModel.dart';
import 'package:notes_app_with_firebase/ui/chat_app/users_screen.dart';
import 'package:notes_app_with_firebase/ui/login_screen.dart';
import '../services/cloudinary_service.dart';

class AuthController extends GetxController with WidgetsBindingObserver {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CloudinaryService _cloudinaryService = CloudinaryService();

  bool isLoading = false;
  String errorMessage = '';
  User? currentUser;

  String nameError = '';
  String emailError = '';
  String passwordError = '';
  bool _isRegistering = false;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this); // Lifecycle observer start
  }

  @override
  void onReady() {
    super.onReady();
    _auth.authStateChanges().listen((User? user) {
      currentUser = user;
      if (_isRegistering) return;

      if (user != null) {
        updateUserStatus(true); // User online ho gaya
        Get.offAll(() => const UserScreen());
      } else {
        Get.offAll(() => const LoginScreen());
      }
      update();
    });
  }

  // App lifecycle handle karne ke liye (Online/Offline status)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (currentUser == null) return;
    if (state == AppLifecycleState.resumed) {
      updateUserStatus(true);
    } else {
      updateUserStatus(false);
    }
  }

  // Status update karne ka function
  Future<void> updateUserStatus(bool isOnline) async {
    if (currentUser != null) {
      await _firestore.collection('users').doc(currentUser!.uid).update({
        'isOnline': isOnline,
        'lastSeen': DateTime.now(),
      });
    }
  }

  Future<void> register(String email, String password, String name, File? image) async {
    if (!_validate(email, password, name)) return;
    try {
      isLoading = true;
      errorMessage = '';
      update();
      _isRegistering = true;

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String photoUrl = '';
      if (image != null) {
        photoUrl = await _cloudinaryService.uploadImage(image);
      }

      UserModel newUser = UserModel(
        uid: userCredential.user!.uid,
        name: name,
        email: email,
        photoUrl: photoUrl,
        isOnline: true, // Registration ke waqt online
        lastSeen: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(newUser.toMap());

      await _auth.signOut();
      _isRegistering = false;

      Get.offAll(() => const LoginScreen());
      Get.snackbar('Success', 'Account created! Please login.');
    } on FirebaseAuthException catch (e) {
      _isRegistering = false;
      errorMessage = _getErrorMessage(e.code);
    } catch (e) {
      _isRegistering = false;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> login(String email, String password) async {
    if (!_validate(email, password, '')) return;
    try {
      isLoading = true;
      errorMessage = '';
      update();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      // login ke baad state change listener status true kar dega
    } on FirebaseAuthException catch (e) {
      errorMessage = _getErrorMessage(e.code);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> logout() async {
    await updateUserStatus(false);
    await _auth.signOut();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  bool _validate(String email, String password, String name) {
    emailError = ''; passwordError = ''; nameError = ''; errorMessage = '';
    bool isValid = true;
    if (name.isNotEmpty && name.trim().isEmpty) { nameError = 'Name required'; isValid = false; }
    if (email.isEmpty) { emailError = 'Email required'; isValid = false; }
    if (password.length < 6) { passwordError = 'Min 6 chars'; isValid = false; }
    update();
    return isValid;
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found': return 'Email not registered';
      case 'wrong-password': return 'Wrong Password';
      default: return 'Auth Error: $code';
    }
  }

  void clearErrors() {
    emailError = ''; passwordError = ''; errorMessage = '';
    update();
  }
}