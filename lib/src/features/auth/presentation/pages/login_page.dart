import 'package:flutter/material.dart';
import 'package:ionex/ionex.dart';
import 'package:vehicle_tracker/src/core/core_exports.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/state/auth_state.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onFlip;

  const LoginPage({super.key, required this.onFlip});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit(AuthController authController) {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      authController.login(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final mediaQuery = MediaQuery.of(context);

    final authController = IonProvider.of<AuthState>(context) as AuthController;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  mediaQuery.size.height -
                  mediaQuery.padding.top -
                  mediaQuery.padding.bottom,
            ),
            child: IntrinsicHeight(
              child: IonBuilder(
                ion: authController,
                builder: (context, state) {
                  if (state.status == .error && state.errorMessage != null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.errorMessage!),
                          backgroundColor: theme.colorScheme.error,
                        ),
                      );
                    });
                  }

                  return Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: .stretch,
                      children: [
                        const Spacer(flex: 2),
                        Column(
                          children: [
                            Icon(
                              Icons.local_shipping_outlined,
                              size: 80,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Vehicle Tracker',
                              style: textTheme.headlineMedium?.copyWith(
                                fontWeight: .bold,
                                letterSpacing: 1.2,
                              ),
                              textAlign: .center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Gerencia sua frota na velocidade da luz.',
                              style: textTheme.bodyMedium,
                              textAlign: .center,
                            ),
                          ],
                        ),
                        const Spacer(flex: 2),

                        CustomTextFormField(
                          controller: _emailController,
                          labelText: 'Email',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: .emailAddress,
                          textInputAction: .next,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira seu e-mail';
                            }
                            if (!value.contains('@')) {
                              return 'Por favor, insira um e-mail válido';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        CustomTextFormField(
                          controller: _passwordController,
                          labelText: 'Senha',
                          prefixIcon: Icons.lock_outline,
                          obscureText: _obscurePassword,
                          textInputAction: .done,
                          onFieldSubmitted: (_) => _submit(authController),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () {
                              setState(
                                () => _obscurePassword = !_obscurePassword,
                              );
                            },
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira sua senha';
                            }
                            if (value.length < 6) {
                              return 'A senha deve ter pelo menos 6 caracteres';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 24),

                        IonBuilder(
                          ion: authController,
                          builder: (context, state) {
                            return ElevatedButton(
                              onPressed: state.status == .loading
                                  ? null
                                  : () => _submit(authController),
                              child: state.status == .loading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text('Entrar'),
                            );
                          },
                        ),

                        const Spacer(flex: 3),

                        Row(
                          mainAxisAlignment: .center,
                          children: [
                            Text(
                              'Não tem uma conta?',
                              style: textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: widget.onFlip,
                              child: Text(
                                'Cadastre-se',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: .bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
