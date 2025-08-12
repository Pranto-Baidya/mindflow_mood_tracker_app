import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en')
  ];

  /// No description provided for @welcome_back.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcome_back;

  /// No description provided for @create_account.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get create_account;

  /// No description provided for @sign_in_description.
  ///
  /// In en, this message translates to:
  /// **'Fill up the credentials below and get started'**
  String get sign_in_description;

  /// No description provided for @sign_up_description.
  ///
  /// In en, this message translates to:
  /// **'Fill up the credentials below and be a member today!'**
  String get sign_up_description;

  /// No description provided for @sign_in.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get sign_in;

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get sign_up;

  /// No description provided for @name_hint.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name_hint;

  /// No description provided for @email_hint.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email_hint;

  /// No description provided for @password_hint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password_hint;

  /// No description provided for @confirm_password_hint.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirm_password_hint;

  /// No description provided for @name_empty_error.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get name_empty_error;

  /// No description provided for @email_empty_error.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get email_empty_error;

  /// No description provided for @email_invalid_error.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get email_invalid_error;

  /// No description provided for @password_empty_error.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get password_empty_error;

  /// No description provided for @password_short_error.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get password_short_error;

  /// No description provided for @confirm_password_empty_error.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get confirm_password_empty_error;

  /// No description provided for @passwords_not_match_error.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwords_not_match_error;

  /// No description provided for @remember_me.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get remember_me;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgot_password;

  /// No description provided for @login_button.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login_button;

  /// No description provided for @register_button.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register_button;

  /// No description provided for @or_sign_in_with.
  ///
  /// In en, this message translates to:
  /// **'Or, Sign in with'**
  String get or_sign_in_with;

  /// No description provided for @continue_with_google.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continue_with_google;

  /// No description provided for @no_account_prompt.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get no_account_prompt;

  /// No description provided for @have_account_prompt.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get have_account_prompt;

  /// No description provided for @login_success_toast.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get login_success_toast;

  /// No description provided for @login_failed_toast.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get login_failed_toast;

  /// No description provided for @registration_success_toast.
  ///
  /// In en, this message translates to:
  /// **'Registration successful'**
  String get registration_success_toast;

  /// No description provided for @signup_failed_toast.
  ///
  /// In en, this message translates to:
  /// **'Signup failed'**
  String get signup_failed_toast;

  /// No description provided for @google_sign_in_success_toast.
  ///
  /// In en, this message translates to:
  /// **'Signed in with Google'**
  String get google_sign_in_success_toast;

  /// No description provided for @google_sign_in_failed_toast.
  ///
  /// In en, this message translates to:
  /// **'Sign in aborted by user'**
  String get google_sign_in_failed_toast;

  /// No description provided for @forgot_password_title.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgot_password_title;

  /// No description provided for @reset_password_description.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we will send you a link to reset your password'**
  String get reset_password_description;

  /// No description provided for @send_link_button.
  ///
  /// In en, this message translates to:
  /// **'Send link'**
  String get send_link_button;

  /// No description provided for @password_reset_success_toast.
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent successfully, check your email'**
  String get password_reset_success_toast;

  /// No description provided for @remember_password_prompt.
  ///
  /// In en, this message translates to:
  /// **'Remember password?'**
  String get remember_password_prompt;

  /// No description provided for @sign_in_button.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get sign_in_button;

  /// No description provided for @change_theme_title.
  ///
  /// In en, this message translates to:
  /// **'Change theme'**
  String get change_theme_title;

  /// No description provided for @light_mode.
  ///
  /// In en, this message translates to:
  /// **'Light mode'**
  String get light_mode;

  /// No description provided for @dark_mode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get dark_mode;

  /// No description provided for @system_default.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get system_default;

  /// No description provided for @cancel_button.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel_button;

  /// No description provided for @set_pin_title.
  ///
  /// In en, this message translates to:
  /// **'Set a new 4 digit pin'**
  String get set_pin_title;

  /// No description provided for @pin_empty_error.
  ///
  /// In en, this message translates to:
  /// **'Please enter a 4-digit pin code'**
  String get pin_empty_error;

  /// No description provided for @pin_length_error.
  ///
  /// In en, this message translates to:
  /// **'Pin code must be exactly 4 digits'**
  String get pin_length_error;

  /// No description provided for @pin_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your 4 digit pin code'**
  String get pin_hint;

  /// No description provided for @set_pin_button.
  ///
  /// In en, this message translates to:
  /// **'Set pin lock'**
  String get set_pin_button;

  /// No description provided for @pin_lock_enabled_toast.
  ///
  /// In en, this message translates to:
  /// **'Pin lock enabled successfully'**
  String get pin_lock_enabled_toast;

  /// No description provided for @update_password_title.
  ///
  /// In en, this message translates to:
  /// **'Update password'**
  String get update_password_title;

  /// No description provided for @update_password_description.
  ///
  /// In en, this message translates to:
  /// **'Fill up the credentials below & update your password'**
  String get update_password_description;

  /// No description provided for @current_password_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password'**
  String get current_password_hint;

  /// No description provided for @current_password_empty_error.
  ///
  /// In en, this message translates to:
  /// **'Please enter your current password'**
  String get current_password_empty_error;

  /// No description provided for @new_password_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get new_password_hint;

  /// No description provided for @new_password_empty_error.
  ///
  /// In en, this message translates to:
  /// **'Please enter your new password'**
  String get new_password_empty_error;

  /// No description provided for @password_updated_toast.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully, Please re login with new password'**
  String get password_updated_toast;

  /// No description provided for @delete_account_description.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this account?\nThis can not be undone'**
  String get delete_account_description;

  /// No description provided for @account_deletion_toast.
  ///
  /// In en, this message translates to:
  /// **'Account deletion successful'**
  String get account_deletion_toast;

  /// No description provided for @user_profile_title.
  ///
  /// In en, this message translates to:
  /// **'User profile'**
  String get user_profile_title;

  /// No description provided for @add_bio_hint.
  ///
  /// In en, this message translates to:
  /// **'Add a bio'**
  String get add_bio_hint;

  /// No description provided for @write_bio_prompt.
  ///
  /// In en, this message translates to:
  /// **'Write something about yourself'**
  String get write_bio_prompt;

  /// No description provided for @personalisation_section.
  ///
  /// In en, this message translates to:
  /// **'Personalisation'**
  String get personalisation_section;

  /// No description provided for @change_language_title.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get change_language_title;

  /// No description provided for @notifications_title.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications_title;

  /// No description provided for @security_section.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security_section;

  /// No description provided for @enable_biometric_pin_lock.
  ///
  /// In en, this message translates to:
  /// **'Enable Biometric / Pin lock'**
  String get enable_biometric_pin_lock;

  /// No description provided for @account_section.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account_section;

  /// No description provided for @sign_out_title.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get sign_out_title;

  /// No description provided for @change_password_title.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get change_password_title;

  /// No description provided for @delete_account_title.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get delete_account_title;

  /// No description provided for @add_tag_title.
  ///
  /// In en, this message translates to:
  /// **'Add a new tag'**
  String get add_tag_title;

  /// No description provided for @tag_empty_error.
  ///
  /// In en, this message translates to:
  /// **'Please add a tag'**
  String get tag_empty_error;

  /// No description provided for @tag_hint.
  ///
  /// In en, this message translates to:
  /// **'Write the tag name you want to add'**
  String get tag_hint;

  /// No description provided for @add_tag_button.
  ///
  /// In en, this message translates to:
  /// **'Add tag'**
  String get add_tag_button;

  /// No description provided for @add_mood_journal_title.
  ///
  /// In en, this message translates to:
  /// **'Add a mood journal'**
  String get add_mood_journal_title;

  /// No description provided for @date_label.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date_label;

  /// No description provided for @change_date_button.
  ///
  /// In en, this message translates to:
  /// **'Change date'**
  String get change_date_button;

  /// No description provided for @select_mood_label.
  ///
  /// In en, this message translates to:
  /// **'Select your mood'**
  String get select_mood_label;

  /// No description provided for @mood_very_happy.
  ///
  /// In en, this message translates to:
  /// **'Very happy'**
  String get mood_very_happy;

  /// No description provided for @mood_happy.
  ///
  /// In en, this message translates to:
  /// **'Happy'**
  String get mood_happy;

  /// No description provided for @mood_neutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get mood_neutral;

  /// No description provided for @mood_sad.
  ///
  /// In en, this message translates to:
  /// **'Sad'**
  String get mood_sad;

  /// No description provided for @mood_depressed.
  ///
  /// In en, this message translates to:
  /// **'Depressed'**
  String get mood_depressed;

  /// No description provided for @content_hint.
  ///
  /// In en, this message translates to:
  /// **'Write about your mood'**
  String get content_hint;

  /// No description provided for @content_empty_error.
  ///
  /// In en, this message translates to:
  /// **'Please write how you\'re feeling now'**
  String get content_empty_error;

  /// No description provided for @select_tags_label.
  ///
  /// In en, this message translates to:
  /// **'Select Tags'**
  String get select_tags_label;

  /// No description provided for @journal_added_toast.
  ///
  /// In en, this message translates to:
  /// **'Added a new mood journal'**
  String get journal_added_toast;

  /// No description provided for @save_button.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save_button;

  /// No description provided for @tag_work.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get tag_work;

  /// No description provided for @tag_family.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get tag_family;

  /// No description provided for @tag_health.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get tag_health;

  /// No description provided for @tag_sleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get tag_sleep;

  /// No description provided for @tag_friends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get tag_friends;

  /// No description provided for @tag_study.
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get tag_study;

  /// No description provided for @tag_exercise.
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get tag_exercise;

  /// No description provided for @tag_diet.
  ///
  /// In en, this message translates to:
  /// **'Diet'**
  String get tag_diet;

  /// No description provided for @edit_mood_journal_title.
  ///
  /// In en, this message translates to:
  /// **'Edit mood journal'**
  String get edit_mood_journal_title;

  /// No description provided for @edit_date_time_button.
  ///
  /// In en, this message translates to:
  /// **'Edit existing date and time'**
  String get edit_date_time_button;

  /// No description provided for @update_tags_label.
  ///
  /// In en, this message translates to:
  /// **'Update tags'**
  String get update_tags_label;

  /// No description provided for @journal_updated_toast.
  ///
  /// In en, this message translates to:
  /// **'Journal updated successfully'**
  String get journal_updated_toast;

  /// No description provided for @save_changes_button.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get save_changes_button;

  /// No description provided for @mood_stats_title.
  ///
  /// In en, this message translates to:
  /// **'Mood Stats'**
  String get mood_stats_title;

  /// No description provided for @weekly_mood_distribution.
  ///
  /// In en, this message translates to:
  /// **'Weekly mood distribution'**
  String get weekly_mood_distribution;

  /// No description provided for @overall_mood_breakdown.
  ///
  /// In en, this message translates to:
  /// **'Overall mood breakdown'**
  String get overall_mood_breakdown;

  /// No description provided for @no_data_pie_chart.
  ///
  /// In en, this message translates to:
  /// **'Not enough data to show in the pie chart'**
  String get no_data_pie_chart;

  /// No description provided for @day_mon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get day_mon;

  /// No description provided for @day_tue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get day_tue;

  /// No description provided for @day_wed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get day_wed;

  /// No description provided for @day_thu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get day_thu;

  /// No description provided for @day_fri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get day_fri;

  /// No description provided for @day_sat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get day_sat;

  /// No description provided for @day_sun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get day_sun;

  /// No description provided for @clear_history_title.
  ///
  /// In en, this message translates to:
  /// **'Wait!'**
  String get clear_history_title;

  /// No description provided for @clear_history_description.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear the entire history?'**
  String get clear_history_description;

  /// No description provided for @confirm_button.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get confirm_button;

  /// No description provided for @search_history_title.
  ///
  /// In en, this message translates to:
  /// **'Search history'**
  String get search_history_title;

  /// No description provided for @no_history_message.
  ///
  /// In en, this message translates to:
  /// **'No history to show'**
  String get no_history_message;

  /// No description provided for @youSearchedFor.
  ///
  /// In en, this message translates to:
  /// **'You searched for'**
  String get youSearchedFor;

  /// No description provided for @enter_pin_title.
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN'**
  String get enter_pin_title;

  /// No description provided for @unlock_button.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlock_button;

  /// No description provided for @invalid_pin_error.
  ///
  /// In en, this message translates to:
  /// **'Enter a 4-digit PIN'**
  String get invalid_pin_error;

  /// No description provided for @use_fingerprint_prompt.
  ///
  /// In en, this message translates to:
  /// **'Use fingerprint instead?'**
  String get use_fingerprint_prompt;

  /// No description provided for @app_title.
  ///
  /// In en, this message translates to:
  /// **'Mindflow'**
  String get app_title;

  /// No description provided for @search_hint.
  ///
  /// In en, this message translates to:
  /// **'Find a mood journal'**
  String get search_hint;

  /// No description provided for @internet_restored_toast.
  ///
  /// In en, this message translates to:
  /// **'Internet connection restored'**
  String get internet_restored_toast;

  /// No description provided for @no_internet_message.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get no_internet_message;

  /// No description provided for @daily_mood_records.
  ///
  /// In en, this message translates to:
  /// **'Your daily mood records'**
  String get daily_mood_records;

  /// No description provided for @filtered_results.
  ///
  /// In en, this message translates to:
  /// **'Showing filtered results'**
  String get filtered_results;

  /// No description provided for @no_mood_journals_found.
  ///
  /// In en, this message translates to:
  /// **'No mood journals found'**
  String get no_mood_journals_found;

  /// No description provided for @no_mood_journals_prompt.
  ///
  /// In en, this message translates to:
  /// **'No mood journals to show, add one to see'**
  String get no_mood_journals_prompt;

  /// No description provided for @filter_by_title.
  ///
  /// In en, this message translates to:
  /// **'Filter by'**
  String get filter_by_title;

  /// No description provided for @selecting_date.
  ///
  /// In en, this message translates to:
  /// **'Selecting date'**
  String get selecting_date;

  /// No description provided for @tap_to_select.
  ///
  /// In en, this message translates to:
  /// **'Tap to select'**
  String get tap_to_select;

  /// No description provided for @selecting_time.
  ///
  /// In en, this message translates to:
  /// **'Selecting time'**
  String get selecting_time;

  /// No description provided for @exit_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Wait!'**
  String get exit_dialog_title;

  /// No description provided for @exit_dialog_description.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit from the app?'**
  String get exit_dialog_description;

  /// No description provided for @delete_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get delete_dialog_title;

  /// No description provided for @delete_dialog_description.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this journal?'**
  String get delete_dialog_description;

  /// No description provided for @delete_button.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete_button;

  /// No description provided for @view_mood_stats.
  ///
  /// In en, this message translates to:
  /// **'View mood stats'**
  String get view_mood_stats;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @report_bug.
  ///
  /// In en, this message translates to:
  /// **'Report a bug'**
  String get report_bug;

  /// No description provided for @about_dev.
  ///
  /// In en, this message translates to:
  /// **'About dev'**
  String get about_dev;

  /// No description provided for @exit_app.
  ///
  /// In en, this message translates to:
  /// **'Exit app'**
  String get exit_app;

  /// No description provided for @tags_label.
  ///
  /// In en, this message translates to:
  /// **'Tags : '**
  String get tags_label;

  /// No description provided for @failed_launch_url_error.
  ///
  /// In en, this message translates to:
  /// **'Failed to launch url'**
  String get failed_launch_url_error;

  /// No description provided for @failed_launch_email_error.
  ///
  /// In en, this message translates to:
  /// **'Could not launch email uri'**
  String get failed_launch_email_error;

  /// No description provided for @allow_notifications.
  ///
  /// In en, this message translates to:
  /// **'Allow notifications'**
  String get allow_notifications;

  /// No description provided for @read_quotes_title.
  ///
  /// In en, this message translates to:
  /// **'Read quotes'**
  String get read_quotes_title;

  /// No description provided for @get_a_quote_tab.
  ///
  /// In en, this message translates to:
  /// **'Get a quote'**
  String get get_a_quote_tab;

  /// No description provided for @favorites_tab.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites_tab;

  /// No description provided for @generate_random_quote_button.
  ///
  /// In en, this message translates to:
  /// **'Generate a random quote'**
  String get generate_random_quote_button;

  /// No description provided for @view_saved_quotes_in_favorites.
  ///
  /// In en, this message translates to:
  /// **'View saved quotes in favorites'**
  String get view_saved_quotes_in_favorites;

  /// No description provided for @generated_random_quote_text.
  ///
  /// In en, this message translates to:
  /// **'Generated random quote'**
  String get generated_random_quote_text;

  /// No description provided for @author_label.
  ///
  /// In en, this message translates to:
  /// **'Author : '**
  String get author_label;

  /// No description provided for @length_label.
  ///
  /// In en, this message translates to:
  /// **'Length : '**
  String get length_label;

  /// No description provided for @characters_label.
  ///
  /// In en, this message translates to:
  /// **'characters'**
  String get characters_label;

  /// No description provided for @no_favorite_quotes_message.
  ///
  /// In en, this message translates to:
  /// **'No favorite quotes yet.'**
  String get no_favorite_quotes_message;

  /// No description provided for @favorite_quote_label.
  ///
  /// In en, this message translates to:
  /// **'Favorite quote'**
  String get favorite_quote_label;

  /// No description provided for @removed_from_favorites_toast.
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites'**
  String get removed_from_favorites_toast;

  /// No description provided for @added_to_favorites_toast.
  ///
  /// In en, this message translates to:
  /// **'Added to favorites, Ready to view offline'**
  String get added_to_favorites_toast;

  /// No description provided for @motivate_yourself.
  ///
  /// In en, this message translates to:
  /// **'Motivate yourself'**
  String get motivate_yourself;

  /// No description provided for @add_new_reminder_title.
  ///
  /// In en, this message translates to:
  /// **'Add new reminder'**
  String get add_new_reminder_title;

  /// No description provided for @set_up_reminder_label.
  ///
  /// In en, this message translates to:
  /// **'Set up reminder'**
  String get set_up_reminder_label;

  /// No description provided for @enter_reminder_id_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter an unique reminder id'**
  String get enter_reminder_id_hint;

  /// No description provided for @unique_id_warning.
  ///
  /// In en, this message translates to:
  /// **'Id must be unique for each reminder, otherwise existing reminder will be overridden'**
  String get unique_id_warning;

  /// No description provided for @write_title_hint.
  ///
  /// In en, this message translates to:
  /// **'Write a title'**
  String get write_title_hint;

  /// No description provided for @write_description_hint.
  ///
  /// In en, this message translates to:
  /// **'Write a description'**
  String get write_description_hint;

  /// No description provided for @select_date_time_label.
  ///
  /// In en, this message translates to:
  /// **'Select date and time: '**
  String get select_date_time_label;

  /// No description provided for @date_time_set_label.
  ///
  /// In en, this message translates to:
  /// **'Date and time is set to: '**
  String get date_time_set_label;

  /// No description provided for @change_date_time_button.
  ///
  /// In en, this message translates to:
  /// **'Change date and time'**
  String get change_date_time_button;

  /// No description provided for @set_reminder_button.
  ///
  /// In en, this message translates to:
  /// **'Set reminder'**
  String get set_reminder_button;

  /// No description provided for @schedule_reminder_button.
  ///
  /// In en, this message translates to:
  /// **'Schedule reminder'**
  String get schedule_reminder_button;

  /// No description provided for @reminder_scheduled_toast.
  ///
  /// In en, this message translates to:
  /// **'Reminder scheduled successfully'**
  String get reminder_scheduled_toast;

  /// No description provided for @schedule_reminder.
  ///
  /// In en, this message translates to:
  /// **'Schedule a reminder'**
  String get schedule_reminder;

  /// No description provided for @reminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get reminder;

  /// No description provided for @please_select_at_least_one_tag.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one tag'**
  String get please_select_at_least_one_tag;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn': return AppLocalizationsBn();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
