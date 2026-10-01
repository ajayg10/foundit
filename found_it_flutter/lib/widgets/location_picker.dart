import 'package:flutter/material.dart';
import 'package:found_it_client/found_it_client.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import '../client.dart';
import '../screens/location_selector_screen.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'map_location_picker.dart';

/// Dynamic location & sub-area picker scoped to the user's active campus/workplace.
/// Integrates Google Maps + Places Autocomplete for venue selection, with a
/// zone/sub-area chip selector for precise area tagging.
class LocationPickerWidget extends StatelessWidget {
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

  IconData _getAreaIcon(String name) {
    final n = name.toLowerCase();
    if (n.contains('library')) return Icons.local_library_outlined;
    if (n.contains('cse') ||
        n.contains('building') ||
        n.contains('lab') ||
        n.contains('tower'))
      return Icons.domain_rounded;
    if (n.contains('canteen') ||
        n.contains('cafe') ||
        n.contains('food') ||
        n.contains('dining'))
      return Icons.restaurant_outlined;
    if (n.contains('hostel') || n.contains('dorm') || n.contains('hall'))
      return Icons.hotel_rounded;
    if (n.contains('sac') ||
        n.contains('activity') ||
        n.contains('gym') ||
        n.contains('sports'))
      return Icons.sports_tennis_rounded;
    if (n.contains('security') || n.contains('gate'))
      return Icons.shield_outlined;
    if (n.contains('terminal') ||
        n.contains('arrival') ||
        n.contains('departure'))
      return Icons.flight_takeoff_rounded;
    if (n.contains('baggage') || n.contains('claim'))
      return Icons.luggage_rounded;
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
                final label = '${activeLoc.name} — $spot';
                onLocationChanged(
                  null,
                  label,
                  activeLoc.latitude,
                  activeLoc.longitude,
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
    final initialPos = latitude != 0.0 && longitude != 0.0
        ? LatLng(latitude, longitude)
        : null;

    final result = await Navigator.of(context).push<MapLocationResult>(
      MaterialPageRoute(
        builder: (_) => MapLocationPickerScreen(
          initialPosition: initialPos,
        ),
        fullscreenDialog: true,
      ),
    );

    if (result != null) {
      final label = result.venueName.isNotEmpty
          ? result.venueName
          : result.address.split(',').first.trim();
      onLocationChanged(null, label, result.latitude, result.longitude);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (context, _) {
        final activeLoc = AppState.instance.currentLocation;
        final areas = AppState.instance.currentLocationAreas;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Primary Location Banner ──────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Primary Location',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF6366F1),
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          activeLoc?.name ?? 'Select Campus / Location',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF312E81),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
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
                        onLocationChanged(
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
                  border: Border.all(color: AppTheme.borderLight),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryDark.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.map_outlined,
                        color: AppTheme.primaryDark,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pin on Map',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textMain,
                            ),
                          ),
                          Text(
                            'Search venues or tap the map',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppTheme.textMuted,
                            ),
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
                        selectedAreaId == area.id ||
                        selectedLabel.contains(area.name);
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
                          final label = '${activeLoc.name} — ${area.name}';
                          final lat = area.latitude ?? activeLoc.latitude;
                          final lon = area.longitude ?? activeLoc.longitude;
                          onLocationChanged(area.id, label, lat, lon);
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
              Text(
                'No sub-areas configured for this location yet.',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.textMuted,
                ),
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
                  const Icon(
                    Icons.pin_drop_outlined,
                    size: 18,
                    color: AppTheme.primaryBlue,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      selectedLabel.isNotEmpty
                          ? selectedLabel
                          : 'Select an area above',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textMain,
                      ),
                    ),
                  ),
                  if (selectedLabel.isNotEmpty)
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
                            'Area Selected',
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
