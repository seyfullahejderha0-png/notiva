import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/contact_model.dart';
import '../../workspaces/controllers/workspace_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactsState {
  final List<ContactModel> contacts;
  final bool isLoading;
  final String? error;

  const ContactsState({
    this.contacts = const [],
    this.isLoading = false,
    this.error,
  });

  ContactsState copyWith({
    List<ContactModel>? contacts,
    bool? isLoading,
    String? error,
  }) {
    return ContactsState(
      contacts: contacts ?? this.contacts,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ContactsController extends StateNotifier<ContactsState> {
  final Ref ref;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _workspaceId;

  ContactsController(this.ref) : super(const ContactsState());

  void loadContacts(String workspaceId) {
    _workspaceId = workspaceId;
    state = state.copyWith(isLoading: true);

    _firestore
        .collection('workspaces')
        .doc(workspaceId)
        .collection('contacts')
        .snapshots()
        .listen((snapshot) {
      final contacts = snapshot.docs.map((doc) => ContactModel.fromJson(doc.data())).toList();
      state = state.copyWith(
        contacts: contacts,
        isLoading: false,
      );
    }, onError: (error) {
      state = state.copyWith(isLoading: false, error: error.toString());
    });
  }

  Future<void> addContact(ContactModel contact) async {
    if (_workspaceId == null) return;
    
    final id = contact.id.isEmpty || contact.id.startsWith('mock_') 
        ? 'contact_${DateTime.now().millisecondsSinceEpoch}' 
        : contact.id;
        
    final newContact = contact.copyWith(id: id);
    await _firestore
        .collection('workspaces')
        .doc(_workspaceId)
        .collection('contacts')
        .doc(id)
        .set(newContact.toJson());
  }

  Future<void> deleteContact(String id) async {
    if (_workspaceId == null) return;
    await _firestore
        .collection('workspaces')
        .doc(_workspaceId)
        .collection('contacts')
        .doc(id)
        .delete();
  }
}

final contactsControllerProvider = StateNotifierProvider<ContactsController, ContactsState>((ref) {
  final controller = ContactsController(ref);
  final activeWorkspace = ref.watch(activeWorkspaceProvider);
  if (activeWorkspace != null) {
    controller.loadContacts(activeWorkspace.id);
  }
  return controller;
});
