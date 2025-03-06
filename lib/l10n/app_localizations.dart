import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_sq.dart';

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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('en'),
    Locale('sq')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Suzanne Podcast'**
  String get appTitle;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the podcast app!'**
  String get welcomeMessage;

  /// No description provided for @chooseInterests.
  ///
  /// In en, this message translates to:
  /// **'Choose your interests and get the best\npodcast recommendations.'**
  String get chooseInterests;

  /// No description provided for @dontWorryChangeLater.
  ///
  /// In en, this message translates to:
  /// **'Don’t worry, you can always change it later.'**
  String get dontWorryChangeLater;

  /// No description provided for @music.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get music;

  /// No description provided for @podcasts.
  ///
  /// In en, this message translates to:
  /// **'Podcasts'**
  String get podcasts;

  /// No description provided for @cinema.
  ///
  /// In en, this message translates to:
  /// **'Cinema'**
  String get cinema;

  /// No description provided for @books.
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get books;

  /// No description provided for @theatre.
  ///
  /// In en, this message translates to:
  /// **'Theatre'**
  String get theatre;

  /// No description provided for @clubbing.
  ///
  /// In en, this message translates to:
  /// **'Clubbing'**
  String get clubbing;

  /// No description provided for @literature.
  ///
  /// In en, this message translates to:
  /// **'Literature'**
  String get literature;

  /// No description provided for @visualArts.
  ///
  /// In en, this message translates to:
  /// **'Visual Arts'**
  String get visualArts;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @welcome_login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get welcome_login;

  /// No description provided for @welcome_signup.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get welcome_signup;

  /// No description provided for @welcome_continue_guest.
  ///
  /// In en, this message translates to:
  /// **'Continue as a guest'**
  String get welcome_continue_guest;

  /// No description provided for @welcome_no_account.
  ///
  /// In en, this message translates to:
  /// **'If you don’t have an account'**
  String get welcome_no_account;

  /// No description provided for @add_to_favorite.
  ///
  /// In en, this message translates to:
  /// **'Add to Favorite'**
  String get add_to_favorite;

  /// No description provided for @remove_from_favorite.
  ///
  /// In en, this message translates to:
  /// **'Remove from Favorite'**
  String get remove_from_favorite;

  /// No description provided for @add_to_playlist.
  ///
  /// In en, this message translates to:
  /// **'Add to Playlist'**
  String get add_to_playlist;

  /// No description provided for @select_playlist.
  ///
  /// In en, this message translates to:
  /// **'Select Playlist or Create New'**
  String get select_playlist;

  /// No description provided for @no_playlists.
  ///
  /// In en, this message translates to:
  /// **'No playlists found'**
  String get no_playlists;

  /// No description provided for @create_new_playlist.
  ///
  /// In en, this message translates to:
  /// **'Create New Playlist'**
  String get create_new_playlist;

  /// No description provided for @enter_playlist_name.
  ///
  /// In en, this message translates to:
  /// **'Enter playlist name'**
  String get enter_playlist_name;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @login_message.
  ///
  /// In en, this message translates to:
  /// **'Please log in to add to playlist or favorite podcasts.'**
  String get login_message;

  /// No description provided for @mondayMarks.
  ///
  /// In en, this message translates to:
  /// **'Monday Marks'**
  String get mondayMarks;

  /// No description provided for @seeMore.
  ///
  /// In en, this message translates to:
  /// **'See More'**
  String get seeMore;

  /// No description provided for @featuredPodcasts.
  ///
  /// In en, this message translates to:
  /// **'Featured Podcasts'**
  String get featuredPodcasts;

  /// No description provided for @infoTitle.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get infoTitle;

  /// No description provided for @infoContent.
  ///
  /// In en, this message translates to:
  /// **'This app is a product of Suzanne Media Platform. The application has been supported by LuxAid and UNDP.'**
  String get infoContent;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcome;

  /// No description provided for @login_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Discover Limitless Choices and Unmatched Convenience.'**
  String get login_subtitle;

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

  /// No description provided for @login_button.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login_button;

  /// No description provided for @incorrect_password.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password.'**
  String get incorrect_password;

  /// No description provided for @user_not_found.
  ///
  /// In en, this message translates to:
  /// **'User is not registered.'**
  String get user_not_found;

  /// No description provided for @unexpected_error.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get unexpected_error;

  /// No description provided for @or_text.
  ///
  /// In en, this message translates to:
  /// **'- Or -'**
  String get or_text;

  /// No description provided for @continue_guest.
  ///
  /// In en, this message translates to:
  /// **'Continue as a Guest'**
  String get continue_guest;

  /// No description provided for @password_validation.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get password_validation;

  /// No description provided for @email_validation.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get email_validation;

  /// No description provided for @enter_email.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get enter_email;

  /// No description provided for @enter_password.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get enter_password;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up!'**
  String get signUp;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an account to get started.'**
  String get createAccount;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @signUpButton.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUpButton;

  /// No description provided for @haveAccount.
  ///
  /// In en, this message translates to:
  /// **'Have an account?'**
  String get haveAccount;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @firstNameRequired.
  ///
  /// In en, this message translates to:
  /// **'First name is required'**
  String get firstNameRequired;

  /// No description provided for @lastNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Last name is required'**
  String get lastNameRequired;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @validEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get validEmail;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordRequired;

  /// No description provided for @passwordsNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsNotMatch;

  /// No description provided for @selectGender.
  ///
  /// In en, this message translates to:
  /// **'Please select a gender'**
  String get selectGender;

  /// No description provided for @registrationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration successful!'**
  String get registrationSuccess;

  /// No description provided for @donthaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get donthaveAccount;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'sq'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'sq': return AppLocalizationsSq();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
