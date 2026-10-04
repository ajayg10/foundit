import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../ui/ui.dart';

/// Result returned from the map picker.
class MapLocationResult {
  final double latitude;
  final double longitude;
  final String address;
  final String venueName;

  const MapLocationResult({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.venueName,
  });
}

/// Full-screen OpenStreetMap location picker.
///
/// Uses:
/// - flutter_map + OpenStreetMap tiles (100% free, no API key)
/// - Nominatim API for search autocomplete + reverse geocoding (free)
/// - Geolocator for "Use My Current Location"
class MapLocationPickerScreen extends StatefulWidget {
  final LatLng? initialPosition;

  const MapLocationPickerScreen({super.key, this.initialPosition});

  @override
  State<MapLocationPickerScreen> createState() =>
      _MapLocationPickerScreenState();
}

class _MapLocationPickerScreenState extends State<MapLocationPickerScreen> {
  // Default to India centre
  LatLng _pinPosition = const LatLng(20.5937, 78.9629);
  final MapController _mapController = MapController();
  final TextEditingController _searchCtrl = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  String _address = 'Tap the map or search a venue';
  String _venueName = '';
  bool _loadingAddress = false;
  bool _loadingLocation = false;

  List<Map<String, dynamic>> _suggestions = [];
  bool _showSuggestions = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    if (widget.initialPosition != null) {
      _pinPosition = widget.initialPosition!;
    }
    _searchCtrl.addListener(_onQueryChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.removeListener(_onQueryChanged);
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  // ── Search ───────────────────────────────────────────────────────────────

  void _onQueryChanged() {
    _debounce?.cancel();
    final q = _searchCtrl.text.trim();
    if (q.length < 3) {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
      });
      return;
    }
    _debounce = Timer(
      const Duration(milliseconds: 500),
      () => _nominatimSearch(q),
    );
  }

  Future<void> _nominatimSearch(String query) async {
    final uri = Uri.parse(
      'https://nominatim.openstreetmap.org/search'
      '?q=${Uri.encodeComponent(query)}'
      '&format=json'
      '&addressdetails=1'
      '&limit=6',
    );
    try {
      final res = await http.get(
        uri,
        headers: {'User-Agent': 'FoundItApp/1.0 (lost-and-found)'},
      );
      if (res.statusCode == 200 && mounted) {
        final data = json.decode(res.body) as List<dynamic>;
        setState(() {
          _suggestions = data.cast<Map<String, dynamic>>();
          _showSuggestions = _suggestions.isNotEmpty;
        });
      }
    } catch (_) {}
  }

  Future<void> _selectSuggestion(Map<String, dynamic> place) async {
    final lat = double.tryParse(place['lat'] as String? ?? '') ?? 0;
    final lon = double.tryParse(place['lon'] as String? ?? '') ?? 0;
    final displayName = place['display_name'] as String? ?? '';
    final nameField =
        (place['namedetails'] as Map?)?['name'] as String? ??
        (place['address'] as Map?)?['amenity'] as String? ??
        (place['address'] as Map?)?['building'] as String? ??
        displayName.split(',').first.trim();

    final pos = LatLng(lat, lon);
    setState(() {
      _pinPosition = pos;
      _address = displayName;
      _venueName = nameField;
      _showSuggestions = false;
      _searchCtrl.text = nameField;
    });
    _searchFocus.unfocus();
    _mapController.move(pos, 16);
  }

  // ── Tap on map ───────────────────────────────────────────────────────────

  Future<void> _onMapTap(TapPosition _, LatLng position) async {
    setState(() {
      _pinPosition = position;
      _loadingAddress = true;
      _showSuggestions = false;
    });
    _searchFocus.unfocus();
    await _reverseGeocode(position);
  }

  Future<void> _reverseGeocode(LatLng pos) async {
    final uri = Uri.parse(
      'https://nominatim.openstreetmap.org/reverse'
      '?lat=${pos.latitude}&lon=${pos.longitude}'
      '&format=json',
    );
    try {
      final res = await http.get(
        uri,
        headers: {'User-Agent': 'FoundItApp/1.0 (lost-and-found)'},
      );
      if (res.statusCode == 200 && mounted) {
        final data = json.decode(res.body) as Map<String, dynamic>;
        final display = data['display_name'] as String? ?? 'Selected location';
        final addr = data['address'] as Map? ?? {};
        final name =
            addr['amenity'] as String? ??
            addr['building'] as String? ??
            addr['tourism'] as String? ??
            addr['road'] as String? ??
            display.split(',').first.trim();
        setState(() {
          _address = display;
          _venueName = name;
          _loadingAddress = false;
          _searchCtrl.text = name;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingAddress = false);
    }
  }

  // ── Current location ─────────────────────────────────────────────────────

  Future<void> _useCurrentLocation() async {
    setState(() => _loadingLocation = true);
    try {
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Location permission denied. Enable it in device Settings.',
              ),
            ),
          );
        }
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 12),
        ),
      );
      final latlng = LatLng(pos.latitude, pos.longitude);
      setState(() {
        _pinPosition = latlng;
        _loadingAddress = true;
      });
      _mapController.move(latlng, 17);
      await _reverseGeocode(latlng);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not get location: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loadingLocation = false);
    }
  }

  // ── Confirm ──────────────────────────────────────────────────────────────

  void _confirm() {
    Navigator.of(context).pop(
      MapLocationResult(
        latitude: _pinPosition.latitude,
        longitude: _pinPosition.longitude,
        address: _address,
        venueName: _venueName.isNotEmpty
            ? _venueName
            : _address.split(',').first.trim(),
      ),
    );
  }

  // ── UI ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppScaffold(
      body: Stack(
        children: [
          // ── OpenStreetMap ────────────────────────────────────────────────
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _pinPosition,
              initialZoom: widget.initialPosition != null ? 16.0 : 5.0,
              onTap: _onMapTap,
            ),
            children: [
              // Free OSM tile layer — no API key
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.found_it_flutter',
                maxZoom: 19,
              ),
              // Pin marker
              MarkerLayer(
                markers: [
                  Marker(
                    point: _pinPosition,
                    width: 48,
                    height: 64,
                    child: Column(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: colors.brand,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colors.onBrand,
                              width: 2.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: colors.brand.withAlpha(100),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.place_rounded,
                            color: colors.onBrand,
                            size: 20,
                          ),
                        ),
                        // Pin tail
                        Container(
                          width: 3,
                          height: 16,
                          decoration: BoxDecoration(
                            color: colors.brand,
                            borderRadius: AppRadius.buttonBr,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Attribution (required by OSM)
              const RichAttributionWidget(
                attributions: [
                  TextSourceAttribution('© OpenStreetMap contributors'),
                ],
              ),
            ],
          ),

          // ── Search bar + back button ─────────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  child: Row(
                    children: [
                      // Back
                      Material(
                        color: colors.surface,
                        borderRadius: AppRadius.panelBr,
                        elevation: 4,
                        child: InkWell(
                          borderRadius: AppRadius.panelBr,
                          onTap: () => Navigator.of(context).pop(),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Icon(
                              Icons.arrow_back_rounded,
                              size: 22,
                              color: colors.ink,
                            ),
                          ),
                        ),
                      ),
                      AppSpacing.hGap12,
                      // Search
                      Expanded(
                        child: Material(
                          color: colors.surface,
                          borderRadius: AppRadius.panelBr,
                          elevation: 4,
                          child: TextField(
                            controller: _searchCtrl,
                            focusNode: _searchFocus,
                            decoration: InputDecoration(
                              hintText:
                                  'Search airport, college, mall, office…',
                              hintStyle: AppText.body(colors.muted),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: colors.brand,
                              ),
                              suffixIcon: _searchCtrl.text.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.close_rounded,
                                        size: 18,
                                        color: colors.ink,
                                      ),
                                      onPressed: () {
                                        _searchCtrl.clear();
                                        setState(() {
                                          _suggestions = [];
                                          _showSuggestions = false;
                                        });
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                            ),
                            style: AppText.body(colors.ink),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Autocomplete suggestions ─────────────────────────────
                if (_showSuggestions && _suggestions.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
                    child: Material(
                      color: colors.surface,
                      borderRadius: AppRadius.panelBr,
                      elevation: 6,
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _suggestions.length.clamp(0, 6),
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1, indent: 16),
                        itemBuilder: (context, i) {
                          final s = _suggestions[i];
                          final name = (s['display_name'] as String? ?? '')
                              .split(',')
                              .first
                              .trim();
                          final sub = s['display_name'] as String? ?? '';
                          final typeIcon = _iconForType(s['type'] as String?);
                          return InkWell(
                            onTap: () => _selectSuggestion(s),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    typeIcon,
                                    size: 20,
                                    color: colors.brand,
                                  ),
                                  AppSpacing.hGap12,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
                                          style: AppText.label(colors.ink),
                                        ),
                                        Text(
                                          sub,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppText.caption(colors.muted),
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
              ],
            ),
          ),

          // ── My Location FAB ──────────────────────────────────────────────
          Positioned(
            right: AppSpacing.s16,
            bottom: 190,
            child: FloatingActionButton.small(
              heroTag: 'myLoc',
              backgroundColor: colors.surface,
              onPressed: _loadingLocation ? null : _useCurrentLocation,
              tooltip: 'Use my location',
              child: _loadingLocation
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(
                      Icons.my_location_rounded,
                      color: colors.brand,
                      size: 20,
                    ),
            ),
          ),

          // ── Confirm panel ────────────────────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppRadius.panel),
                ),
                boxShadow: [
                  BoxShadow(
                    color: colors.scrim.withAlpha(30),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              padding: EdgeInsets.fromLTRB(
                AppSpacing.s20,
                AppSpacing.s16,
                AppSpacing.s20,
                MediaQuery.of(context).padding.bottom + AppSpacing.s16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colors.line,
                        borderRadius: AppRadius.pillBr,
                      ),
                    ),
                  ),
                  AppSpacing.gap16,
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colors.brand.withAlpha(25),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.pin_drop_rounded,
                          color: colors.brand,
                          size: 22,
                        ),
                      ),
                      AppSpacing.hGap12,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selected Location',
                              style: AppText.caption(colors.muted).copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (_loadingAddress)
                              const Padding(
                                padding: EdgeInsets.only(top: 4),
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            else
                              Text(
                                _venueName.isNotEmpty ? _venueName : _address,
                                style: AppText.label(colors.ink),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            if (_venueName.isNotEmpty)
                              Text(
                                _address
                                    .split(',')
                                    .skip(1)
                                    .take(2)
                                    .join(',')
                                    .trim(),
                                style: AppText.caption(colors.muted),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.gap16,
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      onPressed: _loadingAddress ? null : _confirm,
                      label: 'Confirm Location',
                      icon: Icons.check_circle_rounded,
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

  IconData _iconForType(String? type) {
    switch (type) {
      case 'aerodrome':
      case 'airport':
        return Icons.flight_rounded;
      case 'university':
      case 'college':
      case 'school':
        return Icons.school_rounded;
      case 'hospital':
      case 'clinic':
        return Icons.local_hospital_rounded;
      case 'mall':
      case 'department_store':
      case 'supermarket':
        return Icons.shopping_bag_rounded;
      case 'restaurant':
      case 'cafe':
      case 'fast_food':
        return Icons.restaurant_rounded;
      case 'bus_station':
      case 'train_station':
      case 'station':
        return Icons.train_rounded;
      case 'hotel':
        return Icons.hotel_rounded;
      default:
        return Icons.place_outlined;
    }
  }
}
