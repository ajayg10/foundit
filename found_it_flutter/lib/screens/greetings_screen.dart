import 'package:flutter/material.dart';
import '../client.dart';
import '../ui/ui.dart';

class GreetingsScreen extends StatefulWidget {
  final Future<void> Function()? onSignOut;
  const GreetingsScreen({super.key, this.onSignOut});

  @override
  State<GreetingsScreen> createState() => _GreetingsScreenState();
}

class _GreetingsScreenState extends State<GreetingsScreen> {
  /// Holds the last result or null if no result exists yet.
  String? _resultMessage;

  /// Holds the last error message that we've received from the server or null
  /// if no error exists yet.
  String? _errorMessage;

  final _textEditingController = TextEditingController();

  /// Calls the `hello` method of the `greeting` endpoint. Will set either the
  /// `_resultMessage` or `_errorMessage` field, depending on if the call
  /// is successful.
  void _callHello() async {
    try {
      final result = await client.greeting.hello(_textEditingController.text);
      setState(() {
        _errorMessage = null;
        _resultMessage = result.message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = '$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.s16),
      child: Column(
        children: [
          if (widget.onSignOut != null) ...[
            Text('You are connected', style: AppText.body(context.colors.ink)),
            AppSpacing.gap16,
            AppButton(
              onPressed: widget.onSignOut,
              label: 'Sign out',
              variant: AppButtonVariant.secondary,
            ),
          ],
          AppSpacing.gap32,
          AppTextField(
            label: 'Name',
            controller: _textEditingController,
            onSubmitted: (_) => _callHello(),
            hint: 'Enter your name',
            suffixIcon: IconButton(
              onPressed: _callHello,
              icon: Icon(Icons.send, color: context.colors.brand),
            ),
          ),
          AppSpacing.gap16,
          ResultDisplay(
            resultMessage: _resultMessage,
            errorMessage: _errorMessage,
          ),
        ],
      ),
    );
  }
}

/// ResultDisplays shows the result of the call. Either the returned result
/// from the `example.greeting` endpoint method or an error message.
class ResultDisplay extends StatelessWidget {
  final String? resultMessage;
  final String? errorMessage;

  const ResultDisplay({super.key, this.resultMessage, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    String text;
    Color backgroundColor;
    Color foregroundColor;
    if (errorMessage != null) {
      backgroundColor = colors.error.withAlpha(20);
      foregroundColor = colors.error;
      text = errorMessage!;
    } else if (resultMessage != null) {
      backgroundColor = colors.success.withAlpha(20);
      foregroundColor = colors.success;
      text = resultMessage!;
    } else {
      backgroundColor = colors.surface;
      foregroundColor = colors.muted;
      text = 'No server response yet.';
    }

    return Container(
      constraints: const BoxConstraints(minHeight: 60),
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.panelBr,
        border: Border.all(color: foregroundColor.withAlpha(80)),
      ),
      child: Center(
        child: Text(text, style: AppText.body(foregroundColor)),
      ),
    );
  }
}
