import 'package:flutter_test/flutter_test.dart';
import 'package:gun_shop_wms/config/app_config.dart';

void main() {
  test('App config has correct name', () {
    expect(AppConfig.appName, 'Gun Shop WMS');
  });

  test('App config has correct version', () {
    expect(AppConfig.appVersion, '1.0.0');
  });
}
