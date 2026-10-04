import 'package:flutter/material.dart';
import 'package:found_it_client/found_it_client.dart';
import '../state/app_state.dart';
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
                        style: AppText.h3(context.colors.ink),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: context.colors.muted,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  AppSpacing.gap16,
                  AppTextField(
                    label: 'Place or Campus Name *',
                    controller: nameController,
                    hint: 'e.g. Stanford University or Microsoft Campus',
                    prefixIcon: const Icon(Icons.apartment_rounded, size: 18),
                  ),
                  AppSpacing.gap16,
                  Text(
                    'Place Category',
                    style: AppText.label(context.colors.ink),
                  ),
                  AppSpacing.gap8,
                  DropdownButtonFormField<String>(
                    value: dialogType,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.category_outlined, size: 18),
                      filled: true,
                      fillColor: context.colors.surface,
                      border: OutlineInputBorder(
                        borderRadius: AppRadius.buttonBr,
                        borderSide: BorderSide(color: context.colors.line),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: AppRadius.buttonBr,
                        borderSide: BorderSide(color: context.colors.line),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: AppRadius.buttonBr,
                        borderSide: BorderSide(
                          color: context.colors.brand,
                          width: 2,
                        ),
                      ),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'campus',
                        child: Text(
                          '🎓 College / University Campus',
                          style: AppText.body(context.colors.ink),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'office',
                        child: Text(
                          '🏢 Office / Tech Park',
                          style: AppText.body(context.colors.ink),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'airport',
                        child: Text(
                          '✈️ Airport / Terminal',
                          style: AppText.body(context.colors.ink),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'metro',
                        child: Text(
                          '🚇 Metro / Transit Station',
                          style: AppText.body(context.colors.ink),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'mall',
                        child: Text(
                          '🛍️ Shopping Mall',
                          style: AppText.body(context.colors.ink),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'other',
                        child: Text(
                          '📍 Other Community Spot',
                          style: AppText.body(context.colors.ink),
                        ),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setModalState(() => dialogType = val);
                      }
                    },
                  ),
                  AppSpacing.gap16,
                  AppTextField(
                    label: 'Address, Landmark or City',
                    controller: addressController,
                    hint: 'e.g. Hauz Khas, New Delhi',
                    prefixIcon: const Icon(Icons.pin_drop_outlined, size: 18),
                  ),
                  AppSpacing.gap16,
                  AppTextField(
                    label: 'Short Description (Optional)',
                    controller: descController,
                    hint: 'e.g. Main academic and residential campus',
                    prefixIcon: const Icon(Icons.info_outline, size: 18),
                  ),
                  AppSpacing.gap24,
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      icon: Icons.add_location_alt_rounded,
                      label: 'Save & Set as My Location',
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
        final colors = context.colors;

        return AppScaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: colors.ink,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Select Campus or Place',
              style: AppText.h3(colors.ink),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.add_location_alt_outlined,
                  color: colors.brand,
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
                color: colors.bg,
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s16,
                  AppSpacing.s8,
                  AppSpacing.s16,
                  AppSpacing.s12,
                ),
                child: TextField(
                  controller: _searchController,
                  style: AppText.body(colors.ink),
                  onChanged: (_) => _loadLocations(),
                  decoration: InputDecoration(
                    hintText: 'Search college, airport, or workplace...',
                    hintStyle: AppText.body(colors.muted),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: colors.muted,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear_rounded,
                              color: colors.muted,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              _loadLocations();
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: colors.surface,
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.buttonBr,
                      borderSide: BorderSide(color: colors.line),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: AppRadius.buttonBr,
                      borderSide: BorderSide(color: colors.line),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: AppRadius.buttonBr,
                      borderSide: BorderSide(color: colors.brand, width: 2),
                    ),
                  ),
                ),
              ),

              // Filter Chips
              Container(
                color: colors.bg,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s16,
                    vertical: AppSpacing.s8,
                  ),
                  child: Row(
                    children: _types.map((type) {
                      final isSelected = _selectedType == type;
                      final label = type == 'all'
                          ? 'All Places'
                          : type[0].toUpperCase() + type.substring(1);
                      return Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.s8),
                        child: AppChip(
                          label: label,
                          selected: isSelected,
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
              Divider(height: 1, color: colors.line),

              // Location List
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: colors.brand,
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
                        padding: const EdgeInsets.all(AppSpacing.s16),
                        itemCount: locations.length,
                        separatorBuilder: (_, __) => AppSpacing.gap12,
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
                            borderRadius: AppRadius.panelBr,
                            child: Container(
                              padding: const EdgeInsets.all(AppSpacing.s16),
                              decoration: BoxDecoration(
                                color: colors.surface,
                                borderRadius: AppRadius.panelBr,
                                border: Border.all(
                                  color: isCurrent ? colors.brand : colors.line,
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
                                  AppSpacing.hGap16,

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
                                                style: AppText.label(
                                                  colors.ink,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: AppSpacing.s8,
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
                                                style:
                                                    AppText.caption(
                                                      typeColor,
                                                    ).copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 0.5,
                                                      fontSize: 10,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (loc.address != null &&
                                            loc.address!.isNotEmpty) ...[
                                          AppSpacing.gap4,
                                          Text(
                                            loc.address!,
                                            style: AppText.caption(
                                              colors.muted,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                        if (loc.description != null &&
                                            loc.description!.isNotEmpty) ...[
                                          AppSpacing.gap4,
                                          Text(
                                            loc.description!,
                                            style: AppText.caption(
                                              colors.muted.withOpacity(0.7),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  AppSpacing.hGap12,

                                  // Selected checkmark or chevron
                                  if (isCurrent)
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: colors.brand,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.check_rounded,
                                        color: colors.onBrand,
                                        size: 16,
                                      ),
                                    )
                                  else
                                    Icon(
                                      Icons.chevron_right_rounded,
                                      color: colors.muted,
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
