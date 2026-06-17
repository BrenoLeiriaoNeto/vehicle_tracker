import 'package:flutter/material.dart';
import 'package:ionex/ionex.dart';
import 'package:vehicle_tracker/src/core/core_exports.dart';
import 'package:vehicle_tracker/src/core/di/injection_container.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/state/auth_state.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onFlip;

  const LoginPage({super.key, required this.onFlip});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _authController = sl<AuthController>();
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

    return Scaffold(
      body: SafeArea(
        child: IonBuilder<AuthState>(
          ion: _authController,
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
                return _buildPortraitLayout(context, theme, textTheme, state);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(
    BuildContext context,
    ThemeData theme,
    TextTheme textTheme,
    AuthState state,
  ) {
    final mediaQuery = MediaQuery.of(context);

    return SingleChildScrollView(
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
                const Spacer(flex: 1),
                _buildBranding(theme, textTheme, isLandscape: false),
                const Spacer(flex: 1),
                _buildFormFields(theme, state),
                const Spacer(flex: 2),
                _buildFooter(theme, textTheme),
                const Spacer(flex: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLandscapeLayout(
    ThemeData theme,
    TextTheme textTheme,
    AuthState state,
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
                  child: _buildBranding(theme, textTheme, isLandscape: true),
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
                      'Acesse sua conta',
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

  Widget _buildBranding(
    ThemeData theme,
    TextTheme textTheme, {
    required bool isLandscape,
  }) {
    return Column(
      mainAxisSize: .min,
      children: [
        Icon(
          Icons.local_shipping_outlined,
          size: isLandscape ? 64 : 80,
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
          'Gerencie sua frota na velocidade da luz.',
          style: textTheme.bodyMedium,
          textAlign: .center,
        ),
      ],
    );
  }

  Widget _buildFormFields(ThemeData theme, AuthState state) {
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
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
        const SizedBox(height: 16),
        CustomTextFormField(
          controller: _passwordController,
          labelText: 'Senha',
          prefixIcon: Icons.lock_outline,
          obscureText: _obscurePassword,
          textInputAction: .done,
          onFieldSubmitted: (_) => _submit(_authController),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
            onPressed: () {
              setState(() => _obscurePassword = !_obscurePassword);
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
        ElevatedButton(
          onPressed: state.status == .loading
              ? null
              : () => _submit(_authController),
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
        ),
      ],
    );
  }

  Widget _buildFooter(ThemeData theme, TextTheme textTheme) {
    return Wrap(
      alignment: .center,
      crossAxisAlignment: .center,
      children: [
        Text('Não tem uma conta?', style: textTheme.bodyMedium),
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
    );
  }
}
