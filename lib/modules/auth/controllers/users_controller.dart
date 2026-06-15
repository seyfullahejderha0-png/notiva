import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/user_model.dart';

class UsersState {
  final List<UserModel> users;
  final bool isLoading;

  const UsersState({
    this.users = const [],
    this.isLoading = false,
  });

  UsersState copyWith({
    List<UserModel>? users,
    bool? isLoading,
  }) {
    return UsersState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class UsersController extends StateNotifier<UsersState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UsersController() : super(const UsersState()) {
    _loadUsers();
  }

  void _loadUsers() {
    state = state.copyWith(isLoading: true);
    _firestore.collection('users').snapshots().listen((snapshot) {
      final users = snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
      state = state.copyWith(users: users, isLoading: false);
    });
  }

  Future<void> saveUser(UserModel user) async {
    await _firestore.collection('users').doc(user.id).set(user.toJson(), SetOptions(merge: true));
  }
}

final usersControllerProvider = StateNotifierProvider<UsersController, UsersState>((ref) {
  return UsersController();
});
