import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grc/core/auth/auth_state_controller.dart';
import 'package:grc/core/components/bottom_navigation_panel/app_bottom_navigation_panel.dart';
import 'package:grc/core/components/bottom_navigation_panel/nav_tabs.dart';
import 'package:grc/core/components/bottom_navigation_panel/navigation_controller.dart';
import 'package:grc/core/config/constants.dart';

class MainScreenWrapper extends StatelessWidget {
  const MainScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = Get.find<AuthStateController>();
    return Obx(() {
      final isAdminMode = authState.isAdminMode;
      return _MainTabShell(
        key: ValueKey(isAdminMode),
        isAdminMode: isAdminMode,
      );
    });
  }
}

class _MainTabShell extends StatefulWidget {
  final bool isAdminMode;

  const _MainTabShell({super.key, required this.isAdminMode});

  @override
  State<_MainTabShell> createState() => _MainTabShellState();
}

class _MainTabShellState extends State<_MainTabShell> {
  late final NavigationController _navController;

  @override
  void initState() {
    super.initState();
    _navController = Get.find<NavigationController>();
    final tabs = navTabsFor(widget.isAdminMode);
    if (tabs.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _navController.syncWithCurrentRoute();
      });
    }
  }

  List<NavTab> get _tabs => navTabsFor(widget.isAdminMode);

  Widget _buildActiveTab(int index) {
    final tab = _tabs[index];
    return KeyedSubtree(key: ValueKey(tab.route), child: tab.screenBuilder());
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final useRail = width >= 1024;
    final useExtendedRail = width >= 1320;
    final hasTabs = _tabs.isNotEmpty;

    return Scaffold(
      body: !hasTabs
          ? const SizedBox.shrink()
          : Obx(() {
              final index = _navController.currentIndex.clamp(
                0,
                _tabs.length - 1,
              );

              if (!useRail) {
                return _buildActiveTab(index);
              }

              return Row(
                children: [
                  SafeArea(
                    child: SizedBox(
                      width: useExtendedRail ? 250 : 84,
                      child: Column(
                        children: [
                          _RailBrandHeader(extended: useExtendedRail),
                          const Divider(height: 1),
                          Expanded(
                            child: NavigationRail(
                              selectedIndex: index,
                              onDestinationSelected: _navController.changeTab,
                              labelType: useExtendedRail
                                  ? NavigationRailLabelType.none
                                  : NavigationRailLabelType.all,
                              extended: useExtendedRail,
                              minWidth: 84,
                              minExtendedWidth: 250,
                              destinations: [
                                for (final tab in _tabs)
                                  NavigationRailDestination(
                                    icon: Icon(tab.icon),
                                    selectedIcon: Icon(tab.activeIcon),
                                    label: Text(tab.label),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(child: _buildActiveTab(index)),
                ],
              );
            }),
      bottomNavigationBar: (useRail || !hasTabs)
          ? const SizedBox.shrink()
          : Obx(() {
              final index = _navController.currentIndex.clamp(
                0,
                _tabs.length - 1,
              );
              return AppBottomNavigationPanel(
                tabs: _tabs,
                currentIndex: index,
                onTap: _navController.changeTab,
              );
            }),
    );
  }
}

class _RailBrandHeader extends StatelessWidget {
  final bool extended;

  const _RailBrandHeader({required this.extended});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          mainAxisAlignment: extended
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(AppColors.primary).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.directions_run_rounded,
                size: 18,
                color: Color(AppColors.primary),
              ),
            ),
            if (extended) ...[
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  AppConstants.appName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(AppColors.text),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
