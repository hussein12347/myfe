import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/utils/widgets/custom_text_field.dart';
import '../../../../../generated/l10n.dart';

class JobTextFormField extends StatelessWidget {
  const JobTextFormField({
    super.key,
    required this.jobController,
  });

  final TextEditingController jobController;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      prefixIcon:  FontAwesomeIcons.briefcase,
      hintText: S.of(context).job,
      controller: jobController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return S.of(context).pleaseEnterYourJob;
        }

        return null;
      },
    );
  }
}
