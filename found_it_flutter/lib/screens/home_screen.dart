import 'package:flutter/material.dart';
import 'package:found_it_client/found_it_client.dart';
import '../client.dart';
import '../state/app_state.dart';
import '../ui/ui.dart';
import '../widgets/item_card.dart';
import '../widgets/metric_card.dart';
import 'location_selector_screen.dart';
import 'matches_screen.dart';
import 'dashboard_screen.dart';
import 'notifications_screen.dart';
import 'public_board_screen.dart';
import 'report_found_screen.dart';
import 'report_lost_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                      style: TextStyle(
                        color: colors.onBrand,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
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

              // Appearance toggle
              Text(
                'Appearance',
                style: AppText.caption(colors.muted).copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              AppSpacing.gap8,
              ListenableBuilder(
                listenable: ThemeModeController.instance,
                builder: (context, _) {
                  final mode = ThemeModeController.instance.mode;
                  return SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(
                        value: ThemeMode.system,
                        label: Text('System'),
                        icon: Icon(Icons.brightness_auto),
                      ),
                      ButtonSegment(
                        value: ThemeMode.light,
                        label: Text('Light'),
                        icon: Icon(Icons.light_mode),
                      ),
                      ButtonSegment(
                        value: ThemeMode.dark,
                        label: Text('Dark'),
                        icon: Icon(Icons.dark_mode),
                      ),
                    ],
                    selected: {mode},
                    onSelectionChanged: (set) =>
                        ThemeModeController.instance.setMode(set.first),
                    style: SegmentedButton.styleFrom(
                      backgroundColor: colors.surface,
                      selectedBackgroundColor: colors.brand.withAlpha(20),
                      foregroundColor: colors.muted,
                      selectedForegroundColor: colors.brand,
                    ),
                  );
                },
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
        final currentUser = AppState.instance.currentUser;
        final unreadCount = AppState.instance.unreadNotificationCount;
        final matches = AppState.instance.userMatches;
        final colors = context.colors;

        if (AppState.instance.currentLocation?.id != _lastLocationId) {
          _lastLocationId = AppState.instance.currentLocation?.id;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _loadRecent();
          });
        }

        return AppScaffold(
          appBar: AppBar(
            backgroundColor: colors.surface,
            elevation: 0.5,
            surfaceTintColor: Colors.transparent,
            toolbarHeight: 65,
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.s8),
                  decoration: BoxDecoration(
                    color: colors.brand,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.radar, color: colors.onBrand, size: 20),
                ),
                AppSpacing.hGap12,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Found It',
                      style: AppText.h2(
                        colors.ink,
                      ).copyWith(letterSpacing: -0.5),
                    ),
                    Text(
                      'Serverpod Hackathon MVP',
                      style: AppText.caption(colors.muted),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              // Active Campus / Location Pill
              InkWell(
                onTap: () async {
                  final changed = await Navigator.of(context).push<bool>(
                    MaterialPageRoute(
                      builder: (_) => const LocationSelectorScreen(),
                    ),
                  );
                  if (changed == true || mounted) {
                    _loadRecent();
                  }
                },
                borderRadius: AppRadius.pillBr,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colors.brand.withAlpha(20),
                    borderRadius: AppRadius.pillBr,
                    border: Border.all(color: colors.brand.withAlpha(50)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.place_rounded,
                        size: 15,
                        color: colors.brand,
                      ),
                      const SizedBox(width: 4),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 100),
                        child: Text(
                          AppState.instance.currentLocation?.name ?? 'Location',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.caption(colors.brand).copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.arrow_drop_down,
                        size: 16,
                        color: colors.brand,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 4),

              // Active Identity Pill
              InkWell(
                onTap: _showUserSwitcherSheet,
                borderRadius: AppRadius.pillBr,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: AppRadius.pillBr,
                    border: Border.all(color: colors.line),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: colors.brand,
                        child: Text(
                          currentUser.name.isNotEmpty
                              ? currentUser.name[0].toUpperCase()
                              : 'U',
                          style: TextStyle(
                            fontSize: 10,
                            color: colors.onBrand,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 80),
                        child: Text(
                          currentUser.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.caption(colors.ink).copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        size: 16,
                        color: colors.muted,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 6),

              // Notifications Bell with Badge
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined, size: 22),
                    tooltip: 'Notifications',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const NotificationsScreen(),
                        ),
                      );
                    },
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      right: 8,
                      top: 10,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: colors.error,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '$unreadCount',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              // Seed Demo Data Button
              IconButton(
                icon: Icon(
                  Icons.bolt,
                  color: colors.warning,
                  size: 22,
                ),
                tooltip: 'Seed Hackathon Demo Data',
                onPressed: () async {
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
              const SizedBox(width: 8),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero Section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.s24),
                      decoration: BoxDecoration(
                        color: colors.bg,
                        borderRadius: AppRadius.panelBr,
                        boxShadow: [
                          BoxShadow(
                            color: colors.ink.withAlpha(15),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'FOUND IT',
                            style: AppText.label(colors.muted).copyWith(
                              letterSpacing: 2.0,
                            ),
                          ),
                          AppSpacing.gap8,
                          Text(
                            'Lost something? Let\'s get it back.',
                            textAlign: TextAlign.center,
                            style: AppText.h1(colors.ink).copyWith(
                              letterSpacing: -0.5,
                            ),
                          ),
                          AppSpacing.gap8,
                          Text(
                            'AI-powered multi-signal matching for ${AppState.instance.currentLocation?.name ?? "campuses & offices"}. Reports are automatically matched in real time.',
                            textAlign: TextAlign.center,
                            style: AppText.body(colors.muted),
                          ),
                          AppSpacing.gap24,

                          // The Two Primary Action Cards (Prompt Section 16)
                          Row(
                            children: [
                              // I Lost Something
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const ReportLostScreen(),
                                          ),
                                        )
                                        .then((_) => _loadRecent());
                                  },
                                  borderRadius: AppRadius.tileBr,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: AppSpacing.s20,
                                      horizontal: AppSpacing.s16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colors.surface,
                                      borderRadius: AppRadius.tileBr,
                                      boxShadow: [
                                        BoxShadow(
                                          color: colors.ink.withAlpha(8),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(
                                            AppSpacing.s12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: colors.error.withAlpha(25),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.search,
                                            color: colors.error,
                                            size: 26,
                                          ),
                                        ),
                                        AppSpacing.gap12,
                                        Text(
                                          'I LOST',
                                          style: AppText.h3(colors.ink)
                                              .copyWith(
                                                letterSpacing: 0.5,
                                              ),
                                        ),
                                        Text(
                                          'SOMETHING',
                                          style: AppText.caption(colors.error)
                                              .copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),

                              // I Found Something
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const ReportFoundScreen(),
                                          ),
                                        )
                                        .then((_) => _loadRecent());
                                  },
                                  borderRadius: AppRadius.tileBr,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: AppSpacing.s20,
                                      horizontal: AppSpacing.s16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colors.surface,
                                      borderRadius: AppRadius.tileBr,
                                      boxShadow: [
                                        BoxShadow(
                                          color: colors.ink.withAlpha(8),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(
                                            AppSpacing.s12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: colors.success.withAlpha(25),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.check_circle_outline,
                                            color: colors.success,
                                            size: 26,
                                          ),
                                        ),
                                        AppSpacing.gap12,
                                        Text(
                                          'I FOUND',
                                          style: AppText.h3(colors.ink)
                                              .copyWith(
                                                letterSpacing: 0.5,
                                              ),
                                        ),
                                        Text(
                                          'SOMETHING',
                                          style: AppText.caption(colors.success)
                                              .copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Live Match Discovery Banner (if matches exist)
                    if (matches.isNotEmpty) ...[
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const MatchesScreen(),
                            ),
                          );
                        },
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
                      const SizedBox(height: 20),
                    ],

                    // Platform & Area Metrics
                    Row(
                      children: [
                        Expanded(
                          child: MetricCard(
                            label: 'Lost Reported',
                            value: '$_userLostCount',
                            subtitle: 'By you • Tap to view',
                            icon: Icons.search,
                            color: colors.error,
                            onTap: () {
                              Navigator.of(context)
                                  .push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const DashboardScreen(initialTab: 0),
                                    ),
                                  )
                                  .then((_) => _loadRecent());
                            },
                          ),
                        ),
                        AppSpacing.hGap12,
                        Expanded(
                          child: MetricCard(
                            label: 'Found Posted',
                            value: '$_areaFoundCount',
                            subtitle:
                                'In ${AppState.instance.currentLocation?.name ?? "this area"}',
                            icon: Icons.check_circle_outline,
                            color: colors.success,
                            onTap: () {
                              Navigator.of(context)
                                  .push(
                                    MaterialPageRoute(
                                      builder: (_) => const PublicBoardScreen(),
                                    ),
                                  )
                                  .then((_) => _loadRecent());
                            },
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.gap12,
                    Row(
                      children: [
                        Expanded(
                          child: MetricCard(
                            label: 'AI Matched',
                            value: '$_areaMatchedCount',
                            subtitle: 'Tap to view matches',
                            icon: Icons.auto_awesome,
                            color: colors.brand,
                            onTap: () {
                              Navigator.of(context)
                                  .push(
                                    MaterialPageRoute(
                                      builder: (_) => const MatchesScreen(),
                                    ),
                                  )
                                  .then((_) => _loadRecent());
                            },
                          ),
                        ),
                        AppSpacing.hGap12,
                        Expanded(
                          child: MetricCard(
                            label: 'Items Returned',
                            value: '$_areaReturnedCount',
                            subtitle: 'Resolved in area',
                            icon: Icons.handshake_outlined,
                            color: colors.success,
                            onTap: () {
                              Navigator.of(context)
                                  .push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const DashboardScreen(initialTab: 4),
                                    ),
                                  )
                                  .then((_) => _loadRecent());
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Found Near You Header
                    Row(
                      children: [
                        Column(
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
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push(
                                  MaterialPageRoute(
                                    builder: (_) => const PublicBoardScreen(),
                                  ),
                                )
                                .then((_) => _loadRecent());
                          },
                          child: const Text('View All Board'),
                        ),
                      ],
                    ),
                    AppSpacing.gap12,

                    // Found Items Cards
                    if (_isLoadingRecent)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
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
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const PublicBoardScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: AppBottomNav(
            selectedIndex: 0,
            onDestinationSelected: (index) {
              if (index == 1) {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (_) => const PublicBoardScreen(),
                      ),
                    )
                    .then((_) => _loadRecent());
              } else if (index == 2) {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(builder: (_) => const MatchesScreen()),
                    )
                    .then((_) => _loadRecent());
              } else if (index == 3) {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (_) => const DashboardScreen(),
                      ),
                    )
                    .then((_) => _loadRecent());
              }
            },
            destinations: [
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
            ],
          ),
        );
      },
    );
  }
}
