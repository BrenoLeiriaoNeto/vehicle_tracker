import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vehicle_tracker/src/core/widgets/custom_text_form_field.dart';

void main() {
  testWidgets('renders TextFormField with the provided label and controller', (
    tester,
  ) async {
    final controller = TextEditingController(text: 'hello');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomTextFormField(
            controller: controller,
            labelText: 'Email',
            prefixIcon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (_) => null,
          ),
        ),
      ),
    );

    expect(find.text('Email'), findsOneWidget);
    expect(find.byType(EditableText), findsOneWidget);

    final editableText = tester.widget<EditableText>(find.byType(EditableText));
    expect(editableText.obscureText, isFalse);
  });

  testWidgets('renders obscure TextFormField when obscureText is true', (
    tester,
  ) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomTextFormField(
            controller: controller,
            labelText: 'Senha',
            prefixIcon: Icons.lock_outline,
            obscureText: true,
            textInputAction: TextInputAction.done,
            validator: (_) => null,
          ),
        ),
      ),
    );

    expect(find.text('Senha'), findsOneWidget);
    expect(find.byType(EditableText), findsOneWidget);

    final editableText = tester.widget<EditableText>(find.byType(EditableText));
    expect(editableText.obscureText, isTrue);
  });
}
