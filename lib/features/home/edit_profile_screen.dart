import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/constants/app_colors.dart';
import '../../core/services/local_profile_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, this.pickImageOnOpen = false});

  final bool pickImageOnOpen;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final LocalProfileService _profileService = const LocalProfileService();
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _nameCtrl = TextEditingController();

  String _userId = '';
  String _email = '';
  Uint8List? _profileImageBytes;
  bool _isLoading = true;
  bool _isSaving = false;
  bool _didAutoOpenImagePicker = false;

  bool get _canSave =>
      !_isLoading && !_isSaving && _nameCtrl.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final profile = await _profileService.loadProfile();
    if (!mounted) {
      return;
    }

    _nameCtrl.text = profile.name;
    setState(() {
      _userId = profile.userId;
      _email = profile.email;
      _profileImageBytes = profile.imageBytes;
      _isLoading = false;
    });

    if (widget.pickImageOnOpen && !_didAutoOpenImagePicker) {
      _didAutoOpenImagePicker = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _pickImage();
        }
      });
    }
  }

  Future<void> _pickImage() async {
    final file = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 720,
      maxHeight: 720,
      imageQuality: 82,
    );

    if (file == null) {
      return;
    }

    final bytes = await file.readAsBytes();
    if (!mounted) {
      return;
    }

    setState(() => _profileImageBytes = bytes);
  }

  Future<void> _saveProfile() async {
    final trimmedName = _nameCtrl.text.trim();
    if (_isSaving || trimmedName.isEmpty) {
      return;
    }

    setState(() => _isSaving = true);

    await _profileService.saveProfileName(trimmedName);
    if (_profileImageBytes != null) {
      await _profileService.saveProfileImageBytes(_profileImageBytes!);
    }

    if (!mounted) {
      return;
    }

    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully.'),
        backgroundColor: AppColors.success,
      ),
    );
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        ),
      
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 10, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                
                    Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 112,
                            height: 112,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFF3F4F6),
                              border: Border.all(
                                color: AppColors.border,
                                width: 2,
                              ),
                            ),
                            child: ClipOval(
                              child: _profileImageBytes == null
                                  ? const Icon(
                                      Icons.person,
                                      size: 58,
                                      color: AppColors.textTertiary,
                                    )
                                  : Image.memory(
                                      _profileImageBytes!,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          Positioned(
                            right: -2,
                            bottom: -2,
                            child: InkWell(
                              onTap: _isSaving ? null : _pickImage,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.background,
                                    width: 3,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.camera_alt_outlined,
                                  size: 18,
                                  color: AppColors.textWhite,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            const SizedBox(height: 52),
                const Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Fill in your details to get started.',
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),

               
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FC),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ID',
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _userId.isEmpty ? 'Not available' : _userId,
                            style: const TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildLabel('Name'),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _nameCtrl,
                      enabled: !_isSaving,
                      onChanged: (_) => setState(() {}),
                      style: const TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                      decoration: _inputDecoration(
                        'Enter name',
                        Icons.person_outline,
                      ),
                    ),
                    const SizedBox(height: 22),
                    _buildLabel('Email Address'),
                    const SizedBox(height: 10),
                    TextFormField(
                      initialValue: _email.isEmpty ? 'Not available' : _email,
                      readOnly: true,
                      enableInteractiveSelection: false,
                      style: const TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                      decoration:
                          _inputDecoration(
                            'Email address',
                            Icons.email_outlined,
                          ).copyWith(
                            suffixIcon: const Icon(
                              Icons.lock_outline,
                              color: AppColors.textTertiary,
                            ),
                          ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _canSave ? _saveProfile : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.textWhite,
                          disabledBackgroundColor: AppColors.buttonDisabled,
                          disabledForegroundColor: AppColors.buttonTextDisabled,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: AppColors.textWhite,
                                  strokeWidth: 2.4,
                                ),
                              )
                            : const Text(
                                'Submit',
                                style: TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      fontFamily: 'Urbanist',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
  );

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontFamily: 'Urbanist',
        fontSize: 16,
        color: AppColors.textTertiary,
      ),
      prefixIcon: Icon(icon, color: AppColors.textTertiary, size: 22),
      filled: true,
      fillColor: const Color(0xFFF8F9FC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
    );
  }
}
