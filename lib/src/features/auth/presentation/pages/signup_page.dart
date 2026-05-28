import 'package:flutter/material.dart';
import 'package:vehicle_tracker/src/core/core_exports.dart';

class SignupPage extends StatefulWidget {
  final VoidCallback onFlip;

  const SignupPage({super.key, required this.onFlip});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // TODO: Chamar método de criar na AuthController
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: .bold,
                    letterSpacing: 1.2,
                  ),
                  textAlign: .center,
                ),
                const SizedBox(height: 40),

                CustomTextFormField(
                  controller: _emailController,
                  labelText: 'E-mail',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: .emailAddress,
                  textInputAction: .next,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Insira um e-mail';
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
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Insira uma senha';
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
                  onFieldSubmitted: (_) => _submit(),
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'As senhas não coincidem';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Cadastrar'),
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: .center,
                  children: [
                    const Text(
                      'Já possui uma conta?',
                      style: TextStyle(color: Colors.white54),
                    ),
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
