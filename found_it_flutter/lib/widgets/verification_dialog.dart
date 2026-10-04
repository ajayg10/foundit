import 'package:flutter/material.dart';
import '../client.dart';
import '../state/app_state.dart';
import '../ui/ui.dart';

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
    final colors = context.colors;

    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 440),
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.s12),
                  decoration: BoxDecoration(
                    color: _isVerified
                        ? colors.success.withAlpha(25)
                        : colors.brand.withAlpha(25),
                    borderRadius: AppRadius.buttonBr,
                  ),
                  child: Icon(
                    _isVerified
                        ? Icons.check_circle
                        : Icons.verified_user_outlined,
                    color: _isVerified ? colors.success : colors.brand,
                    size: 24,
                  ),
                ),
                AppSpacing.hGap12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isVerified
                            ? 'Verification Successful!'
                            : 'Ownership Verification',
                        style: AppText.h3(colors.ink),
                      ),
                      Text(
                        widget.itemTitle,
                        style: AppText.caption(colors.muted),
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
                  color: colors.muted,
                ),
              ],
            ),
            AppSpacing.gap20,

            if (_isVerified) ...[
              // Success Content
              Container(
                padding: const EdgeInsets.all(AppSpacing.s16),
                decoration: BoxDecoration(
                  color: colors.success.withAlpha(25),
                  borderRadius: AppRadius.buttonBr,
                  border: Border.all(color: colors.success.withAlpha(60)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.security,
                          color: colors.success,
                          size: 20,
                        ),
                        AppSpacing.hGap8,
                        Flexible(
                          child: Text(
                            'You are confirmed as the owner!',
                            style: AppText.label(colors.success),
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.gap8,
                    Text(
                      'Your answer was verified by the server. You can now coordinate with the finder to retrieve your item.',
                      style: AppText.body(colors.success).copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.gap16,
              if (!_isMarkedReturned) ...[
                Text(
                  'Once you have received your item in person, click below to mark it as Returned.',
                  style: AppText.body(colors.muted),
                ),
                AppSpacing.gap12,
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    onPressed: _isSubmitting ? null : _markReturned,
                    icon: Icons.handshake_outlined,
                    label: 'Mark Item Returned & Close Case',
                    variant: AppButtonVariant.found,
                    loading: _isSubmitting,
                  ),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(AppSpacing.s12),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: AppRadius.buttonBr,
                    border: Border.all(color: colors.line),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.celebration,
                        color: colors.success,
                        size: 20,
                      ),
                      AppSpacing.hGap8,
                      Expanded(
                        child: Text(
                          '🎉 Item returned and case closed!',
                          style: AppText.label(colors.ink),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ] else ...[
              // Prompt Section
              Container(
                padding: const EdgeInsets.all(AppSpacing.s16),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: AppRadius.buttonBr,
                  border: Border.all(color: colors.line),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'THE FINDER ASKS:',
                      style: AppText.caption(colors.muted).copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    AppSpacing.gap8,
                    Text(
                      '"${widget.question}"',
                      style: AppText.h3(colors.ink).copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.gap16,

              AppTextField(
                label: 'Your Answer',
                controller: _answerController,
                enabled: !_isLocked && !_isSubmitting,
                hint: 'e.g. Red keychain, dog photo, etc.',
                prefixIcon: const Icon(Icons.lock_open, size: 18),
                errorText: _errorMessage,
                onSubmitted: (_) => _submitAnswer(),
              ),

              if (_remainingAttempts != null && !_isVerified) ...[
                AppSpacing.gap4,
                Text(
                  'Attempts remaining: $_remainingAttempts',
                  style: AppText.caption(
                    _remainingAttempts! <= 1 ? colors.error : colors.warning,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
              ],
              AppSpacing.gap8,

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.shield_outlined,
                    size: 16,
                    color: colors.muted,
                  ),
                  AppSpacing.hGap8,
                  Expanded(
                    child: Text(
                      'Verified server-side. The finder\'s expected answer is never shared with you.',
                      style: AppText.caption(colors.muted),
                    ),
                  ),
                ],
              ),
              AppSpacing.gap24,

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButton(
                    onPressed: () => Navigator.of(context).pop(),
                    label: 'Cancel',
                    variant: AppButtonVariant.tertiary,
                  ),
                  AppSpacing.hGap12,
                  AppButton(
                    onPressed: _isLocked || _isSubmitting
                        ? null
                        : _submitAnswer,
                    label: 'Submit Verification',
                    loading: _isSubmitting,
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
