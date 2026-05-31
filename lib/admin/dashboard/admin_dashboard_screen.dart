import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grc/admin/dashboard/admin_dashboard_controller.dart';
import 'package:grc/components/admin/stat_card.dart';
import 'package:grc/components/shared/custom_button.dart';
import 'package:grc/core/config/constants.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminDashboardController>();

    return Scaffold(
      backgroundColor: const Color(AppColors.background),
      appBar: AppBar(title: const Text('Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Overview',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: const [
              AdminStatCard(
                label: 'Total events',
                value: '12',
                icon: Icons.event_outlined,
              ),
              AdminStatCard(
                label: 'Registrations',
                value: '48',
                icon: Icons.people_outline,
              ),
              AdminStatCard(
                label: 'Revenue',
                value: '₹24,500',
                icon: Icons.payments_outlined,
              ),
            ],
          ),
          const SizedBox(height: 40),
          CustomButton(
            text: 'Manage Events',
            onPressed: controller.openMyEventsTab,
          ),
          const SizedBox(height: 12),
          CustomButton(
            text: 'Add Event',
            isOutlined: true,
            onPressed: controller.openEventForm,
          ),
        ],
      ),
    );
  }
}
