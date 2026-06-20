import 'package:grc/core/config/api_constants.dart';
import 'package:grc/core/services/api_service.dart';

class PlacePrediction {
  final String placeId;
  final String description;
  final String mainText;
  final String? secondaryText;

  const PlacePrediction({
    required this.placeId,
    required this.description,
    required this.mainText,
    this.secondaryText,
  });

  factory PlacePrediction.fromMap(Map<String, dynamic> map) {
    return PlacePrediction(
      placeId: map['placeId'] as String? ?? '',
      description: map['description'] as String? ?? '',
      mainText: map['mainText'] as String? ?? '',
      secondaryText: map['secondaryText'] as String?,
    );
  }
}

class PlaceDetails {
  final String placeId;
  final String address;
  final String city;
  final String state;
  final double? lat;
  final double? long;

  const PlaceDetails({
    required this.placeId,
    required this.address,
    required this.city,
    required this.state,
    this.lat,
    this.long,
  });

  factory PlaceDetails.fromMap(Map<String, dynamic> map) {
    return PlaceDetails(
      placeId: map['placeId'] as String? ?? '',
      address: map['address'] as String? ?? '',
      city: map['city'] as String? ?? '',
      state: map['state'] as String? ?? '',
      lat: _readDouble(map['lat']),
      long: _readDouble(map['long']),
    );
  }

  static double? _readDouble(dynamic value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return null;
  }
}

class PlacesService {
  PlacesService._();

  static final PlacesService instance = PlacesService._();
  final ApiService _api = ApiService();

  Future<List<PlacePrediction>> autocomplete({
    required String input,
    List<String> countries = const ['in'],
    String language = 'en',
  }) async {
    if (input.trim().length < 2) return [];

    final response = await _api.get<Map<String, dynamic>>(
      ApiConstants.places.autocomplete,
      queryParameters: {
        'input': input.trim(),
        'countries': countries.join(','),
        'language': language,
      },
    );

    final rawPredictions = response?['predictions'];
    if (rawPredictions is! List) return [];

    return rawPredictions
        .whereType<Map>()
        .map((item) => PlacePrediction.fromMap(Map<String, dynamic>.from(item)))
        .where((prediction) =>
            prediction.placeId.isNotEmpty && prediction.description.isNotEmpty)
        .toList();
  }

  Future<PlaceDetails?> details({
    required String placeId,
    String language = 'en',
  }) async {
    if (placeId.trim().isEmpty) return null;

    final response = await _api.get<Map<String, dynamic>>(
      ApiConstants.places.details,
      queryParameters: {
        'placeId': placeId.trim(),
        'language': language,
      },
    );

    if (response == null) return null;
    return PlaceDetails.fromMap(response);
  }
}
