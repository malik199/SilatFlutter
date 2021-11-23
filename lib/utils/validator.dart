class Validator {
  static String? validateFirstname({required String? firstname}) {
    if (firstname == null) {
      return null;
    }

    if (firstname.isEmpty) {
      return 'First name can\'t be empty';
    }

    return null;
  }

  static String? validateLastname({required String? lastname}) {
    if (lastname == null) {
      return null;
    }

    if (lastname.isEmpty) {
      return 'Last name can\'t be empty';
    }

    return null;
  }

  static String? validateEmail({required String? email}) {
    if (email == null) {
      return null;
    }

    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    if (email.isEmpty) {
      return 'Email can\'t be empty';
    } else if (!emailRegExp.hasMatch(email)) {
      return 'Enter a correct email';
    }

    return null;
  }

  static String? validatePassword({required String? password}) {
    if (password == null) {
      return null;
    }

    if (password.isEmpty) {
      return 'Password can\'t be empty';
    } else if (password.length < 6) {
      return 'Enter a password with length at least 6';
    }

    return null;
  }

  static String? validateConfirmPassword({required String? firstPassword, required String? secondPassword}) {
    if (secondPassword == null) {
      return null;
    }

    if (firstPassword != secondPassword) {
      return 'Passwords must match';
    }

    return null;
  }
}
