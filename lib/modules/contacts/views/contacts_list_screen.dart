import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/notiva_card.dart';
import '../../../shared/widgets/notiva_empty_state.dart';
import '../models/contact_model.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/contacts_controller.dart';
import 'package:nexus_app/core/theme/theme_ext.dart';

/// Kişiler listesi ekranı.
class ContactsListScreen extends ConsumerStatefulWidget {
  const ContactsListScreen({super.key});

  @override
  ConsumerState<ContactsListScreen> createState() => _ContactsListScreenState();
}

class _ContactsListScreenState extends ConsumerState<ContactsListScreen> {
  final _searchController = TextEditingController();
  bool _showSearch = false;

  List<ContactModel> _getFilteredContacts(List<ContactModel> allContacts) {
    if (_searchController.text.isEmpty) return allContacts;
    return allContacts.where((c) =>
        c.name.toLowerCase().contains(_searchController.text.toLowerCase())).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contactsState = ref.watch(contactsControllerProvider);
    final contacts = _getFilteredContacts(contactsState.contacts);

    return Scaffold(
      backgroundColor: context.bgBackground,
      appBar: AppBar(
        title: _showSearch
            ? TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Kişi ara...',
                  border: InputBorder.none,
                  hintStyle: AppTypography.bodyMedium.copyWith(color: context.textTertiary),
                ),
              )
            : const Text('Kişiler'),
        actions: [
          IconButton(
            icon: Icon(_showSearch ? Icons.close_rounded : Icons.search_rounded),
            onPressed: () {
              setState(() {
                _showSearch = !_showSearch;
                if (!_showSearch) _searchController.clear();
              });
            },
          ),
        ],
      ),
      body: contacts.isEmpty
          ? const NotivaEmptyState(
              icon: Icons.people_outline,
              title: 'Henüz kişi yok',
              subtitle: 'İlk kişinizi ekleyin',
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: contacts.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return Dismissible(
                  key: Key(contact.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                    ),
                    child: const Icon(Icons.delete_outline, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    ref.read(contactsControllerProvider.notifier).deleteContact(contact.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${contact.name} silindi')),
                    );
                  },
                  child: NotivaCard(
                    onTap: () => Navigator.pushNamed(context, '/contact-detail'),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: AppColors.secondary,
                          child: Text(
                            contact.initials,
                            style: AppTypography.titleSmall.copyWith(color: AppColors.primary),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(contact.name, style: AppTypography.titleSmall),
                              if (contact.company != null || contact.role != null)
                                Text(
                                  [contact.role, contact.company].whereType<String>().join(' · '),
                                  style: AppTypography.bodySmall.copyWith(color: context.textTertiary),
                                ),
                            ],
                          ),
                        ),
                        if (contact.phone != null)
                          IconButton(
                            icon: const Icon(Icons.phone_outlined, size: 20, color: AppColors.success),
                            onPressed: () {},
                          ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                          onPressed: () {
                            ref.read(contactsControllerProvider.notifier).deleteContact(contact.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/contact-detail'),
        child: const Icon(Icons.person_add_rounded),
      ),
    );
  }
}
