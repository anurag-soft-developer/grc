import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grc/core/components/bottom_navigation_panel/navigation_controller.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/components/home/home_constants.dart';

class HomeComingSoonPoster extends StatelessWidget {
  const HomeComingSoonPoster({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Get.find<NavigationController>().changeTab(1),
        child: Container(
          height: kHomeCarouselHeight,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF312E81),
                Color(AppColors.primary),
                Color(AppColors.secondary),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -24,
                top: -24,
                child: Icon(
                  Icons.directions_run_rounded,
                  size: 140,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
              Positioned(
                left: -16,
                bottom: -20,
                child: Icon(
                  Icons.event_available_outlined,
                  size: 110,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.22),
                        ),
                      ),
                      child: const Text(
                        'COMING SOON',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'New runs are\non the way',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Check back soon or explore the events tab.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.82),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
