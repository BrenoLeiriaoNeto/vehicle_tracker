import 'package:flutter/material.dart';
import 'package:ionex/ionex.dart';
import 'package:vehicle_tracker/src/core/core_exports.dart';
import 'package:vehicle_tracker/src/core/di/injection_container.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/controllers/signup_controller.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/state/signup_state.dart';

class SignupPage extends StatefulWidget {
  final VoidCallback onFlip;

  const SignupPage({super.key, required this.onFlip});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _signupController = sl<SignupController>();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
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
      final authController = sl<AuthController>();
      authController.setAuthenticatedUser(state.createdUser);
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final name = _nameController.text.trim();

      _signupController.signUp(email, password, name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      body: SafeArea(
        child: IonBuilder<SignupState>(
          ion: _signupController,
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

            return OrientationBuilder(
              builder: (context, orientation) {
                if (orientation == .landscape) {
                  return _buildLandscapeLayout(theme, textTheme, state);
                }
                return _buildPortraitLayout(theme, textTheme, state);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(
    ThemeData theme,
    TextTheme textTheme,
    SignupState state,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            const SizedBox(height: 40),
            _buildHeader(theme, textTheme, isLandscape: false),
            const SizedBox(height: 32),
            _buildFormFields(theme, state),
            const SizedBox(height: 24),
            _buildFooter(theme, textTheme),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildLandscapeLayout(
    ThemeData theme,
    TextTheme textTheme,
    SignupState state,
  ) {
    return Form(
      key: _formKey,
      child: Row(
        children: [
          Expanded(
            flex: 9,
            child: Container(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: SingleChildScrollView(
                  child: _buildHeader(theme, textTheme, isLandscape: true),
                ),
              ),
            ),
          ),
          VerticalDivider(
            width: 1,
            thickness: 1,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
          ),

          Expanded(
            flex: 11,
            child: Center(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 24.0,
                ),
                child: Column(
                  mainAxisAlignment: .center,
                  crossAxisAlignment: .stretch,
                  children: [
                    Text(
                      'Crie sua conta!',
                      style: textTheme.titleLarge?.copyWith(fontWeight: .bold),
                    ),
                    const SizedBox(height: 20),
                    _buildFormFields(theme, state),
                    const SizedBox(height: 24),
                    _buildFooter(theme, textTheme),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    ThemeData theme,
    TextTheme textTheme, {
    required bool isLandscape,
  }) {
    return Column(
      mainAxisSize: .min,
      children: [
        if (isLandscape) ...[
          Icon(
            Icons.local_shipping_outlined,
            size: 48,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 12),
        ],
        Text(
          'Criar Conta',
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: .bold,
            letterSpacing: 1.2,
          ),
          textAlign: .center,
        ),
        if (isLandscape) ...[
          const SizedBox(height: 8),
          Text(
            'Cadastre sua empresa e comece a monitorar seus veículos em tempo real hoje mesmo.',
            style: textTheme.bodyMedium,
            textAlign: .center,
          ),
        ],
      ],
    );
  }

  Widget _buildFormFields(ThemeData theme, SignupState state) {
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        CustomTextFormField(
          controller: _nameController,
          labelText: 'Nome',
          prefixIcon: Icons.person_outline,
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
              setState(() => _obscurePassword = !_obscurePassword);
            },
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Insira uma senha';
            }
            if (value.length < 6) return 'Mínimo de 6 caracteres';
            return null;
          },
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          controller: _confirmPasswordController,
          labelText: 'Confirmar Senha',
          prefixIcon: Icons.lock_clock_outlined,
          obscureText: _obscureConfirmPassword,
          textInputAction: .done,
          onFieldSubmitted: (_) => _submit(),
          suffixIcon: IconButton(
            onPressed: () {
              setState(
                () => _obscureConfirmPassword = !_obscureConfirmPassword,
              );
            },
            icon: Icon(
              _obscureConfirmPassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
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
        ElevatedButton(
          onPressed: state.status == .loading ? null : () => _submit(),
          child: state.status == .loading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: theme.colorScheme.onPrimary,
                  ),
                )
              : const Text('Cadastrar'),
        ),
      ],
    );
  }

  Widget _buildFooter(ThemeData theme, TextTheme textTheme) {
    return Row(
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
    );
  }
}
