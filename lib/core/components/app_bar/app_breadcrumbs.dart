import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/navigation/app_navigation.dart';
import 'package:grc/core/routes/main_tab_routes.dart';

class GrcBreadcrumbItem {
  final String label;
  final String? route;
  final Map<String, String>? parameters;
  final VoidCallback? onTap;

  const GrcBreadcrumbItem({
    required this.label,
    this.route,
    this.parameters,
    this.onTap,
  });

  bool get isNavigable => onTap != null || route != null;
}

class AppBreadcrumbs {
  AppBreadcrumbs._();

  static void _goToTab(String route) => Get.offNamed(route);

  static GrcBreadcrumbItem _profileTab([String label = 'Profile']) {
    return GrcBreadcrumbItem(
      label: label,
      onTap: () => _goToTab(MainTabRoutes.profile),
    );
  }

  static GrcBreadcrumbItem _eventsTab([String label = 'Events']) {
    return GrcBreadcrumbItem(
      label: label,
      onTap: () => _goToTab(MainTabRoutes.events),
    );
  }

  static GrcBreadcrumbItem _registrationsTab([String label = 'Registrations']) {
    return GrcBreadcrumbItem(
      label: label,
      onTap: () => _goToTab(MainTabRoutes.registrations),
    );
  }

  static GrcBreadcrumbItem _myEventsTab([String label = 'My Events']) {
    return GrcBreadcrumbItem(
      label: label,
      onTap: () => _goToTab(MainTabRoutes.myEvents),
    );
  }

  static GrcBreadcrumbItem _settings() {
    return GrcBreadcrumbItem(
      label: 'Settings',
      route: AppConstants.routes.settings,
      onTap: () => AppNavigation.toNamed(AppConstants.routes.settings),
    );
  }

  static GrcBreadcrumbItem _current(String label) {
    return GrcBreadcrumbItem(label: label);
  }

  static GrcBreadcrumbItem _adminEvent(String eventId, String eventTitle) {
    return GrcBreadcrumbItem(
      label: eventTitle,
      route: AppConstants.routes.adminEventDetailPath(eventId),
      onTap: () => AppNavigation.toNamed(
        AppConstants.routes.adminEventDetailPath(eventId),
      ),
    );
  }

  static GrcBreadcrumbItem _userEvent(String eventSlug, String eventTitle) {
    return GrcBreadcrumbItem(
      label: eventTitle,
      route: AppConstants.routes.eventDetailPath(eventSlug),
      onTap: () => AppNavigation.toNamed(
        AppConstants.routes.eventDetailPath(eventSlug),
      ),
    );
  }

  static GrcBreadcrumbItem _questionnaires(String eventId) {
    return GrcBreadcrumbItem(
      label: 'Registration questions',
      route: AppConstants.routes.adminEventQuestionnairesPath(eventId),
      onTap: () => AppNavigation.toNamed(
        AppConstants.routes.adminEventQuestionnairesPath(eventId),
      ),
    );
  }

  static List<GrcBreadcrumbItem> settings() {
    return [_profileTab(), _settings()];
  }

  static List<GrcBreadcrumbItem> settingsChild(String pageTitle) {
    return [_profileTab(), _settings(), _current(pageTitle)];
  }

  static List<GrcBreadcrumbItem> editProfile() {
    return [_profileTab(), _current('Edit profile')];
  }

  static List<GrcBreadcrumbItem> userEventDetail({
    required String eventSlug,
    String? eventTitle,
  }) {
    return [
      _eventsTab(),
      _current(eventTitle?.trim().isNotEmpty == true ? eventTitle! : 'Event details'),
    ];
  }

  static List<GrcBreadcrumbItem> userEventRegistration({
    required String eventSlug,
    String? eventTitle,
  }) {
    final title = eventTitle?.trim().isNotEmpty == true ? eventTitle! : 'Event';
    return [
      _eventsTab(),
      _userEvent(eventSlug, title),
      _current('Register'),
    ];
  }

  static List<GrcBreadcrumbItem> registrationDetail() {
    return [_registrationsTab(), _current('Registration')];
  }

  static List<GrcBreadcrumbItem> adminEventFormCreate() {
    return [_myEventsTab(), _current('Add event')];
  }

  static List<GrcBreadcrumbItem> adminEventFormEdit() {
    return [_myEventsTab(), _current('Edit event')];
  }

  static List<GrcBreadcrumbItem> adminEventDetail({
    required String eventId,
    String? eventTitle,
  }) {
    return [
      _myEventsTab(),
      _current(eventTitle?.trim().isNotEmpty == true ? eventTitle! : 'Event details'),
    ];
  }

  static List<GrcBreadcrumbItem> adminEventChild({
    required String eventId,
    String? eventTitle,
    required String pageTitle,
  }) {
    final title = eventTitle?.trim().isNotEmpty == true ? eventTitle! : 'Event';
    return [
      _myEventsTab(),
      _adminEvent(eventId, title),
      _current(pageTitle),
    ];
  }

  static List<GrcBreadcrumbItem> adminQuestionnaires({
    required String eventId,
    String? eventTitle,
  }) {
    final title = eventTitle?.trim().isNotEmpty == true ? eventTitle! : 'Event';
    return [
      _myEventsTab(),
      _adminEvent(eventId, title),
      _current('Registration questions'),
    ];
  }

  static List<GrcBreadcrumbItem> adminFormBuilder({
    required String eventId,
    String? eventTitle,
  }) {
    final title = eventTitle?.trim().isNotEmpty == true ? eventTitle! : 'Event';
    return [
      _myEventsTab(),
      _adminEvent(eventId, title),
      _questionnaires(eventId),
      _current('Form builder'),
    ];
  }
}
