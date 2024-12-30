import 'package:flutter/material.dart';

class LoadingBtn extends StatelessWidget {
  const LoadingBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Center(
        child: CircularProgressIndicator.adaptive(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}
