import 'package:flutter/material.dart';
import 'package:found_it_client/found_it_client.dart';
import 'package:intl/intl.dart';
import '../client.dart';
import '../state/app_state.dart';
import '../ui/ui.dart';
import '../widgets/location_picker.dart';
import '../widgets/photo_picker.dart';

class ReportFoundScreen extends StatefulWidget {
  const ReportFoundScreen({super.key});

  @override
  State<ReportFoundScreen> createState() => _ReportFoundScreenState();
}

class _ReportFoundScreenState extends State<ReportFoundScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();

  String _selectedCategory = 'Bags';
  String _locationLabel = 'Central Library';
  int? _locationAreaId;
  double _latitude = 28.5448;
  double _longitude = 77.1928;
  DateTime _eventTime = DateTime.now().subtract(const Duration(hours: 1));
  String? _imageUrl;

  bool _isSubmitting = false;

  final List<String> _categories = [
    'Bags',
    'Electronics',
    'Keys',
    'Wallets & Purses',
    'Documents & IDs',
    'Clothing',
    'Jewelry & Accessories',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    final activeLoc = AppState.instance.currentLocation;
    if (activeLoc != null) {
      _latitude = activeLoc.latitude;
      _longitude = activeLoc.longitude;
      _locationLabel = activeLoc.name;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  void _fillSampleFoundBackpack() {
    final activeLoc = AppState.instance.currentLocation;
    final areas = AppState.instance.currentLocationAreas;
    final libArea = areas
        .where((a) => a.name.toLowerCase().contains('library'))
        .firstOrNull;

    setState(() {
      _titleController.text = 'Black Backpack';
      _descController.text =
          'Black Wildcraft backpack found on study table near Central Library 2nd floor.';
      _selectedCategory = 'Bags';
      _locationAreaId = libArea?.id;
      _locationLabel = libArea != null
          ? '${activeLoc?.name ?? "IIT Delhi"} — ${libArea.name}'
          : '${activeLoc?.name ?? "IIT Delhi"} — Central Library';
      _latitude = libArea?.latitude ?? activeLoc?.latitude ?? 28.5448;
      _longitude = libArea?.longitude ?? activeLoc?.longitude ?? 77.1928;
      _imageUrl =
          'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=600&auto=format&fit=crop&q=80';
      _eventTime = DateTime.now().subtract(const Duration(hours: 1));
      _questionController.text =
          "What is attached to the front zipper of the backpack?";
      _answerController.text = "Red keychain";
    });
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final user = AppState.instance.currentUser;
      final report = ItemReport(
        userId: user.userId,
        userName: user.name,
        userEmail: user.email,
        reportType: 'found',
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        category: _selectedCategory,
        latitude: _latitude,
        longitude: _longitude,
        locationLabel: _locationLabel,
        locationId: AppState.instance.currentLocation?.id,
        locationAreaId: _locationAreaId,
        eventTime: _eventTime,
        imageUrl: _imageUrl,
        status: 'open',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final question = _questionController.text.trim();
      final answer = _answerController.text.trim();

      await client.report.createReport(
        report: report,
        verificationQuestion: question.isNotEmpty ? question : null,
        verificationAnswer: answer.isNotEmpty ? answer : null,
      );

      await AppState.instance.refreshAll();

      if (!mounted) return;

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: context.colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (ctx) => Padding(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.s16),
                decoration: BoxDecoration(
                  color: context.colors.success.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.auto_awesome,
                  color: context.colors.success,
                  size: 40,
                ),
              ),
              AppSpacing.gap16,
              Text(
                'Found Item Listed & Matched!',
                style: AppText.h2(context.colors.ink),
              ),
              AppSpacing.gap8,
              Text(
                'Serverpod processed your found report. Any potential owners who reported lost matching items have been notified with your verification challenge.',
                textAlign: TextAlign.center,
                style: AppText.body(context.colors.muted),
              ),
              AppSpacing.gap24,
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(context).pop();
                  },
                  label: 'View Matches & Alerts',
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating found report: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppScaffold(
      appBar: AppTopBar(
        title: 'I Found Something',
        actions: [
          TextButton.icon(
            onPressed: _fillSampleFoundBackpack,
            icon: Icon(
              Icons.flash_on,
              size: 16,
              color: colors.warning,
            ),
            label: Text(
              'Fill Demo',
              style: AppText.label(colors.warning),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.s20),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.s16),
                            decoration: BoxDecoration(
                              color: colors.foundSoft,
                              borderRadius: AppRadius.tileBr,
                              border: Border.all(
                                color: colors.found.withAlpha(50),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.volunteer_activism_outlined,
                                  color: colors.found,
                                  size: 20,
                                ),
                                AppSpacing.hGap12,
                                Expanded(
                                  child: Text(
                                    'Thank you for being a good Samaritan! Set a verification question so only the rightful owner can claim this item.',
                                    style: AppText.body(colors.ink),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AppSpacing.gap24,

                          const SectionHeader(title: 'Item Title *'),
                          AppSpacing.gap8,
                          AppTextField(
                            controller: _titleController,
                            hint: 'e.g. Black Backpack, AirPods Pro Case',
                            prefixIcon: Icon(
                              Icons.title,
                              size: 18,
                              color: colors.muted,
                            ),
                            validator: (v) => v == null || v.trim().isEmpty
                                ? 'Please enter item title'
                                : null,
                          ),
                          AppSpacing.gap16,

                          const SectionHeader(title: 'Public Description *'),
                          AppSpacing.gap8,
                          AppTextField(
                            controller: _descController,
                            maxLines: 3,
                            hint:
                                'Describe where you found it (keep details private!)...',
                            validator: (v) => v == null || v.trim().isEmpty
                                ? 'Please enter a description'
                                : null,
                          ),
                          AppSpacing.gap16,

                          const SectionHeader(title: 'Category *'),
                          AppSpacing.gap8,
                          Wrap(
                            spacing: AppSpacing.s8,
                            runSpacing: AppSpacing.s8,
                            children: _categories.map((c) {
                              return AppChip(
                                label: c,
                                selected: _selectedCategory == c,
                                onSelected: (val) {
                                  if (val) {
                                    setState(() => _selectedCategory = c);
                                  }
                                },
                              );
                            }).toList(),
                          ),
                          AppSpacing.gap16,

                          const SectionHeader(title: 'Location *'),
                          AppSpacing.gap8,
                          LocationPickerWidget(
                            selectedLabel: _locationLabel,
                            selectedAreaId: _locationAreaId,
                            latitude: _latitude,
                            longitude: _longitude,
                            onLocationChanged: (areaId, label, lat, lon) {
                              setState(() {
                                _locationAreaId = areaId;
                                _locationLabel = label;
                                _latitude = lat;
                                _longitude = lon;
                              });
                            },
                          ),
                          AppSpacing.gap16,

                          const SectionHeader(
                            title: 'Approximate Date & Time Found *',
                          ),
                          AppSpacing.gap8,
                          InkWell(
                            onTap: () async {
                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: _eventTime,
                                firstDate: DateTime.now().subtract(
                                  const Duration(days: 365),
                                ),
                                lastDate: DateTime.now(),
                              );
                              if (pickedDate != null && mounted) {
                                final pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(
                                    _eventTime,
                                  ),
                                );
                                if (pickedTime != null) {
                                  setState(() {
                                    _eventTime = DateTime(
                                      pickedDate.year,
                                      pickedDate.month,
                                      pickedDate.day,
                                      pickedTime.hour,
                                      pickedTime.minute,
                                    );
                                  });
                                }
                              }
                            },
                            borderRadius: AppRadius.buttonBr,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.s16,
                                vertical: AppSpacing.s12,
                              ),
                              decoration: BoxDecoration(
                                color: colors.surface,
                                borderRadius: AppRadius.buttonBr,
                                border: Border.all(color: colors.line),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 18,
                                    color: colors.brand,
                                  ),
                                  AppSpacing.hGap12,
                                  Expanded(
                                    child: Text(
                                      DateFormat(
                                        'EEEE, MMM d, yyyy • h:mm a',
                                      ).format(_eventTime),
                                      style: AppText.body(colors.ink),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Icon(
                                    Icons.edit,
                                    size: 16,
                                    color: colors.muted,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          AppSpacing.gap24,

                          // Verification Question Box
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.s16),
                            decoration: BoxDecoration(
                              color: colors.warningSoft,
                              borderRadius: AppRadius.tileBr,
                              border: Border.all(
                                color: colors.warning.withAlpha(50),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.verified_user,
                                      color: colors.warning,
                                      size: 20,
                                    ),
                                    AppSpacing.hGap8,
                                    Expanded(
                                      child: Text(
                                        'Private Ownership Verification Challenge',
                                        style: AppText.label(colors.warning)
                                            .copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                AppSpacing.gap8,
                                Text(
                                  'To ensure only the real owner claims this item, ask a specific question that only they would know. The answer is NEVER shown publicly and is securely verified on the server.',
                                  style: AppText.caption(colors.warning),
                                ),
                                AppSpacing.gap16,

                                Text(
                                  'Verification Question *',
                                  style: AppText.label(colors.warning),
                                ),
                                AppSpacing.gap4,
                                AppTextField(
                                  controller: _questionController,
                                  hint:
                                      'e.g. What keychain/accessory is attached to it?',
                                  validator: (v) =>
                                      v == null || v.trim().isEmpty
                                      ? 'Please enter a verification question'
                                      : null,
                                ),
                                AppSpacing.gap12,

                                Text(
                                  'Expected Answer (Kept Strictly Secret) *',
                                  style: AppText.label(colors.warning),
                                ),
                                AppSpacing.gap4,
                                AppTextField(
                                  controller: _answerController,
                                  hint: 'e.g. Red keychain',
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    size: 18,
                                    color: colors.muted,
                                  ),
                                  validator: (v) =>
                                      v == null || v.trim().isEmpty
                                      ? 'Please enter the expected answer'
                                      : null,
                                ),
                              ],
                            ),
                          ),
                          AppSpacing.gap16,

                          const SectionHeader(title: 'Photo (Optional)'),
                          AppSpacing.gap8,
                          PhotoPickerWidget(
                            initialImageUrl: _imageUrl,
                            onImageChanged: (url) {
                              setState(() => _imageUrl = url);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(AppSpacing.s20),
              decoration: BoxDecoration(
                color: colors.surface,
                border: Border(top: BorderSide(color: colors.line)),
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      onPressed: _isSubmitting ? null : _submitReport,
                      label: 'Post Found Item & Notify Owners',
                      variant: AppButtonVariant.found,
                      loading: _isSubmitting,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
