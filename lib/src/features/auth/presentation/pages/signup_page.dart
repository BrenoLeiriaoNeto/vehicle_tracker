import 'package:flutter/material.dart';
import 'package:ionex/ionex.dart';
import 'package:vehicle_tracker/src/core/core_exports.dart';
import 'package:vehicle_tracker/src/core/di/injection_container.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/controllers/signup_controller.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/state/auth_state.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/state/signup_state.dart';

class SignupPage extends StatefulWidget {
  final VoidCallback onFlip;

  const SignupPage({super.key, required this.onFlip});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _signupController = sl<SignupController>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();

    _signupController.addListener(_onSignUpStateChanged);
  }

  @override
  void dispose() {
    _signupController.removeListener(_onSignUpStateChanged);
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _signupController.dispose();
    super.dispose();
  }

  void _onSignUpStateChanged() {
    final state = _signupController.state;

    if (state.status == .success) {
      final authController =
          IonProvider.of<AuthState>(context) as AuthController;
      authController.setAuthenticatedUser(state.createdUser);
    }
  }

  void _submit(SignupController signupController) {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final name = _nameController.text.trim();

      signupController.signUp(email, password, name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                const SizedBox(height: 40),

                Text(
                  'Criar Conta',
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: .bold,
                    letterSpacing: 1.2,
                  ),
                  textAlign: .center,
                ),
                const SizedBox(height: 40),

                CustomTextFormField(
                  controller: _nameController,
                  labelText: 'Nome',
                  prefixIcon: Icons.person,
                  keyboardType: .text,
                  textInputAction: .next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Insira um nome';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                CustomTextFormField(
                  controller: _emailController,
                  labelText: 'E-mail',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: .emailAddress,
                  textInputAction: .next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Insira um e-mail';
                    }
                    if (!value.contains('@')) return 'E-mail inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomTextFormField(
                  controller: _passwordController,
                  labelText: 'Senha',
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscurePassword,
                  textInputAction: .next,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        () => _obscurePassword = !_obscurePassword;
                      });
                    },
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.white54,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Insira uma senha';
                    }
                    if (value.length < 6) return 'Mínimo de 6 caractéres';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomTextFormField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirmar Senha',
                  prefixIcon: Icons.lock_clock_outlined,
                  obscureText: _obscurePassword,
                  textInputAction: .done,
                  onFieldSubmitted: (_) => _submit(_signupController),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        () =>
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.white54,
                    ),
                  ),
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'As senhas não coincidem';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                IonBuilder<SignupState>(
                  ion: _signupController,
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state.status == .loading
                          ? null
                          : () => _submit(_signupController),
                      child: state.status == .loading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: theme.colorScheme.tertiary,
                              ),
                            )
                          : Text('Cadastrar'),
                    );
                  },
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: .center,
                  children: [
                    Text('Já possui uma conta?', style: textTheme.bodyMedium),
                    TextButton(
                      onPressed: widget.onFlip,
                      child: Text(
                        'Faça o login',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: .bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
