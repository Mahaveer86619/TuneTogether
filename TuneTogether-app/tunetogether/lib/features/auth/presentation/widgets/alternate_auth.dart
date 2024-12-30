import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AlternateAuth extends StatelessWidget {
  final String asset;
  final VoidCallback onTap;

  const AlternateAuth({
    super.key,
    required this.asset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.onSurface.withAlpha(70),
        child: SvgPicture.asset(
          asset,
          theme: SvgTheme(
            currentColor: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
