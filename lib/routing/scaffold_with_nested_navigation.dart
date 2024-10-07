// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:evergreen_lifechurch_todo/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Stateful navigation based on:
// https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) => navigationShell.goBranch(
        index,
        // A common pattern when using bottom navigation bars is to support
        // navigating to the initial location when tapping the item that is
        // already active. This example demonstrates how to support this behavior,
        // using the initialLocation parameter of goBranch.
        initialLocation: index == navigationShell.currentIndex,
      );

  @override
  Widget build(BuildContext context) => MediaQuery.sizeOf(context).width < 450
      ? ScaffoldWithNavigationBar(
          body: navigationShell,
          currentIndex: navigationShell.currentIndex,
          onDestinationSelected: _goBranch,
        )
      : ScaffoldWithNavigationRail(
          body: navigationShell,
          currentIndex: navigationShell.currentIndex,
          onDestinationSelected: _goBranch,
        );
}

class ScaffoldWithNavigationBar extends StatelessWidget {
  const ScaffoldWithNavigationBar({
    required this.body,
    required this.currentIndex,
    required this.onDestinationSelected,
    super.key,
  });

  final Widget body;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: body,
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentIndex,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.work_outline),
              selectedIcon: const Icon(Icons.work),
              label: 'Todos'.hardcoded,
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined),
              selectedIcon: const Icon(Icons.settings),
              label: 'Settings'.hardcoded,
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline),
              selectedIcon: const Icon(Icons.person),
              label: 'Account'.hardcoded,
            ),
          ],
          onDestinationSelected: onDestinationSelected,
        ),
      );
}

class ScaffoldWithNavigationRail extends StatelessWidget {
  const ScaffoldWithNavigationRail({
    required this.body,
    required this.currentIndex,
    required this.onDestinationSelected,
    super.key,
  });

  final Widget body;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: currentIndex,
              onDestinationSelected: onDestinationSelected,
              labelType: NavigationRailLabelType.all,
              destinations: <NavigationRailDestination>[
                NavigationRailDestination(
                  icon: const Icon(Icons.work_outline),
                  selectedIcon: const Icon(Icons.work),
                  label: Text('Todos'.hardcoded),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.settings_outlined),
                  selectedIcon: const Icon(Icons.settings),
                  label: Text('Settings'.hardcoded),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.person_outline),
                  selectedIcon: const Icon(Icons.person),
                  label: Text('Account'.hardcoded),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            // This is the main content.
            Expanded(
              child: body,
            ),
          ],
        ),
      );
}
