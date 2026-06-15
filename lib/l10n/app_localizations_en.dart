// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get home => 'Home';

  @override
  String get modules => 'Modules';

  @override
  String get profile => 'Profile';

  @override
  String get notes => 'Notes';

  @override
  String get tasks => 'My Tasks';

  @override
  String get reminders => 'Reminders';

  @override
  String get workspace => 'Shared Workspace (Teams)';

  @override
  String get todos => 'To-Do List';

  @override
  String get archive => 'Archive';

  @override
  String get appSettings => 'App Settings';

  @override
  String get subscription => 'Subscription & Plans';

  @override
  String get appearance => 'Appearance';

  @override
  String get font => 'Font';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get language => 'Language';

  @override
  String get supportAndLegal => 'Support & Legal';

  @override
  String get contactUs => 'Contact Us / Support';

  @override
  String get rateApp => 'Rate the App';

  @override
  String get privacyPolicy => 'Privacy Policy & Terms';

  @override
  String get accountManagement => 'Account Management';

  @override
  String get logout => 'Log Out';

  @override
  String get deleteAccount => 'Permanently Delete Account';

  @override
  String get greetingMorning => 'Good Morning';

  @override
  String get greetingAfternoon => 'Good Afternoon';

  @override
  String get greetingEvening => 'Good Evening';

  @override
  String get searchHint => 'What do you want to search?';

  @override
  String get overview => 'Overview';

  @override
  String get taskSingle => 'Task';

  @override
  String get tasksToCompleteToday => 'To be completed today';

  @override
  String get activeReminder => 'Active Reminder';

  @override
  String get todoList => 'To-Do List';

  @override
  String get recentNotes => 'Recent Notes';

  @override
  String get seeAll => 'See All';

  @override
  String get noNotesYet => 'No notes yet';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get noPendingTasks => 'No pending tasks 🎉';

  @override
  String get priorityLow => 'Low';

  @override
  String get priorityMedium => 'Medium';

  @override
  String get priorityHigh => 'High';

  @override
  String get priorityCritical => 'Critical';

  @override
  String get notSpecified => 'Not specified';

  @override
  String get assigned => 'Assigned';

  @override
  String get recentTodos => 'Recent To-Dos';

  @override
  String get noActiveTodos => 'No active to-do list';

  @override
  String stepsCompleted(int completed, int total) {
    return '$completed / $total steps completed';
  }

  @override
  String get noteSingle => 'Note';

  @override
  String get completedSingle => 'Completed';

  @override
  String get todoSingle => 'To-Do';

  @override
  String get reminderSingle => 'Reminder';

  @override
  String get totalNotes => 'Total Notes';

  @override
  String get totalTasks => 'Total Tasks';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get appearanceSelection => 'Appearance Selection';

  @override
  String get fontSelection => 'Font Selection';

  @override
  String get cancel => 'Cancel';

  @override
  String get deleteAccountTitle => 'Delete Account';

  @override
  String get deleteAccountDesc =>
      'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted.';

  @override
  String get yesDeleteAccount => 'Yes, Delete My Account';

  @override
  String get all => 'All';

  @override
  String get pinned => 'Pinned';

  @override
  String get favorites => 'Favorites';

  @override
  String get noPinnedNotes => 'No pinned notes';

  @override
  String get pinnedNotesDesc => 'Pin your important notes to see them here.';

  @override
  String get noFavoriteNotes => 'No favorite notes';

  @override
  String get favoriteNotesDesc =>
      'Add notes you like to favorites to see them here.';

  @override
  String get noArchivedNotes => 'No archived notes';

  @override
  String get archivedNotesDesc => 'There are no archived notes yet.';

  @override
  String get createFirstNote => 'Create your first note';

  @override
  String get createNote => 'Create Note';

  @override
  String get noteArchived => 'Note archived.';

  @override
  String get save => 'Save';

  @override
  String get titleHint => 'Title';

  @override
  String get startWritingNote => 'Start writing your note...';

  @override
  String get addTag => 'Add Tag';

  @override
  String get attachments => 'Attachments';

  @override
  String get addImage => 'Add Image';

  @override
  String get addFile => 'Add File';

  @override
  String get voiceInputComingSoon => 'Voice input coming soon';

  @override
  String get voiceRecord => 'Voice Record';

  @override
  String get templates => 'Templates';

  @override
  String get fileCannotOpen => 'File could not be opened';

  @override
  String get tagName => 'Tag name';

  @override
  String get add => 'Add';

  @override
  String get untitledNote => 'Untitled Note';

  @override
  String get imageSizeError => 'Image size must be less than 5 MB.';

  @override
  String get pdfSizeError => 'PDF size must be less than 5 MB.';

  @override
  String get fileUploadFailed => 'File upload failed';

  @override
  String get chooseTemplate => 'Choose Template';

  @override
  String get meetingNote => 'Meeting Note';

  @override
  String get shoppingList => 'Shopping List';

  @override
  String get projectPlan => 'Project Plan';

  @override
  String get tasksLabel => 'Tasks';

  @override
  String get taskDetail => 'Task Detail';

  @override
  String get taskTitle => 'Task Title';

  @override
  String get pleaseEnterTaskTitle => 'Please enter a task title.';

  @override
  String get subtasks => 'Subtasks';

  @override
  String get addNewSubtask => 'Add new subtask...';

  @override
  String get assignUser => 'Assign User';

  @override
  String get assignedTo => 'Assigned to';

  @override
  String get pending => 'Pending';

  @override
  String get inProgress => 'In Progress';

  @override
  String get taskArchived => 'Task archived.';

  @override
  String get taskNotFound => 'Task not found';

  @override
  String get assignToNobody => 'Assign to nobody';

  @override
  String get assignUserOptional => 'Assign User (Optional)';

  @override
  String get selectPerson => 'Select Person';

  @override
  String get priorityLabel => 'Priority';

  @override
  String get todosLabel => 'Todos';

  @override
  String get todosListEmpty => 'Your todo list is empty';

  @override
  String get clickPlusToAddList => 'Click the + button to add a new list.';

  @override
  String get newList => 'New List';

  @override
  String get listNameExample => 'List Name (e.g. Shopping)';

  @override
  String get pleaseEnterTitle => 'Please enter a title.';

  @override
  String get itemsEmpty => 'Items are empty...';

  @override
  String get addNewItem => 'Add new item...';

  @override
  String get completedItemsTab => 'Completed';

  @override
  String get deleteListConfirm =>
      'Are you sure you want to permanently delete this list?';

  @override
  String get deleteList => 'Delete List';

  @override
  String get listArchived => 'List archived.';

  @override
  String get listNotFound => 'List not found';

  @override
  String get shopping => 'Shopping';

  @override
  String get details => 'Details';

  @override
  String get checklist => 'Checklist';

  @override
  String get boardView => 'Board View';

  @override
  String get listView => 'List View';

  @override
  String get reminder => 'Reminder';

  @override
  String get createReminder => 'Create Reminder';

  @override
  String get reminderName => 'Reminder name';

  @override
  String get reminderArchived => 'Reminder archived.';

  @override
  String get reminderSavedNotify =>
      'Reminder saved. Notification is being sent to the relevant person...';

  @override
  String get noRemindersYet => 'You don\'t have any reminders yet';

  @override
  String get createFirstReminder => 'Create your first reminder';

  @override
  String get selectEndDate => 'Select End Date';

  @override
  String get dateLabel => 'Date:';

  @override
  String get timeLabel => 'Time:';

  @override
  String get repeat => 'Repeat';

  @override
  String get noRepeat => 'No Repeat';

  @override
  String get daily => 'Daily';

  @override
  String get weekly => 'Weekly';

  @override
  String get colorSelection => 'Color Selection:';

  @override
  String get notification => 'Notification';

  @override
  String get filesAndImages => 'Files and Images';

  @override
  String get noAttachmentsYet => 'No attachments yet';

  @override
  String get addDetailedDescription => 'Add detailed description...';

  @override
  String get delete => 'Delete';

  @override
  String get clearSelection => 'Clear Selection';

  @override
  String get create => 'Create';

  @override
  String get me => 'Me';

  @override
  String get legalDocuments => 'Legal Documents';

  @override
  String get termsOfUse => 'Terms of Use';

  @override
  String get accountDeletionPolicy => 'Account Deletion Policy';

  @override
  String get kvkkText => 'KVKK Clarification Text';

  @override
  String get appStorePrivacy => 'App Store Privacy Compliance';

  @override
  String get googlePlayData => 'Google Play Data Safety Compliance';

  @override
  String get personalWorkspace => 'Personal';

  @override
  String get sharedWorkspace => 'Shared Workspace';

  @override
  String get statusLabel => 'Status';

  @override
  String get priorityLevel => 'Priority Level';

  @override
  String get repeatNone => 'No Repeat';

  @override
  String get repeatDaily => 'Daily';

  @override
  String get repeatWeekly => 'Weekly';

  @override
  String get repeatMonthly => 'Monthly';

  @override
  String get dateAndTime => 'Date and Time';

  @override
  String get calendarAndPlanning => 'Calendar & Planning';

  @override
  String get noPlansOnDate => 'No plans on this date';

  @override
  String get noArchiveWarning => 'No archive';

  @override
  String get archiveEmptyWarning => 'Archive is empty';

  @override
  String get searchAll => 'All';

  @override
  String get searchNotes => 'Notes';

  @override
  String get searchTasks => 'Tasks';

  @override
  String get searchTodos => 'To-Dos';

  @override
  String get workspaceEmpty => 'No workspaces found';

  @override
  String get subscriptionTitle => 'Subscription';

  @override
  String get documentNotFound => 'Document not found.';

  @override
  String get today => 'Today';

  @override
  String get basicPlan => 'Basic Plan';

  @override
  String get proPlan => 'Professional';

  @override
  String get enterprisePlan => 'Enterprise';

  @override
  String get unlimitedNotes => 'Unlimited Notes and Tasks';

  @override
  String get storage100mb => '100 MB Storage';

  @override
  String get storage1gb => '1 GB Storage';

  @override
  String get storage5gb => '5 GB Storage';

  @override
  String get teamCapacity3 => '3 Member Team Capacity';

  @override
  String get teamCapacity10 => '10 Member Team Capacity';

  @override
  String get teamCapacity50 => '50 Member Team Capacity';

  @override
  String get workspace1 => '1 Shared Workspace';

  @override
  String get workspace2 => '2 Shared Workspaces';

  @override
  String get advancedReminders => 'Advanced Reminders';

  @override
  String get prioritySupport => 'Priority Support';

  @override
  String get selectPlan => 'Select';

  @override
  String get subscriptionActivated => 'Subscription successfully activated! 🥳';

  @override
  String get subscriptionCancelled =>
      'Purchase was cancelled or could not be completed.';

  @override
  String get subscriptionSubtitle => 'Remove Limits 🚀';

  @override
  String get subscriptionDesc =>
      'Take your Notiva experience to the peak by choosing the best plan for you and your team.';

  @override
  String get teamWork => 'Team Work';

  @override
  String get teamWorkDesc =>
      'Build a team or join an existing team with an invite code to manage your projects together.';

  @override
  String get createNewTeam => 'Create New Team';

  @override
  String get joinWithInviteCode => 'Join with Invite Code';

  @override
  String get myTeams => 'My Teams';

  @override
  String membersCount(int count) {
    return '$count members';
  }

  @override
  String get contactsLabel => 'Contacts';

  @override
  String get noResultsFound => 'No results found';

  @override
  String get tryDifferentKeywords => 'Try different keywords';

  @override
  String get searchTitle => 'Search';

  @override
  String get createReminderTitle => 'Create Reminder';

  @override
  String get titleLabel => 'Title';

  @override
  String get repeatLabel => 'Repeat';

  @override
  String get notificationLabel => 'Notification';

  @override
  String get activityStreamTitle => 'Activity Stream';

  @override
  String get taskUpdatedActivity => 'updated task';

  @override
  String get taskAddedActivity => 'added task';

  @override
  String get reminderAddedActivity => 'added reminder';

  @override
  String get noteAddedActivity => 'added note';

  @override
  String get noteUpdatedActivity => 'updated note';

  @override
  String get notInAnyTeam => 'You are not a member of any team yet.';

  @override
  String get joinTeam => 'Join Team';

  @override
  String get joinTeamDesc =>
      'Enter the 6-digit invite code you received from the team admin.';

  @override
  String get inviteCode => 'Invite Code';

  @override
  String get join => 'Join';

  @override
  String get teamJoinedSuccess => 'You have successfully joined the team! 🎉';

  @override
  String get alreadyTeamMember => 'You are already a member of this team.';

  @override
  String get invalidInviteCode => 'Invalid invite code. Please check again.';

  @override
  String get noPlansForDate => 'No plans for this date.';

  @override
  String get task => 'Task';

  @override
  String get error => 'Error';

  @override
  String get reminderLabel => 'Reminder';

  @override
  String get unarchiveTooltip => 'Unarchive';

  @override
  String get itemUnarchived => 'Item unarchived.';

  @override
  String get manageProductivity => 'Manage your productivity';

  @override
  String get loginTitle => 'Login';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'example@email.com';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get forgotPassword => 'Forgot Password';

  @override
  String get orLabel => 'OR';

  @override
  String get loginWithGoogle => 'Login with Google';

  @override
  String get noAccount => 'Don\'t have an account? ';

  @override
  String get createAccount => 'Create Account';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get welcomeToNotiva => 'Welcome to Notiva';

  @override
  String get fullNameLabel => 'Full Name';

  @override
  String get fullNameHint => 'Enter your name';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get passwordLengthHint => 'At least 6 characters';

  @override
  String get passwordLength => 'Must be at least 6 characters';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get confirmPasswordHint => 'Re-enter your password';

  @override
  String get confirmPasswordRequired => 'Confirm password is required';

  @override
  String get registerLabel => 'Register';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get completeProfile => 'Complete Your Profile';

  @override
  String get welcomeHeadline => 'Welcome!';

  @override
  String get completeProfileDesc =>
      'Please complete your details before proceeding.';

  @override
  String get photoSizeLimit => 'Profile photo must be smaller than 5 MB.';

  @override
  String get saveAndStart => 'Save and Start';

  @override
  String get phoneLabel => 'Phone Number';

  @override
  String get phoneRequired => 'Phone number is required';

  @override
  String get resetPasswordTitle => 'Password Reset';

  @override
  String get resetPasswordDesc =>
      'Enter your email address, and we\'ll send you a password reset link.';

  @override
  String get sendLink => 'Send Link';

  @override
  String get linkSent => 'Link Sent!';

  @override
  String get linkSentDesc =>
      'A password reset link has been sent to your email address.';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get workspacesTitle => 'Workspaces';

  @override
  String get personalWorkspaceCannotBeManaged =>
      'Personal workspace cannot be managed';

  @override
  String get teamManagement => 'Team Management';

  @override
  String get inviteCodeLabel => 'Invite Code';

  @override
  String teamMembersCount(int count) {
    return 'Team Members ($count)';
  }

  @override
  String get nameLabel => 'Name';

  @override
  String get nonePermission => 'None';

  @override
  String get readPermission => 'Read';

  @override
  String get writePermission => 'Write';

  @override
  String get leaveTeam => 'Leave Team';

  @override
  String get deleteAndDisbandTeam => 'Delete and Disband Team';

  @override
  String get managePermissions => 'Manage Permissions';

  @override
  String get savePermissions => 'Save Permissions';

  @override
  String get permissions => 'Permissions';

  @override
  String get adminRole => 'Admin';

  @override
  String get unknownUser => 'Unknown User';

  @override
  String get removeMemberTitle => 'Remove Member';

  @override
  String get removeMemberDesc =>
      'Are you sure you want to remove this member from the team?';

  @override
  String get remove => 'Remove';

  @override
  String get leaveTeamTitle => 'Leave Team';

  @override
  String get leaveTeamDesc =>
      'Are you sure you want to leave this team? You cannot return unless the team admin invites you again.';

  @override
  String get deleteTeamTitle => 'Delete Team';

  @override
  String get deleteTeamDesc =>
      'If you delete this team, all data inside it (notes, tasks) will be deleted. Are you sure?';

  @override
  String get deleteAction => 'Delete';

  @override
  String get inviteCodeCopied => 'Invite code copied!';

  @override
  String get loading => 'Loading...';

  @override
  String get errorMsg => 'Error';
}
