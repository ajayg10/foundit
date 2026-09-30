import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../theme/app_theme.dart';

/// Result returned from the MapLocationPicker when the user confirms a location.
class MapLocationResult {
  final double latitude;
  final double longitude;
  final String address;
  final String? placeId;
  final String venueName;

  const MapLocationResult({
    required this.latitude,
    required this.longitude,
    required this.address,
    this.placeId,
    required this.venueName,
  });
}

/// Full-screen map location picker with:
/// - Google Places Autocomplete search bar
/// - Interactive map pin dragging
/// - "Use my current location" button
/// - Address reverse-geocoding via Places API
class MapLocationPickerScreen extends StatefulWidget {
  /// Your Google Maps/Places API key (from Google Cloud Console).
  final String apiKey;

  /// Initial position to show (defaults to India center if null).
  final LatLng? initialPosition;

  const MapLocationPickerScreen({
    super.key,
    required this.apiKey,
    this.initialPosition,
  });

  @override
  State<MapLocationPickerScreen> createState() => _MapLocationPickerScreenState();
}

class _MapLocationPickerScreenState extends State<MapLocationPickerScreen> {
  final Completer<GoogleMapController> _mapController = Completer();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  LatLng _selectedPosition = const LatLng(20.5937, 78.9629); // India center
  String _selectedAddress = 'Tap the map or search a location';
  String? _selectedPlaceId;
  String _venueName = '';

  bool _isLoadingLocation = false;
  bool _isLoadingAddress = false;
  List<Map<String, dynamic>> _suggestions = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialPosition != null) {
      _selectedPosition = widget.initialPosition!;
    }
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query.length >= 3) {
      _fetchAutocompleteSuggestions(query);
    } else {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
      });
    }
  }

  Future<void> _fetchAutocompleteSuggestions(String query) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/autocomplete/json'
      '?input=${Uri.encodeComponent(query)}'
      '&types=establishment|geocode'
      '&key=${widget.apiKey}',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final predictions = (data['predictions'] as List<dynamic>? ?? [])
            .map((p) => p as Map<String, dynamic>)
            .toList();
        if (mounted) {
          setState(() {
            _suggestions = predictions;
            _showSuggestions = predictions.isNotEmpty;
          });
        }
      }
    } catch (_) {
      // Silently ignore — user can still tap map
    }
  }

  Future<void> _selectSuggestion(Map<String, dynamic> suggestion) async {
    final placeId = suggestion['place_id'] as String;
    final description = suggestion['description'] as String;

    setState(() {
      _showSuggestions = false;
      _selectedPlaceId = placeId;
      _searchController.text = description;
      _isLoadingAddress = true;
    });
    _searchFocus.unfocus();

    // Fetch place details to get coordinates
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json'
      '?place_id=$placeId'
      '&fields=geometry,name,formatted_address'
      '&key=${widget.apiKey}',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final result = data['result'] as Map<String, dynamic>;
        final location =
            (result['geometry'] as Map<String, dynamic>)['location'] as Map<String, dynamic>;
        final lat = (location['lat'] as num).toDouble();
        final lng = (location['lng'] as num).toDouble();
        final name = result['name'] as String? ?? description;
        final address = result['formatted_address'] as String? ?? description;

        final newPosition = LatLng(lat, lng);
        setState(() {
          _selectedPosition = newPosition;
          _selectedAddress = address;
          _venueName = name;
          _isLoadingAddress = false;
        });

        final controller = await _mapController.future;
        await controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: newPosition, zoom: 17),
          ),
        );
      }
    } catch (_) {
      setState(() => _isLoadingAddress = false);
    }
  }

  Future<void> _onMapTap(LatLng position) async {
    setState(() {
      _selectedPosition = position;
      _isLoadingAddress = true;
      _showSuggestions = false;
    });
    _searchFocus.unfocus();
    await _reverseGeocode(position);
  }

  Future<void> _reverseGeocode(LatLng position) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json'
      '?latlng=${position.latitude},${position.longitude}'
      '&key=${widget.apiKey}',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final results = data['results'] as List<dynamic>;
        if (results.isNotEmpty) {
          final first = results.first as Map<String, dynamic>;
          final address = first['formatted_address'] as String;
          // Extract a short venue name from address_components
          final components =
              first['address_components'] as List<dynamic>? ?? [];
          String venueName = '';
          for (final c in components) {
            final types = (c['types'] as List<dynamic>).cast<String>();
            if (types.contains('point_of_interest') ||
                types.contains('establishment') ||
                types.contains('premise')) {
              venueName = c['long_name'] as String;
              break;
            }
          }
          if (venueName.isEmpty && components.isNotEmpty) {
            venueName = components.first['long_name'] as String? ?? '';
          }
          if (mounted) {
            setState(() {
              _selectedAddress = address;
              _venueName = venueName;
              _isLoadingAddress = false;
              _searchController.text = address;
            });
          }
        } else {
          setState(() => _isLoadingAddress = false);
        }
      }
    } catch (_) {
      setState(() => _isLoadingAddress = false);
    }
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Location permission permanently denied. Please enable it in Settings.',
              ),
            ),
          );
        }
        setState(() => _isLoadingLocation = false);
        return;
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 10),
          ),
        );

        final newPosition = LatLng(position.latitude, position.longitude);
        setState(() {
          _selectedPosition = newPosition;
          _isLoadingAddress = true;
        });

        final controller = await _mapController.future;
        await controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: newPosition, zoom: 17),
          ),
        );

        await _reverseGeocode(newPosition);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not get location: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoadingLocation = false);
    }
  }

  void _confirm() {
    Navigator.of(context).pop(
      MapLocationResult(
        latitude: _selectedPosition.latitude,
        longitude: _selectedPosition.longitude,
        address: _selectedAddress,
        placeId: _selectedPlaceId,
        venueName: _venueName.isNotEmpty ? _venueName : _selectedAddress,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: Stack(
        children: [
          // ── Map ──────────────────────────────────────────────────────────
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _selectedPosition,
              zoom: widget.initialPosition != null ? 16 : 5,
            ),
            onMapCreated: (controller) => _mapController.complete(controller),
            onTap: _onMapTap,
            myLocationButtonEnabled: false,
            myLocationEnabled: false,
            zoomControlsEnabled: false,
            markers: {
              Marker(
                markerId: const MarkerId('selected'),
                position: _selectedPosition,
                draggable: true,
                onDragEnd: _onMapTap,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueViolet,
                ),
              ),
            },
          ),

          // ── Top Search Bar & Back Button ──────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  child: Row(
                    children: [
                      // Back button
                      Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        elevation: 4,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => Navigator.of(context).pop(),
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(Icons.arrow_back_rounded, size: 22),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Search field
                      Expanded(
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          elevation: 4,
                          child: TextField(
                            controller: _searchController,
                            focusNode: _searchFocus,
                            decoration: InputDecoration(
                              hintText: 'Search airport, college, mall…',
                              hintStyle: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppTheme.textMuted,
                              ),
                              prefixIcon: const Icon(
                                Icons.search_rounded,
                                color: AppTheme.primaryBlue,
                              ),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.close_rounded,
                                          size: 18),
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() {
                                          _showSuggestions = false;
                                          _suggestions = [];
                                        });
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 14),
                            ),
                            style: GoogleFonts.inter(fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Autocomplete Suggestions ──────────────────────────────
                if (_showSuggestions && _suggestions.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      elevation: 6,
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _suggestions.length.clamp(0, 5),
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1, indent: 16),
                        itemBuilder: (context, index) {
                          final s = _suggestions[index];
                          final main = (s['structured_formatting']
                                  as Map<String, dynamic>?)?['main_text'] as String? ??
                              s['description'] as String;
                          final secondary = (s['structured_formatting']
                                  as Map<String, dynamic>?)?['secondary_text'] as String? ??
                              '';
                          return InkWell(
                            onTap: () => _selectSuggestion(s),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              child: Row(
                                children: [
                                  const Icon(Icons.place_outlined,
                                      size: 20, color: AppTheme.primaryBlue),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(main,
                                            style: GoogleFonts.inter(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600)),
                                        if (secondary.isNotEmpty)
                                          Text(secondary,
                                              style: GoogleFonts.inter(
                                                  fontSize: 11,
                                                  color: AppTheme.textMuted),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis),
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
              ],
            ),
          ),

          // ── Current Location FAB ─────────────────────────────────────────
          Positioned(
            right: 16,
            bottom: 180,
            child: FloatingActionButton.small(
              heroTag: 'currentLocation',
              backgroundColor: Colors.white,
              onPressed: _isLoadingLocation ? null : _useCurrentLocation,
              child: _isLoadingLocation
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.my_location_rounded,
                      color: AppTheme.primaryBlue, size: 20),
            ),
          ),

          // ── Bottom Confirm Panel ─────────────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              padding: EdgeInsets.fromLTRB(
                  20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryDark.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.pin_drop_rounded,
                            color: AppTheme.primaryDark, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selected Location',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.textMuted,
                              ),
                            ),
                            _isLoadingAddress
                                ? const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  )
                                : Text(
                                    _selectedAddress,
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textMain,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryDark,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: _isLoadingAddress ? null : _confirm,
                      icon: const Icon(Icons.check_circle_rounded, size: 20),
                      label: Text(
                        'Confirm Location',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
