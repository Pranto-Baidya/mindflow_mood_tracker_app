import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/provider/credentials_provider/credentials_provider.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/provider/local_auth_provider/local_auth_provider.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/screens/auth_screens/password_reset/password_reset.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/screens/auth_screens/pin_lock_screen/pin_lock_screen.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/screens/ui_screens/home/all_mood_journal_screen.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/widgets/app_loader/app_loader.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/widgets/app_toastMsg/app_toastMsg.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/widgets/status_bar_color/status%20bar%20color.dart';
import 'package:provider/provider.dart';

import '../../../provider/auth_provider/auth_provider.dart';
import '../../../provider/preferences_provider/preferences_provider.dart';

class SignInSignUp extends StatefulWidget {
  const SignInSignUp({super.key});

  @override
  State<SignInSignUp> createState() => _SignInSignUpState();
}

class _SignInSignUpState extends State<SignInSignUp> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _signUpEmailController = TextEditingController();
  final TextEditingController _signUpPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  final GlobalKey<FormState> _signInFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();

  bool isTyping = false;
  bool isSignIn = true;
  bool showPassword = false;
  bool showConfirmPassword = false;

  @override
  void initState() {
    _nameController.addListener(checkTyping);
    _emailController.addListener(checkTyping);
    _signUpEmailController.addListener(checkTyping);
    _signUpPasswordController.addListener(checkTyping);
    _passwordController.addListener(checkTyping);
    _confirmPassController.addListener(checkTyping);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<CredentialsProvider>().loadCredentials();
      final credentials = context.read<CredentialsProvider>();

      if (credentials.rememberMe) {
        _emailController.text = credentials.email ?? '';
        _passwordController.text = credentials.password ?? '';
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    StatusBarColor.apply(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nameController.removeListener(checkTyping);
    _emailController.removeListener(checkTyping);
    _signUpEmailController.removeListener(checkTyping);
    _signUpPasswordController.removeListener(checkTyping);
    _passwordController.removeListener(checkTyping);
    _confirmPassController.removeListener(checkTyping);
    _nameController.dispose();
    _emailController.dispose();
    _signUpEmailController.dispose();
    _signUpPasswordController.dispose();
    _passwordController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  void checkTyping() {
    bool hasValue;
    if (isSignIn) {
      hasValue =
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    } else {
      hasValue =
          _nameController.text.isNotEmpty &&
          _signUpEmailController.text.isNotEmpty &&
          _signUpPasswordController.text.isNotEmpty &&
          _confirmPassController.text.isNotEmpty;
    }
    if (hasValue != isTyping) {
      setState(() {
        isTyping = hasValue;
      });
    }
  }

  void toggleShowConfirmPassword() {
    setState(() {
      showConfirmPassword = !showConfirmPassword;
    });
  }

  void toggleShowPassword() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  void toggleAuthState() {
    setState(() {
      isSignIn = !isSignIn;
      isTyping = false;
      showPassword = false;
      showConfirmPassword = false;
      _nameController.clear();
      _signUpEmailController.clear();
      _signUpPasswordController.clear();
      _confirmPassController.clear();

      _signInFormKey.currentState?.reset();
      _signUpFormKey.currentState?.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final credentials = context.watch<CredentialsProvider>();
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 80.h),
              isSignIn
                  ? Text('Welcome back', style: theme.textTheme.displaySmall)
                  : Text(
                      'Create an account',
                      style: theme.textTheme.displaySmall,
                    ),
              SizedBox(height: 20.h),
              isSignIn
                  ? Text(
                      'Fill up the credentials below and get started',
                      style: theme.textTheme.titleMedium,
                    )
                  : Text(
                      'Fill up the credentials below and be a member today!',
                      style: theme.textTheme.titleMedium,
                    ),
              SizedBox(height: 20.h),
              toggleButton(theme),
              SizedBox(height: 20.h),
              isSignIn
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Text(
                        'Sign In',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Text(
                        'Sign Up',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
              if (!isSignIn) ...[
                Form(
                  key: _signUpFormKey,
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: TextFormField(
                          controller: _nameController,
                          cursorColor: theme.colorScheme.primary,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'Name',
                            hintStyle: theme.textTheme.titleMedium,
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: theme.iconTheme.color,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: TextFormField(
                          controller: _signUpEmailController,
                          cursorColor: theme.colorScheme.primary,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@') ||
                                !value.contains('.com')) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: theme.textTheme.titleMedium,
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: theme.iconTheme.color,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _signUpPasswordController,
                          cursorColor: theme.colorScheme.primary,
                          obscureText: showPassword ? false : true,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your password";
                            }
                            if (value.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: theme.textTheme.titleMedium,
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: theme.iconTheme.color,
                            ),
                            suffixIcon: Padding(
                              padding: EdgeInsets.only(right: 8.w),
                              child: IconButton(
                                onPressed: toggleShowPassword,
                                icon: Icon(
                                  showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: theme.iconTheme.color,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _confirmPassController,
                          cursorColor: theme.colorScheme.primary,
                          obscureText: showConfirmPassword ? false : true,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Please confirm your password";
                            }
                            if (value != _signUpPasswordController.text) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'Confirm password',
                            hintStyle: theme.textTheme.titleMedium,
                            prefixIcon: Icon(
                              Icons.password,
                              color: theme.iconTheme.color,
                            ),
                            suffixIcon: Padding(
                              padding: EdgeInsets.only(right: 8.w),
                              child: IconButton(
                                onPressed: toggleShowConfirmPassword,
                                icon: Icon(
                                  showConfirmPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: theme.iconTheme.color,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (isSignIn) ...[
                Form(
                  key: _signInFormKey,
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: TextFormField(
                          controller: _emailController,
                          cursorColor: theme.colorScheme.primary,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@') ||
                                !value.contains('.com')) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: theme.textTheme.titleMedium,
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: theme.iconTheme.color,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _passwordController,
                          cursorColor: theme.colorScheme.primary,
                          obscureText: showPassword ? false : true,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your password";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: theme.textTheme.titleMedium,
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: theme.iconTheme.color,
                            ),
                            suffixIcon: Padding(
                              padding: EdgeInsets.only(right: 8.w),
                              child: IconButton(
                                onPressed: toggleShowPassword,
                                icon: Icon(
                                  showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: theme.iconTheme.color,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Consumer<CredentialsProvider>(
                            builder: (context, credentials, child) {
                              return Row(
                                children: [
                                  Checkbox(
                                    activeColor: theme.colorScheme.primary,
                                    checkColor: Colors.white,
                                    value: credentials.rememberMe,
                                    onChanged: (value) {
                                      credentials.toggleCheckBox();
                                    },
                                  ),
                                  Text(
                                    'Remember me',
                                    style: theme.textTheme.titleMedium,
                                  ),
                                ],
                              );
                            },
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PasswordReset(),
                                ),
                              );
                            },
                            child: Text(
                              'Forgot Password?',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Consumer<AuthProvider>(
                  builder: (context, auth, _) {
                    return ElevatedButton(
                      onPressed: isTyping
                          ? () async {
                              final currentFormKey = isSignIn ? _signInFormKey : _signUpFormKey;
                              if (currentFormKey.currentState!.validate()) {
                                if (isSignIn) {
                                  bool remember = credentials.rememberMe;
                                  bool success = await auth.signIn(
                                    _emailController.text,
                                    _passwordController.text,
                                  );

                                  if (success) {
                                    credentials.saveCredentials(
                                      remember,
                                      _emailController.text,
                                      _passwordController.text,
                                    );
                                    final preferencesProvider = context.read<PreferencesProvider>();
                                    final localAuthProvider = context.read<LocalAuthProvider>();

                                    await preferencesProvider.loadLocalAuth();
                                    await localAuthProvider.loadPin();

                                    if (preferencesProvider.isAuthEnabled && localAuthProvider.isPinSet) {
                                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => PinLockScreen()),(Route<dynamic> route) => false);
                                    } else {
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AllMoodJournals()));
                                    }

                                    ToastMsg.successToast('Login successful');
                                  } else {
                                    ToastMsg.errorToast(
                                      auth.errorMsg ?? 'Login failed',
                                    );
                                  }
                                } else {
                                  bool success = await auth.signUp(
                                    _signUpEmailController.text,
                                    _signUpPasswordController.text,
                                    _nameController.text
                                  );
                                  if (success) {
                                    await Future.delayed(
                                      Duration(milliseconds: 800),
                                    );
                                    toggleAuthState();
                                    ToastMsg.successToast(
                                      'Registration successful',
                                    );
                                  } else {
                                    ToastMsg.errorToast(
                                      auth.errorMsg ?? 'Signup failed',
                                    );
                                  }
                                }
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: theme.colorScheme.primary,
                        minimumSize: Size(double.infinity.w, 50.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                      ),
                      child: auth.isLoading
                          ? AppLoader.lightThemeLoader()
                          : Text(
                              isSignIn ? 'Login' : 'Register',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20.h),
              if (isSignIn) ...[
                Center(
                  child: Text(
                    'Or, Sign in with',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Consumer<AuthProvider>(
                    builder: (context, auth, _) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: ElevatedButton(
                          onPressed: auth.isLoading
                              ? null
                              : () async {
                                  final user = await auth.signInWithGoogle();
                                  if (user != null) {
                                    final preferencesProvider = context.read<PreferencesProvider>();
                                    final localAuthProvider = context.read<LocalAuthProvider>();

                                    await preferencesProvider.loadLocalAuth();
                                    await localAuthProvider.loadPin();

                                    if (preferencesProvider.isAuthEnabled && localAuthProvider.isPinSet) {
                                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => PinLockScreen()),(Route<dynamic> route) => false);
                                    } else {
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AllMoodJournals()));
                                    }

                                    ToastMsg.successToast(
                                      'Signed in with Google',
                                    );
                                  } else {
                                    ToastMsg.errorToast(
                                      auth.errorMsg ??
                                          'Sign in aborted by user',
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            minimumSize: Size(double.infinity, 50.h),
                            backgroundColor: Colors.white,
                            side: BorderSide(color: theme.colorScheme.primary),
                          ),
                          child: auth.isLoading
                              ? AppLoader.lightThemeLoader()
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/google.png',
                                      width: 25.w,
                                      height: 25.h,
                                    ),
                                    SizedBox(width: 10.w),
                                    Text(
                                      'Continue with Google',
                                      style: TextStyle(
                                        color: Color(0xFF333333),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20.h),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isSignIn
                      ? Text(
                          "Don't have an account?",
                          style: theme.textTheme.titleSmall,
                        )
                      : Text(
                          "Already have an account?",
                          style: theme.textTheme.titleSmall,
                        ),
                  SizedBox(width: 5.w),
                  GestureDetector(
                    onTap: () async {
                      await Future.delayed(Duration(milliseconds: 800));
                      toggleAuthState();
                    },
                    child: Text(
                      isSignIn ? "Sign up" : "Sign In",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget toggleButton(ThemeData theme) {
    return Container(
      height: 50.h,
      width: double.infinity,
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (!isSignIn) {
                  toggleAuthState();
                }
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSignIn
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(25.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Sign in",
                  style: isSignIn
                      ? theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                        )
                      : theme.textTheme.titleMedium?.copyWith(
                          color: Color(0xFF333333),
                        ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (isSignIn) {
                  toggleAuthState();
                }
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: !isSignIn
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(25.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Sign up",
                  style: !isSignIn
                      ? theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                        )
                      : theme.textTheme.titleMedium?.copyWith(
                          color: Color(0xFF333333),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
