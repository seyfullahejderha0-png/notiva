import 'package:flutter/material.dart';
import 'package:nexus_app/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/notiva_card.dart';
import '../../../shared/widgets/notiva_empty_state.dart';
import '../controllers/todos_controller.dart';
import '../models/todo_list_model.dart';
import 'todo_detail_screen.dart';
import 'package:nexus_app/core/theme/theme_ext.dart';
import '../../workspaces/controllers/workspace_controller.dart';
import '../../auth/controllers/auth_controller.dart';

class TodosScreen extends ConsumerStatefulWidget {
  const TodosScreen({super.key});

  @override
  ConsumerState<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends ConsumerState<TodosScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(todosControllerProvider);
    final todos = state.todos.where((t) => !t.isArchived).toList();
    
    final workspaceState = ref.watch(workspaceControllerProvider);
    final activeWs = workspaceState.activeWorkspace;
    final user = ref.watch(authControllerProvider).user;
    
    bool hasWritePerm = true;
    if (activeWs != null && user != null && activeWs.ownerId != user.id) {
      final perms = activeWs.memberPermissions[user.id] ?? {};
      if (perms['todos'] == 'read') {
        hasWritePerm = false;
      }
    }

    return Scaffold(
      backgroundColor: context.bgBackground,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.todosLabel),
      ),
      body: state.isLoading && todos.isEmpty
          ? Center(child: CircularProgressIndicator())
          : todos.isEmpty
              ? NotivaEmptyState(
                  icon: Icons.checklist_rounded,
                  title: AppLocalizations.of(context)!.todosListEmpty,
                  subtitle: hasWritePerm ? AppLocalizations.of(context)!.clickPlusToAddList : null,
                )
              : MasonryGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  padding: const EdgeInsets.all(16),
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return Dismissible(
                      key: ValueKey(todo.id),
                      direction: DismissDirection.horizontal,
                      onDismissed: (_) {
                        final updated = todo.copyWith(isArchived: true);
                        ref.read(todosControllerProvider.notifier).updateTodoList(updated);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.listArchived)));
                      },
                      child: _ToDoCard(todo: todo),
                    );
                  },
                ),
      floatingActionButton: hasWritePerm ? FloatingActionButton(
        onPressed: _showCreateDialog,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ) : null,
    );
  }

  Future<void> _showCreateDialog() async {
    final titleController = TextEditingController();
    int selectedColor = 0xFFE0E0E0;
    
    final colors = [
      0xFFE0E0E0, 0xFFFEE2E2, 0xFFFEF3C7, 0xFFD1FAE5, 
      0xFFDBEAFE, 0xFFE0E7FF, 0xFFF3E8FF, 0xFFFCE7F3
    ];

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.newList),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: 'Liste Adı (örn: Alışveriş)',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Text(AppLocalizations.of(context)!.colorSelection),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: colors.map((c) => GestureDetector(
                    onTap: () => setState(() => selectedColor = c),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Color(c),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selectedColor == c ? AppColors.primary : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                  )).toList(),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
              FilledButton(
                onPressed: () {
                  if (titleController.text.trim().isNotEmpty) {
                    ref.read(todosControllerProvider.notifier).addTodoList(
                          titleController.text,
                          selectedColor,
                        );
                    Navigator.pop(context);
                  }
                },
                child: Text(AppLocalizations.of(context)!.create),
              ),
            ],
          );
        }
      ),
    );
  }
}

class _ToDoCard extends ConsumerWidget {
  final ToDoListModel todo;

  const _ToDoCard({required this.todo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeItems = todo.items.where((i) => !i.isCompleted).toList();
    final completedItems = todo.items.where((i) => i.isCompleted).toList();

    return NotivaCard(
      color: Color(todo.color),
      padding: const EdgeInsets.all(12),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TodoDetailScreen(listId: todo.id),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            todo.title,
            style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          if (todo.items.isEmpty)
            Text(
              AppLocalizations.of(context)!.itemsEmpty,
              style: AppTypography.bodySmall.copyWith(color: context.textTertiary),
            )
          else ...[
            ...activeItems.take(4).map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_box_outline_blank, size: 14, color: context.textSecondary),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      item.text,
                      style: AppTypography.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            )),
            if (activeItems.length > 4)
              Text(
                '+ ${activeItems.length - 4} madde daha',
                style: AppTypography.bodySmall.copyWith(color: context.textTertiary),
              ),
            if (completedItems.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    const Icon(Icons.check_box, size: 14, color: AppColors.success),
                    const SizedBox(width: 4),
                    Text(
                      '${completedItems.length} tamamlandı',
                      style: AppTypography.labelSmall.copyWith(color: context.textTertiary),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}
