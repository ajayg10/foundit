import 'package:flutter/material.dart';
import 'package:found_it_client/found_it_client.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../client.dart';
import '../theme/app_theme.dart';
import '../widgets/item_card.dart';
import '../widgets/verification_dialog.dart';

class PublicBoardScreen extends StatefulWidget {
  const PublicBoardScreen({super.key});

  @override
  State<PublicBoardScreen> createState() => _PublicBoardScreenState();
}

class _PublicBoardScreenState extends State<PublicBoardScreen> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'All';
  List<ItemReport> _items = [];
  bool _isLoading = true;

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
    setState(() => _isLoading = true);
    try {
      final items = await client.report.listReports(
        reportType: 'found',
        category: _selectedCategory,
        searchQuery: _searchController.text.trim().isNotEmpty
            ? _searchController.text.trim()
            : null,
        limit: 50,
      );
      setState(() => _items = items);
    } catch (e) {
      debugPrint('Error fetching public board: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showItemDetails(ItemReport item) async {
    final question = await client.verification.getVerificationQuestion(item.id!);

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.recoveryGreen.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'FOUND ITEM',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.recoveryGreen,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.category,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textMain,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              Text(
                item.title,
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textMain,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                item.description,
                style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textMuted, height: 1.5),
              ),
              const SizedBox(height: 16),

              // Approximate Location Banner (Privacy Rule #10)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.borderLight),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: AppTheme.primaryBlue, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.locationLabel,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textMain,
                            ),
                          ),
                          Text(
                            'Found on ${DateFormat('MMM d, yyyy • h:mm a').format(item.eventTime.toLocal())}',
                            style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Claim Action
              if (question != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
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
                    icon: const Icon(Icons.verified_user_outlined, size: 18),
                    label: const Text('Is this yours? Verify Ownership'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryDark,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'No verification question set. Please visit Campus Lost & Found center.',
                      style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textMuted),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Public Found Items Board',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          // Search & Filters Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by keyword, location, or item name...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              _fetchItems();
                            },
                          )
                        : null,
                    fillColor: const Color(0xFFF8FAFC),
                  ),
                  onSubmitted: (_) => _fetchItems(),
                ),
                const SizedBox(height: 12),

                // Category chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((c) {
                      final isSelected = _selectedCategory == c;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(c),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedCategory = c);
                              _fetchItems();
                            }
                          },
                          selectedColor: AppTheme.primaryDark,
                          backgroundColor: const Color(0xFFF1F5F9),
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
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Items List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _items.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.inventory_2_outlined, size: 48, color: AppTheme.textMuted),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No found items found',
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textMain,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Try clearing your search filters or check back later.',
                              style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textMuted),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _fetchItems,
                        child: ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: _items.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = _items[index];
                            return ItemCard(
                              report: item,
                              onTap: () => _showItemDetails(item),
                              trailing: const Icon(Icons.chevron_right, size: 20, color: AppTheme.textMuted),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
