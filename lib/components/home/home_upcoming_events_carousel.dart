import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grc/admin/events/model/run_event_model.dart';
import 'package:grc/components/home/home_coming_soon_poster.dart';
import 'package:grc/components/home/home_constants.dart';
import 'package:grc/components/home/home_event_carousel_card.dart';
import 'package:grc/components/home/home_section_message.dart';
import 'package:grc/core/config/constants.dart';

class HomeUpcomingEventsCarousel extends HookWidget {
  final List<RunEventModel> events;
  final bool isLoading;
  final bool isError;
  final VoidCallback onRetry;

  const HomeUpcomingEventsCarousel({
    super.key,
    required this.events,
    required this.isLoading,
    required this.isError,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController(viewportFraction: 0.9);
    final currentPage = useState(0);

    useEffect(() {
      void onPageChanged() {
        final page = pageController.page?.round() ?? 0;
        if (currentPage.value != page) {
          currentPage.value = page;
        }
      }

      pageController.addListener(onPageChanged);
      return () => pageController.removeListener(onPageChanged);
    }, [pageController]);

    if (isLoading) {
      return const SizedBox(
        height: kHomeCarouselHeight,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (isError) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: HomeSectionMessage(
          message: 'Could not load events',
          actionLabel: 'Retry',
          onAction: onRetry,
        ),
      );
    }

    if (events.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: HomeComingSoonPoster(),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: kHomeCarouselHeight,
          child: PageView.builder(
            controller: pageController,
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: HomeEventCarouselCard(event: event),
              );
            },
          ),
        ),
        if (events.length > 1) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(events.length, (index) {
              final active = index == currentPage.value;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: active ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: active
                      ? const Color(AppColors.primary)
                      : const Color(AppColors.divider),
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}
