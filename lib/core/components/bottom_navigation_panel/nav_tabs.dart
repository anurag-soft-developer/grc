import 'package:flutter/material.dart';
import 'package:grc/features/events/events_placeholder_screen.dart';
import 'package:grc/features/home/home_placeholder_screen.dart';
import 'package:grc/features/registrations/registrations_placeholder_screen.dart';
import 'package:grc/profile/profile_screen.dart';

class NavTab {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final Widget Function() screenBuilder;

  const NavTab({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.screenBuilder,
  });
}

final List<NavTab> kNavTabs = [
  NavTab(
    icon: Icons.home_outlined,
    activeIcon: Icons.home,
    label: 'Home',
    screenBuilder: () => const HomePlaceholderScreen(),
  ),
  NavTab(
    icon: Icons.event_outlined,
    activeIcon: Icons.event,
    label: 'Events',
    screenBuilder: () => const EventsPlaceholderScreen(),
  ),
  NavTab(
    icon: Icons.assignment_outlined,
    activeIcon: Icons.assignment,
    label: 'Registrations',
    screenBuilder: () => const RegistrationsPlaceholderScreen(),
  ),
  NavTab(
    icon: Icons.person_outline,
    activeIcon: Icons.person,
    label: 'Profile',
    screenBuilder: () => const ProfileTabScreen(),
  ),
];
