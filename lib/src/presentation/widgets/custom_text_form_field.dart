import 'package:flutter/material.dart';
import '../../core/validators/text_field_validator.dart';
import '../../core/validators/validator_builder.dart';

enum TextFieldType {
  password,
  email;

  bool get isPassword => this == TextFieldType.password;
}

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    required this.textEditingController,
    required this.validator,
    required this.type,
    this.hintMessage,
    this.prefixIcon,
    this.keyboardType,
    super.key,
  });

  factory CustomTextFormField.password(TextEditingController controller) {
    final validator = ValidatorBuilder()
        .add(TextFieldValidator.required)
        .add((value) => TextFieldValidator.minLength(value, 6))
        .build;

    return CustomTextFormField(
      textEditingController: controller,
      validator: validator,
      type: TextFieldType.password,
      hintMessage: '**********',
      prefixIcon: const Icon(Icons.lock_outline),
      keyboardType: TextInputType.visiblePassword,
    );
  }

  factory CustomTextFormField.email(TextEditingController controller) {
    final validator = ValidatorBuilder()
        .add(TextFieldValidator.required)
        .add((value) => TextFieldValidator.minLength(value, 6))
        .add(TextFieldValidator.email)
        .build;

    return CustomTextFormField(
      textEditingController: controller,
      validator: validator,
      type: TextFieldType.email,
      hintMessage: 'example@example.com',
      prefixIcon: const Icon(Icons.email_outlined),
      keyboardType: TextInputType.emailAddress,
    );
  }

  final TextEditingController textEditingController;
  final FormFieldValidator<String> validator;
  final TextFieldType type;

  final String? hintMessage;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _isObscuredPassword;

  bool get isPassword => widget.type.isPassword;

  @override
  void initState() {
    _isObscuredPassword = isPassword;
    super.initState();
  }

  void _changeIsObscuredPassword() =>
      setState(() => _isObscuredPassword = !_isObscuredPassword);

  Widget? get suffixPasswordIcon {
    if (!isPassword) return null;
    final icon = _isObscuredPassword
        ? Icons.visibility_off_outlined
        : Icons.visibility_outlined;
    return IconButton(
      icon: Icon(icon),
      onLongPress: _changeIsObscuredPassword,
      onPressed: _changeIsObscuredPassword,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textEditingController,
      validator: widget.validator,
      obscureText: _isObscuredPassword,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      textAlignVertical: TextAlignVertical.center,
      autovalidateMode: AutovalidateMode.onUnfocus,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        // TODO(radov): to ThemeData
        contentPadding: const EdgeInsets.all(5),
        hintText: widget.hintMessage,
        prefixIcon: widget.prefixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        suffixIcon: suffixPasswordIcon,
      ),
    );
  }
}
