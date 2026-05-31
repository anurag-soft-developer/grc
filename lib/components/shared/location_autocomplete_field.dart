import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:grc/core/config/app_colors.dart';
import 'package:grc/core/config/env_config.dart';
import 'package:grc/core/services/google_places_service.dart';

typedef OnLocationSelected =
    void Function({
      required String address,
      required String city,
      required String state,
      required double latitude,
      required double longitude,
    });

class LocationAutocompleteField extends StatefulWidget {
  final TextEditingController controller;
  final OnLocationSelected onLocationSelected;
  final String labelText;
  final String hintText;
  final List<String> countries;

  const LocationAutocompleteField({
    super.key,
    required this.controller,
    required this.onLocationSelected,
    this.labelText = 'Location',
    this.hintText = 'Search for event location…',
    this.countries = const ['in'],
  });

  @override
  State<LocationAutocompleteField> createState() =>
      _LocationAutocompleteFieldState();
}

class _LocationAutocompleteFieldState extends State<LocationAutocompleteField> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _onPlaceSelected(Prediction prediction) {
    final details = GooglePlacesService.fromPrediction(prediction);
    if (details == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not resolve location. Try another place.'),
          ),
        );
      }
      return;
    }

    widget.onLocationSelected(
      address: details.address,
      city: details.city,
      state: details.state,
      latitude: details.lat,
      longitude: details.long,
    );

    if (_focusNode.canRequestFocus) _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            widget.labelText,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(AppColors.text),
            ),
          ),
        ),
        GooglePlaceAutoCompleteTextField(
          textEditingController: widget.controller,
          googleAPIKey: EnvConfig.googlePlacesApiKey,
          focusNode: _focusNode,
          textStyle: const TextStyle(color: Color(AppColors.text)),
          inputDecoration: InputDecoration(
            hintText: widget.hintText,
            suffixIcon: const Icon(Icons.location_on_outlined),
          ),
          debounceTime: 600,
          isLatLngRequired: true,
          countries: widget.countries,
          seperatedBuilder: const Divider(height: 1),
          itemBuilder: (context, index, prediction) {
            return ListTile(
              leading: const Icon(Icons.place_outlined),
              title: Text(
                prediction.structuredFormatting?.mainText ??
                    prediction.description ??
                    '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: prediction.structuredFormatting?.secondaryText != null
                  ? Text(
                      prediction.structuredFormatting!.secondaryText!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  : null,
            );
          },
          getPlaceDetailWithLatLng: _onPlaceSelected,
          itemClick: (_) => _focusNode.unfocus(),
        ),
      ],
    );
  }
}
