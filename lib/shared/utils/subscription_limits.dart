import '../models/user_model.dart';
import '../../modules/auth/controllers/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubscriptionLimits {
  static const int freeNotes = 50;
  static const int freeTasks = 20;
  static const int freeTodos = 20;
  static const int freeReminders = 10;
  static const int freeSharedWorkspaces = 1;
  static const int freeTeamCapacity = 2;
  static const int freeStorage = 0; // MB

  static const int basicSharedWorkspaces = 1;
  static const int basicTeamCapacity = 3;
  static const int basicStorage = 100;

  static const int proSharedWorkspaces = 1;
  static const int proTeamCapacity = 10;
  static const int proStorage = 1024; // 1 GB

  static const int enterpriseSharedWorkspaces = 2;
  static const int enterpriseTeamCapacity = 50;
  static const int enterpriseStorage = 5120; // 5 GB

  static bool isUnlimited(String plan) => plan != 'free' && plan != 'trial';
  
  static int getMaxNotes(String plan) => isUnlimited(plan) ? -1 : freeNotes;
  static int getMaxTasks(String plan) => isUnlimited(plan) ? -1 : freeTasks;
  static int getMaxTodos(String plan) => isUnlimited(plan) ? -1 : freeTodos;
  static int getMaxReminders(String plan) => isUnlimited(plan) ? -1 : freeReminders;

  static int getMaxSharedWorkspaces(UserModel? user) {
    int max = freeSharedWorkspaces;
    final plan = user?.subscriptionType ?? 'free';
    switch (plan) {
      case 'enterprise': max = enterpriseSharedWorkspaces; break;
      case 'professional': max = proSharedWorkspaces; break;
      case 'basic': max = basicSharedWorkspaces; break;
    }
    if (user?.hasExtraWorkspace == true) {
      max += 1;
    }
    return max;
  }

  static int getMaxTeamCapacity(String plan) {
    switch (plan) {
      case 'enterprise': return enterpriseTeamCapacity;
      case 'professional': return proTeamCapacity;
      case 'basic': return basicTeamCapacity;
      default: return freeTeamCapacity;
    }
  }

  static int getMaxStorageMB(UserModel? user) {
    int max = freeStorage;
    final plan = user?.subscriptionType ?? 'free';
    switch (plan) {
      case 'enterprise': max = enterpriseStorage; break;
      case 'professional': max = proStorage; break;
      case 'basic': max = basicStorage; break;
      case 'trial': max = 0; break;
    }
    if (user?.hasExtraStorage == true) {
      max += 1024; // Extra 1 GB
    }
    return max;
  }

  static bool checkLimit(int current, int max) {
    if (max == -1) return true; // unlimited
    return current < max;
  }
}

// Global helper provider
final limitCheckProvider = Provider((ref) {
  final user = ref.watch(authControllerProvider).user;
  return LimitChecker(user);
});

class LimitChecker {
  final UserModel? user;
  LimitChecker(this.user);

  String get plan => user?.subscriptionType ?? 'free';

  bool canCreateNote(int currentCount) => SubscriptionLimits.checkLimit(currentCount, SubscriptionLimits.getMaxNotes(plan));
  bool canCreateTask(int currentCount) => SubscriptionLimits.checkLimit(currentCount, SubscriptionLimits.getMaxTasks(plan));
  bool canCreateTodo(int currentCount) => SubscriptionLimits.checkLimit(currentCount, SubscriptionLimits.getMaxTodos(plan));
  bool canCreateReminder(int currentCount) => SubscriptionLimits.checkLimit(currentCount, SubscriptionLimits.getMaxReminders(plan));
  
  bool canUploadFile(int currentUsedBytes, int fileSize) {
    int maxMB = SubscriptionLimits.getMaxStorageMB(user);
    if (maxMB == 0) return false;
    // maxStorage logic can be expanded with Add-ons (using workspace limits directly)
    return true; // Simplified for now
  }
}

class LimitExceededException implements Exception {
  final String message;
  LimitExceededException(this.message);
  @override
  String toString() => message;
}
