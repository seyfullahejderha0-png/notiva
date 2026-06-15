import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'firebase_options.dart';
import 'shared/services/subscription_service.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'core/theme/locale_controller.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nexus_app/l10n/app_localizations.dart';
import 'shared/widgets/main_shell.dart';
import 'modules/auth/views/login_screen.dart';
import 'modules/auth/views/register_screen.dart';
import 'modules/auth/views/forgot_password_screen.dart';
import 'modules/settings/views/profile_screen.dart';
import 'modules/workspaces/views/create_workspace_screen.dart';
import 'modules/notes/views/notes_list_screen.dart';
import 'modules/notes/views/note_editor_screen.dart';
import 'modules/tasks/views/tasks_list_screen.dart';
import 'modules/tasks/views/task_detail_screen.dart';
import 'modules/contacts/views/contacts_list_screen.dart';
import 'modules/contacts/views/contact_detail_screen.dart';
import 'modules/reminders/views/reminders_list_screen.dart';
import 'modules/reminders/views/create_reminder_screen.dart';
import 'modules/search/views/search_screen.dart';
import 'modules/auth/views/profile_setup_screen.dart';
import 'modules/settings/views/edit_profile_screen.dart';
import 'modules/auth/controllers/auth_controller.dart';
import 'modules/workspaces/views/team_manage_screen.dart';
import 'modules/workspaces/views/shared_workspace_screen.dart';
import 'modules/workspaces/views/activities_screen.dart';
import 'modules/todos/views/todos_screen.dart';
import 'modules/todos/views/todo_detail_screen.dart';
import 'modules/calendar/views/calendar_screen.dart';
import 'modules/settings/views/archive_screen.dart';
import 'modules/subscription/views/subscription_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase başlat
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase init error: $e');
  }

  // Hive başlat
  await Hive.initFlutter();
  await Hive.openBox('settings_box');

  // OneSignal başlat
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("93870b6a-a5fe-494c-bf53-f6925f0acd54");
  OneSignal.Notifications.requestPermission(true);

  runApp(
    const ProviderScope(
      child: NotivaApp(),
    ),
  );
}

class NotivaApp extends ConsumerStatefulWidget {
  const NotivaApp({super.key});

  @override
  ConsumerState<NotivaApp> createState() => _NotivaAppState();
}

class _NotivaAppState extends ConsumerState<NotivaApp> {
  @override
  void initState() {
    super.initState();
    // Initialize In-App Purchases
    Future.microtask(() {
      ref.read(subscriptionServiceProvider).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeControllerProvider);
    final locale = ref.watch(localeControllerProvider);

    return MaterialApp(
      title: 'Notiva',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(themeState.fontFamily),
      darkTheme: AppTheme.darkTheme(themeState.fontFamily),
      themeMode: themeState.mode,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: supportedLocales,
      home: Consumer(
        builder: (context, ref, child) {
          final authState = ref.watch(authControllerProvider);
          
          if (authState.isInitializing) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          if (authState.isAuthenticated && authState.user != null) {
            return const MainShell();
          }

          return const LoginScreen();
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/home': (context) => const MainShell(),
        '/profile': (context) => const ProfileScreen(),
        '/workspace-create': (context) => const CreateWorkspaceScreen(),
        '/notes': (context) => const NotesListScreen(),
        '/note-editor': (context) => const NoteEditorScreen(),
        '/tasks': (context) => const TasksListScreen(),
        '/task-detail': (context) => const TaskDetailScreen(),
        '/contacts': (context) => const ContactsListScreen(),
        '/contact-detail': (context) => const ContactDetailScreen(),
        '/reminders': (context) => const RemindersListScreen(),
        '/reminder-create': (context) => const CreateReminderScreen(),
        '/search': (context) => const SearchScreen(),
        '/profile-setup': (context) => const ProfileSetupScreen(),
        '/edit-profile': (context) => const EditProfileScreen(),
        '/team-manage': (context) => const TeamManageScreen(),
        '/shared-workspace': (context) => const SharedWorkspaceScreen(),
        '/activities': (context) => const ActivitiesScreen(),
        '/todos': (context) => const TodosScreen(),
        '/calendar': (context) => const CalendarScreen(),
        '/archive': (context) => const ArchiveScreen(),
        '/subscription': (context) => const SubscriptionScreen(),
        '/todo-detail': (context) {
          final listId = ModalRoute.of(context)!.settings.arguments as String;
          return TodoDetailScreen(listId: listId);
        },
      },
    );
  }
}
