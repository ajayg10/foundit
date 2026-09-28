import 'package:flutter/material.dart';
import 'package:found_it_client/found_it_client.dart';
import 'package:google_fonts/google_fonts.dart';
import '../client.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/item_card.dart';

class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({super.key});

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<ItemReport> _userReports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserReports();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUserReports() async {
    setState(() => _isLoading = true);
    try {
      final reports = await client.report.listUserReports(
        AppState.instance.currentUser.userId,
      );
      setState(() => _userReports = reports);
    } catch (e) {
      debugPrint('Error loading user reports: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lostReports = _userReports.where((r) => r.reportType == 'lost').toList();
    final foundReports = _userReports.where((r) => r.reportType == 'found').toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Activity & Reports',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryDark,
          unselectedLabelColor: AppTheme.textMuted,
          indicatorColor: AppTheme.primaryDark,
          indicatorWeight: 3,
          tabs: [
            Tab(text: 'Lost Items (${lostReports.length})'),
            Tab(text: 'Found Items (${foundReports.length})'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildReportList(lostReports, 'You haven\'t reported any lost items yet.'),
                _buildReportList(foundReports, 'You haven\'t posted any found items yet.'),
              ],
            ),
    );
  }

  Widget _buildReportList(List<ItemReport> reports, String emptyMessage) {
    if (reports.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.folder_open, size: 40, color: AppTheme.textMuted),
              ),
              const SizedBox(height: 16),
              Text(
                emptyMessage,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textMuted),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadUserReports,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: reports.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final report = reports[index];
          return ItemCard(
            report: report,
          );
        },
      ),
    );
  }
}
