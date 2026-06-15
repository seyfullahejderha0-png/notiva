import 'package:flutter/material.dart';
import 'package:nexus_app/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../controllers/todos_controller.dart';
import '../models/todo_list_model.dart';
import 'package:nexus_app/core/theme/theme_ext.dart';

class TodoDetailScreen extends ConsumerStatefulWidget {
  final String listId;

  const TodoDetailScreen({super.key, required this.listId});

  @override
  ConsumerState<TodoDetailScreen> createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends ConsumerState<TodoDetailScreen> {
  final TextEditingController _addItemController = TextEditingController();
  final FocusNode _addItemFocus = FocusNode();

  @override
  void dispose() {
    _addItemController.dispose();
    _addItemFocus.dispose();
    super.dispose();
  }

  void _submitNewItem() {
    final text = _addItemController.text.trim();
    if (text.isNotEmpty) {
      ref.read(todosControllerProvider.notifier).addTodoItem(widget.listId, text);
      _addItemController.clear();
      _addItemFocus.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(todosControllerProvider);
    final todoListIndex = state.todos.indexWhere((l) => l.id == widget.listId);
    
    if (todoListIndex == -1) {
      return Scaffold(body: Center(child: Text(AppLocalizations.of(context)!.listNotFound)));
    }

    final todoList = state.todos[todoListIndex];
    final activeItems = todoList.items.where((i) => !i.isCompleted).toList();
    final completedItems = todoList.items.where((i) => i.isCompleted).toList();

    return Scaffold(
      backgroundColor: Color(todoList.color),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: context.textPrimary),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(AppLocalizations.of(context)!.deleteList),
                  content: Text(AppLocalizations.of(context)!.deleteListConfirm),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: Text(AppLocalizations.of(context)!.cancel)),
                    FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: AppColors.error),
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(AppLocalizations.of(context)!.delete),
                    ),
                  ],
                ),
              );

              if (confirm == true && mounted) {
                ref.read(todosControllerProvider.notifier).deleteTodoList(widget.listId);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              todoList.title,
              style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                color: context.bgSurface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    // Aktif Maddeler
                    ...activeItems.map((item) => _buildTodoItem(item, todoList)),
                    
                    // Yeni Madde Ekleme Alanı
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Icon(Icons.add_rounded, color: context.textTertiary),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: _addItemController,
                              focusNode: _addItemFocus,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!.addNewItem,
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              onSubmitted: (_) => _submitNewItem(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (completedItems.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.only(top: 24, bottom: 8),
                        child: Divider(),
                      ),
                      Text(
                        'Tamamlananlar (${completedItems.length})',
                        style: AppTypography.titleSmall.copyWith(color: context.textTertiary),
                      ),
                      const SizedBox(height: 8),
                      ...completedItems.map((item) => _buildTodoItem(item, todoList)),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodoItem(ToDoItem item, ToDoListModel todoList) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: GestureDetector(
        onTap: () {
          ref.read(todosControllerProvider.notifier).toggleTodoItem(todoList.id, item.id);
        },
        child: Container(
          width: 24,
          height: 24,
          margin: const EdgeInsets.only(top: 2), // Hizalama
          decoration: BoxDecoration(
            color: item.isCompleted ? AppColors.success : Colors.transparent,
            border: Border.all(
              color: item.isCompleted ? AppColors.success : context.textTertiary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: item.isCompleted 
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : null,
        ),
      ),
      title: Text(
        item.text,
        style: AppTypography.bodyMedium.copyWith(
          color: item.isCompleted ? context.textTertiary : context.textPrimary,
          decoration: item.isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.close_rounded, size: 20, color: context.textTertiary),
        onPressed: () {
          ref.read(todosControllerProvider.notifier).deleteTodoItem(todoList.id, item.id);
        },
      ),
    );
  }
}
