import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../modules/dashboard/views/dashboard_screen.dart';
import 'package:nexus_app/l10n/app_localizations.dart';
import '../../modules/dashboard/views/modules_screen.dart';
import '../../modules/settings/views/profile_screen.dart';
import '../providers/navigation_provider.dart';

/// Ana uygulama kabuğu — alt gezinme çubuğu ile sayfa yönetimi.
class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(mainTabProvider);
    final pages = const [
      DashboardScreen(),
      ModulesScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => ref.read(mainTabProvider.notifier).state = index,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.dashboard_outlined),
              activeIcon: const Icon(Icons.dashboard_rounded),
              label: AppLocalizations.of(context)!.home,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.apps_outlined),
              activeIcon: const Icon(Icons.apps_rounded),
              label: AppLocalizations.of(context)!.modules,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline),
              activeIcon: const Icon(Icons.person_rounded),
              label: AppLocalizations.of(context)!.profile,
            ),
          ],
        ),
      ),
    );
  }
}
