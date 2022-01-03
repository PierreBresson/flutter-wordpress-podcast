import 'package:flutter/foundation.dart';
import 'package:fwp/models/models.dart';
import 'package:test/test.dart';

void main() {
  test('tests the app Enum values', () {
    const thinkerview = APP.thinkerview;
    assert(describeEnum(thinkerview) == "thinkerview");

    const causeCommune = APP.causecommune;
    assert(describeEnum(causeCommune) == "causecommune");
  });
}
