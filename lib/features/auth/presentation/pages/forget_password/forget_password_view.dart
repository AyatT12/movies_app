import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/di/service_locator.dart';
import 'package:movies_app/core/utils/app_colors.dart';
import 'package:movies_app/features/auth/presentation/cubit/forget_password_cubit.dart';
import 'package:movies_app/features/auth/presentation/widgets/auth_header.dart';
import 'package:movies_app/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:movies_app/features/onboarding/presentation/widgets/custom_button.dart';
import 'package:movies_app/l10n/app_localizations.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => sl<ForgetPasswordCubit>(),
      child: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
        listener: (context, state) {
          if (state.status == ForgetPasswordStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Reset password email sent. Please check your email.',
                ),
              ),
            );
            Navigator.pop(context);
          } else if (state.status == ForgetPasswordStatus.failure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message ?? 'Error')));
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      AuthHeader(title: localizations.forgetPassword),
                      const SizedBox(height: 30),
                      Image.asset(
                        'assets/images/forget_password.png',
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 48),
                      AuthTextField(
                        controller: _emailController,
                        hintText: localizations.email,
                        prefixIcon: Icons.email,
                      ),
                      const SizedBox(height: 24),
                      if (state.status == ForgetPasswordStatus.loading)
                        const CircularProgressIndicator(
                          color: AppColors.primary,
                        )
                      else
                        CustomButton(
                          text: localizations.verifyEmail,
                          onPressed: () {
                            context.read<ForgetPasswordCubit>().resetPassword(
                              _emailController.text,
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
