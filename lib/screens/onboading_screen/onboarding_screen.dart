import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/provider/onboarding_provider/onboarding_provider.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/screens/auth_screens/sign_in_sign_up/sign_in_sign_up.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../provider/theme_provider/theme_provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;
    bool darkMode = context.watch<ThemeProvider>().currentTheme == ThemeMode.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness:
          isDark ? Brightness.light : Brightness.light,
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: darkMode
              ? const Color(0xFF1C2526)
              : const Color(0xFFF5F7FA),
        ),
        actions: [
          if(!isLastPage)
          TextButton(
              onPressed: (){
                _controller.jumpToPage(4);
              },
              child: Text('Skip',style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary),)
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              physics: const BouncingScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  isLastPage = index == 4;
                });
              },
              children: [
                BuildPage(
                  theme: theme,
                  title: 'Welcome to Mindflow',
                  imageUrl: darkMode
                      ? 'assets/welcome_dark.png'
                      : 'assets/welcome_light.png',
                  subtitle:
                  'Capture feelings, unlock patterns, embrace positivity',
                ),
                BuildPage(
                  theme: theme,
                  title: 'Track your mood, Everyday',
                  imageUrl: darkMode
                      ? 'assets/track_dark.png'
                      : 'assets/track_light.png',
                  subtitle:
                  'Understand yourself better with daily mood tracking',
                ),
                BuildPage(
                  theme: theme,
                  title: 'Get daily motivational quotes',
                  imageUrl: darkMode
                      ? 'assets/moti_dark.png'
                      : 'assets/moti_light.png',
                  subtitle:
                  'Never feel low with our powerful motivational quotes',
                ),
                BuildPage(
                  theme: theme,
                  title: 'Peace of mind, Secured',
                  imageUrl: darkMode
                      ? 'assets/security_dark.png'
                      : 'assets/security_light.png',
                  subtitle: 'Your emotions stay yours with our privacy feature',
                ),
                BuildPage(
                  theme: theme,
                  title: 'Simple & beautiful',
                  imageUrl: darkMode
                      ? 'assets/simple_dark.png'
                      : 'assets/simple_light.png',
                  subtitle:
                  'A calming design for a peaceful tracking experience',
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          SmoothPageIndicator(
            controller: _controller,
            count: 5,
            effect: ExpandingDotsEffect(
              dotColor:
              darkMode ? const Color(0xFFF5F7FA) : const Color(0xFF333333),
              activeDotColor: theme.colorScheme.primary,
              dotHeight: 10.h,
              dotWidth: 10.w,
            ),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: ElevatedButton(
              onPressed: () {
                if (isLastPage) {
                  context.read<OnBoardingProvider>().saveUserOnBoarding(true);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const SignInSignUp()),
                  );
                } else {
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: theme.colorScheme.primary,
                minimumSize: Size(double.infinity.w, 50.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
              ),
              child: Text(
                isLastPage ? 'Get started' : 'Next',
                style: theme.textTheme.titleLarge
                    ?.copyWith(color: Colors.white,fontWeight: FontWeight.w500),
              ),
            ),
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}

class BuildPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final ThemeData theme;

  const BuildPage({
    super.key,
    required this.theme,
    required this.title,
    required this.imageUrl,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500,color: theme.colorScheme.primary),
            textAlign: TextAlign.center,
          ),
          Image.asset(
            imageUrl,
            fit: BoxFit.cover,
            width: 300.w,
            height: 300.w,
          ),
          Text(
            subtitle,
            style: theme.textTheme.titleSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
