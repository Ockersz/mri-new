// lib/widgets/responsive_form_fields.dart
import 'package:flutter/material.dart';

class ResponsiveFormFields extends StatelessWidget {
  final Widget field1;
  final Widget? field2;
  final double breakpoint;
  final double spacing;
  final CrossAxisAlignment columnAlignment;

  const ResponsiveFormFields({
    super.key,
    required this.field1,
    this.field2,
    this.breakpoint = 520.0,
    this.spacing = 16.0,
    this.columnAlignment = CrossAxisAlignment.stretch,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWideScreen = constraints.maxWidth > breakpoint;

        if (field2 == null) return field1;

        if (isWideScreen) {
          return Row(
            children: [
              Expanded(child: field1),
              SizedBox(width: spacing),
              Expanded(child: field2!),
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: columnAlignment,
            children: [field1, SizedBox(height: spacing), field2!],
          );
        }
      },
    );
  }
}
