import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class CampusLocation {
  final String label;
  final double latitude;
  final double longitude;
  final IconData icon;

  const CampusLocation({
    required this.label,
    required this.latitude,
    required this.longitude,
    required this.icon,
  });
}

const List<CampusLocation> campusPresets = [
  CampusLocation(
    label: 'Campus Library',
    latitude: 37.7749,
    longitude: -122.4194,
    icon: Icons.local_library_outlined,
  ),
  CampusLocation(
    label: 'Engineering Block',
    latitude: 37.7810,
    longitude: -122.4120,
    icon: Icons.biotech_outlined,
  ),
  CampusLocation(
    label: 'Student Union Cafeteria',
    latitude: 37.7760,
    longitude: -122.4180,
    icon: Icons.restaurant_outlined,
  ),
  CampusLocation(
    label: 'Parking Structure B',
    latitude: 37.7735,
    longitude: -122.4210,
    icon: Icons.local_parking_outlined,
  ),
  CampusLocation(
    label: 'Sports Complex & Gym',
    latitude: 37.7720,
    longitude: -122.4150,
    icon: Icons.fitness_center_outlined,
  ),
  CampusLocation(
    label: 'Central Courtyard',
    latitude: 37.7755,
    longitude: -122.4205,
    icon: Icons.park_outlined,
  ),
];

class LocationPickerWidget extends StatelessWidget {
  final String selectedLabel;
  final double latitude;
  final double longitude;
  final Function(String label, double lat, double lon) onLocationChanged;

  const LocationPickerWidget({
    super.key,
    required this.selectedLabel,
    required this.latitude,
    required this.longitude,
    required this.onLocationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.location_on, color: AppTheme.primaryBlue, size: 20),
            const SizedBox(width: 8),
            Text(
              'Location / Campus Spot',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textMain,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: campusPresets.map((loc) {
            final isSelected = selectedLabel == loc.label;
            return ChoiceChip(
              avatar: Icon(
                loc.icon,
                size: 16,
                color: isSelected ? Colors.white : AppTheme.textMuted,
              ),
              label: Text(loc.label),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onLocationChanged(loc.label, loc.latitude, loc.longitude);
                }
              },
              selectedColor: AppTheme.primaryDark,
              backgroundColor: Colors.white,
              labelStyle: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : AppTheme.textMain,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: isSelected ? AppTheme.primaryDark : AppTheme.borderLight,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.borderLight),
          ),
          child: Row(
            children: [
              const Icon(Icons.pin_drop_outlined, size: 18, color: AppTheme.primaryBlue),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  selectedLabel.isNotEmpty ? selectedLabel : 'Select location above',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textMain,
                  ),
                ),
              ),
              Text(
                '(${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)})',
                style: GoogleFonts.robotoMono(
                  fontSize: 11,
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
