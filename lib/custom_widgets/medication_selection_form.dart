import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:flutter/material.dart';

import '../screens/wiki/medication/medication.dart';
import '../screens/wiki/medication/medication_list.dart';
import 'icon_label_detail_button.dart';

/// A medication selector, when tapped, will launch a page identical to the med
/// wiki page, but each entry will have a button that will select that med.
///
/// Also integrates with [FormField] which can be validated.
class MedicationSelectionForm extends StatelessWidget {
  // inspired by https://stackoverflow.com/a/76676515
  // and then https://www.youtube.com/watch?v=osZ0cm9nvxM
  // (instead of nesting 2 widgets, we just use FormField in the first place)
  /// Initial medication that the selector will show. (For editing old entries)
  final Medication? medication;
  /// A callback that will execute when a medication is selected.
  final Function(Medication) onChanged;
  /// Validator function that can be used in a form to validate before doing
  /// something else.
  final FormFieldValidator<Medication>? validator;

  const MedicationSelectionForm({
    super.key,
    required this.medication,
    required this.onChanged,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<Medication>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: medication,
        validator: validator,
        builder: (formState) {
          return Column(
            children: [
              // The actual widget
              medication == null
                  ? IconLabelDetailButton(
                      label: "กดที่นี่เพื่อเลือกยาที่ต้องการ",
                      onTap: () async {
                        // https://docs.flutter.dev/cookbook/navigation/returning-data
                        final selectedMedication =
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const MedicationList(
                              resultExpected: true,
                            )));

                        if (!context.mounted) return;

                        if (selectedMedication != null) {
                          onChanged(selectedMedication);
                          formState.didChange(selectedMedication);  // Do not forget this; otherwise, the FormField itself will not know the current value.
                        }
                      },
                    )
                  : IconLabelDetailButton(
                      icon: medication!.icon,
                      label: medication!.name,
                      onTap: () async {
                        final selectedMedication =
                            await Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const MedicationList(
                                      resultExpected: true,
                                    )));

                        if (!context.mounted) return;

                        if (selectedMedication != null) {
                          onChanged(selectedMedication);
                          formState.didChange(selectedMedication);
                        }
                      },
                    ),
              // The error text
              Align(
                alignment: Alignment.centerLeft,
                child: formState.errorText != null
                    ? Text(
                        formState.errorText!,
                        style:
                            Theme.of(context).inputDecorationTheme.errorStyle ?? errorStyle,
                      )
                    : const SizedBox.shrink(),
              )
            ],
          );
        });
  }
}