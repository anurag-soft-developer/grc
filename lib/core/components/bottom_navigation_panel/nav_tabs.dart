import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grc/admin/dashboard/admin_dashboard_controller.dart';
import 'package:grc/admin/dashboard/admin_dashboard_screen.dart';
import 'package:grc/admin/events/my_events_controller.dart';
import 'package:grc/admin/events/my_events_screen.dart';
import 'package:grc/events/events_screen.dart';
import 'package:grc/home/home_screen.dart';
import 'package:grc/profile/profile_screen.dart';
import 'package:grc/registrations/registrations_screen.dart';
import 'package:grc/core/routes/main_tab_routes.dart';

class NavTab {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;
  final Widget Function() screenBuilder;
  final void Function()? loadController;
  final void Function()? disposeController;

  const NavTab({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
    required this.screenBuilder,
    this.loadController,
    this.disposeController,
  });
}

void _ensure<T extends GetxController>(T Function() factory) {
  if (!Get.isRegistered<T>()) {
    Get.put<T>(factory(), permanent: false);
  }
}

void _dispose<T extends GetxController>() {
  if (Get.isRegistered<T>()) {
    Get.delete<T>();
  }
}

final List<NavTab> kUserNavTabs = [
  NavTab(
    icon: Icons.home_outlined,
    activeIcon: Icons.home,
    label: 'Home',
    route: MainTabRoutes.home,
    screenBuilder: () => const HomeScreen(),
  ),
  NavTab(
    icon: Icons.event_outlined,
    activeIcon: Icons.event,
    label: 'Events',
    route: MainTabRoutes.events,
    screenBuilder: () => const EventsScreen(),
  ),
  NavTab(
    icon: Icons.assignment_outlined,
    activeIcon: Icons.assignment,
    label: 'Registrations',
    route: MainTabRoutes.registrations,
    screenBuilder: () => const RegistrationsScreen(),
  ),
  NavTab(
    icon: Icons.person_outline,
    activeIcon: Icons.person,
    label: 'Profile',
    route: MainTabRoutes.profile,
    screenBuilder: () => const ProfileTabScreen(),
  ),
];

final List<NavTab> kAdminNavTabs = [
  NavTab(
    icon: Icons.dashboard_outlined,
    activeIcon: Icons.dashboard,
    label: 'Dashboard',
    route: MainTabRoutes.dashboard,
    screenBuilder: () => const AdminDashboardScreen(),
    loadController: () =>
        _ensure<AdminDashboardController>(() => AdminDashboardController()),
    disposeController: () => _dispose<AdminDashboardController>(),
  ),
  NavTab(
    icon: Icons.event_note_outlined,
    activeIcon: Icons.event_note,
    label: 'My Events',
    route: MainTabRoutes.myEvents,
    screenBuilder: () => const MyEventsScreen(),
    loadController: () =>
        _ensure<MyEventsController>(() => MyEventsController()),
    disposeController: () => _dispose<MyEventsController>(),
  ),
  NavTab(
    icon: Icons.person_outline,
    activeIcon: Icons.person,
    label: 'Profile',
    route: MainTabRoutes.profile,
    screenBuilder: () => const ProfileTabScreen(),
  ),
];

List<NavTab> navTabsFor(bool isAdminMode) =>
    isAdminMode ? kAdminNavTabs : kUserNavTabs;
