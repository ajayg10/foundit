import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../ui/ui.dart';

/// Branded sign-in & sign-up screen for Found It.
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _loading = false;

  final _signInEmailCtrl = TextEditingController();
  final _signInPassCtrl = TextEditingController();
  final _signUpNameCtrl = TextEditingController();
  final _signUpEmailCtrl = TextEditingController();
  final _signUpPassCtrl = TextEditingController();
  final _signUpConfirmCtrl = TextEditingController();

  final _signInForm = GlobalKey<FormState>();
  final _signUpForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _signInEmailCtrl.dispose();
    _signInPassCtrl.dispose();
    _signUpNameCtrl.dispose();
    _signUpEmailCtrl.dispose();
    _signUpPassCtrl.dispose();
    _signUpConfirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_signInForm.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await AppState.instance.signIn(
        email: _signInEmailCtrl.text.trim(),
        password: _signInPassCtrl.text,
      );
    } catch (e) {
      if (mounted) {
        _showError('Sign-in failed: ${e.toString().split(':').last.trim()}');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _signUp() async {
    if (!_signUpForm.currentState!.validate()) return;
    if (_signUpPassCtrl.text != _signUpConfirmCtrl.text) {
      _showError('Passwords do not match');
      return;
    }
    setState(() => _loading = true);
    try {
      await AppState.instance.signUp(
        name: _signUpNameCtrl.text.trim(),
        email: _signUpEmailCtrl.text.trim(),
        password: _signUpPassCtrl.text,
      );
    } catch (e) {
      if (mounted) {
        _showError('Sign-up failed: ${e.toString().split(':').last.trim()}');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: AppText.body(context.colors.surface)),
        backgroundColor: context.colors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.tileBr),
        margin: const EdgeInsets.all(AppSpacing.s16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppScaffold(
      body: Stack(
        children: [
          // Background
          Container(
            color: colors.bg,
          ),

          // Decorative shapes (subtle)
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.brand.withAlpha(20),
              ),
            ),
          ),
          Positioned(
            top: 120,
            left: -80,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.brand.withAlpha(15),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppSpacing.gap32,

                      // Logo & branding
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: colors.brand,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: colors.brand.withAlpha(80),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.radar_rounded,
                          color: colors.surface,
                          size: 36,
                        ),
                      ),
                      AppSpacing.gap24,
                      Text(
                        'Found It',
                        style: AppText.h1(colors.ink).copyWith(
                          letterSpacing: -0.5,
                        ),
                      ),
                      AppSpacing.gap8,
                      Text(
                        'Campus & Workplace Lost-and-Found Network',
                        textAlign: TextAlign.center,
                        style: AppText.body(colors.muted),
                      ),
                      AppSpacing.gap32,

                      // Auth card
                      Container(
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: AppRadius.panelBr,
                          boxShadow: [
                            BoxShadow(
                              color: colors.ink.withAlpha(10),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                          border: Border.all(color: colors.line),
                        ),
                        child: Column(
                          children: [
                            // Tab bar
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                AppSpacing.s16,
                                AppSpacing.s16,
                                AppSpacing.s16,
                                0,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: colors.bg,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: TabBar(
                                  controller: _tabCtrl,
                                  indicator: BoxDecoration(
                                    color: colors.surface,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: colors.ink.withAlpha(10),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  labelColor: colors.ink,
                                  unselectedLabelColor: colors.muted,
                                  dividerColor: Colors.transparent,
                                  labelStyle: AppText.label(
                                    colors.ink,
                                  ).copyWith(fontWeight: FontWeight.w700),
                                  unselectedLabelStyle: AppText.label(
                                    colors.muted,
                                  ).copyWith(fontWeight: FontWeight.w500),
                                  tabs: const [
                                    Tab(text: 'Sign In'),
                                    Tab(text: 'Sign Up'),
                                  ],
                                ),
                              ),
                            ),
                            // Tab views
                            AnimatedBuilder(
                              animation: _tabCtrl,
                              builder: (context, _) {
                                return SizedBox(
                                  // dynamically adjust height based on active tab
                                  height: _tabCtrl.index == 0 ? 300 : 530,
                                  child: TabBarView(
                                    controller: _tabCtrl,
                                    children: [
                                      _buildSignInForm(colors),
                                      _buildSignUpForm(colors),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      AppSpacing.gap32,

                      // Quick Demo Section
                      Text(
                        '— OR TEST WITH DEMO PERSONA —',
                        style: AppText.caption(colors.muted).copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                        ),
                      ),
                      AppSpacing.gap16,
                      Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              onPressed: () => AppState.instance.loginAsDemo(
                                AppState.demoAlice,
                              ),
                              label: 'Alice (Lost)',
                              variant: AppButtonVariant.secondary,
                              icon: Icons.person,
                            ),
                          ),
                          AppSpacing.hGap12,
                          Expanded(
                            child: AppButton(
                              onPressed: () => AppState.instance.loginAsDemo(
                                AppState.demoBob,
                              ),
                              label: 'Bob (Found)',
                              variant: AppButtonVariant.secondary,
                              icon: Icons.person,
                            ),
                          ),
                        ],
                      ),
                      AppSpacing.gap40,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignInForm(AppSemantic colors) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.s20),
      child: Form(
        key: _signInForm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              label: 'Email Address',
              controller: _signInEmailCtrl,
              hint: 'you@campus.edu',
              prefixIcon: Icon(
                Icons.email_outlined,
                size: 20,
                color: colors.brand,
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (v) =>
                  (v?.contains('@') ?? false) ? null : 'Enter a valid email',
            ),
            AppSpacing.gap16,
            AppTextField(
              label: 'Password',
              controller: _signInPassCtrl,
              hint: '••••••••',
              prefixIcon: Icon(
                Icons.lock_outline_rounded,
                size: 20,
                color: colors.brand,
              ),
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                  color: colors.muted,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
              validator: (v) =>
                  (v != null && v.length >= 4) ? null : 'Min 4 characters',
            ),
            AppSpacing.gap24,
            SizedBox(
              width: double.infinity,
              child: AppButton(
                onPressed: _loading ? null : _signIn,
                label: 'Sign In',
                loading: _loading,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpForm(AppSemantic colors) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.s20),
      child: Form(
        key: _signUpForm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              label: 'Full Name',
              controller: _signUpNameCtrl,
              hint: 'Your Name',
              prefixIcon: Icon(
                Icons.person_outline_rounded,
                size: 20,
                color: colors.brand,
              ),
              validator: (v) => (v != null && v.trim().length >= 2)
                  ? null
                  : 'Enter your name',
            ),
            AppSpacing.gap12,
            AppTextField(
              label: 'Email Address',
              controller: _signUpEmailCtrl,
              hint: 'you@campus.edu',
              prefixIcon: Icon(
                Icons.email_outlined,
                size: 20,
                color: colors.brand,
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (v) =>
                  (v?.contains('@') ?? false) ? null : 'Valid email required',
            ),
            AppSpacing.gap12,
            AppTextField(
              label: 'Password',
              controller: _signUpPassCtrl,
              hint: '••••••••',
              prefixIcon: Icon(
                Icons.lock_outline_rounded,
                size: 20,
                color: colors.brand,
              ),
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                  color: colors.muted,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
              validator: (v) =>
                  (v != null && v.length >= 4) ? null : 'Min 4 characters',
            ),
            AppSpacing.gap12,
            AppTextField(
              label: 'Confirm Password',
              controller: _signUpConfirmCtrl,
              hint: '••••••••',
              prefixIcon: Icon(
                Icons.lock_outline_rounded,
                size: 20,
                color: colors.brand,
              ),
              obscureText: _obscureConfirm,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirm
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                  color: colors.muted,
                ),
                onPressed: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
              ),
              validator: (v) =>
                  (v != null && v.length >= 4) ? null : 'Min 4 characters',
            ),
            AppSpacing.gap24,
            SizedBox(
              width: double.infinity,
              child: AppButton(
                onPressed: _loading ? null : _signUp,
                label: 'Create Account',
                loading: _loading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
