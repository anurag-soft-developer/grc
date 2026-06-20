import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grc/components/shared/custom_text_field.dart';
import 'package:grc/core/config/app_colors.dart';
import 'package:grc/core/services/places_service.dart';

typedef OnLocationChanged =
    void Function({
      required String address,
      required String city,
      required String state,
      double? latitude,
      double? longitude,
    });

class EventLocationFields extends StatefulWidget {
  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final OnLocationChanged onLocationChanged;
  final List<String> countries;
  final String? Function(String?)? addressValidator;
  final String? Function(String?)? cityValidator;
  final String? Function(String?)? stateValidator;

  const EventLocationFields({
    super.key,
    required this.addressController,
    required this.cityController,
    required this.stateController,
    required this.onLocationChanged,
    this.countries = const ['in'],
    this.addressValidator,
    this.cityValidator,
    this.stateValidator,
  });

  @override
  State<EventLocationFields> createState() => _EventLocationFieldsState();
}

class _EventLocationFieldsState extends State<EventLocationFields> {
  static const _debounceDuration = Duration(milliseconds: 600);
  static const _dropdownMaxHeight = 240.0;

  final FocusNode _addressFocusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _addressFieldKey = GlobalKey();
  Timer? _debounceTimer;
  Timer? _hideOverlayTimer;
  OverlayEntry? _overlayEntry;
  List<PlacePrediction> _predictions = [];
  bool _isLoading = false;
  bool _isSelecting = false;
  int _searchGeneration = 0;

  @override
  void initState() {
    super.initState();
    widget.addressController.addListener(_onAddressControllerChanged);
    widget.cityController.addListener(_notifyManualChange);
    widget.stateController.addListener(_notifyManualChange);
    _addressFocusNode.addListener(_onAddressFocusChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _hideOverlayTimer?.cancel();
    _removeOverlay();
    widget.addressController.removeListener(_onAddressControllerChanged);
    widget.cityController.removeListener(_notifyManualChange);
    widget.stateController.removeListener(_notifyManualChange);
    _addressFocusNode.removeListener(_onAddressFocusChanged);
    _addressFocusNode.dispose();
    super.dispose();
  }

  void _onAddressControllerChanged() {
    if (_isSelecting || !_addressFocusNode.hasFocus) return;
    final text = widget.addressController.text;
    _syncLocationValues(address: text);
    _scheduleSearch(text);
  }

  void _onAddressFocusChanged() {
    if (_addressFocusNode.hasFocus) {
      _hideOverlayTimer?.cancel();
      return;
    }

    if (_isSelecting) return;

    // Delay so a tap on the dropdown can register before the overlay is removed.
    _hideOverlayTimer?.cancel();
    _hideOverlayTimer = Timer(const Duration(milliseconds: 200), () {
      if (!mounted || _addressFocusNode.hasFocus || _isSelecting) return;
      _removeOverlay();
      _syncLocationValues();
    });
  }

  void _notifyManualChange() {
    if (_isSelecting) return;
    _syncLocationValues();
  }

  void _syncLocationValues({String? address}) {
    widget.onLocationChanged(
      address: address ?? widget.addressController.text,
      city: widget.cityController.text,
      state: widget.stateController.text,
      latitude: null,
      longitude: null,
    );
  }

  void _scheduleSearch(String value) {
    _debounceTimer?.cancel();
    final trimmed = value.trim();

    if (trimmed.length < 2) {
      _searchGeneration++;
      setState(() {
        _predictions = [];
        _isLoading = false;
      });
      _removeOverlay();
      return;
    }

    _debounceTimer = Timer(_debounceDuration, () {
      _runSearch(trimmed);
    });
  }

  Future<void> _runSearch(String input) async {
    final generation = ++_searchGeneration;
    setState(() => _isLoading = true);

    final predictions = await PlacesService.instance.autocomplete(
      input: input,
      countries: widget.countries,
    );

    if (!mounted || generation != _searchGeneration) return;

    setState(() {
      _predictions = predictions;
      _isLoading = false;
    });

    if (!_addressFocusNode.hasFocus) {
      _removeOverlay();
      return;
    }

    if (predictions.isEmpty) {
      _removeOverlay();
      return;
    }

    _showOverlay();
  }

  Future<void> _onPredictionSelected(PlacePrediction prediction) async {
    if (_isSelecting) return;

    _isSelecting = true;
    _hideOverlayTimer?.cancel();
    _debounceTimer?.cancel();
    _searchGeneration++;
    _removeOverlay();

    widget.addressController.text = prediction.description;
    widget.cityController.text = '';
    widget.stateController.text = '';

    final details = await PlacesService.instance.details(
      placeId: prediction.placeId,
    );

    if (!mounted) return;

    final address = details?.address ?? prediction.description;
    final city = details?.city ?? '';
    final state = details?.state ?? '';

    widget.addressController.text = address;
    widget.cityController.text = city;
    widget.stateController.text = state;

    widget.onLocationChanged(
      address: address,
      city: city,
      state: state,
      latitude: details?.lat,
      longitude: details?.long,
    );

    _isSelecting = false;
    if (_addressFocusNode.canRequestFocus) {
      _addressFocusNode.unfocus();
    }
  }

  void _showOverlay() {
    _hideOverlayTimer?.cancel();
    _removeOverlay();
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _hideOverlayTimer?.cancel();
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  double _addressFieldWidth() {
    final renderBox =
        _addressFieldKey.currentContext?.findRenderObject() as RenderBox?;
    return renderBox?.size.width ?? MediaQuery.sizeOf(context).width;
  }

  double _addressFieldHeight() {
    final renderBox =
        _addressFieldKey.currentContext?.findRenderObject() as RenderBox?;
    return renderBox?.size.height ?? 0;
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (overlayContext) {
        final width = _addressFieldWidth();
        final height = _addressFieldHeight();

        return CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, height + 4),
          child: Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 6,
              shadowColor: Colors.black26,
              color: Theme.of(overlayContext).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              clipBehavior: Clip.antiAlias,
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: width,
                    maxWidth: width,
                    maxHeight: _dropdownMaxHeight,
                  ),
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: _predictions.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final prediction = _predictions[index];
                      return Listener(
                        behavior: HitTestBehavior.opaque,
                        onPointerDown: (_) => _onPredictionSelected(prediction),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 2),
                                child: Icon(
                                  Icons.place_outlined,
                                  size: 20,
                                  color: Color(AppColors.textSecondary),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      prediction.mainText,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Color(AppColors.text),
                                      ),
                                    ),
                                    if (prediction.secondaryText != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: Text(
                                          prediction.secondaryText!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color:
                                                Color(AppColors.textSecondary),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
        );
      },
    );
  }

  Widget? _buildAddressSuffixIcon() {
    if (!_isLoading) return null;
    return const Padding(
      padding: EdgeInsets.all(12),
      child: SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CompositedTransformTarget(
          key: _addressFieldKey,
          link: _layerLink,
          child: CustomTextField(
            controller: widget.addressController,
            focusNode: _addressFocusNode,
            labelText: 'Address',
            hintText: 'Search venue or address…',
            validator: widget.addressValidator,
            prefixIcon: const Icon(Icons.location_on_outlined),
            suffixIcon: _buildAddressSuffixIcon(),
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 640;
            final cityField = CustomTextField(
              controller: widget.cityController,
              labelText: 'City',
              hintText: 'Enter city',
              validator: widget.cityValidator,
            );
            final stateField = CustomTextField(
              controller: widget.stateController,
              labelText: 'State',
              hintText: 'Enter state',
              validator: widget.stateValidator,
            );

            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: cityField),
                  const SizedBox(width: 16),
                  Expanded(child: stateField),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                cityField,
                const SizedBox(height: 16),
                stateField,
              ],
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            'Pick a suggestion to auto-fill city and state, or enter them manually.',
            style: TextStyle(
              color: const Color(AppColors.textSecondary),
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
