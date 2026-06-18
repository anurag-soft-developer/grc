import 'dart:io' show Platform;

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:grc/admin/events/model/run_event_model.dart';
import 'package:grc/core/utils/exception_handler.dart';
import 'package:url_launcher/url_launcher.dart';

bool canOpenEventLocationInMaps(RunEventLocation? location) {
  return _locationMapTargets(location).isNotEmpty;
}

Uri? buildEventLocationMapsUri(RunEventLocation? location) {
  final targets = _locationMapTargets(location);
  if (targets.isEmpty) return null;

  for (final uri in targets) {
    if (uri.scheme == 'https' || uri.scheme == 'http') return uri;
  }
  return targets.first;
}

List<Uri> _locationMapTargets(RunEventLocation? location) {
  if (location == null) return const [];

  final lat = location.lat;
  final long = location.long;
  if (lat != null && long != null) {
    final webUri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$long',
    );
    if (kIsWeb) return [webUri];
    return [
      Uri.parse('geo:$lat,$long?q=$lat,$long'),
      webUri,
    ];
  }

  final query = _locationSearchQuery(location);
  if (query == null) return const [];

  final encoded = Uri.encodeComponent(query);
  final webUri = Uri.parse(
    'https://www.google.com/maps/search/?api=1&query=$encoded',
  );
  if (kIsWeb) return [webUri];
  return [
    Uri.parse('geo:0,0?q=$encoded'),
    webUri,
  ];
}

String? _locationSearchQuery(RunEventLocation location) {
  final parts = [
    location.address,
    if (location.city.isNotEmpty || location.state.isNotEmpty)
      '${location.city}${location.state.isNotEmpty ? ', ${location.state}' : ''}',
  ].where((part) => part.trim().isNotEmpty);

  final query = parts.join(', ').trim();
  return query.isEmpty ? null : query;
}

/// Invoke from tap handlers so web browsers keep the user-gesture chain.
void handleEventLocationTap(RunEventLocation? location) {
  final uri = buildEventLocationMapsUri(location);
  if (uri == null) return;

  if (kIsWeb) {
    launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    ).then((launched) {
      if (!launched) {
        ExceptionHandler.showErrorToast('Could not open maps');
      }
    });
    return;
  }

  openEventLocationInMaps(location);
}

Future<bool> openEventLocationInMaps(RunEventLocation? location) async {
  final targets = _locationMapTargets(location);
  if (targets.isEmpty) return false;

  if (kIsWeb) {
    final launched = await launchUrl(
      targets.first,
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    );
    if (!launched) {
      ExceptionHandler.showErrorToast('Could not open maps');
    }
    return launched;
  }

  for (final uri in targets) {
    if (await _tryLaunchUri(uri)) {
      return true;
    }
  }

  if (Platform.isAndroid) {
    for (final uri in targets) {
      if (await _tryLaunchAndroidIntent(uri)) {
        return true;
      }
    }
  }

  ExceptionHandler.showErrorToast('Could not open maps');
  return false;
}

Future<bool> _tryLaunchUri(Uri uri) async {
  if (kIsWeb) {
    if (uri.scheme != 'http' && uri.scheme != 'https') return false;
    return launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    );
  }

  try {
    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    return launched;
  } on PlatformException {
    try {
      return await launchUrl(uri, mode: LaunchMode.platformDefault);
    } on PlatformException {
      return false;
    }
  } catch (_) {
    return false;
  }
}

Future<bool> _tryLaunchAndroidIntent(Uri uri) async {
  try {
    final intent = AndroidIntent(
      action: 'action_view',
      data: uri.toString(),
    );
    await intent.launch();
    return true;
  } catch (_) {
    return false;
  }
}
