import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../ui/ui.dart';
import '../widgets/match_card.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final matches = AppState.instance.userMatches;

        final colors = context.colors;

        return AppScaffold(
          appBar: AppBar(
            backgroundColor: colors.surface,
            surfaceTintColor: Colors.transparent,
            title: Text(
              'Possible Matches',
              style: AppText.h3(colors.ink),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.refresh, color: colors.ink),
                tooltip: 'Refresh Matches',
                onPressed: () => AppState.instance.fetchUserMatches(),
              ),
            ],
          ),
          body: matches.isEmpty
              ? EmptyState(
                  title: 'No Matches Yet',
                  body:
                      'When someone reports an item matching your lost or found posts, Serverpod will rank them and notify you automatically.',
                  icon: Icons.auto_awesome,
                  actionLabel: 'Seed Hackathon Demo Data',
                  onAction: () => AppState.instance.resetDemoData(),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.s16),
                  itemCount: matches.length,
                  separatorBuilder: (_, __) => AppSpacing.gap16,
                  itemBuilder: (context, index) {
                    final match = matches[index];
                    return MatchCard(
                      matchDetails: match,
                      onVerified: () => AppState.instance.fetchUserMatches(),
                    );
                  },
                ),
        );
      },
    );
  }
}
