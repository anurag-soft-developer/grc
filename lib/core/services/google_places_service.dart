import 'package:google_places_flutter/model/prediction.dart';

class PlaceAddressDetails {
  final String address;
  final String city;
  final String state;
  final double lat;
  final double long;

  const PlaceAddressDetails({
    required this.address,
    required this.city,
    required this.state,
    required this.lat,
    required this.long,
  });
}

/// Parses [Prediction] after [GooglePlaceAutoCompleteTextField] resolves lat/lng.
/// No extra API call — the widget already hits Place Details when
/// `isLatLngRequired` is true.
class GooglePlacesService {
  GooglePlacesService._();

  static PlaceAddressDetails? fromPrediction(Prediction prediction) {
    final lat = double.tryParse(prediction.lat ?? '');
    final lng = double.tryParse(prediction.lng ?? '');
    if (lat == null || lng == null) return null;

    final address = prediction.description?.trim() ??
        [
          prediction.structuredFormatting?.mainText,
          prediction.structuredFormatting?.secondaryText,
        ].where((p) => p != null && p.trim().isNotEmpty).join(', ');

    if (address.isEmpty) return null;

    var city = '';
    var state = '';

    final terms = prediction.terms;
    if (terms != null && terms.isNotEmpty) {
      final values = terms
          .map((t) => t.value?.trim() ?? '')
          .where((v) => v.isNotEmpty)
          .toList();
      if (values.length >= 3) {
        city = values[values.length - 3];
        state = values[values.length - 2];
      } else if (values.length == 2) {
        city = values[0];
        state = values[1];
      }
    }

    if (city.isEmpty || state.isEmpty) {
      final parsed = _parseSecondaryText(
        prediction.structuredFormatting?.secondaryText,
      );
      if (city.isEmpty) city = parsed.city;
      if (state.isEmpty) state = parsed.state;
    }

    if (city.isEmpty || state.isEmpty) return null;

    return PlaceAddressDetails(
      address: address,
      city: city,
      state: state,
      lat: lat,
      long: lng,
    );
  }

  static ({String city, String state}) _parseSecondaryText(String? text) {
    if (text == null || text.trim().isEmpty) {
      return (city: '', state: '');
    }
    final parts = text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    if (parts.length >= 3) {
      return (city: parts[parts.length - 3], state: parts[parts.length - 2]);
    }
    if (parts.length == 2) {
      return (city: parts[0], state: parts[1]);
    }
    return (city: '', state: '');
  }
}
