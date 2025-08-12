// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcome_back => 'Welcome back';

  @override
  String get create_account => 'Create an account';

  @override
  String get sign_in_description => 'Fill up the credentials below and get started';

  @override
  String get sign_up_description => 'Fill up the credentials below and be a member today!';

  @override
  String get sign_in => 'Sign In';

  @override
  String get sign_up => 'Sign Up';

  @override
  String get name_hint => 'Name';

  @override
  String get email_hint => 'Email';

  @override
  String get password_hint => 'Password';

  @override
  String get confirm_password_hint => 'Confirm password';

  @override
  String get name_empty_error => 'Please enter your name';

  @override
  String get email_empty_error => 'Please enter your email';

  @override
  String get email_invalid_error => 'Please enter a valid email address';

  @override
  String get password_empty_error => 'Please enter your password';

  @override
  String get password_short_error => 'Password must be at least 6 characters';

  @override
  String get confirm_password_empty_error => 'Please confirm your password';

  @override
  String get passwords_not_match_error => 'Passwords do not match';

  @override
  String get remember_me => 'Remember me';

  @override
  String get forgot_password => 'Forgot Password?';

  @override
  String get login_button => 'Login';

  @override
  String get register_button => 'Register';

  @override
  String get or_sign_in_with => 'Or, Sign in with';

  @override
  String get continue_with_google => 'Continue with Google';

  @override
  String get no_account_prompt => 'Don\'t have an account?';

  @override
  String get have_account_prompt => 'Already have an account?';

  @override
  String get login_success_toast => 'Login successful';

  @override
  String get login_failed_toast => 'Login failed';

  @override
  String get registration_success_toast => 'Registration successful';

  @override
  String get signup_failed_toast => 'Signup failed';

  @override
  String get google_sign_in_success_toast => 'Signed in with Google';

  @override
  String get google_sign_in_failed_toast => 'Sign in aborted by user';

  @override
  String get forgot_password_title => 'Forgot password?';

  @override
  String get reset_password_description => 'Enter your email address and we will send you a link to reset your password';

  @override
  String get send_link_button => 'Send link';

  @override
  String get password_reset_success_toast => 'Password reset link sent successfully, check your email';

  @override
  String get remember_password_prompt => 'Remember password?';

  @override
  String get sign_in_button => 'Sign In';

  @override
  String get change_theme_title => 'Change theme';

  @override
  String get light_mode => 'Light mode';

  @override
  String get dark_mode => 'Dark mode';

  @override
  String get system_default => 'System default';

  @override
  String get cancel_button => 'Cancel';

  @override
  String get set_pin_title => 'Set a new 4 digit pin';

  @override
  String get pin_empty_error => 'Please enter a 4-digit pin code';

  @override
  String get pin_length_error => 'Pin code must be exactly 4 digits';

  @override
  String get pin_hint => 'Enter your 4 digit pin code';

  @override
  String get set_pin_button => 'Set pin lock';

  @override
  String get pin_lock_enabled_toast => 'Pin lock enabled successfully';

  @override
  String get update_password_title => 'Update password';

  @override
  String get update_password_description => 'Fill up the credentials below & update your password';

  @override
  String get current_password_hint => 'Enter your current password';

  @override
  String get current_password_empty_error => 'Please enter your current password';

  @override
  String get new_password_hint => 'Enter your new password';

  @override
  String get new_password_empty_error => 'Please enter your new password';

  @override
  String get password_updated_toast => 'Password updated successfully, Please re login with new password';

  @override
  String get delete_account_description => 'Are you sure you want to delete this account?\nThis can not be undone';

  @override
  String get account_deletion_toast => 'Account deletion successful';

  @override
  String get user_profile_title => 'User profile';

  @override
  String get add_bio_hint => 'Add a bio';

  @override
  String get write_bio_prompt => 'Write something about yourself';

  @override
  String get personalisation_section => 'Personalisation';

  @override
  String get change_language_title => 'Change language';

  @override
  String get notifications_title => 'Notifications';

  @override
  String get security_section => 'Security';

  @override
  String get enable_biometric_pin_lock => 'Enable Biometric / Pin lock';

  @override
  String get account_section => 'Account';

  @override
  String get sign_out_title => 'Sign out';

  @override
  String get change_password_title => 'Change password';

  @override
  String get delete_account_title => 'Delete account';

  @override
  String get add_tag_title => 'Add a new tag';

  @override
  String get tag_empty_error => 'Please add a tag';

  @override
  String get tag_hint => 'Write the tag name you want to add';

  @override
  String get add_tag_button => 'Add tag';

  @override
  String get add_mood_journal_title => 'Add a mood journal';

  @override
  String get date_label => 'Date';

  @override
  String get change_date_button => 'Change date';

  @override
  String get select_mood_label => 'Select your mood';

  @override
  String get mood_very_happy => 'Very happy';

  @override
  String get mood_happy => 'Happy';

  @override
  String get mood_neutral => 'Neutral';

  @override
  String get mood_sad => 'Sad';

  @override
  String get mood_depressed => 'Depressed';

  @override
  String get content_hint => 'Write about your mood';

  @override
  String get content_empty_error => 'Please write how you\'re feeling now';

  @override
  String get select_tags_label => 'Select Tags';

  @override
  String get journal_added_toast => 'Added a new mood journal';

  @override
  String get save_button => 'Save';

  @override
  String get tag_work => 'Work';

  @override
  String get tag_family => 'Family';

  @override
  String get tag_health => 'Health';

  @override
  String get tag_sleep => 'Sleep';

  @override
  String get tag_friends => 'Friends';

  @override
  String get tag_study => 'Study';

  @override
  String get tag_exercise => 'Exercise';

  @override
  String get tag_diet => 'Diet';

  @override
  String get edit_mood_journal_title => 'Edit mood journal';

  @override
  String get edit_date_time_button => 'Edit existing date and time';

  @override
  String get update_tags_label => 'Update tags';

  @override
  String get journal_updated_toast => 'Journal updated successfully';

  @override
  String get save_changes_button => 'Save changes';

  @override
  String get mood_stats_title => 'Mood Stats';

  @override
  String get weekly_mood_distribution => 'Weekly mood distribution';

  @override
  String get overall_mood_breakdown => 'Overall mood breakdown';

  @override
  String get no_data_pie_chart => 'Not enough data to show in the pie chart';

  @override
  String get day_mon => 'Mon';

  @override
  String get day_tue => 'Tue';

  @override
  String get day_wed => 'Wed';

  @override
  String get day_thu => 'Thu';

  @override
  String get day_fri => 'Fri';

  @override
  String get day_sat => 'Sat';

  @override
  String get day_sun => 'Sun';

  @override
  String get clear_history_title => 'Wait!';

  @override
  String get clear_history_description => 'Are you sure you want to clear the entire history?';

  @override
  String get confirm_button => 'Yes';

  @override
  String get search_history_title => 'Search history';

  @override
  String get no_history_message => 'No history to show';

  @override
  String get youSearchedFor => 'You searched for';

  @override
  String get enter_pin_title => 'Enter your PIN';

  @override
  String get unlock_button => 'Unlock';

  @override
  String get invalid_pin_error => 'Enter a 4-digit PIN';

  @override
  String get use_fingerprint_prompt => 'Use fingerprint instead?';

  @override
  String get app_title => 'Mindflow';

  @override
  String get search_hint => 'Find a mood journal';

  @override
  String get internet_restored_toast => 'Internet connection restored';

  @override
  String get no_internet_message => 'No internet connection';

  @override
  String get daily_mood_records => 'Your daily mood records';

  @override
  String get filtered_results => 'Showing filtered results';

  @override
  String get no_mood_journals_found => 'No mood journals found';

  @override
  String get no_mood_journals_prompt => 'No mood journals to show, add one to see';

  @override
  String get filter_by_title => 'Filter by';

  @override
  String get selecting_date => 'Selecting date';

  @override
  String get tap_to_select => 'Tap to select';

  @override
  String get selecting_time => 'Selecting time';

  @override
  String get exit_dialog_title => 'Wait!';

  @override
  String get exit_dialog_description => 'Are you sure you want to exit from the app?';

  @override
  String get delete_dialog_title => 'Confirm Delete';

  @override
  String get delete_dialog_description => 'Are you sure you want to delete this journal?';

  @override
  String get delete_button => 'Delete';

  @override
  String get view_mood_stats => 'View mood stats';

  @override
  String get history => 'History';

  @override
  String get report_bug => 'Report a bug';

  @override
  String get about_dev => 'About dev';

  @override
  String get exit_app => 'Exit app';

  @override
  String get tags_label => 'Tags : ';

  @override
  String get failed_launch_url_error => 'Failed to launch url';

  @override
  String get failed_launch_email_error => 'Could not launch email uri';

  @override
  String get allow_notifications => 'Allow notifications';

  @override
  String get read_quotes_title => 'Read quotes';

  @override
  String get get_a_quote_tab => 'Get a quote';

  @override
  String get favorites_tab => 'Favorites';

  @override
  String get generate_random_quote_button => 'Generate a random quote';

  @override
  String get view_saved_quotes_in_favorites => 'View saved quotes in favorites';

  @override
  String get generated_random_quote_text => 'Generated random quote';

  @override
  String get author_label => 'Author : ';

  @override
  String get length_label => 'Length : ';

  @override
  String get characters_label => 'characters';

  @override
  String get no_favorite_quotes_message => 'No favorite quotes yet.';

  @override
  String get favorite_quote_label => 'Favorite quote';

  @override
  String get removed_from_favorites_toast => 'Removed from favorites';

  @override
  String get added_to_favorites_toast => 'Added to favorites, Ready to view offline';

  @override
  String get motivate_yourself => 'Motivate yourself';

  @override
  String get add_new_reminder_title => 'Add new reminder';

  @override
  String get set_up_reminder_label => 'Set up reminder';

  @override
  String get enter_reminder_id_hint => 'Enter an unique reminder id';

  @override
  String get unique_id_warning => 'Id must be unique for each reminder, otherwise existing reminder will be overridden';

  @override
  String get write_title_hint => 'Write a title';

  @override
  String get write_description_hint => 'Write a description';

  @override
  String get select_date_time_label => 'Select date and time: ';

  @override
  String get date_time_set_label => 'Date and time is set to: ';

  @override
  String get change_date_time_button => 'Change date and time';

  @override
  String get set_reminder_button => 'Set reminder';

  @override
  String get schedule_reminder_button => 'Schedule reminder';

  @override
  String get reminder_scheduled_toast => 'Reminder scheduled successfully';

  @override
  String get schedule_reminder => 'Schedule a reminder';

  @override
  String get reminder => 'Reminder';

  @override
  String get please_select_at_least_one_tag => 'Please select at least one tag';
}
