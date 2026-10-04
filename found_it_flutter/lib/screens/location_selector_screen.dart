import 'package:flutter/material.dart';
import 'package:found_it_client/found_it_client.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../ui/ui.dart';

/// Clean, mobile-friendly screen allowing users to select or add their campus or workplace.
class LocationSelectorScreen extends StatefulWidget {
  const LocationSelectorScreen({super.key});

  @override
  State<LocationSelectorScreen> createState() => _LocationSelectorScreenState();
}

class _LocationSelectorScreenState extends State<LocationSelectorScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedType = 'all';
  bool _isLoading = false;

  final List<String> _types = [
    'all',
    'campus',
    'airport',
    'office',
    'metro',
    'other',
  ];

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadLocations() async {
    setState(() => _isLoading = true);
    await AppState.instance.fetchLocations(
      query: _searchController.text.trim().isNotEmpty
          ? _searchController.text.trim()
          : null,
      type: _selectedType == 'all' ? null : _selectedType,
    );
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'campus':
        return Icons.school_rounded;
      case 'airport':
        return Icons.flight_takeoff_rounded;
      case 'office':
        return Icons.business_rounded;
      case 'metro':
        return Icons.subway_rounded;
      case 'mall':
        return Icons.local_mall_rounded;
      default:
        return Icons.place_rounded;
    }
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'campus':
        return const Color(0xFF4F46E5);
      case 'airport':
        return const Color(0xFF0284C7);
      case 'office':
        return const Color(0xFF059669);
      case 'metro':
        return const Color(0xFFD97706);
      default:
        return const Color(0xFF7C3AED);
    }
  }

  void _showAddLocationDialog() {
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final descController = TextEditingController();
    String dialogType = 'campus';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              top: 24,
              left: 20,
              right: 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add New Campus or Place',
                        style: GoogleFonts.outfit(
                          color: AppTheme.textMain,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: AppTheme.textMuted,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    style: const TextStyle(color: AppTheme.textMain),
                    decoration: InputDecoration(
                      labelText: 'Place or Campus Name *',
                      hintText: 'e.g. Stanford University or Microsoft Campus',
                      prefixIcon: const Icon(
                        Icons.apartment_rounded,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    value: dialogType,
                    style: const TextStyle(color: AppTheme.textMain),
                    decoration: const InputDecoration(
                      labelText: 'Place Category',
                      prefixIcon: Icon(
                        Icons.category_outlined,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'campus',
                        child: Text('🎓 College / University Campus'),
                      ),
                      DropdownMenuItem(
                        value: 'office',
                        child: Text('🏢 Office / Tech Park'),
                      ),
                      DropdownMenuItem(
                        value: 'airport',
                        child: Text('✈️ Airport / Terminal'),
                      ),
                      DropdownMenuItem(
                        value: 'metro',
                        child: Text('🚇 Metro / Transit Station'),
                      ),
                      DropdownMenuItem(
                        value: 'mall',
                        child: Text('🛍️ Shopping Mall'),
                      ),
                      DropdownMenuItem(
                        value: 'other',
                        child: Text('📍 Other Community Spot'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setModalState(() => dialogType = val);
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: addressController,
                    style: const TextStyle(color: AppTheme.textMain),
                    decoration: InputDecoration(
                      labelText: 'Address, Landmark or City',
                      hintText: 'e.g. Hauz Khas, New Delhi',
                      prefixIcon: const Icon(
                        Icons.pin_drop_outlined,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: descController,
                    style: const TextStyle(color: AppTheme.textMain),
                    decoration: InputDecoration(
                      labelText: 'Short Description (Optional)',
                      hintText: 'e.g. Main academic and residential campus',
                      prefixIcon: const Icon(
                        Icons.info_outline,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryDark,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.add_location_alt_rounded),
                      label: Text(
                        'Save & Set as My Location',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () async {
                        final name = nameController.text.trim();
                        if (name.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter a location name'),
                            ),
                          );
                          return;
                        }

                        final newLoc = Location(
                          name: name,
                          type: dialogType,
                          address: addressController.text.trim().isNotEmpty
                              ? addressController.text.trim()
                              : 'Campus Facility',
                          description: descController.text.trim().isNotEmpty
                              ? descController.text.trim()
                              : 'Active lost and found location',
                          latitude: 28.5456,
                          longitude: 77.1926,
                          isActive: true,
                          createdAt: DateTime.now(),
                        );

                        try {
                          await AppState.instance.createLocation(newLoc);
                          if (mounted) {
                            Navigator.pop(ctx);
                            Navigator.pop(context, true);
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error creating location: $e'),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (context, _) {
        final currentLoc = AppState.instance.currentLocation;
        final locations = AppState.instance.locations;

        return Scaffold(
          backgroundColor: AppTheme.backgroundLight,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: AppTheme.textMain,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Select Campus or Place',
              style: GoogleFonts.outfit(
                color: AppTheme.textMain,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.add_location_alt_outlined,
                  color: AppTheme.primaryBlue,
                ),
                tooltip: 'Add New Place',
                onPressed: _showAddLocationDialog,
              ),
            ],
          ),
          body: Column(
            children: [
              // Search Bar
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: AppTheme.textMain),
                  onChanged: (_) => _loadLocations(),
                  decoration: InputDecoration(
                    hintText: 'Search college, airport, or workplace...',
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppTheme.textMuted,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear_rounded,
                              color: AppTheme.textMuted,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              _loadLocations();
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: const Color(0xFFF1F5F9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // Filter Chips
              Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: _types.map((type) {
                      final isSelected = _selectedType == type;
                      final label = type == 'all'
                          ? 'All Places'
                          : type[0].toUpperCase() + type.substring(1);
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          selected: isSelected,
                          label: Text(label),
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : AppTheme.textMain,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            fontSize: 13,
                          ),
                          backgroundColor: const Color(0xFFF8FAFC),
                          selectedColor: AppTheme.primaryDark,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? AppTheme.primaryDark
                                : AppTheme.borderLight,
                          ),
                          onSelected: (selected) {
                            setState(() => _selectedType = type);
                            _loadLocations();
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const Divider(height: 1, color: AppTheme.borderLight),

              // Location List
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryBlue,
                        ),
                      )
                    : locations.isEmpty
                    ? EmptyState(
                        title: 'No Locations',
                        body: 'No places found for "${_searchController.text}"',
                        icon: Icons.location_off_rounded,
                        actionLabel: 'Add This Location',
                        onAction: _showAddLocationDialog,
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: locations.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final loc = locations[index];
                          final isCurrent = currentLoc?.id == loc.id;
                          final typeColor = _getTypeColor(loc.type);

                          return InkWell(
                            onTap: () async {
                              await AppState.instance.selectLocation(loc);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Switched to ${loc.name}'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                                Navigator.pop(context, true);
                              }
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isCurrent
                                      ? AppTheme.primaryBlue
                                      : AppTheme.borderLight,
                                  width: isCurrent ? 2 : 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.02),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Type Icon badge
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: typeColor.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(
                                      _getTypeIcon(loc.type),
                                      color: typeColor,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 14),

                                  // Location Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                loc.name,
                                                style: GoogleFonts.outfit(
                                                  color: AppTheme.textMain,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: typeColor.withOpacity(
                                                  0.12,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                loc.type.toUpperCase(),
                                                style: GoogleFonts.inter(
                                                  color: typeColor,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (loc.address != null &&
                                            loc.address!.isNotEmpty) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            loc.address!,
                                            style: GoogleFonts.inter(
                                              color: AppTheme.textMuted,
                                              fontSize: 13,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                        if (loc.description != null &&
                                            loc.description!.isNotEmpty) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            loc.description!,
                                            style: GoogleFonts.inter(
                                              color: AppTheme.textMuted
                                                  .withOpacity(0.7),
                                              fontSize: 12,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),

                                  // Selected checkmark or chevron
                                  if (isCurrent)
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: const BoxDecoration(
                                        color: AppTheme.primaryBlue,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check_rounded,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    )
                                  else
                                    const Icon(
                                      Icons.chevron_right_rounded,
                                      color: AppTheme.borderLight,
                                      size: 20,
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
