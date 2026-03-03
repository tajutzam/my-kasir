import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_kasir/core/services/database_service.dart';
import 'package:my_kasir/data/models/user_model.dart';
import 'package:my_kasir/data/repositories/user_repositories.dart';

class AuthController extends GetxController {
  final DatabaseService _databaseService = Get.find<DatabaseService>();
  late final UserRepository _userRepo;

  // Observables
  final isLoading = false.obs;
  final isLoggedIn = false.obs;
  final Rxn<UserModel> currentUser = Rxn<UserModel>();

  // Form fields
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _userRepo = UserRepository(_databaseService.database);
    _checkExistingSession();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    super.onClose();
  }

  Future<void> _checkExistingSession() async {
    // TODO: Implement session checking with SharedPreferences
    // For now, just check if there are any users
    final users = await _userRepo.getAll();
    if (users.isNotEmpty) {
      // Auto-login with first user (simplified)
      currentUser.value = users.first;
      isLoggedIn.value = true;
    }
  }

  Future<bool> login() async {
    // Validate input
    if (!_validateLoginInput()) {
      return false;
    }

    isLoading.value = true;

    try {
      final email = emailController.text.trim();
      final password = passwordController.text;

      final user = await _userRepo.login(email, password);

      if (user != null) {
        currentUser.value = user;
        isLoggedIn.value = true;
        Get.snackbar(
          'Success',
          'Login berhasil! Selamat datang, ${user.fullName}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primaryContainer,
        );
        return true;
      } else {
        Get.snackbar(
          'Error',
          'Email atau password salah',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.errorContainer,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.errorContainer,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> register() async {
    // Validate input
    if (!_validateRegisterInput()) {
      return false;
    }

    isLoading.value = true;

    try {
      final fullName = fullNameController.text.trim();
      final email = emailController.text.trim();
      final password = passwordController.text;

      // Check if email already exists
      final emailExists = await _userRepo.emailExists(email);
      if (emailExists) {
        Get.snackbar(
          'Error',
          'Email sudah terdaftar. Silakan gunakan email lain.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.errorContainer,
        );
        return false;
      }

      final newUser = UserModel(
        fullName: fullName,
        email: email,
        password: password, // TODO: Hash password in production!
      );

      await _userRepo.register(newUser);

      Get.snackbar(
        'Success',
        'Registrasi berhasil! Silakan login.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primaryContainer,
      );

      // Navigate to login
      Get.back();
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.errorContainer,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    currentUser.value = null;
    isLoggedIn.value = false;
    _clearFormFields();
    Get.snackbar(
      'Info',
      'Anda telah logout',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  bool _validateLoginInput() {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty) {
      Get.snackbar('Error', 'Email tidak boleh kosong');
      return false;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Error', 'Format email tidak valid');
      return false;
    }

    if (password.isEmpty) {
      Get.snackbar('Error', 'Password tidak boleh kosong');
      return false;
    }

    if (password.length < 6) {
      Get.snackbar('Error', 'Password minimal 6 karakter');
      return false;
    }

    return true;
  }

  bool _validateRegisterInput() {
    final fullName = fullNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (fullName.isEmpty) {
      Get.snackbar('Error', 'Nama lengkap tidak boleh kosong');
      return false;
    }

    if (email.isEmpty) {
      Get.snackbar('Error', 'Email tidak boleh kosong');
      return false;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Error', 'Format email tidak valid');
      return false;
    }

    if (password.isEmpty) {
      Get.snackbar('Error', 'Password tidak boleh kosong');
      return false;
    }

    if (password.length < 6) {
      Get.snackbar('Error', 'Password minimal 6 karakter');
      return false;
    }

    return true;
  }

  void _clearFormFields() {
    emailController.clear();
    passwordController.clear();
    fullNameController.clear();
  }
}
