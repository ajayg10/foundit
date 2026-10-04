import 'package:flutter/material.dart';
import 'package:found_it_client/found_it_client.dart';
import '../client.dart';
import '../state/app_state.dart';
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
    final colors = context.colors;

    return AppScaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: colors.brand,
            foregroundColor: colors.onBrand,
            title: Text(
              'My Dashboard',
              style: AppText.h3(colors.onBrand),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: _buildStatsHeader(colors),
            ),
            bottom: TabBar(
              controller: _tabController,
              labelColor: colors.onBrand,
              unselectedLabelColor: colors.onBrandMuted,
              indicatorColor: colors.onBrand,
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

  Widget _buildStatsHeader(AppSemantic colors) {
    return Container(
      decoration: BoxDecoration(
        color: colors.brand,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.s20,
            60,
            AppSpacing.s20,
            0,
          ),
          child: Row(
            children: [
              _statTile(
                '${_lostCount + _foundCount}',
                'Total\nReports',
                Icons.article_outlined,
                colors,
              ),
              AppSpacing.hGap12,
              _statTile(
                '$_matchedCount',
                'Matches\nFound',
                Icons.auto_awesome_rounded,
                colors,
              ),
              AppSpacing.hGap12,
              _statTile(
                '$_returnedCount',
                'Items\nReturned',
                Icons.check_circle_rounded,
                colors,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statTile(
    String value,
    String label,
    IconData icon,
    AppSemantic colors,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.s12,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: colors.onBrand.withAlpha(30),
          borderRadius: AppRadius.buttonBr,
          border: Border.all(color: colors.onBrand.withAlpha(50), width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: colors.onBrand, size: 22),
            AppSpacing.gap4,
            Text(
              value,
              style: AppText.h2(colors.onBrand),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppText.caption(
                colors.onBrandMuted,
              ).copyWith(fontSize: 10),
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
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s16,
              vertical: AppSpacing.s8,
            ),
            color: context.colors.surface,
            child: Row(
              children: [
                AppChip(
                  label: 'All (${allReports.length})',
                  selected: !_filterByCurrentLocation,
                  onSelected: (val) =>
                      setState(() => _filterByCurrentLocation = false),
                ),
                AppSpacing.hGap8,
                AppChip(
                  label:
                      '${activeLoc.name} (${allReports.where((r) => r.locationId == activeLoc.id).length})',
                  selected: _filterByCurrentLocation,
                  onSelected: (val) =>
                      setState(() => _filterByCurrentLocation = true),
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
                    padding: const EdgeInsets.all(AppSpacing.s16),
                    itemCount: filteredReports.length,
                    separatorBuilder: (_, __) => AppSpacing.gap12,
                    itemBuilder: (context, index) {
                      final report = filteredReports[index];
                      return Stack(
                        children: [
                          ItemCard(report: report),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: StatusBadge(status: report.status),
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
        padding: const EdgeInsets.all(AppSpacing.s16),
        itemCount: _matches.length,
        separatorBuilder: (_, __) => AppSpacing.gap12,
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
