import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grc/core/auth/auth_state_controller.dart';
import 'package:grc/core/components/bottom_navigation_panel/app_bottom_navigation_panel.dart';
import 'package:grc/core/components/bottom_navigation_panel/nav_tabs.dart';
import 'package:grc/core/components/bottom_navigation_panel/navigation_controller.dart';

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
                          _RailBrandHeader(
                            onTap: _navController.resetToFirstTab,
                          ),
                          const Divider(height: 1),
                          Expanded(
                            child: useExtendedRail
                                ? _ExtendedRailDestinations(
                                    tabs: _tabs,
                                    selectedIndex: index,
                                    onSelect: _navController.changeTab,
                                  )
                                : NavigationRail(
                                    selectedIndex: index,
                                    onDestinationSelected:
                                        _navController.changeTab,
                                    labelType: NavigationRailLabelType.all,
                                    extended: false,
                                    minWidth: 84,
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
  final VoidCallback onTap;

  const _RailBrandHeader({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Image.asset(
                  'assets/logos/grc_logo.png',
                  width: 36,
                  height: 36,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // if (extended) ...[
            //   const SizedBox(width: 10),
            //   Expanded(
            //     child: Text(
            //       AppConstants.appName,
            //       maxLines: 1,
            //       overflow: TextOverflow.ellipsis,
            //       style: const TextStyle(
            //         fontSize: 15,
            //         fontWeight: FontWeight.w700,
            //         color: Color(AppColors.text),
            //       ),
            //     ),
            //   ),
            // ],
          ],
        ),
      ),
    );
  }
}

class _ExtendedRailDestinations extends StatelessWidget {
  final List<NavTab> tabs;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const _ExtendedRailDestinations({
    required this.tabs,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 16),
      itemCount: tabs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 6),
      itemBuilder: (context, index) {
        final tab = tabs[index];
        final selected = index == selectedIndex;
        return _ExtendedRailDestinationTile(
          icon: selected ? tab.activeIcon : tab.icon,
          label: tab.label,
          selected: selected,
          onTap: () => onSelect(index),
        );
      },
    );
  }
}

class _ExtendedRailDestinationTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ExtendedRailDestinationTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedBg = colorScheme.primary.withValues(alpha: 0.16);
    final selectedBorder = colorScheme.primary.withValues(alpha: 0.45);
    final selectedText = colorScheme.onSurface;
    final unselectedText = colorScheme.onSurface.withValues(alpha: 0.74);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: selected ? selectedBg : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? selectedBorder
                  : colorScheme.outline.withValues(alpha: 0.20),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 22,
                color: selected ? colorScheme.primary : unselectedText,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected ? selectedText : unselectedText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
