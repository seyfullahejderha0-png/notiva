import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Ana sekme (MainShell) indeksini global olarak tutan state provider.
/// 0: Dashboard, 1: Notes, 2: Tasks, 3: Contacts, 4: Settings
final mainTabProvider = StateProvider<int>((ref) => 0);
