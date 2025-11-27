class TextFieldValidator {
  const TextFieldValidator._();

  static String? required(
    String? value, {
    String message = 'Please enter some text',
  }) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  static String? email(String? value, {String message = 'Not valid email'}) {
    if (value == null || value.trim().isEmpty) return null;

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value)) {
      return message;
    }
    return null;
  }

  static String? minLength(String? value, int length, {String? message}) {
    if (value == null) return null;

    if (value.trim().length < length) {
      return message ?? 'Min length — $length';
    }
    return null;
  }

  static String? maxLength(String? value, int length, {String? message}) {
    if (value == null) return null;

    if (value.trim().length > length) {
      return message ?? 'Max length — $length';
    }
    return null;
  }
}
