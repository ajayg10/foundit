import 'package:flutter/material.dart';
import 'package:found_it_client/found_it_client.dart';
import 'package:google_fonts/google_fonts.dart';
import '../client.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/item_card.dart';
import '../widgets/metric_card.dart';
import 'matches_screen.dart';
import 'my_reports_screen.dart';
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

  @override
  void initState() {
    super.initState();
    _loadRecent();
  }

  Future<void> _loadRecent() async {
    setState(() => _isLoadingRecent = true);
    try {
      final items = await client.report.listReports(
        reportType: 'found',
        limit: 5,
      );
      setState(() => _recentFoundItems = items);
    } catch (e) {
      debugPrint('Error loading recent: $e');
    } finally {
      if (mounted) setState(() => _isLoadingRecent = false);
    }
  }

  void _showUserSwitcherSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final current = AppState.instance.currentUser;

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Demo Identity Switcher',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textMain,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Easily switch perspectives between Phone A (the person who lost an item) and Phone B (the finder) for testing the primary hackathon demo.',
                style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textMuted),
              ),
              const SizedBox(height: 20),

              // Alice
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: AppTheme.lostRed.withOpacity(0.12),
                  child: const Text('A', style: TextStyle(color: AppTheme.lostRed, fontWeight: FontWeight.bold)),
                ),
                title: Text(
                  'Alice Johnson (Phone A: Lost Backpack)',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text('alice@campus.edu'),
                trailing: current.userId == AppState.demoAlice.userId
                    ? const Icon(Icons.check_circle, color: AppTheme.recoveryGreen)
                    : null,
                onTap: () {
                  Navigator.of(ctx).pop();
                  AppState.instance.switchUser(AppState.demoAlice);
                  _loadRecent();
                },
              ),
              const Divider(),

              // Bob
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: AppTheme.recoveryGreen.withOpacity(0.12),
                  child: const Text('B', style: TextStyle(color: AppTheme.recoveryGreen, fontWeight: FontWeight.bold)),
                ),
                title: Text(
                  'Bob Martinez (Phone B: Found Backpack)',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text('bob@campus.edu'),
                trailing: current.userId == AppState.demoBob.userId
                    ? const Icon(Icons.check_circle, color: AppTheme.recoveryGreen)
                    : null,
                onTap: () {
                  Navigator.of(ctx).pop();
                  AppState.instance.switchUser(AppState.demoBob);
                  _loadRecent();
                },
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
        final stats = AppState.instance.stats;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // Modern App Bar
              SliverAppBar(
                floating: true,
                pinned: true,
                expandedHeight: 80,
                backgroundColor: Colors.white,
                elevation: 0,
                title: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryDark,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.radar, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Found It',
                          style: GoogleFonts.outfit(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            color: AppTheme.textMain,
                          ),
                        ),
                        Text(
                          'Serverpod Hackathon MVP',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                actions: [
                  // Active Identity Pill
                  InkWell(
                    onTap: _showUserSwitcherSheet,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.borderLight),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: 16,
                            color: currentUser.userId == AppState.demoAlice.userId
                                ? AppTheme.lostRed
                                : AppTheme.recoveryGreen,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            currentUser.userId == AppState.demoAlice.userId ? 'Alice' : 'Bob',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textMain,
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down, size: 16, color: AppTheme.textMuted),
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
                            MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                          );
                        },
                      ),
                      if (unreadCount > 0)
                        Positioned(
                          right: 8,
                          top: 10,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppTheme.lostRed,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
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
                    icon: const Icon(Icons.bolt, color: AppTheme.warningAmber, size: 22),
                    tooltip: 'Seed Hackathon Demo Data',
                    onPressed: () async {
                      await AppState.instance.resetDemoData();
                      _loadRecent();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Demo scenario seeded! Check Public Board & Matches.'),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ),

              // Body Content
              SliverToBoxAdapter(
                child: Padding(
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
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF0F172A).withOpacity(0.15),
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
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 2.0,
                                    color: const Color(0xFF94A3B8),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Lost something? Let\'s get it back.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.outfit(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'AI-powered multi-signal matching across college campus & offices. Reports are matched automatically in real time.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: const Color(0xFFCBD5E1),
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // The Two Primary Action Cards (Prompt Section 16)
                                Row(
                                  children: [
                                    // I Lost Something
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) => const ReportLostScreen(),
                                            ),
                                          ).then((_) => _loadRecent());
                                        },
                                        borderRadius: BorderRadius.circular(16),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.08),
                                                blurRadius: 12,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  color: AppTheme.lostRed.withOpacity(0.12),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.search,
                                                  color: AppTheme.lostRed,
                                                  size: 26,
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              Text(
                                                'I LOST',
                                                style: GoogleFonts.outfit(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w800,
                                                  color: AppTheme.textMain,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                              Text(
                                                'SOMETHING',
                                                style: GoogleFonts.outfit(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppTheme.lostRed,
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
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) => const ReportFoundScreen(),
                                            ),
                                          ).then((_) => _loadRecent());
                                        },
                                        borderRadius: BorderRadius.circular(16),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.08),
                                                blurRadius: 12,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  color: AppTheme.recoveryGreen.withOpacity(0.12),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.check_circle_outline,
                                                  color: AppTheme.recoveryGreen,
                                                  size: 26,
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              Text(
                                                'I FOUND',
                                                style: GoogleFonts.outfit(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w800,
                                                  color: AppTheme.textMain,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                              Text(
                                                'SOMETHING',
                                                style: GoogleFonts.outfit(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppTheme.recoveryGreen,
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
                                  MaterialPageRoute(builder: (_) => const MatchesScreen()),
                                );
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFEEF2FF), Color(0xFFE0E7FF)],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFFC7D2FE)),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: AppTheme.matchIndigo,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(Icons.auto_awesome, color: Colors.white, size: 22),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${matches.length} Potential Match${matches.length == 1 ? '' : 'es'} Discovered!',
                                            style: GoogleFonts.outfit(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF312E81),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Top match: ${(matches.first.match.confidenceScore * 100).round()}% confidence (${matches.first.lostReport.title} & ${matches.first.foundReport.title})',
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: const Color(0xFF4338CA),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.matchIndigo),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],

                          // Platform Metrics
                          if (stats != null) ...[
                            Row(
                              children: [
                                Expanded(
                                  child: MetricCard(
                                    label: 'Lost Reported',
                                    value: '${stats.totalLost}',
                                    icon: Icons.search,
                                    color: AppTheme.lostRed,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: MetricCard(
                                    label: 'Found Posted',
                                    value: '${stats.totalFound}',
                                    icon: Icons.check_circle_outline,
                                    color: AppTheme.recoveryGreen,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: MetricCard(
                                    label: 'AI Matched',
                                    value: '${stats.totalMatched}',
                                    icon: Icons.auto_awesome,
                                    color: AppTheme.matchIndigo,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: MetricCard(
                                    label: 'Items Returned',
                                    value: '${stats.totalReturned}',
                                    icon: Icons.handshake_outlined,
                                    color: const Color(0xFF0D9488),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Found Near You Header
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Found Near You',
                                    style: GoogleFonts.outfit(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.textMain,
                                    ),
                                  ),
                                  Text(
                                    'Recently posted found items on campus',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppTheme.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => const PublicBoardScreen()),
                                  ).then((_) => _loadRecent());
                                },
                                child: const Text('View All Board'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Found Items Cards
                          if (_isLoadingRecent)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(32),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          else if (_recentFoundItems.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppTheme.borderLight),
                              ),
                              child: Center(
                                child: Text(
                                  'No items currently on the board. Post one or click Seed Demo Data!',
                                  style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textMuted),
                                ),
                              ),
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _recentFoundItems.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final item = _recentFoundItems[index];
                                return ItemCard(
                                  report: item,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (_) => const PublicBoardScreen()),
                                    );
                                  },
                                );
                              },
                            ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            backgroundColor: Colors.white,
            elevation: 2,
            indicatorColor: const Color(0xFFF1F5F9),
            selectedIndex: 0,
            onDestinationSelected: (index) {
              if (index == 1) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PublicBoardScreen()),
                ).then((_) => _loadRecent());
              } else if (index == 2) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const MatchesScreen()),
                ).then((_) => _loadRecent());
              } else if (index == 3) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const MyReportsScreen()),
                ).then((_) => _loadRecent());
              }
            },
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home, color: AppTheme.primaryDark),
                label: 'Home',
              ),
              const NavigationDestination(
                icon: Icon(Icons.grid_view_outlined),
                selectedIcon: Icon(Icons.grid_view, color: AppTheme.primaryDark),
                label: 'Public Board',
              ),
              NavigationDestination(
                icon: Badge(
                  isLabelVisible: matches.isNotEmpty,
                  label: Text('${matches.length}'),
                  child: const Icon(Icons.auto_awesome_outlined),
                ),
                selectedIcon: const Icon(Icons.auto_awesome, color: AppTheme.matchIndigo),
                label: 'Matches',
              ),
              const NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person, color: AppTheme.primaryDark),
                label: 'My Activity',
              ),
            ],
          ),
        );
      },
    );
  }
}
