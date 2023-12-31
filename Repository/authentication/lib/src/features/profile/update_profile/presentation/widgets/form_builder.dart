part of '../pages/update_profile_page.dart';

class UpdateProfileFormBuilder extends ConsumerStatefulWidget {
  const UpdateProfileFormBuilder({super.key});

  @override
  ConsumerState<UpdateProfileFormBuilder> createState() {
    return _UpdateProfileFormBuilderState();
  }
}

class _UpdateProfileFormBuilderState
    extends ConsumerState<UpdateProfileFormBuilder> {
  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(updateProfileInfoProvider.notifier);

    return SingleChildScrollView(
      child: Form(
        key: notifier.formKey,
        child: Column(
          children: [
            InputFormField(
              onChanged: (value) {
                _capitalizeFirstLetter(notifier.firstNameController);
              },
              borderColor: UIColors.timberWolf,
              textEditingController: notifier.firstNameController,
              labelText: TextConstants.firstName,
              style: AppTypography.regular16Caros(),
              labelTextStyle: AppTypography.medium14Circular(
                color: UIColors.pineGreen,
              ),
              autocorrect: false,
            ),
            InputFormField(
              onChanged: (value) {
                _capitalizeFirstLetter(notifier.lastNameController);
              },
              borderColor: UIColors.timberWolf,
              textEditingController: notifier.lastNameController,
              labelText: TextConstants.lastName,
              style: AppTypography.regular16Caros(),
              labelTextStyle: AppTypography.medium14Circular(
                color: UIColors.pineGreen,
              ),
              autocorrect: false,
              keyboardType: TextInputType.name,
            ),
            InputFormField(
              textEditingController: notifier.onlyPhoneController,
              style: AppTypography.regular16Caros(),
              label: Text(
                TextConstants.phoneNumber,
                style: AppTypography.medium14Circular(
                  color: UIColors.pineGreen,
                ),
              ),
              borderColor: UIColors.timberWolf,
              maxLength: 10,
              prefix: IntrinsicHeight(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CountryCodePicker(
                      initialSelection: notifier.countryCodeController.text,
                      padding: EdgeInsets.zero, // Set zero padding to the left
                      countryFilter: const ['+880', 'US'],
                      textStyle: const TextStyle(
                        fontSize: 16,
                        color: UIColors.black,
                      ),
                      onChanged: (country) {
                        notifier.countryCodeController.text = country.dialCode!;
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                      child: const VerticalDivider(
                        color: UIColors.black,
                        width: 1,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
              ),
              validator: InputValidators.phone,
              onChanged: (value) {
                ref
                    .watch(updateProfileValidationProvider.notifier)
                    .isAbleToUpdate(value);
              },
            ),
            const GenderDropdownFormField(),
            const BirthdayFormFieldBuilder(),
          ],
        ),
      ),
    );
  }

  void _capitalizeFirstLetter(TextEditingController controller) {
    final text = controller.text;
    final newText = text.replaceAllMapped(
      RegExp(r'\b\w'),
      (match) => match.group(0)!.toUpperCase(),
    );

    if (newText != text) {
      final newSelectionOffset = newText.length;
      controller.value = controller.value.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newSelectionOffset),
      );
    }
  }
}
