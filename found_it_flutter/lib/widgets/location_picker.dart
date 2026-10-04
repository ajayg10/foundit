import 'package:flutter/material.dart';
import 'package:found_it_client/found_it_client.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../screens/location_selector_screen.dart';
import '../state/app_state.dart';
import '../ui/ui.dart';
import 'map_location_picker.dart';

/// Dynamic location & sub-area picker scoped to the user's active campus/workplace.
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
    final colors = context.colors;
    final customController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Custom Spot / Area', style: AppText.h3(colors.ink)),
        content: AppTextField(
          label: 'Area description',
          controller: customController,
          hint: 'e.g. 3rd floor staircase near lab 2',
        ),
        actions: [
          AppButton(
            onPressed: () => Navigator.pop(ctx),
            label: 'Cancel',
            variant: AppButtonVariant.tertiary,
          ),
          AppButton(
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
            label: 'Select',
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
        await AppState.instance.selectLocation(matchedLoc);
      } else {
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
    final colors = context.colors;

    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (context, _) {
        final activeLoc = AppState.instance.currentLocation;
        final areas = AppState.instance.currentLocationAreas;

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
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s16,
                vertical: AppSpacing.s12,
              ),
              decoration: BoxDecoration(
                color: colors.brand.withAlpha(20),
                borderRadius: AppRadius.tileBr,
                border: Border.all(color: colors.brand.withAlpha(50)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.place_rounded,
                    color: colors.brand,
                    size: 22,
                  ),
                  AppSpacing.hGap12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Primary Location',
                              style: AppText.caption(colors.brand).copyWith(
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                            if (_isResolvingLocation) ...[
                              AppSpacing.hGap8,
                              SizedBox(
                                width: 10,
                                height: 10,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colors.brand,
                                ),
                              ),
                            ],
                          ],
                        ),
                        AppSpacing.gap4,
                        Text(
                          primaryTitle,
                          style: AppText.label(colors.ink).copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (_hasCustomMapPin &&
                            _pinnedVenue.isNotEmpty &&
                            _pinnedVenue.toLowerCase() !=
                                activeLoc?.name.toLowerCase()) ...[
                          AppSpacing.gap4,
                          Text(
                            '📍 Pin: $_pinnedVenue',
                            style: AppText.caption(colors.brand).copyWith(
                              fontWeight: FontWeight.w500,
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
                        horizontal: AppSpacing.s8,
                        vertical: AppSpacing.s4,
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
                    icon: Icon(
                      Icons.swap_horiz_rounded,
                      size: 16,
                      color: colors.brand,
                    ),
                    label: Text(
                      'Change',
                      style: AppText.caption(colors.brand).copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.gap12,

            // ── Pin on Map Button ────────────────────────────────────────
            InkWell(
              onTap: () => _openMapPicker(context),
              borderRadius: AppRadius.buttonBr,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s16,
                  vertical: AppSpacing.s12,
                ),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: AppRadius.buttonBr,
                  border: Border.all(
                    color: _hasCustomMapPin ? colors.success : colors.line,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.s8),
                      decoration: BoxDecoration(
                        color: _hasCustomMapPin
                            ? colors.success.withAlpha(20)
                            : colors.brand.withAlpha(25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _hasCustomMapPin
                            ? Icons.pin_drop_rounded
                            : Icons.map_outlined,
                        color: _hasCustomMapPin ? colors.success : colors.brand,
                        size: 18,
                      ),
                    ),
                    AppSpacing.hGap12,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _hasCustomMapPin
                                ? 'Pin on Map (Active)'
                                : 'Pin on Map',
                            style: AppText.label(colors.ink),
                          ),
                          Text(
                            _hasCustomMapPin && _pinnedVenue.isNotEmpty
                                ? _pinnedVenue
                                : 'Search venues or tap the map to drop a pin',
                            style: AppText.caption(
                              _hasCustomMapPin ? colors.success : colors.muted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: colors.muted,
                    ),
                  ],
                ),
              ),
            ),

            // ── Map Pin Active Pill & Reset ──────────────────────────────
            if (_hasCustomMapPin) ...[
              AppSpacing.gap8,
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s12,
                  vertical: AppSpacing.s8,
                ),
                decoration: BoxDecoration(
                  color: colors.success.withAlpha(20),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: colors.success.withAlpha(60)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.my_location_rounded,
                      size: 16,
                      color: colors.success,
                    ),
                    AppSpacing.hGap8,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Map Pin Coordinates Locked',
                            style: AppText.caption(colors.success).copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '${_pinnedLat.toStringAsFixed(4)}, ${_pinnedLon.toStringAsFixed(4)}${_pinnedAddress.isNotEmpty ? " • $_pinnedAddress" : (_pinnedVenue.isNotEmpty ? " • $_pinnedVenue" : "")}',
                            style: AppText.caption(colors.success).copyWith(
                              color: colors.success.withAlpha(200),
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
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.s4),
                          child: Icon(
                            Icons.close_rounded,
                            size: 16,
                            color: colors.success,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            AppSpacing.gap12,

            // ── Specific Sub-Area chips ──────────────────────────────────
            Text(
              'Specific Zone / Sub-Area *',
              style: AppText.label(colors.ink),
            ),
            AppSpacing.gap8,

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
                        color: isSelected ? colors.surface : colors.muted,
                      ),
                      label: Text(area.name),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected && activeLoc != null) {
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
                      selectedColor: colors.brand,
                      backgroundColor: colors.surface,
                      labelStyle:
                          AppText.caption(
                            isSelected ? colors.surface : colors.ink,
                          ).copyWith(
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: isSelected ? colors.brand : colors.line,
                        ),
                      ),
                    );
                  }),
                  // Custom spot chip
                  ActionChip(
                    avatar: Icon(
                      Icons.add_rounded,
                      size: 16,
                      color: colors.brand,
                    ),
                    label: const Text('Other Spot…'),
                    backgroundColor: colors.surface,
                    side: BorderSide(color: colors.line),
                    labelStyle: AppText.caption(colors.brand).copyWith(
                      fontWeight: FontWeight.w600,
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
                    avatar: Icon(
                      Icons.add_rounded,
                      size: 16,
                      color: colors.brand,
                    ),
                    label: const Text('Specify Spot / Zone…'),
                    backgroundColor: colors.surface,
                    side: BorderSide(color: colors.line),
                    labelStyle: AppText.caption(colors.brand).copyWith(
                      fontWeight: FontWeight.w600,
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
            AppSpacing.gap12,

            // ── Selected summary pill ────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s16,
                vertical: AppSpacing.s12,
              ),
              decoration: BoxDecoration(
                color: colors.bg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: colors.line),
              ),
              child: Row(
                children: [
                  Icon(
                    _hasCustomMapPin
                        ? Icons.pin_drop_rounded
                        : Icons.pin_drop_outlined,
                    size: 18,
                    color: _hasCustomMapPin ? colors.success : colors.brand,
                  ),
                  AppSpacing.hGap8,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.selectedLabel.isNotEmpty
                              ? widget.selectedLabel
                              : 'Select an area above or pin on map',
                          style: AppText.label(colors.ink),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (widget.latitude != 0.0 && widget.longitude != 0.0)
                          Text(
                            'Lat: ${widget.latitude.toStringAsFixed(4)}, Lon: ${widget.longitude.toStringAsFixed(4)}${_hasCustomMapPin ? " (Map Pin Locked)" : ""}',
                            style: AppText.caption(
                              _hasCustomMapPin ? colors.success : colors.muted,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (widget.selectedLabel.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.s8,
                        vertical: AppSpacing.s4,
                      ),
                      decoration: BoxDecoration(
                        color: colors.success.withAlpha(20),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 12,
                            color: colors.success,
                          ),
                          AppSpacing.hGap4,
                          Text(
                            _hasCustomMapPin ? 'Pin Locked' : 'Area Selected',
                            style: AppText.caption(colors.success).copyWith(
                              fontWeight: FontWeight.w600,
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
