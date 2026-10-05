import 'package:flutter/material.dart';
import 'package:found_it_client/found_it_client.dart';
import '../client.dart';
import '../state/app_state.dart';
import '../ui/ui.dart';
import '../widgets/item_card.dart';
import 'matches_screen.dart';
import 'dashboard_screen.dart';
import 'public_board_screen.dart';
import 'report_found_screen.dart';
import 'report_lost_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;
  int _dashboardTab = 0;
  List<ItemReport> _recentFoundItems = [];
  bool _isLoadingRecent = true;
  int _areaFoundCount = 0;
  int _userLostCount = 0;
  int _areaMatchedCount = 0;
  int _areaReturnedCount = 0;
  int? _lastLocationId;

  @override
  void initState() {
    super.initState();
    _loadRecent();
  }

  Future<void> _loadRecent() async {
    setState(() => _isLoadingRecent = true);
    try {
      final locId = AppState.instance.currentLocation?.id;
      final userId = AppState.instance.currentUser.userId;

      // 1. Fetch found items in this area
      final foundInArea = await client.report.listReports(
        locationId: locId,
        reportType: 'found',
        limit: 50,
      );

      // 2. Fetch user's reports
      final userReports = await client.report.listUserReports(userId);
      final userLost = userReports
          .where((r) => r.reportType == 'lost')
          .toList();

      // 3. Fetch user matches
      final userMatches = await client.match.getUserMatches(userId);

      // 4. Fetch returned items in this area
      final returnedInArea = await client.report.listReports(
        locationId: locId,
        status: 'returned',
        limit: 50,
      );

      setState(() {
        _recentFoundItems = foundInArea.take(6).toList();
        _areaFoundCount = foundInArea.length;
        _userLostCount = userLost.length;
        _areaMatchedCount = userMatches.length;
        _areaReturnedCount = returnedInArea.length;
        _lastLocationId = locId;
      });
    } catch (e) {
      debugPrint('Error loading recent: $e');
    } finally {
      if (mounted) setState(() => _isLoadingRecent = false);
    }
  }

  void _showUserSwitcherSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadius.sheetBr,
      ),
      builder: (ctx) {
        final current = AppState.instance.currentUser;
        final colors = ctx.colors;

        return Padding(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: colors.brand,
                    radius: 20,
                    child: Text(
                      current.name.isNotEmpty
                          ? current.name[0].toUpperCase()
                          : 'U',
                      style: AppText.h3(colors.onBrand),
                    ),
                  ),
                  AppSpacing.hGap12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          current.name,
                          style: AppText.h3(colors.ink),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          current.email,
                          style: AppText.caption(colors.muted),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              AppSpacing.gap16,
              Divider(color: colors.line),
              AppSpacing.gap8,

              Text(
                'Demo Personas (Quick Switch)',
                style: AppText.caption(colors.muted).copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              AppSpacing.gap8,

              // Alice
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: colors.error.withAlpha(25),
                  child: Text(
                    'A',
                    style: TextStyle(
                      color: colors.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  'Alice Johnson (Phone A: Lost Backpack)',
                  style: AppText.body(
                    colors.ink,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'alice@campus.edu',
                  style: AppText.caption(colors.muted),
                ),
                trailing: current.userId == AppState.demoAlice.userId
                    ? Icon(
                        Icons.check_circle,
                        color: colors.success,
                      )
                    : null,
                onTap: () {
                  Navigator.of(ctx).pop();
                  AppState.instance.switchUser(AppState.demoAlice);
                  _loadRecent();
                },
              ),
              Divider(color: colors.line),

              // Bob
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: colors.success.withAlpha(25),
                  child: Text(
                    'B',
                    style: TextStyle(
                      color: colors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  'Bob Martinez (Phone B: Found Backpack)',
                  style: AppText.body(
                    colors.ink,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'bob@campus.edu',
                  style: AppText.caption(colors.muted),
                ),
                trailing: current.userId == AppState.demoBob.userId
                    ? Icon(
                        Icons.check_circle,
                        color: colors.success,
                      )
                    : null,
                onTap: () {
                  Navigator.of(ctx).pop();
                  AppState.instance.switchUser(AppState.demoBob);
                  _loadRecent();
                },
              ),
              AppSpacing.gap16,

              // Sign Out Button
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: 'Sign Out',
                  icon: Icons.logout_rounded,
                  variant: AppButtonVariant.secondary,
                  onPressed: () async {
                    Navigator.of(ctx).pop();
                    await AppState.instance.signOut();
                  },
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
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final matches = AppState.instance.userMatches;
        final colors = context.colors;

        final width = MediaQuery.of(context).size.width;
        final isTablet = width >= Breakpoints.compact;
        final isDesktop = width >= Breakpoints.medium;

        if (AppState.instance.currentLocation?.id != _lastLocationId) {
          _lastLocationId = AppState.instance.currentLocation?.id;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _loadRecent();
          });
        }

        final navDestinations = [
          const AppNavDestination(
            icon: Icons.home_outlined,
            selectedIcon: Icons.home,
            label: 'Home',
          ),
          const AppNavDestination(
            icon: Icons.grid_view_outlined,
            selectedIcon: Icons.grid_view,
            label: 'Public Board',
          ),
          AppNavDestination(
            icon: Icons.auto_awesome_outlined,
            selectedIcon: Icons.auto_awesome,
            label: 'Matches',
            badgeCount: matches.length,
          ),
          const AppNavDestination(
            icon: Icons.person_outline,
            selectedIcon: Icons.person,
            label: 'My Activity',
          ),
        ];

        void handleNav(int index, {int dashboardTab = 0}) {
          setState(() {
            _currentNavIndex = index;
            _dashboardTab = dashboardTab;
          });
          if (index == 0) {
            _loadRecent();
          }
        }

        Widget content = SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 32 : 20,
            vertical: 12,
          ),
          child: ContentConstraint(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top),
                BrandHeader(
                  onUserSwitch: _showUserSwitcherSheet,
                  onLocationChanged: () {
                    if (mounted) _loadRecent();
                  },
                  onDemoSeed: () async {
                    await AppState.instance.resetDemoData();
                    _loadRecent();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Demo scenario seeded! Check Public Board & Matches.',
                          ),
                        ),
                      );
                    }
                  },
                ),
                AppSpacing.gap24,
                TicketHero(
                  onLostTap: () {
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (_) => const ReportLostScreen(),
                          ),
                        )
                        .then((_) => _loadRecent());
                  },
                  onFoundTap: () {
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (_) => const ReportFoundScreen(),
                          ),
                        )
                        .then((_) => _loadRecent());
                  },
                ),
                AppSpacing.gap20,

                // Live Match Discovery Banner (if matches exist)
                if (matches.isNotEmpty) ...[
                  InkWell(
                    onTap: () => handleNav(2),
                    borderRadius: AppRadius.tileBr,
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.s16),
                      decoration: BoxDecoration(
                        color: colors.brand.withAlpha(20),
                        borderRadius: AppRadius.tileBr,
                        border: Border.all(
                          color: colors.brand.withAlpha(50),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.s8),
                            decoration: BoxDecoration(
                              color: colors.brand,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.auto_awesome,
                              color: colors.onBrand,
                              size: 22,
                            ),
                          ),
                          AppSpacing.hGap12,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${matches.length} Potential Match${matches.length == 1 ? '' : 'es'} Discovered!',
                                  style: AppText.h3(colors.ink),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Top match: ${(matches.first.match.confidenceScore * 100).round()}% confidence (${matches.first.lostReport.title} & ${matches.first.foundReport.title})',
                                  style: AppText.caption(colors.brand),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: colors.brand,
                          ),
                        ],
                      ),
                    ),
                  ),
                  AppSpacing.gap20,
                ],

                // Platform & Area Metrics
                StatBento(
                  matchedCount: _areaMatchedCount,
                  lostCount: _userLostCount,
                  foundCount: _areaFoundCount,
                  returnedCount: _areaReturnedCount,
                  locationName:
                      AppState.instance.currentLocation?.name ?? "this area",
                  onMatchesTap: () => handleNav(2),
                  onLostTap: () => handleNav(3, dashboardTab: 0),
                  onFoundTap: () => handleNav(1),
                  onReturnedTap: () => handleNav(3, dashboardTab: 4),
                ),
                AppSpacing.gap24,

                // Found Near You Header
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Found at ${AppState.instance.currentLocation?.name ?? "Campus"}',
                            style: AppText.h2(colors.ink),
                          ),
                          Text(
                            'Recently posted found items in this location',
                            style: AppText.caption(colors.muted),
                          ),
                        ],
                      ),
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 120),
                      child: TextButton(
                        onPressed: () => handleNav(1),
                        child: const Text(
                          'View All Board',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                AppSpacing.gap12,

                // Found Items Cards
                if (_isLoadingRecent)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.s32),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (_recentFoundItems.isEmpty)
                  const EmptyState(
                    title: 'No Items',
                    body:
                        'No items currently on the board. Post one or click Seed Demo Data!',
                    icon: Icons.inventory_2_outlined,
                  )
                else
                  Column(
                    children: _recentFoundItems
                        .map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ItemCard(
                              report: item,
                              onTap: () => handleNav(1),
                            ),
                          ),
                        )
                        .toList(),
                  ),
              ],
            ),
          ),
        );

        Widget activeBody;
        switch (_currentNavIndex) {
          case 1:
            activeBody = const PublicBoardScreen(isEmbedded: true);
            break;
          case 2:
            activeBody = const MatchesScreen(isEmbedded: true);
            break;
          case 3:
            activeBody = DashboardScreen(
              key: ValueKey('dashboard_$_dashboardTab'),
              initialTab: _dashboardTab,
              isEmbedded: true,
            );
            break;
          case 0:
          default:
            activeBody = content;
            break;
        }

        return PopScope(
          canPop: _currentNavIndex == 0,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop && _currentNavIndex != 0) {
              setState(() => _currentNavIndex = 0);
            }
          },
          child: AppScaffold(
            appBar: null,
            body: isDesktop
                ? Row(
                    children: [
                      AppNavRail(
                        selectedIndex: _currentNavIndex,
                        onDestinationSelected: handleNav,
                        destinations: navDestinations,
                        extended: true,
                      ),
                      Expanded(child: activeBody),
                    ],
                  )
                : activeBody,
            bottomNavigationBar: isDesktop
                ? null
                : AppBottomNav(
                    selectedIndex: _currentNavIndex,
                    onDestinationSelected: handleNav,
                    destinations: navDestinations,
                  ),
          ),
        );
      },
    );
  }
}
