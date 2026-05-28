import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

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

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // TODO: Próximo passo -> Chamar o controller de Auth via ionex
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      debugPrint('Tentando logar com: $email');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final mediaQuery = MediaQuery.of(context);

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
              child: Form(
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
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: .bold,
                            letterSpacing: 1.2,
                          ),
                          textAlign: .center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Gerencia sua frota na velocidade da luz.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white54,
                          ),
                          textAlign: .center,
                        ),
                      ],
                    ),
                    const Spacer(flex: 2),

                    TextFormField(
                      controller: _emailController,
                      keyboardType: .emailAddress,
                      textInputAction: .next,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
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

                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: .done,
                      onFieldSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.white54,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
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

                    ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Entrar'),
                    ),
                    const Spacer(flex: 3),

                    Row(
                      mainAxisAlignment: .center,
                      children: [
                        const Text(
                          'Não tem uma conta?',
                          style: TextStyle(color: Colors.white54),
                        ),
                        TextButton(
                          onPressed: () {},
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
