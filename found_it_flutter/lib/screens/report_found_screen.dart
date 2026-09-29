import 'package:flutter/material.dart';
import 'package:found_it_client/found_it_client.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../client.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
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
  String _locationLabel = 'Engineering Block';
  double _latitude = 37.7810;
  double _longitude = -122.4120;
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
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  void _fillSampleFoundBackpack() {
    setState(() {
      _titleController.text = 'Black Backpack';
      _descController.text =
          'Black Wildcraft backpack found on bench near Engineering Block hallway.';
      _selectedCategory = 'Bags';
      _locationLabel = 'Engineering Block';
      _latitude = 37.7810;
      _longitude = -122.4120;
      _imageUrl =
          'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=600&auto=format&fit=crop&q=80';
      _eventTime = DateTime.now().subtract(const Duration(hours: 1));
      _questionController.text = "What is attached to the front zipper of the backpack?";
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

      // Show match discovery modal
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (ctx) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.recoveryGreen.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.auto_awesome, color: AppTheme.recoveryGreen, size: 40),
              ),
              const SizedBox(height: 16),
              Text(
                'Found Item Listed & Matched!',
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textMain,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Serverpod processed your found report. Any potential owners who reported lost matching items have been notified with your verification challenge.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textMuted),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('View Matches & Alerts'),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'I Found Something',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
        ),
        actions: [
          TextButton.icon(
            onPressed: _fillSampleFoundBackpack,
            icon: const Icon(Icons.flash_on, size: 16, color: AppTheme.warningAmber),
            label: Text(
              'Fill Demo',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.warningAmber,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.recoveryGreen.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.recoveryGreen.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.volunteer_activism_outlined, color: AppTheme.recoveryGreen, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Thank you for being a good Samaritan! Set a verification question so only the rightful owner can claim this item.',
                            style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textMain),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title
                  Text(
                    'Item Title *',
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Black Backpack, AirPods Pro Case, Set of Keys',
                      prefixIcon: Icon(Icons.title, size: 18),
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Please enter item title' : null,
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    'Public Description *',
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _descController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText:
                          'Describe where you found it, general appearance (keep subtle details private for the verification question!)...',
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Please enter a description' : null,
                  ),
                  const SizedBox(height: 16),

                  // Category
                  Text(
                    'Category *',
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.category_outlined, size: 18),
                    ),
                    items: _categories.map((c) {
                      return DropdownMenuItem(value: c, child: Text(c));
                    }).toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _selectedCategory = v);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Location
                  LocationPickerWidget(
                    selectedLabel: _locationLabel,
                    latitude: _latitude,
                    longitude: _longitude,
                    onLocationChanged: (label, lat, lon) {
                      setState(() {
                        _locationLabel = label;
                        _latitude = lat;
                        _longitude = lon;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Date and Time Found
                  Text(
                    'Approximate Date & Time Found *',
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  InkWell(
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _eventTime,
                        firstDate: DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null && mounted) {
                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(_eventTime),
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
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.borderLight),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 18, color: AppTheme.primaryBlue),
                          const SizedBox(width: 12),
                          Text(
                            DateFormat('EEEE, MMM d, yyyy • h:mm a').format(_eventTime),
                            style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textMain),
                          ),
                          const Spacer(),
                          const Icon(Icons.edit, size: 16, color: AppTheme.textMuted),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Verification Question Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFFDE68A)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.verified_user, color: AppTheme.warningAmber, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Private Ownership Verification Challenge',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF92400E),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'To ensure only the real owner claims this item, ask a specific question that only they would know. The answer is NEVER shown publicly and is securely verified on the server.',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF78350F),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Question
                        Text(
                          'Verification Question *',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF78350F),
                          ),
                        ),
                        const SizedBox(height: 4),
                        TextFormField(
                          controller: _questionController,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            hintText: 'e.g. What keychain/accessory is attached to it?',
                          ),
                          validator: (v) =>
                              v == null || v.trim().isEmpty ? 'Please enter a verification question' : null,
                        ),
                        const SizedBox(height: 12),

                        // Answer
                        Text(
                          'Expected Answer (Kept Strictly Secret) *',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF78350F),
                          ),
                        ),
                        const SizedBox(height: 4),
                        TextFormField(
                          controller: _answerController,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            hintText: 'e.g. Red keychain',
                            prefixIcon: Icon(Icons.lock, size: 18),
                          ),
                          validator: (v) =>
                              v == null || v.trim().isEmpty ? 'Please enter the expected answer' : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Photo Picker (Camera + Gallery)
                  PhotoPickerWidget(
                    initialImageUrl: _imageUrl,
                    onImageChanged: (url) {
                      setState(() => _imageUrl = url);
                    },
                  ),
                  const SizedBox(height: 28),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitReport,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.recoveryGreen,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : Text(
                              'Post Found Item & Notify Owners',
                              style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
