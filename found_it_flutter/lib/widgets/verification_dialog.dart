import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../client.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class VerificationDialog extends StatefulWidget {
  final int reportId;
  final String itemTitle;
  final String question;
  final VoidCallback? onVerificationSuccess;

  const VerificationDialog({
    super.key,
    required this.reportId,
    required this.itemTitle,
    required this.question,
    this.onVerificationSuccess,
  });

  @override
  State<VerificationDialog> createState() => _VerificationDialogState();
}

class _VerificationDialogState extends State<VerificationDialog> {
  final _answerController = TextEditingController();
  bool _isSubmitting = false;
  String? _errorMessage;
  bool _isVerified = false;
  int? _remainingAttempts;
  bool _isLocked = false;
  bool _isMarkedReturned = false;

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  Future<void> _submitAnswer() async {
    final answer = _answerController.text.trim();
    if (answer.isEmpty) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final claimantUserId = AppState.instance.currentUser.userId;
      final result = await client.verification.submitVerificationAnswer(
        reportId: widget.reportId,
        claimantUserId: claimantUserId,
        answer: answer,
      );

      setState(() {
        _isVerified = result.success;
        _remainingAttempts = result.attemptsRemaining;
        _isLocked = result.isLocked;
        if (!result.success) {
          _errorMessage = result.message;
        }
      });

      if (result.success) {
        widget.onVerificationSuccess?.call();
        await AppState.instance.refreshAll();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error submitting verification: $e';
      });
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Future<void> _markReturned() async {
    setState(() => _isSubmitting = true);
    try {
      final success = await client.verification.markItemReturned(
        reportId: widget.reportId,
        userId: AppState.instance.currentUser.userId,
      );

      if (success) {
        setState(() => _isMarkedReturned = true);
        await AppState.instance.refreshAll();
      }
    } catch (e) {
      setState(() => _errorMessage = 'Error closing case: $e');
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 440),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _isVerified
                        ? AppTheme.recoveryGreen.withOpacity(0.12)
                        : AppTheme.primaryBlue.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _isVerified ? Icons.check_circle : Icons.verified_user_outlined,
                    color: _isVerified ? AppTheme.recoveryGreen : AppTheme.primaryBlue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isVerified ? 'Verification Successful!' : 'Ownership Verification',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textMain,
                        ),
                      ),
                      Text(
                        widget.itemTitle,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.textMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, size: 20),
                  splashRadius: 20,
                ),
              ],
            ),
            const SizedBox(height: 18),

            if (_isVerified) ...[
              // Success Content
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFA7F3D0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.security, color: AppTheme.recoveryGreen, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'You are confirmed as the owner!',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.recoveryGreen,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your answer was verified by the server. You can now coordinate with the finder to retrieve your item.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF065F46),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (!_isMarkedReturned) ...[
                Text(
                  'Once you have received your item in person, click below to mark it as Returned.',
                  style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textMuted),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _markReturned,
                    icon: const Icon(Icons.handshake_outlined, size: 18),
                    label: Text(_isSubmitting ? 'Updating...' : 'Mark Item Returned & Close Case'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.recoveryGreen,
                    ),
                  ),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.celebration, color: AppTheme.recoveryGreen, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        '🎉 Item returned and case closed!',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textMain,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ] else ...[
              // Prompt Section
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.borderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'THE FINDER ASKS:',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: AppTheme.textMuted,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '"${widget.question}"',
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textMain,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'Your Answer',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textMain,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _answerController,
                enabled: !_isLocked && !_isSubmitting,
                decoration: InputDecoration(
                  hintText: 'e.g. Red keychain, dog photo, etc.',
                  prefixIcon: const Icon(Icons.lock_open, size: 18),
                  errorText: _errorMessage,
                ),
                onSubmitted: (_) => _submitAnswer(),
              ),
              if (_remainingAttempts != null && !_isVerified) ...[
                const SizedBox(height: 4),
                Text(
                  'Attempts remaining: $_remainingAttempts',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _remainingAttempts! <= 1 ? AppTheme.lostRed : AppTheme.warningAmber,
                  ),
                ),
              ],
              const SizedBox(height: 8),

              Row(
                children: [
                  const Icon(Icons.shield_outlined, size: 14, color: AppTheme.textMuted),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Verified server-side. The finder\'s expected answer is never shared with you.',
                      style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textMuted),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _isLocked || _isSubmitting ? null : _submitAnswer,
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Submit Verification'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
