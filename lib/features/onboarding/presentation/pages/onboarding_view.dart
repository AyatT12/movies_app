import 'package:flutter/material.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../domain/entities/onboarding_entity.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_outline_button.dart';
import '../../../auth/presentation/pages/login_view.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingEntity> _onboardingData = [
    OnboardingEntity(
      image: AppAssets.firstOnBoarding,
      title: 'Find Your Next Favorite Movie Here',
      description:
          'Get access to a huge library of movies to suit all tastes. You will surely like it.',
      buttonText: 'Explore Now',
    ),
    OnboardingEntity(
      image: AppAssets.secondOnBoarding,
      title: 'Discover Movies',
      description:
          'Explore a vast collection of movies in all qualities and genres. Find your next favorite film with ease.',
      buttonText: 'Next',
    ),
    OnboardingEntity(
      image: AppAssets.thirdOnBoarding,
      title: 'Explore All Genres',
      description:
          'Discover movies from every genre, in all available qualities. Find something new and exciting to watch every day.',
      buttonText: 'Next',
    ),
    OnboardingEntity(
      image: AppAssets.fourthOnBoarding,
      title: 'Create Watch lists',
      description:
          'Save movies to your watchlist to keep track of what you want to watch next. Enjoy films in various qualities and genres.',
      buttonText: 'Next',
    ),
    OnboardingEntity(
      image: AppAssets.fifthOnBoarding,
      title: 'Rate, Review, and Learn',
      description:
          'Share your thoughts on the movies you have watched. Dive deep into film details and help others discover great movies with your reviews.',
      buttonText: 'Next',
    ),
    OnboardingEntity(
      image: AppAssets.sixthOnBoarding,
      title: 'Start Watching Now',
      description: '',
      buttonText: 'Finish',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: _onboardingData.length,
            itemBuilder: (context, index) {
              return Image.asset(
                _onboardingData[index].image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              );
            },
          ),
          if (_currentIndex == 0)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.background.withAlpha(128),
                      AppColors.background,
                    ],
                    stops: const [0.5, 0.7, 1.0],
                  ),
                ),
              ),
            ),
          if (_currentIndex == 0)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 48.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    _onboardingData[_currentIndex].title,
                    style: AppStyles.title.copyWith(fontSize: 32),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _onboardingData[_currentIndex].description,
                    style: AppStyles.description,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  CustomButton(
                    text: _onboardingData[_currentIndex].buttonText,
                    onPressed: _nextPage,
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          if (_currentIndex > 0)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 50,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Text(
                      _onboardingData[_currentIndex].title,
                      style: AppStyles.title.copyWith(fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _onboardingData[_currentIndex].description,
                      style: AppStyles.description.copyWith(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    CustomButton(
                      text: _onboardingData[_currentIndex].buttonText,
                      onPressed: _nextPage,
                    ),
                    if (_currentIndex >= 2) ...[
                      const SizedBox(height: 16),
                      CustomOutlineButton(
                        text: 'Back',
                        onPressed: _previousPage,
                      ),
                    ],
                    const SizedBox(height: 24),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _nextPage() {
    if (_currentIndex < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
      );
    }
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
