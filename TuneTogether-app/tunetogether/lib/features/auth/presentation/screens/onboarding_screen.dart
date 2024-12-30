import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../widgets/onboarding_tile.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  void _changeScreen(
    String routeName, {
    Map<String, dynamic>? arguments,
    bool isReplacement = false,
  }) {
    if (isReplacement) {
      Navigator.pushReplacementNamed(
        context,
        routeName,
        arguments: arguments,
      );
    } else {
      Navigator.pushNamed(
        context,
        routeName,
        arguments: arguments,
      );
    }
  }

  // void _showMessage(String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text(message)),
  //   );
  // }

  List<Widget> onBoardingPages = [
    const OnBoardingCard(
      title: 'Connect Globally',
      description: 'Stay connected with friends, no matter the distance.',
      path: 'assets/illustrations/anywhere_in_the_world.svg',
    ),
    const OnBoardingCard(
      title: 'Chat Seamlessly',
      description: 'Engage in effortless conversations.',
      path: 'assets/illustrations/chat_with_connections.svg',
    ),
    const OnBoardingCard(
      title: 'Tune Together',
      description: 'Collaborate and create unforgettable experiences.',
      path: 'assets/illustrations/ready_to_tune_together.svg',
    ),
  ];

  bool _isLastPage = false;
  final _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  _buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      actions: [
        TextButton(
          onPressed: () {
            _changeScreen('/sign-in');
          },
          child: Text(
            'Skip',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
        ),
      ],
    );
  }

  _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                _pageController.animateToPage(
                  index,
                  duration: Durations.short3,
                  curve: Curves.easeIn,
                );
                setState(() {
                  _isLastPage = index == onBoardingPages.length - 1;
                });
              },
              children: onBoardingPages,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SmoothPageIndicator(
                controller: _pageController,
                count: onBoardingPages.length,
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  if (_isLastPage) {
                    _changeScreen('/sign-in');
                  } else {
                    _pageController.animateToPage(
                      _pageController.page!.round() + 1,
                      duration: Durations.short3,
                      curve: Curves.easeIn,
                    );
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: _isLastPage
                      ? Padding(
                          padding: const EdgeInsets.only(
                            left: 18.0,
                            right: 12.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Start Tuning',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.keyboard_arrow_right,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Icon(
                            Icons.keyboard_arrow_right,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
