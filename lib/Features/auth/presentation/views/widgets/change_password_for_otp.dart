import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:multi_vendor_e_commerce_app/Features/auth/presentation/views/login_view.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/styles/app_styles.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:multi_vendor_e_commerce_app/generated/l10n.dart';
import '../../../../../core/utils/api_services.dart';
import '../../../../../core/utils/local_storage_helper.dart';

class ChangePasswordForOtpScreen extends StatefulWidget {
  const ChangePasswordForOtpScreen({super.key});

  @override
  State<ChangePasswordForOtpScreen> createState() => _ChangePasswordForOtpScreenState();
}

class _ChangePasswordForOtpScreenState extends State<ChangePasswordForOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isLoading = false;

  @override
  void dispose() {
    // Sign out when the screen is exited
    Supabase.instance.client.auth.signOut();
     LocalStorageHelper.clearUser();
     LocalStorageHelper.clearCart();

    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> updatePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      final newPassword = newPasswordController.text;

      try {
        final response = await Supabase.instance.client.auth.updateUser(
          UserAttributes(password: newPassword),
        );

        final userId = Supabase.instance.client.auth.currentUser?.id;

        if (userId != null) {
          await ApiServices().patchData(
            path: 'users?id=eq.$userId',
            data: {"password": newPassword},
          );
        }

        if (response.user != null) {
          // Sign out only after successful password change
          await Supabase.instance.client.auth.signOut();
          await LocalStorageHelper.clearUser();
          await LocalStorageHelper.clearCart();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).passwordChanged),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginView()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).passwordChangeFailed),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        log(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).errorOccurred(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isPasswordVisible,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppStyles.semiBold18(context),
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {
            setState(() {
              isPasswordVisible = !isPasswordVisible;
            });
          },
        ),
      ),
      validator: validator ??
              (value) {
            if (value == null || value.isEmpty) {
              return S.of(context).requiredField;
            }
            if (value.length < 6) {
              return S.of(context).passwordTooShort;
            }
            return null;
          },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).changePassword),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildPasswordField(
                label: S.of(context).newPassword,
                controller: newPasswordController,
              ),
              const SizedBox(height: 16),
              _buildPasswordField(
                label: S.of(context).confirmPassword,
                controller: confirmPasswordController,
                validator: (value) {
                  if (value != newPasswordController.text) {
                    return S.of(context).passwordsDoNotMatch;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                onPressed: updatePassword,
                icon: const Icon(Icons.lock_reset, color: Colors.white),
                label: Text(
                  S.of(context).saveChanges,
                  style: AppStyles.semiBold18(context),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}