import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grc/admin/events/model/run_event_model.dart';
import 'package:grc/core/utils/date_format_util.dart';
import 'package:grc/core/config/constants.dart';

class HomeEventCarouselCard extends StatelessWidget {
  final RunEventModel event;

  const HomeEventCarouselCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    String? coverUrl;
    for (final url in event.coverImages) {
      if (url.isNotEmpty) {
        coverUrl = url;
        break;
      }
    }

    final priceLabel = event.price == null
        ? ''
        : event.price == 0
        ? 'Free'
        : '₹${event.price!.toStringAsFixed(0)}';

    return Material(
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Get.toNamed(
          AppConstants.routes.eventDetail,
          arguments: event,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (coverUrl != null)
              Image.network(
                coverUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const _CarouselImageFallback(),
              )
            else
              const _CarouselImageFallback(),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.72),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (event.isOpenForRegistration)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(AppColors.success)
                            .withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'OPEN',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  const Spacer(),
                  Text(
                    event.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          formatEventDate(event.eventDate),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (priceLabel.isNotEmpty)
                        Text(
                          priceLabel,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CarouselImageFallback extends StatelessWidget {
  const _CarouselImageFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(AppColors.primary),
      child: const Center(
        child: Icon(
          Icons.event_outlined,
          size: 48,
          color: Colors.white54,
        ),
      ),
    );
  }
}
