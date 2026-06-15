import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_app/main.dart';

void main() {
  testWidgets('App başlatılıyor', (WidgetTester tester) async {
    await tester.pumpWidget(const NotivaApp());
    expect(find.text('Nexus'), findsOneWidget);
  });
}
