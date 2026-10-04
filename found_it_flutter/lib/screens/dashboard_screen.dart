import 'package:flutter/material.dart';
import 'package:found_it_client/found_it_client.dart';
import 'package:google_fonts/google_fonts.dart';
import '../client.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../ui/ui.dart';
import '../widgets/item_card.dart';
import '../widgets/match_card.dart';

/// My Items Dashboard — shows all the user's activity in one place:
/// Lost | Found | Matches | Claims | Returned
class DashboardScreen extends StatefulWidget {
  final int initialTab;
  const DashboardScreen({super.key, this.initialTab = 0});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _filterByCurrentLocation = false;

  List<ItemReport> _userReports = [];
  List<MatchDetailsDto> _matches = [];
  bool _isLoading = true;

  // Stats
  int get _lostCount =>
      _userReports.where((r) => r.reportType == 'lost').length;
  int get _foundCount =>
      _userReports.where((r) => r.reportType == 'found').length;
  int get _matchedCount => _matches.length;
  int get _claimsCount =>
      _userReports.where((r) => r.status == 'claimPending').length;
  int get _returnedCount =>
      _userReports.where((r) => r.status == 'returned').length;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 5,
      vsync: this,
      initialIndex: widget.initialTab.clamp(0, 4),
    );
    _loadAll();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAll() async {
    setState(() => _isLoading = true);
    try {
      final userId = AppState.instance.currentUser.userId;
      final reports = await client.report.listUserReports(userId);
      final matches = await client.match.getUserMatches(userId);
      setState(() {
        _userReports = reports;
        _matches = matches;
      });
    } catch (e) {
      debugPrint('Dashboard load error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: AppTheme.primaryDark,
            foregroundColor: Colors.white,
            title: Text(
              'My Dashboard',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: _buildStatsHeader(),
            ),
            bottom: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              tabs: [
                Tab(text: 'Lost ($_lostCount)'),
                Tab(text: 'Found ($_foundCount)'),
                Tab(text: 'Matches ($_matchedCount)'),
                Tab(text: 'Claims ($_claimsCount)'),
                Tab(text: 'Returned ($_returnedCount)'),
              ],
            ),
          ),
        ],
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildReportList(
                    _userReports.where((r) => r.reportType == 'lost').toList(),
                    'No lost item reports yet.',
                    Icons.search_off_rounded,
                  ),
                  _buildReportList(
                    _userReports.where((r) => r.reportType == 'found').toList(),
                    'No found item reports yet.',
                    Icons.inventory_2_outlined,
                  ),
                  _buildMatchesList(),
                  _buildReportList(
                    _userReports
                        .where((r) => r.status == 'claimPending')
                        .toList(),
                    'No pending claims.',
                    Icons.pending_actions_outlined,
                  ),
                  _buildReportList(
                    _userReports.where((r) => r.status == 'returned').toList(),
                    'No returned items yet — keep going! 🎉',
                    Icons.check_circle_outline_rounded,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildStatsHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF4F46E5),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
          child: Row(
            children: [
              _statTile(
                '${_lostCount + _foundCount}',
                'Total\nReports',
                Icons.article_outlined,
              ),
              const SizedBox(width: 12),
              _statTile(
                '$_matchedCount',
                'Matches\nFound',
                Icons.auto_awesome_rounded,
              ),
              const SizedBox(width: 12),
              _statTile(
                '$_returnedCount',
                'Items\nReturned',
                Icons.check_circle_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statTile(String value, String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(height: 6),
            Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportList(
    List<ItemReport> allReports,
    String emptyMessage,
    IconData emptyIcon,
  ) {
    final activeLoc = AppState.instance.currentLocation;
    final filteredReports = _filterByCurrentLocation && activeLoc?.id != null
        ? allReports.where((r) => r.locationId == activeLoc!.id).toList()
        : allReports;

    return Column(
      children: [
        if (activeLoc != null && allReports.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                FilterChip(
                  label: Text('All (${allReports.length})'),
                  selected: !_filterByCurrentLocation,
                  onSelected: (val) =>
                      setState(() => _filterByCurrentLocation = false),
                  selectedColor: AppTheme.primaryDark,
                  labelStyle: TextStyle(
                    color: !_filterByCurrentLocation
                        ? Colors.white
                        : AppTheme.textMain,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  avatar: const Icon(Icons.place, size: 14),
                  label: Text(
                    '${activeLoc.name} (${allReports.where((r) => r.locationId == activeLoc.id).length})',
                  ),
                  selected: _filterByCurrentLocation,
                  onSelected: (val) =>
                      setState(() => _filterByCurrentLocation = true),
                  selectedColor: const Color(0xFF4F46E5),
                  labelStyle: TextStyle(
                    color: _filterByCurrentLocation
                        ? Colors.white
                        : AppTheme.textMain,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: filteredReports.isEmpty
              ? EmptyState(
                  title: 'No Reports',
                  body: emptyMessage,
                  icon: emptyIcon,
                )
              : RefreshIndicator(
                  onRefresh: _loadAll,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredReports.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final report = filteredReports[index];
                      return Stack(
                        children: [
                          ItemCard(report: report),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: _statusBadge(report.status),
                          ),
                        ],
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _statusBadge(String status) {
    final config = _statusConfig(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: config.$1.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: config.$1.withOpacity(0.3)),
      ),
      child: Text(
        config.$2,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: config.$1,
        ),
      ),
    );
  }

  (Color, String) _statusConfig(String status) {
    switch (status) {
      case 'open':
        return (Colors.blue, 'Open');
      case 'matched':
        return (Colors.orange, 'Matched');
      case 'claimPending':
        return (Colors.purple, 'Claim Pending');
      case 'verified':
        return (Colors.teal, 'Verified');
      case 'returned':
        return (AppTheme.recoveryGreen, 'Returned ✓');
      default:
        return (AppTheme.textMuted, status);
    }
  }

  Widget _buildMatchesList() {
    if (_matches.isEmpty) {
      return const EmptyState(
        title: 'No Matches',
        body: 'Keep your report open — we\'ll notify you!',
        icon: Icons.auto_awesome_outlined,
      );
    }
    return RefreshIndicator(
      onRefresh: _loadAll,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _matches.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final dto = _matches[index];
          return MatchCard(
            matchDetails: dto,
            currentUserId: AppState.instance.currentUser.userId,
          );
        },
      ),
    );
  }
}
