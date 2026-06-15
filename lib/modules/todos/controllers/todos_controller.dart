import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/todo_list_model.dart';
import '../../workspaces/controllers/workspace_controller.dart';

class TodosState {
  final List<ToDoListModel> todos;
  final bool isLoading;

  const TodosState({
    this.todos = const [],
    this.isLoading = false,
  });

  TodosState copyWith({
    List<ToDoListModel>? todos,
    bool? isLoading,
  }) {
    return TodosState(
      todos: todos ?? this.todos,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class TodosController extends StateNotifier<TodosState> {
  TodosController(this._ref) : super(const TodosState()) {
    _init();
  }

  final Ref _ref;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription? _sub;
  String? _workspaceId;

  void _init() {
    _ref.listen(activeWorkspaceProvider, (prev, next) {
      if (next?.id != _workspaceId) {
        if (next != null) {
          loadTodos(next.id);
        } else {
          state = const TodosState();
          _sub?.cancel();
        }
      }
    });

    final activeWs = _ref.read(activeWorkspaceProvider);
    if (activeWs != null) {
      loadTodos(activeWs.id);
    }
  }

  Future<void> loadTodos(String workspaceId) async {
    _workspaceId = workspaceId;
    state = state.copyWith(isLoading: true);
    await _sub?.cancel();

    _sub = _firestore
        .collection('workspaces')
        .doc(workspaceId)
        .collection('todos')
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      final todos = snapshot.docs
          .map((doc) => ToDoListModel.fromMap(doc.data(), doc.id))
          .toList();
      state = state.copyWith(todos: todos, isLoading: false);
    });
  }

  Future<void> addTodoList(String title, int color) async {
    if (_workspaceId == null || title.trim().isEmpty) return;

    final docRef = _firestore
        .collection('workspaces')
        .doc(_workspaceId)
        .collection('todos')
        .doc();

    final newList = ToDoListModel(
      id: docRef.id,
      workspaceId: _workspaceId!,
      title: title.trim(),
      color: color,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      items: [],
    );

    await docRef.set(newList.toMap());
  }

  Future<void> deleteTodoList(String id) async {
    if (_workspaceId == null) return;
    await _firestore
        .collection('workspaces')
        .doc(_workspaceId)
        .collection('todos')
        .doc(id)
        .delete();
  }

  Future<void> updateTodoList(ToDoListModel todoList) async {
    if (_workspaceId == null) return;
    final updatedList = todoList.copyWith(updatedAt: DateTime.now());
    await _firestore
        .collection('workspaces')
        .doc(_workspaceId)
        .collection('todos')
        .doc(todoList.id)
        .update(updatedList.toMap());
  }

  Future<void> addTodoItem(String listId, String text) async {
    if (_workspaceId == null || text.trim().isEmpty) return;

    final listIndex = state.todos.indexWhere((l) => l.id == listId);
    if (listIndex == -1) return;

    final list = state.todos[listIndex];
    final newItem = ToDoItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text.trim(),
    );

    final updatedItems = List<ToDoItem>.from(list.items)..add(newItem);
    await updateTodoList(list.copyWith(items: updatedItems));
  }

  Future<void> toggleTodoItem(String listId, String itemId) async {
    if (_workspaceId == null) return;

    final listIndex = state.todos.indexWhere((l) => l.id == listId);
    if (listIndex == -1) return;

    final list = state.todos[listIndex];
    final updatedItems = list.items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(isCompleted: !item.isCompleted);
      }
      return item;
    }).toList();

    await updateTodoList(list.copyWith(items: updatedItems));
  }

  Future<void> deleteTodoItem(String listId, String itemId) async {
    if (_workspaceId == null) return;

    final listIndex = state.todos.indexWhere((l) => l.id == listId);
    if (listIndex == -1) return;

    final list = state.todos[listIndex];
    final updatedItems = list.items.where((item) => item.id != itemId).toList();

    await updateTodoList(list.copyWith(items: updatedItems));
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

final todosControllerProvider =
    StateNotifierProvider<TodosController, TodosState>((ref) {
  return TodosController(ref);
});
