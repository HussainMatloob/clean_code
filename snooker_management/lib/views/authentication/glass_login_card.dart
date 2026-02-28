import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:snooker_management/controller/auth_controller.dart';
import 'package:snooker_management/routes/router_refresh_notifire.dart';

class GlassLoginCard extends StatelessWidget {
  GlassLoginCard({
    required this.formKey,
    required this.email,
    required this.password,
    required this.obscure,
    required this.setObsecure,
    required this.loading,
    required this.onLogin,
    required this.gold,
    required this.green,
    required this.felt,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController email;
  final TextEditingController password;
  final bool obscure;
  final VoidCallback setObsecure;
  final bool loading;
  final VoidCallback onLogin;

  final Color gold;
  final Color green;
  final Color felt;

  final authNotifier = AuthStateNotifier();

  AuthenticationController get authenticationController =>
      Get.put(AuthenticationController(authNotifier));

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.all(26),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withOpacity(0.16)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Heading
                Text(
                  "Welcome back",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Sign in to continue managing your snooker club.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 22),

                // Email
                _Field(
                  label: "Email",
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  icon: Icons.email_outlined,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return "Email is required";
                    if (!RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]+$")
                        .hasMatch(v.trim())) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Password
                _Field(
                  label: "Password",
                  controller: password,
                  icon: Icons.lock_outline,
                  obscureText: obscure,
                  onToggleObscure: setObsecure,
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Password is required";
                    if (v.length < 6) return "Minimum 6 characters";
                    return null;
                  },
                ),

                // Forgot

                SizedBox(height: 20.h),

                // Login button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {}, //loading ? null : onLogin,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: green,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ).merge(
                      ButtonStyle(
                        overlayColor: WidgetStateProperty.resolveWith(
                          (s) => s.contains(WidgetState.pressed)
                              ? Colors.white.withOpacity(0.08)
                              : null,
                        ),
                      ),
                    ),
                    child:
                        //  loading
                        //     ? const SizedBox(
                        //         height: 22,
                        //         width: 22,
                        //         child: CircularProgressIndicator(strokeWidth: 2),
                        //       )
                        //     :
                        const Text(
                      "LOG IN",
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Login button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loading
                        ? null
                        : loading
                            ? null
                            : onLogin,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: green,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ).merge(
                      ButtonStyle(
                        overlayColor: WidgetStateProperty.resolveWith(
                          (s) => s.contains(WidgetState.pressed)
                              ? Colors.white.withOpacity(0.08)
                              : null,
                        ),
                      ),
                    ),
                    child: loading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            "Demo mode",
                            style: TextStyle(
                              fontSize: 16.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.4,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 14),

                // Support / Footer line
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        gold.withOpacity(0.0),
                        gold.withOpacity(0.5),
                        gold.withOpacity(0.0)
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  height: 1,
                ),
                const SizedBox(height: 12),
                const Text(
                  "Need help? Contact support@snookerpartner.com",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white60, fontSize: 12.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.controller,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.onToggleObscure,
    this.validator,
  });

  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final VoidCallback? onToggleObscure;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        suffixIcon: onToggleObscure == null
            ? null
            : IconButton(
                onPressed: onToggleObscure,
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white70,
                ),
              ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.06),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.18)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }
}
