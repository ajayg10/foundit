import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/match_card.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final matches = AppState.instance.userMatches;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Possible Matches',
              style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh Matches',
                onPressed: () => AppState.instance.fetchUserMatches(),
              ),
            ],
          ),
          body: matches.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppTheme.matchIndigo.withOpacity(0.10),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            size: 48,
                            color: AppTheme.matchIndigo,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'No Matches Yet',
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textMain,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'When someone reports an item matching your lost or found posts, Serverpod will rank them and notify you automatically.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppTheme.textMuted,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 24),
                        OutlinedButton.icon(
                          onPressed: () => AppState.instance.resetDemoData(),
                          icon: const Icon(
                            Icons.flash_on,
                            size: 18,
                            color: AppTheme.warningAmber,
                          ),
                          label: const Text('Seed Hackathon Demo Data'),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: matches.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
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
