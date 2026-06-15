import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── Search Filter ───────────────────────────────────────────────

enum SearchFilter { all, notes, tasks, contacts }

// ─── Search Result Type ──────────────────────────────────────────

enum SearchResultType { note, task, contact }

// ─── Search Result ───────────────────────────────────────────────

@immutable
class SearchResult {
  const SearchResult({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
  });

  final String id;
  final String title;
  final String subtitle;
  final SearchResultType type;
}

// ─── Search State ────────────────────────────────────────────────

@immutable
class SearchState {
  const SearchState({
    this.query = '',
    this.results = const [],
    this.isSearching = false,
    this.selectedFilter = SearchFilter.all,
    this.recentSearches = const [],
  });

  final String query;
  final List<SearchResult> results;
  final bool isSearching;
  final SearchFilter selectedFilter;
  final List<String> recentSearches;

  bool get hasQuery => query.trim().isNotEmpty;

  SearchState copyWith({
    String? query,
    List<SearchResult>? results,
    bool? isSearching,
    SearchFilter? selectedFilter,
    List<String>? recentSearches,
  }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      isSearching: isSearching ?? this.isSearching,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      recentSearches: recentSearches ?? this.recentSearches,
    );
  }
}

// ─── Mock Data Source ────────────────────────────────────────────

const _allMockResults = <SearchResult>[
  // Notes
  SearchResult(
    id: 'n1',
    title: 'Flutter Proje Notları',
    subtitle: 'Riverpod ile state management yapısı',
    type: SearchResultType.note,
  ),
  SearchResult(
    id: 'n2',
    title: 'Toplantı Notları',
    subtitle: 'Sprint planlama ve görev dağılımı',
    type: SearchResultType.note,
  ),
  SearchResult(
    id: 'n3',
    title: 'API Dökümantasyonu',
    subtitle: 'REST endpoint tanımları',
    type: SearchResultType.note,
  ),
  SearchResult(
    id: 'n4',
    title: 'Kitap Özetleri',
    subtitle: 'Atomic Habits - alışkanlık notları',
    type: SearchResultType.note,
  ),
  // Tasks
  SearchResult(
    id: 't1',
    title: 'Dashboard tasarımını tamamla',
    subtitle: 'Yüksek öncelik • Bugün',
    type: SearchResultType.task,
  ),
  SearchResult(
    id: 't2',
    title: 'Veritabanı migration yaz',
    subtitle: 'Yüksek öncelik • Yarın',
    type: SearchResultType.task,
  ),
  SearchResult(
    id: 't3',
    title: 'Haftalık raporu hazırla',
    subtitle: 'Orta öncelik • 2 gün sonra',
    type: SearchResultType.task,
  ),
  SearchResult(
    id: 't4',
    title: 'Test senaryolarını güncelle',
    subtitle: 'Düşük öncelik • 3 gün sonra',
    type: SearchResultType.task,
  ),
  // Contacts
  SearchResult(
    id: 'c1',
    title: 'Mehmet Yılmaz',
    subtitle: 'mehmet@example.com • İş',
    type: SearchResultType.contact,
  ),
  SearchResult(
    id: 'c2',
    title: 'Ayşe Demir',
    subtitle: 'ayse@example.com • Kişisel',
    type: SearchResultType.contact,
  ),
  SearchResult(
    id: 'c3',
    title: 'Fatma Kaya',
    subtitle: 'fatma@example.com • İş',
    type: SearchResultType.contact,
  ),
];

// ─── Search Controller ──────────────────────────────────────────

class NotivaSearchController extends StateNotifier<SearchState> {
  NotivaSearchController()
      : super(const SearchState(
          recentSearches: [
            'Flutter notları',
            'Toplantı',
            'Mehmet',
            'Haftalık rapor',
          ],
        ));

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = state.copyWith(
        query: '',
        results: [],
        isSearching: false,
      );
      return;
    }

    state = state.copyWith(query: query, isSearching: true);

    // Simulate search latency
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final lowerQuery = query.toLowerCase();

    var filtered = _allMockResults.where((result) {
      final matchesQuery =
          result.title.toLowerCase().contains(lowerQuery) ||
              result.subtitle.toLowerCase().contains(lowerQuery);

      final matchesFilter = switch (state.selectedFilter) {
        SearchFilter.all => true,
        SearchFilter.notes => result.type == SearchResultType.note,
        SearchFilter.tasks => result.type == SearchResultType.task,
        SearchFilter.contacts => result.type == SearchResultType.contact,
      };

      return matchesQuery && matchesFilter;
    }).toList();

    state = state.copyWith(results: filtered, isSearching: false);
  }

  void setFilter(SearchFilter filter) {
    state = state.copyWith(selectedFilter: filter);
    if (state.hasQuery) {
      search(state.query);
    }
  }

  void clearSearch() {
    state = state.copyWith(
      query: '',
      results: [],
      isSearching: false,
    );
  }

  void addToRecentSearches(String query) {
    if (query.trim().isEmpty) return;

    final updated = [
      query,
      ...state.recentSearches.where((s) => s != query),
    ].take(8).toList();

    state = state.copyWith(recentSearches: updated);
  }

  void removeRecentSearch(String query) {
    state = state.copyWith(
      recentSearches: state.recentSearches.where((s) => s != query).toList(),
    );
  }

  void clearRecentSearches() {
    state = state.copyWith(recentSearches: []);
  }
}

// ─── Provider ────────────────────────────────────────────────────

final searchControllerProvider =
    StateNotifierProvider<NotivaSearchController, SearchState>(
  (ref) => NotivaSearchController(),
);
