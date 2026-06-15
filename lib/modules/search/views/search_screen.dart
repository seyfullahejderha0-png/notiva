import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/notiva_card.dart';
import '../../../shared/widgets/notiva_text_field.dart';
import '../../../shared/widgets/notiva_empty_state.dart';
import '../../notes/controllers/notes_controller.dart';
import '../../tasks/controllers/tasks_controller.dart';
import '../../contacts/controllers/contacts_controller.dart';
import '../../todos/controllers/todos_controller.dart';
import 'package:nexus_app/core/theme/theme_ext.dart';
import 'package:nexus_app/l10n/app_localizations.dart';

/// Arama sonuç türleri.
enum SearchFilter { all, notes, tasks, contacts, todos }

/// Arama sonucu.
class SearchResult {
  final String id;
  final String title;
  final String subtitle;
  final SearchFilter type;
  final IconData icon;

  const SearchResult({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.icon,
  });
}

/// Genel arama ekranı.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  SearchFilter _filter = SearchFilter.all;
  List<SearchResult> _results = [];
  bool _isSearching = false;
  final Map<String, String> _userNamesCache = {};
  int _searchCounter = 0;  void _search(String query) {
    setState(() => _isSearching = true);
    final currentSearch = ++_searchCounter;
    
    Future.delayed(const Duration(milliseconds: 300), () async {
      if (!mounted || currentSearch != _searchCounter) return;
      
      final notes = ref.read(notesControllerProvider).state.notes;
      final tasks = ref.read(tasksControllerProvider).tasks;
      final contacts = ref.read(contactsControllerProvider).contacts;
      final todos = ref.read(todosControllerProvider).todos;
      
      // Fetch missing user names for tasks
      try {
        for (var t in tasks) {
          if (t.assignedTo != null && !_userNamesCache.containsKey(t.assignedTo)) {
             final doc = await FirebaseFirestore.instance.collection('users').doc(t.assignedTo).get();
             if (doc.exists) {
                final data = doc.data();
                _userNamesCache[t.assignedTo!] = '${data?['name'] ?? ''} ${data?['surname'] ?? ''}'.trim();
             } else {
                _userNamesCache[t.assignedTo!] = 'Bilinmeyen Kullanıcı';
             }
          }
        }
      } catch (_) {}
      
      if (!mounted || currentSearch != _searchCounter) return;
      
      final List<SearchResult> allData = [
        ...notes.map((n) => SearchResult(id: n.id, title: n.title, subtitle: 'Not · ${n.content.length > 20 ? n.content.substring(0, 20) : n.content}', type: SearchFilter.notes, icon: Icons.note_alt_outlined)),
        ...tasks.map((t) {
           final assigneeName = t.assignedTo != null ? _userNamesCache[t.assignedTo] : null;
           final subtitle = assigneeName != null 
                ? 'Görev · ${t.priority.displayLabel} · $assigneeName' 
                : 'Görev · ${t.priority.displayLabel}';
           return SearchResult(id: t.id, title: t.title, subtitle: subtitle, type: SearchFilter.tasks, icon: Icons.check_circle_outline);
        }),
        ...contacts.map((c) => SearchResult(id: c.id, title: c.name, subtitle: 'Kişi · ${(c.role != null && c.role!.isNotEmpty) ? c.role : 'Bilgi yok'}', type: SearchFilter.contacts, icon: Icons.person_outline)),
        ...todos.map((todoList) {
           final completed = todoList.items.where((i) => i.isCompleted).length;
           final total = todoList.items.length;
          return SearchResult(id: todoList.id, title: todoList.title, subtitle: '${AppLocalizations.of(context)!.todoSingle} · $completed/$total ${AppLocalizations.of(context)!.completedSingle}', type: SearchFilter.todos, icon: Icons.checklist_rtl_rounded);
        }),
      ];

      setState(() {
        _isSearching = false;
        if (query.isEmpty) {
          _results = [];
        } else {
          _results = allData.where((r) {
            final matchesQuery = r.title.toLowerCase().contains(query.toLowerCase()) || r.subtitle.toLowerCase().contains(query.toLowerCase());
            final matchesFilter = _filter == SearchFilter.all || r.type == _filter;
            return matchesQuery && matchesFilter;
          }).toList();
        }
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bgBackground,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.searchTitle),
        backgroundColor: context.bgSurface,
      ),
      body: Column(
        children: [
          // Arama çubuğu
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacing16),
            child: NotivaTextField(
              controller: _searchController,
              hint: AppLocalizations.of(context)!.searchHint,
              autofocus: true,
              prefixIcon: const Icon(Icons.search_rounded, size: 20),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () {
                        _searchController.clear();
                        _search('');
                      },
                    )
                  : null,
              onChanged: _search,
            ),
          ),

          // Filtre çipleri
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildFilterChip(AppLocalizations.of(context)!.all, SearchFilter.all),
                const SizedBox(width: 8),
                _buildFilterChip(AppLocalizations.of(context)!.notes, SearchFilter.notes),
                const SizedBox(width: 8),
                _buildFilterChip(AppLocalizations.of(context)!.tasksLabel, SearchFilter.tasks),
                const SizedBox(width: 8),
                _buildFilterChip(AppLocalizations.of(context)!.contactsLabel, SearchFilter.contacts),
                const SizedBox(width: 8),
                _buildFilterChip(AppLocalizations.of(context)!.todosLabel, SearchFilter.todos),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Sonuçlar
          Expanded(
            child: _searchController.text.isEmpty
                ? _buildRecentSearches()
                : _results.isEmpty
                    ? NotivaEmptyState(
                        icon: Icons.search_off_rounded,
                        title: AppLocalizations.of(context)!.noResultsFound,
                        subtitle: AppLocalizations.of(context)!.tryDifferentKeywords,
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _results.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final result = _results[index];
                          return NotivaCard(
                            onTap: () {},
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: _getTypeColor(result.type).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(result.icon, color: _getTypeColor(result.type), size: 20),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(result.title, style: AppTypography.titleSmall),
                                      Text(result.subtitle,
                                          style: AppTypography.bodySmall.copyWith(color: context.textTertiary)),
                                    ],
                                  ),
                                ),
                                Icon(Icons.chevron_right_rounded, color: context.textTertiary),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, SearchFilter filter) {
    final isSelected = _filter == filter;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        setState(() => _filter = filter);
        _search(_searchController.text);
      },
      selectedColor: AppColors.secondary,
      checkmarkColor: AppColors.primary,
      labelStyle: AppTypography.labelMedium.copyWith(
        color: isSelected ? AppColors.primary : context.textSecondary,
      ),
    );
  }

  Widget _buildRecentSearches() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Son Aramalar', style: AppTypography.titleSmall.copyWith(color: context.textTertiary)),
          const SizedBox(height: 12),
          _buildRecentItem('Proje planı'),
          _buildRecentItem('Toplantı notları'),
          _buildRecentItem('Ahmet'),
        ],
      ),
    );
  }

  Widget _buildRecentItem(String text) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.history_rounded, color: context.textTertiary, size: 20),
      title: Text(text, style: AppTypography.bodyMedium),
      onTap: () {
        _searchController.text = text;
        _search(text);
      },
      dense: true,
    );
  }

  Color _getTypeColor(SearchFilter type) {
    return switch (type) {
      SearchFilter.notes => AppColors.primary,
      SearchFilter.tasks => AppColors.success,
      SearchFilter.contacts => AppColors.warning,
      SearchFilter.todos => Color(0xFF14B8A6), // Teal color
      SearchFilter.all => context.textSecondary,
    };
  }
}
