// lib/widgets/responsive_form_fields.dart
import 'package:flutter/material.dart';

class ResponsiveFormFields extends StatelessWidget {
  final Widget field1;
  final Widget? field2;
  final Widget? field3;
  final double breakpoint;
  final double spacing;
  final CrossAxisAlignment columnAlignment;

  const ResponsiveFormFields({
    super.key,
    required this.field1,
    this.field2,
    this.field3,
    this.breakpoint = 520.0,
    this.spacing = 16.0,
    this.columnAlignment = CrossAxisAlignment.stretch,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWideScreen = constraints.maxWidth > breakpoint;

        // Collect the non-null fields
        final fields = [
          field1,
          if (field2 != null) field2!,
          if (field3 != null) field3!,
        ];

        if (fields.length == 1) return field1;

        if (isWideScreen) {
          return Row(
            children: [
              for (int i = 0; i < fields.length; i++) ...[
                Expanded(child: fields[i]),
                if (i < fields.length - 1) SizedBox(width: spacing),
              ],
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: columnAlignment,
            children: [
              for (int i = 0; i < fields.length; i++) ...[
                fields[i],
                if (i < fields.length - 1) SizedBox(height: spacing),
              ],
            ],
          );
        }
      },
    );
  }
}
