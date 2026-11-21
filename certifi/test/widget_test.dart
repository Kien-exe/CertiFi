import 'package:certifi/core/constants/app_durations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AppDurations tuân thủ luật animation 150ms-250ms', () {
    expect(AppDurations.fast, const Duration(milliseconds: 150));
    expect(AppDurations.medium, const Duration(milliseconds: 200));
    expect(AppDurations.slow, const Duration(milliseconds: 250));
    expect(AppDurations.toastVisible, const Duration(seconds: 3));
  });
}
