import 'package:flutter/material.dart';
import 'package:found_it_client/found_it_client.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

/// Screen allowing users to browse, search, select, or create active locations.
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
        return const Color(0xFF6366F1);
      case 'airport':
        return const Color(0xFF0EA5E9);
      case 'office':
        return const Color(0xFF10B981);
      case 'metro':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF8B5CF6);
    }
  }

  void _showAddLocationDialog() {
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final descController = TextEditingController();
    final latController = TextEditingController(text: '28.5456');
    final lonController = TextEditingController(text: '77.1926');
    String dialogType = 'campus';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              top: 24,
              left: 20,
              right: 20,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF1E293B),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Add New Location',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white70),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Location / Campus Name *',
                      labelStyle: const TextStyle(color: Colors.white70),
                      hintText: 'e.g. Stanford University or Google NYC',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                      filled: true,
                      fillColor: const Color(0xFF0F172A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: dialogType,
                    dropdownColor: const Color(0xFF0F172A),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Location Type',
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: const Color(0xFF0F172A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'campus', child: Text('🎓 Campus / University')),
                      DropdownMenuItem(value: 'office', child: Text('🏢 Office / Tech Park')),
                      DropdownMenuItem(value: 'airport', child: Text('✈️ Airport / Terminal')),
                      DropdownMenuItem(value: 'metro', child: Text('🚇 Metro / Transit')),
                      DropdownMenuItem(value: 'mall', child: Text('🛍️ Shopping Mall')),
                      DropdownMenuItem(value: 'other', child: Text('📍 Other Venue')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setModalState(() => dialogType = val);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: addressController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Full Address or Landmark',
                      labelStyle: const TextStyle(color: Colors.white70),
                      hintText: 'e.g. Hauz Khas, New Delhi',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                      filled: true,
                      fillColor: const Color(0xFF0F172A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Description / Notes',
                      labelStyle: const TextStyle(color: Colors.white70),
                      hintText: 'e.g. Main academic and residential campus',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                      filled: true,
                      fillColor: const Color(0xFF0F172A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: latController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Latitude',
                            labelStyle: const TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: const Color(0xFF0F172A),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: lonController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Longitude',
                            labelStyle: const TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: const Color(0xFF0F172A),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.add_location_alt_rounded),
                      label: const Text(
                        'Save & Set as Active Location',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () async {
                        final name = nameController.text.trim();
                        if (name.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter a location name')),
                          );
                          return;
                        }

                        final lat = double.tryParse(latController.text) ?? 28.5456;
                        final lon = double.tryParse(lonController.text) ?? 77.1926;

                        final newLoc = Location(
                          name: name,
                          type: dialogType,
                          address: addressController.text.trim(),
                          description: descController.text.trim(),
                          latitude: lat,
                          longitude: lon,
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
                            SnackBar(content: Text('Error creating location: $e')),
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
          backgroundColor: const Color(0xFF0F172A),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0F172A),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Select Campus or Location',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_rounded, color: AppTheme.primaryBlue),
                tooltip: 'Add New Location',
                onPressed: _showAddLocationDialog,
              ),
            ],
          ),
          body: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  onChanged: (_) => _loadLocations(),
                  decoration: InputDecoration(
                    hintText: 'Search campus, airport, office...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                    prefixIcon: const Icon(Icons.search_rounded, color: Colors.white54),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, color: Colors.white54),
                            onPressed: () {
                              _searchController.clear();
                              _loadLocations();
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: const Color(0xFF1E293B),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: _types.map((type) {
                    final isSelected = _selectedType == type;
                    final label = type == 'all'
                        ? 'All'
                        : type[0].toUpperCase() + type.substring(1);
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(label),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 13,
                        ),
                        backgroundColor: const Color(0xFF1E293B),
                        selectedColor: AppTheme.primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        side: BorderSide.none,
                        onSelected: (selected) {
                          setState(() => _selectedType = type);
                          _loadLocations();
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Location List
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: AppTheme.primaryBlue),
                      )
                    : locations.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.location_off_rounded,
                                    size: 56, color: Colors.white.withOpacity(0.3)),
                                const SizedBox(height: 12),
                                const Text(
                                  'No locations found',
                                  style: TextStyle(color: Colors.white70, fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton.icon(
                                  onPressed: _showAddLocationDialog,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryBlue,
                                  ),
                                  icon: const Icon(Icons.add_rounded),
                                  label: const Text('Add This Location'),
                                )
                              ],
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: locations.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
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
                                    color: const Color(0xFF1E293B),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isCurrent
                                          ? AppTheme.primaryBlue
                                          : Colors.white.withOpacity(0.08),
                                      width: isCurrent ? 2 : 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      // Type Icon badge
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: typeColor.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(12),
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
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    loc.name,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 2,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: typeColor.withOpacity(0.2),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Text(
                                                    loc.type.toUpperCase(),
                                                    style: TextStyle(
                                                      color: typeColor,
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.bold,
                                                      letterSpacing: 0.5,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (loc.address != null && loc.address!.isNotEmpty) ...[
                                              const SizedBox(height: 4),
                                              Text(
                                                loc.address!,
                                                style: TextStyle(
                                                  color: Colors.white.withOpacity(0.6),
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
                                                style: TextStyle(
                                                  color: Colors.white.withOpacity(0.4),
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
                                          padding: const EdgeInsets.all(4),
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
                                        Icon(
                                          Icons.chevron_right_rounded,
                                          color: Colors.white.withOpacity(0.3),
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
