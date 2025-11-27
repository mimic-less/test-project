class ValidatorBuilder {
  final List<String? Function(String?)> _validators = [];

  ValidatorBuilder add(String? Function(String?) validator) {
    _validators.add(validator);
    return this;
  }

  String? build(String? value) {
    for (final validator in _validators) {
      final result = validator(value);
      if (result != null) return result;
    }
    return null;
  }
}
