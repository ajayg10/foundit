import 'package:flutter/material.dart';
import 'package:found_it_client/found_it_client.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import '../screens/location_selector_screen.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'map_location_picker.dart';

/// Dynamic location & sub-area picker scoped to the user's active campus/workplace.
/// Integrates OpenStreetMap + Nominatim for map pin & venue selection, with
/// automatic synchronization to Primary Location and zone/sub-area chips that
/// preserve the precise map pin coordinates.
class LocationPickerWidget extends StatefulWidget {
  final String selectedLabel;
  final int? selectedAreaId;
  final double latitude;
  final double longitude;
  final Function(int? areaId, String label, double lat, double lon)
  onLocationChanged;

  const LocationPickerWidget({
    super.key,
    required this.selectedLabel,
    this.selectedAreaId,
    required this.latitude,
    required this.longitude,
    required this.onLocationChanged,
  });

  @override
  State<LocationPickerWidget> createState() => _LocationPickerWidgetState();
}

class _LocationPickerWidgetState extends State<LocationPickerWidget> {
  bool _hasCustomMapPin = false;
  double _pinnedLat = 0.0;
  double _pinnedLon = 0.0;
  String _pinnedVenue = '';
  String _pinnedAddress = '';
  bool _isResolvingLocation = false;

  @override
  void initState() {
    super.initState();
    _initFromWidget();
  }

  @override
  void didUpdateWidget(LocationPickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.latitude != widget.latitude ||
        oldWidget.longitude != widget.longitude) {
      _initFromWidget();
    }
  }

  void _initFromWidget() {
    if (widget.latitude != 0.0 && widget.longitude != 0.0) {
      _pinnedLat = widget.latitude;
      _pinnedLon = widget.longitude;
      final activeLoc = AppState.instance.currentLocation;
      if (activeLoc != null) {
        final dist = Geolocator.distanceBetween(
          widget.latitude,
          widget.longitude,
          activeLoc.latitude,
          activeLoc.longitude,
        );
        // If passed coordinates differ by more than 20 meters from campus default, mark as custom pin
        if (dist > 20.0) {
          _hasCustomMapPin = true;
          if (_pinnedVenue.isEmpty && widget.selectedLabel.isNotEmpty) {
            _pinnedVenue = widget.selectedLabel.split('—').first.trim();
          }
        }
      }
    }
  }

  IconData _getAreaIcon(String name) {
    final n = name.toLowerCase();
    if (n.contains('library')) return Icons.local_library_outlined;
    if (n.contains('cse') ||
        n.contains('building') ||
        n.contains('lab') ||
        n.contains('tower')) {
      return Icons.domain_rounded;
    }
    if (n.contains('canteen') ||
        n.contains('cafe') ||
        n.contains('food') ||
        n.contains('dining')) {
      return Icons.restaurant_outlined;
    }
    if (n.contains('hostel') || n.contains('dorm') || n.contains('hall')) {
      return Icons.hotel_rounded;
    }
    if (n.contains('sac') ||
        n.contains('activity') ||
        n.contains('gym') ||
        n.contains('sports')) {
      return Icons.sports_tennis_rounded;
    }
    if (n.contains('security') || n.contains('gate')) {
      return Icons.shield_outlined;
    }
    if (n.contains('terminal') ||
        n.contains('arrival') ||
        n.contains('departure')) {
      return Icons.flight_takeoff_rounded;
    }
    if (n.contains('baggage') || n.contains('claim')) {
      return Icons.luggage_rounded;
    }
    if (n.contains('parking')) return Icons.local_parking_rounded;
    return Icons.place_outlined;
  }

  void _showCustomAreaDialog(BuildContext context, Location activeLoc) {
    final customController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Custom Spot / Area'),
        content: TextField(
          controller: customController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'e.g. 3rd floor staircase near lab 2',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryDark,
            ),
            onPressed: () {
              final spot = customController.text.trim();
              if (spot.isNotEmpty) {
                final double finalLat = _hasCustomMapPin
                    ? _pinnedLat
                    : activeLoc.latitude;
                final double finalLon = _hasCustomMapPin
                    ? _pinnedLon
                    : activeLoc.longitude;

                final String base;
                if (_hasCustomMapPin &&
                    _pinnedVenue.isNotEmpty &&
                    _pinnedVenue.toLowerCase() !=
                        activeLoc.name.toLowerCase()) {
                  base = '${activeLoc.name} ($_pinnedVenue)';
                } else {
                  base = activeLoc.name;
                }

                final label = '$base — $spot';
                widget.onLocationChanged(
                  null,
                  label,
                  finalLat,
                  finalLon,
                );
                Navigator.pop(ctx);
              }
            },
            child: const Text('Select'),
          ),
        ],
      ),
    );
  }

  Future<void> _openMapPicker(BuildContext context) async {
    final activeLoc = AppState.instance.currentLocation;
    final initialPos = widget.latitude != 0.0 && widget.longitude != 0.0
        ? LatLng(widget.latitude, widget.longitude)
        : (activeLoc != null
              ? LatLng(activeLoc.latitude, activeLoc.longitude)
              : null);

    final result = await Navigator.of(context).push<MapLocationResult>(
      MaterialPageRoute(
        builder: (_) => MapLocationPickerScreen(
          initialPosition: initialPos,
        ),
        fullscreenDialog: true,
      ),
    );

    if (result == null) return;

    final venueName = result.venueName.isNotEmpty
        ? result.venueName
        : result.address.split(',').first.trim();

    setState(() {
      _hasCustomMapPin = true;
      _pinnedLat = result.latitude;
      _pinnedLon = result.longitude;
      _pinnedVenue = venueName;
      _pinnedAddress = result.address;
      _isResolvingLocation = true;
    });

    try {
      // 1. Check if the pin is near an existing registered location in AppState
      Location? matchedLoc;
      double minDistance = double.infinity;
      for (final loc in AppState.instance.locations) {
        final dist = Geolocator.distanceBetween(
          result.latitude,
          result.longitude,
          loc.latitude,
          loc.longitude,
        );
        if (dist < minDistance) {
          minDistance = dist;
          if (dist <= 2500 ||
              loc.name.toLowerCase() == venueName.toLowerCase()) {
            matchedLoc = loc;
          }
        }
      }

      if (matchedLoc != null) {
        // Matched an existing campus or registered location
        await AppState.instance.selectLocation(matchedLoc);
      } else {
        // Automatically create and select this new location so Primary Location updates immediately
        final cleanName = venueName.isNotEmpty
            ? venueName
            : 'Selected Location';
        final newLoc = Location(
          name: cleanName,
          type: 'other',
          address: result.address.isNotEmpty ? result.address : cleanName,
          latitude: result.latitude,
          longitude: result.longitude,
          isActive: true,
          createdAt: DateTime.now(),
        );
        try {
          await AppState.instance.createLocation(newLoc);
        } catch (_) {
          await AppState.instance.selectLocation(newLoc);
        }
      }
    } catch (e) {
      debugPrint('Sync map location error: $e');
    } finally {
      if (mounted) {
        setState(() => _isResolvingLocation = false);
      }
    }

    final currentLocName = AppState.instance.currentLocation?.name ?? venueName;
    final String label;
    if (venueName.isNotEmpty &&
        venueName.toLowerCase() != currentLocName.toLowerCase()) {
      label = '$currentLocName — $venueName';
    } else {
      label = currentLocName.isNotEmpty ? currentLocName : venueName;
    }

    widget.onLocationChanged(null, label, result.latitude, result.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (context, _) {
        final activeLoc = AppState.instance.currentLocation;
        final areas = AppState.instance.currentLocationAreas;

        // Primary title for the location banner
        final primaryTitle =
            activeLoc?.name ??
            (_pinnedVenue.isNotEmpty
                ? _pinnedVenue
                : 'Select Campus / Location');

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Primary Location Banner ──────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFC7D2FE)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.place_rounded,
                    color: Color(0xFF4F46E5),
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Primary Location',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF6366F1),
                                letterSpacing: 0.5,
                              ),
                            ),
                            if (_isResolvingLocation) ...[
                              const SizedBox(width: 8),
                              const SizedBox(
                                width: 10,
                                height: 10,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF6366F1),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          primaryTitle,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF312E81),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (_hasCustomMapPin &&
                            _pinnedVenue.isNotEmpty &&
                            _pinnedVenue.toLowerCase() !=
                                activeLoc?.name.toLowerCase()) ...[
                          const SizedBox(height: 1),
                          Text(
                            '📍 Pin: $_pinnedVenue',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF4F46E5),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const LocationSelectorScreen(),
                        ),
                      );
                      final newLoc = AppState.instance.currentLocation;
                      if (newLoc != null) {
                        setState(() {
                          _hasCustomMapPin = false;
                          _pinnedVenue = '';
                          _pinnedAddress = '';
                          _pinnedLat = newLoc.latitude;
                          _pinnedLon = newLoc.longitude;
                        });
                        widget.onLocationChanged(
                          null,
                          newLoc.name,
                          newLoc.latitude,
                          newLoc.longitude,
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.swap_horiz_rounded,
                      size: 16,
                      color: Color(0xFF4F46E5),
                    ),
                    label: Text(
                      'Change',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF4F46E5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // ── Pin on Map Button ────────────────────────────────────────
            InkWell(
              onTap: () => _openMapPicker(context),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _hasCustomMapPin
                        ? const Color(0xFF86EFAC)
                        : AppTheme.borderLight,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: _hasCustomMapPin
                            ? const Color(0xFFDCFCE7)
                            : AppTheme.primaryDark.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _hasCustomMapPin
                            ? Icons.pin_drop_rounded
                            : Icons.map_outlined,
                        color: _hasCustomMapPin
                            ? const Color(0xFF16A34A)
                            : AppTheme.primaryDark,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _hasCustomMapPin
                                ? 'Pin on Map (Active)'
                                : 'Pin on Map',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textMain,
                            ),
                          ),
                          Text(
                            _hasCustomMapPin && _pinnedVenue.isNotEmpty
                                ? _pinnedVenue
                                : 'Search venues or tap the map to drop a pin',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: _hasCustomMapPin
                                  ? const Color(0xFF15803D)
                                  : AppTheme.textMuted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppTheme.textMuted,
                    ),
                  ],
                ),
              ),
            ),

            // ── Map Pin Active Pill & Reset ──────────────────────────────
            if (_hasCustomMapPin) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFBBF7D0)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.my_location_rounded,
                      size: 15,
                      color: Color(0xFF16A34A),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Map Pin Coordinates Locked',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF15803D),
                            ),
                          ),
                          Text(
                            '${_pinnedLat.toStringAsFixed(4)}, ${_pinnedLon.toStringAsFixed(4)}${_pinnedAddress.isNotEmpty ? " • $_pinnedAddress" : (_pinnedVenue.isNotEmpty ? " • $_pinnedVenue" : "")}',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: const Color(0xFF166534),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Tooltip(
                      message: 'Reset to campus center coordinates',
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _hasCustomMapPin = false;
                            _pinnedVenue = '';
                            _pinnedAddress = '';
                          });
                          if (activeLoc != null) {
                            widget.onLocationChanged(
                              null,
                              activeLoc.name,
                              activeLoc.latitude,
                              activeLoc.longitude,
                            );
                          }
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.close_rounded,
                            size: 16,
                            color: Color(0xFF15803D),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 12),

            // ── Specific Sub-Area chips ──────────────────────────────────
            Text(
              'Specific Zone / Sub-Area *',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.textMain,
              ),
            ),
            const SizedBox(height: 8),

            if (areas.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...areas.map((area) {
                    final isSelected =
                        widget.selectedAreaId == area.id ||
                        widget.selectedLabel.contains(area.name);
                    return ChoiceChip(
                      avatar: Icon(
                        _getAreaIcon(area.name),
                        size: 16,
                        color: isSelected ? Colors.white : AppTheme.textMuted,
                      ),
                      label: Text(area.name),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected && activeLoc != null) {
                          // CRITICAL FIX: If map pin was chosen, keep exact map pin coordinates!
                          final double finalLat = _hasCustomMapPin
                              ? _pinnedLat
                              : (area.latitude ?? activeLoc.latitude);
                          final double finalLon = _hasCustomMapPin
                              ? _pinnedLon
                              : (area.longitude ?? activeLoc.longitude);

                          final String base;
                          if (_hasCustomMapPin &&
                              _pinnedVenue.isNotEmpty &&
                              _pinnedVenue.toLowerCase() !=
                                  activeLoc.name.toLowerCase() &&
                              !_pinnedVenue.toLowerCase().contains(
                                area.name.toLowerCase(),
                              )) {
                            base = '${activeLoc.name} ($_pinnedVenue)';
                          } else {
                            base = activeLoc.name;
                          }

                          final label = '$base — ${area.name}';
                          widget.onLocationChanged(
                            area.id,
                            label,
                            finalLat,
                            finalLon,
                          );
                        }
                      },
                      selectedColor: AppTheme.primaryDark,
                      backgroundColor: Colors.white,
                      labelStyle: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: isSelected ? Colors.white : AppTheme.textMain,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: isSelected
                              ? AppTheme.primaryDark
                              : AppTheme.borderLight,
                        ),
                      ),
                    );
                  }),
                  // Custom spot chip
                  ActionChip(
                    avatar: const Icon(
                      Icons.add_rounded,
                      size: 16,
                      color: AppTheme.primaryBlue,
                    ),
                    label: const Text('Other Spot…'),
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: AppTheme.borderLight),
                    labelStyle: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryBlue,
                    ),
                    onPressed: () {
                      if (activeLoc != null) {
                        _showCustomAreaDialog(context, activeLoc);
                      }
                    },
                  ),
                ],
              ),
            ] else ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ActionChip(
                    avatar: const Icon(
                      Icons.add_rounded,
                      size: 16,
                      color: AppTheme.primaryBlue,
                    ),
                    label: const Text('Specify Spot / Zone…'),
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: AppTheme.borderLight),
                    labelStyle: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryBlue,
                    ),
                    onPressed: () {
                      if (activeLoc != null) {
                        _showCustomAreaDialog(context, activeLoc);
                      }
                    },
                  ),
                ],
              ),
            ],
            const SizedBox(height: 10),

            // ── Selected summary pill ────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.borderLight),
              ),
              child: Row(
                children: [
                  Icon(
                    _hasCustomMapPin
                        ? Icons.pin_drop_rounded
                        : Icons.pin_drop_outlined,
                    size: 18,
                    color: _hasCustomMapPin
                        ? const Color(0xFF16A34A)
                        : AppTheme.primaryBlue,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.selectedLabel.isNotEmpty
                              ? widget.selectedLabel
                              : 'Select an area above or pin on map',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textMain,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (widget.latitude != 0.0 && widget.longitude != 0.0)
                          Text(
                            'Lat: ${widget.latitude.toStringAsFixed(4)}, Lon: ${widget.longitude.toStringAsFixed(4)}${_hasCustomMapPin ? " (Map Pin Locked)" : ""}',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: _hasCustomMapPin
                                  ? const Color(0xFF15803D)
                                  : AppTheme.textMuted,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (widget.selectedLabel.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.recoveryGreen.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            size: 12,
                            color: AppTheme.recoveryGreen,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _hasCustomMapPin ? 'Pin Locked' : 'Area Selected',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.recoveryGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
