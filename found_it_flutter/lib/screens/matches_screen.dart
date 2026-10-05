import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../ui/ui.dart';
import '../widgets/match_card.dart';

class MatchesScreen extends StatefulWidget {
  final bool isEmbedded;
  const MatchesScreen({super.key, this.isEmbedded = false});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (AppState.instance.userMatches.isEmpty) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      await AppState.instance.fetchUserMatches();
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final matches = AppState.instance.userMatches;

        return AppScaffold(
          appBar: AppTopBar(
            title: 'Possible Matches',
            showBackButton: !widget.isEmbedded,
            actions: [
              IconButton(
                icon: Icon(Icons.refresh, color: context.colors.ink),
                tooltip: 'Refresh Matches',
                onPressed: _loadData,
              ),
            ],
          ),
          body: _buildBody(matches),
        );
      },
    );
  }

  Widget _buildBody(List matches) {
    if (_isLoading && matches.isEmpty) {
      return const SkeletonList();
    }

    if (_error != null && matches.isEmpty) {
      return ErrorState(
        message: _error!,
        onRetry: _loadData,
      );
    }

    if (matches.isEmpty) {
      return EmptyState(
        title: 'No Matches Yet',
        body:
            'When someone reports an item matching your lost or found posts, Serverpod will rank them and notify you automatically.',
        icon: Icons.auto_awesome,
        actionLabel: 'Seed Hackathon Demo Data',
        onAction: () async {
          setState(() => _isLoading = true);
          await AppState.instance.resetDemoData();
          if (mounted) setState(() => _isLoading = false);
        },
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.s16),
        itemCount: matches.length,
        separatorBuilder: (_, __) => AppSpacing.gap16,
        itemBuilder: (context, index) {
          final match = matches[index];
          return MatchCard(
            matchDetails: match,
            currentUserId: AppState.instance.currentUser.userId,
            onVerified: _loadData,
          );
        },
      ),
    );
  }
}
