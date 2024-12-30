import 'package:flutter/widgets.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget smallScreen;
  final Widget mediumScreen;
  final Widget largeScreen;

  const ResponsiveLayout({
    super.key,
    required this.smallScreen,
    required this.mediumScreen,
    required this.largeScreen,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 600) {
        return smallScreen;
      } else if (constraints.maxWidth < 1000) {
        return mediumScreen;
      } else {
        return largeScreen;
      }
    });
  }
}
