// The package import carries the generated project name, which can sort
// differently from here.
// ignore_for_file: directives_ordering

import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}/src/modules/auth/domain/validators/validators.dart';

void main() {
  group('EmailValidator', () {
    final validate = EmailValidator().call;

    test('accepts plus tags, dashes and subdomains', () {
      expect(validate('jane+work@mail.example.co.uk'), isNull);
      expect(validate('first_last-name@example.com'), isNull);
    });

    test('rejects missing or malformed addresses', () {
      expect(validate(null), isNotNull);
      expect(validate(''), isNotNull);
      expect(validate('no-at-sign.example.com'), isNotNull);
      expect(validate('user@nodot'), isNotNull);
    });
  });

  group('PasswordValidator', () {
    final validator = PasswordValidator();

    test('requires length, case, a digit and a symbol', () {
      expect(validator('Sh0rt!'), isNotNull);
      expect(validator('alllowercase1!'), isNotNull);
      expect(validator('ALLUPPERCASE1!'), isNotNull);
      expect(validator('NoDigitsHere!'), isNotNull);
      expect(validator('NoSymbol123'), isNotNull);
      expect(validator('Valid#Pass1'), isNull);
    });

    test('presence only skips the strength rules', () {
      expect(validator.presence('weak'), isNull);
      expect(validator.presence(''), isNotNull);
      expect(validator.presence(null), isNotNull);
    });
  });

  group('ConfirmPasswordValidator', () {
    final validate = ConfirmPasswordValidator().call;

    test('matches only identical passwords', () {
      expect(validate('Valid#Pass1', 'Valid#Pass1'), isNull);
      expect(validate('Valid#Pass1', 'Other#Pass1'), isNotNull);
      expect(validate('', 'Valid#Pass1'), isNotNull);
    });
  });
}
