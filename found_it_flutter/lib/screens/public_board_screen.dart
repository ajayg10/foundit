import 'package:flutter/material.dart';
import 'package:found_it_client/found_it_client.dart';
import 'package:intl/intl.dart';
import '../client.dart';
import '../state/app_state.dart';
import '../ui/ui.dart';
import '../widgets/item_card.dart';
import '../widgets/verification_dialog.dart';
import 'location_selector_screen.dart';

class PublicBoardScreen extends StatefulWidget {
  final bool isEmbedded;
  const PublicBoardScreen({super.key, this.isEmbedded = false});

  @override
  State<PublicBoardScreen> createState() => _PublicBoardScreenState();
}

class _PublicBoardScreenState extends State<PublicBoardScreen> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'All';
  List<ItemReport> _items = [];
  bool _isLoading = true;
  String? _error;

  final List<String> _categories = [
    'All',
    'Bags',
    'Electronics',
    'Keys',
    'Wallets & Purses',
    'Documents & IDs',
    'Clothing',
    'Jewelry & Accessories',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchItems() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final items = await client.report.listReports(
        locationId: AppState.instance.currentLocation?.id,
        reportType: 'found',
        category: _selectedCategory,
        searchQuery: _searchController.text.trim().isNotEmpty
            ? _searchController.text.trim()
            : null,
        limit: 50,
      );
      setState(() => _items = items);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showItemDetails(ItemReport item) async {
    final question = await client.verification.getVerificationQuestion(
      item.id!,
    );

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadius.sheetBr,
      ),
      builder: (ctx) {
        final colors = ctx.colors;

        return Padding(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colors.success.withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'FOUND ITEM',
                      style: AppText.caption(colors.success).copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  AppSpacing.hGap8,
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      border: Border.all(color: colors.line),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.category,
                      style: AppText.caption(colors.ink).copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.close, size: 20, color: colors.muted),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              AppSpacing.gap16,

              Text(
                item.title,
                style: AppText.h2(colors.ink),
              ),
              AppSpacing.gap8,

              Text(
                item.description,
                style: AppText.body(colors.muted).copyWith(
                  height: 1.5,
                ),
              ),
              AppSpacing.gap16,

              // Approximate Location Banner
              Container(
                padding: const EdgeInsets.all(AppSpacing.s12),
                decoration: BoxDecoration(
                  color: colors.bg,
                  borderRadius: AppRadius.tileBr,
                  border: Border.all(color: colors.line),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: colors.brand,
                      size: 20,
                    ),
                    AppSpacing.hGap8,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.locationLabel,
                            style: AppText.caption(colors.ink).copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Found on ${DateFormat('MMM d, yyyy • h:mm a').format(item.eventTime.toLocal())}',
                            style: AppText.caption(colors.muted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.gap20,

              // Claim Action
              if (question != null)
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      showDialog(
                        context: context,
                        builder: (_) => VerificationDialog(
                          reportId: item.id!,
                          itemTitle: item.title,
                          question: question,
                          onVerificationSuccess: _fetchItems,
                        ),
                      );
                    },
                    icon: Icons.verified_user_outlined,
                    label: 'Is this yours? Verify Ownership',
                  ),
                )
              else
                const EmptyState(
                  title: 'No Question Set',
                  body:
                      'No verification question set. Please visit Campus Lost & Found center.',
                  icon: Icons.help_outline,
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppScaffold(
      appBar: AppTopBar(
        title: 'Public Found Items',
        showBackButton: !widget.isEmbedded,
        actions: [
          InkWell(
            onTap: () async {
              final changed = await Navigator.of(context).push<bool>(
                MaterialPageRoute(
                  builder: (_) => const LocationSelectorScreen(),
                ),
              );
              if (changed == true || mounted) {
                _fetchItems();
              }
            },
            borderRadius: AppRadius.pillBr,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: colors.brand.withAlpha(20),
                borderRadius: AppRadius.pillBr,
                border: Border.all(color: colors.brand.withAlpha(50)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.place_rounded,
                    size: 14,
                    color: colors.brand,
                  ),
                  AppSpacing.hGap4,
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 110),
                    child: Text(
                      AppState.instance.currentLocation?.name ?? 'Location',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.caption(colors.brand).copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  AppSpacing.hGap4,
                  Icon(
                    Icons.arrow_drop_down,
                    size: 16,
                    color: colors.brand,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Clamp the filter header to at most 50% of the viewport height so
          // the list always has room on small/landscape screens.
          final maxHeaderHeight = constraints.maxHeight * 0.5;
          return Column(
            children: [
              // Search & Filters Header — height-capped and internally scrollable
              // to prevent overflow on landscape (844×390) or 2× text scale.
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxHeaderHeight),
                child: SingleChildScrollView(
                  child: Container(
                    color: colors.surface,
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.s16,
                      AppSpacing.s8,
                      AppSpacing.s16,
                      AppSpacing.s16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Search bar
                        AppTextField(
                          label: '',
                          controller: _searchController,
                          hint: 'Search by keyword, location, or item name...',
                          prefixIcon: const Icon(Icons.search, size: 20),
                          onSubmitted: (_) => _fetchItems(),
                          onChanged: (val) {
                            if (val.isEmpty) _fetchItems();
                          },
                        ),
                        AppSpacing.gap12,

                        // Category chips
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _categories.map((c) {
                              final isSelected = _selectedCategory == c;
                              return Padding(
                                padding: const EdgeInsets.only(
                                  right: AppSpacing.s8,
                                ),
                                child: AppChip(
                                  label: c,
                                  selected: isSelected,
                                  onSelected: (_) {
                                    setState(() => _selectedCategory = c);
                                    _fetchItems();
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        AppSpacing.gap12,

                        // Area scope indicator banner
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.s12,
                            vertical: AppSpacing.s8,
                          ),
                          decoration: BoxDecoration(
                            color: colors.success.withAlpha(20),
                            borderRadius: AppRadius.tileBr,
                            border: Border.all(
                              color: colors.success.withAlpha(50),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 15,
                                color: colors.success,
                              ),
                              AppSpacing.hGap8,
                              Expanded(
                                child: Text(
                                  'Showing found items in: ${AppState.instance.currentLocation?.name ?? "Current Area"} (${_items.length} items)',
                                  style:
                                      AppText.caption(
                                        colors.success,
                                      ).copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Items List — takes remaining space
              Expanded(
                child: _buildBody(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _items.isEmpty) {
      return const SkeletonList();
    }

    if (_error != null && _items.isEmpty) {
      return ErrorState(
        message: _error!,
        onRetry: _fetchItems,
      );
    }

    if (_items.isEmpty) {
      return const EmptyState(
        title: 'No found items found',
        body: 'Try clearing your search filters or check back later.',
        icon: Icons.inventory_2_outlined,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 600 ? 2 : 1;

        return RefreshIndicator(
          onRefresh: _fetchItems,
          child: GridView.builder(
            padding: const EdgeInsets.all(AppSpacing.s16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: AppSpacing.s12,
              crossAxisSpacing: AppSpacing.s12,
              mainAxisExtent: 168,
            ),
            itemCount: _items.length,
            itemBuilder: (context, index) {
              final item = _items[index];
              return ItemCard(
                report: item,
                onTap: () => _showItemDetails(item),
                trailing: Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: context.colors.muted,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
