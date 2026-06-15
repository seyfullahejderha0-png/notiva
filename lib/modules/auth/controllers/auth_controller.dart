import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthState;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../shared/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

/// Kimlik doğrulama durumu.
class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? errorMessage;
  final bool isAuthenticated;
  final bool isInitializing;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
    this.isAuthenticated = false,
    this.isInitializing = true,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? errorMessage,
    bool? isAuthenticated,
    bool? isInitializing,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isInitializing: isInitializing ?? this.isInitializing,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthController() : super(const AuthState()) {
    _init();
  }

  void _init() {
    _auth.authStateChanges().listen((User? user) async {
      if (user != null) {
        UserModel? userModel;
        try {
          // Firestore'dan ek bilgileri (telefon vs) getir
          final doc = await _firestore.collection('users').doc(user.uid).get();
          final data = doc.data();
          
          userModel = UserModel(
            id: user.uid,
            name: data?['name'] as String? ?? user.displayName ?? 'Kullanıcı',
            email: data?['email'] as String? ?? user.email ?? '',
            phone: data?['phone'] as String?,
            avatar: data?['avatar'] as String? ?? user.photoURL,
            createdAt: data?['createdAt'] != null 
                ? DateTime.parse(data!['createdAt'] as String) 
                : DateTime.now(),
          );
          
          // Firestore'a kaydet (varsa günceller, yoksa oluşturur)
          await _firestore.collection('users').doc(user.uid).set(userModel.toJson(), SetOptions(merge: true));
        } catch (e) {
          debugPrint('Firestore init error: $e');
          // Firestore hatası olsa bile uygulamaya girmesine izin ver (fallback)
          userModel = UserModel(
            id: user.uid,
            name: user.displayName ?? 'Kullanıcı',
            email: user.email ?? '',
            avatar: user.photoURL,
            createdAt: DateTime.now(),
          );
        }

        state = state.copyWith(
          user: userModel,
          isAuthenticated: true,
          isLoading: false,
          isInitializing: false,
        );
        OneSignal.login(user.uid);
      } else {
        OneSignal.logout();
        state = const AuthState(isInitializing: false);
      }
    });
  }

  /// E-posta ile giriş.
  Future<bool> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      if (email.isEmpty || password.isEmpty) {
        state = state.copyWith(isLoading: false, errorMessage: 'E-posta ve şifre boş olamaz.');
        return false;
      }
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Giriş başarısız: ${e.message}');
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Bir hata oluştu: $e');
      return false;
    }
  }

  /// Yeni hesap oluşturma.
  Future<bool> register(String name, String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        state = state.copyWith(isLoading: false, errorMessage: 'Tüm alanlar doldurulmalıdır.');
        return false;
      }
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user?.updateDisplayName(name);
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Kayıt başarısız: ${e.message}');
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Bir hata oluştu: $e');
      return false;
    }
  }

  /// Google ile giriş
  Future<bool> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        state = state.copyWith(isLoading: false, errorMessage: 'Giriş iptal edildi');
        return false;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      await _auth.signInWithCredential(credential);
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Google giriş hatası: ${e.message}');
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Google giriş hatası: $e');
      return false;
    }
  }

  /// Apple ile giriş
  Future<bool> signInWithApple() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final AuthorizationCredentialAppleID appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
      );
      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      await _auth.signInWithCredential(oauthCredential);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Apple ile giriş başarısız: $e');
      return false;
    }
  }

  /// Oturumu kapat.
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
    OneSignal.logout();
    state = const AuthState(isInitializing: false);
  }

  /// Hesabı kalıcı olarak sil.
  Future<bool> deleteAccount() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // 1. Delete user document from Firestore (Optional: cascade delete data)
        await _firestore.collection('users').doc(user.uid).delete();
        
        // 2. Delete auth record
        await user.delete();
        
        // 3. Clear local state
        await GoogleSignIn().signOut();
        OneSignal.logout();
        state = const AuthState(isInitializing: false);
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        state = state.copyWith(isLoading: false, errorMessage: 'Güvenlik nedeniyle tekrar giriş yapmanız gerekmektedir.');
      } else {
        state = state.copyWith(isLoading: false, errorMessage: 'Hesap silinirken hata oluştu: ${e.message}');
      }
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Bir hata oluştu: $e');
      return false;
    }
  }

  /// Şifre sıfırlama.
  Future<bool> resetPassword(String email) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      if (email.isEmpty) {
        state = state.copyWith(isLoading: false, errorMessage: 'Lütfen bir e-posta adresi girin');
        return false;
      }
      await _auth.sendPasswordResetEmail(email: email);
      state = state.copyWith(isLoading: false);
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Şifre sıfırlama başarısız: ${e.message}',
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Şifre sıfırlama başarısız: $e',
      );
      return false;
    }
  }

  /// Profil güncelle.
  Future<void> updateProfile({String? name, String? avatar, String? phone}) async {
    if (state.user == null) return;
    final updatedUser = state.user!.copyWith(name: name, avatar: avatar, phone: phone);
    
    // ÖNCE state'i güncelleyelim ki arayüz hemen tepki versin (Optimistic UI)
    // Böylece Firebase beklerken uygulama donmaz veya takılmaz.
    state = state.copyWith(user: updatedUser);
    
    // Firestore'da da arka planda güncelle (AWAIT OLMADAN, tam optimistic)
    _firestore.collection('users').doc(updatedUser.id).set({
      'name': ?name,
      'avatar': ?avatar,
      'phone': ?phone,
    }, SetOptions(merge: true)).catchError((e) {
      debugPrint('Firestore profil güncelleme hatası: $e');
    });
  }

  /// Hata mesajını temizle.
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

/// Auth provider.
final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController();
});
