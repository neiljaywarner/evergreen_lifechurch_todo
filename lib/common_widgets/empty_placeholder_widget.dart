import 'package:evergreen_lifechurch_todo/common_widgets/primary_button.dart';
import 'package:evergreen_lifechurch_todo/constants/app_sizes.dart';
import 'package:evergreen_lifechurch_todo/features/authentication/data/firebase_auth_repository.dart';
import 'package:evergreen_lifechurch_todo/localization/string_hardcoded.dart';
import 'package:evergreen_lifechurch_todo/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Placeholder widget showing a message and CTA to go back to the home screen.
class EmptyPlaceholderWidget extends ConsumerWidget {
  const EmptyPlaceholderWidget({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.p16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              message,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            gapH32,
            PrimaryButton(
              onPressed: () {
                final isLoggedIn =
                    ref.watch(authRepositoryProvider).currentUser != null;
                context.goNamed(
                    isLoggedIn ? AppRoute.todos.name : AppRoute.signIn.name);
              },
              text: 'Go Home'.hardcoded,
            )
          ],
        ),
      ),
    );
  }
}
