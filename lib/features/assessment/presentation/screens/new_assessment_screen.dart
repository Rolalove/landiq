import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:landiq/core/theme/app_colors.dart';
import 'package:landiq/core/theme/app_sizes.dart';
import 'package:landiq/core/theme/app_buttons.dart';
import 'package:landiq/features/assessment/data/nigerian_states.dart';
import 'package:landiq/features/assessment/presentation/providers/assessment_provider.dart';

class NewAssessmentScreen extends ConsumerStatefulWidget {
  const NewAssessmentScreen({super.key});

  @override
  ConsumerState<NewAssessmentScreen> createState() =>
      _NewAssessmentScreenState();
}

class _NewAssessmentScreenState extends ConsumerState<NewAssessmentScreen> {
  String? _selectedState;
  String? _selectedLGA;
  String? _selectedLandSize;
  String? _selectedPurpose;
  final _locationController = TextEditingController();
  final _stateController = TextEditingController();
  final _lgaController = TextEditingController();
  bool _isSubmitting = false;

  final _landSizes = {
    'Less than 1 hectare': 0.5,
    '1 - 5 hectares': 3.0,
    '5 - 10 hectares': 7.5,
    '10 - 50 hectares': 30.0,
    '50 - 100 hectares': 75.0,
    'More than 100 hectares': 150.0,
  };

  final _purposes = [
    'Crop Farming',
    'Livestock',
    'Mixed Farming',
    'Real Estate',
    'Investment',
    'Research',
    'Other',
  ];

  @override
  void dispose() {
    _locationController.dispose();
    _stateController.dispose();
    _lgaController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_selectedState == null || _selectedLandSize == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a state and land size'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final lat = NigerianStates.getLatitude(_selectedState!);
    final lng = NigerianStates.getLongitude(_selectedState!);
    final area = _landSizes[_selectedLandSize!] ?? 10.0;

    final assessment = await ref.read(createAssessmentProvider.notifier).create(
          latitude: lat,
          longitude: lng,
          areaHectares: area,
        );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (assessment != null) {
      // Refresh list immediately
      ref.invalidate(assessmentsListProvider);
      ref.read(currentAssessmentProvider.notifier).state = assessment;
      context.goNamed('assessmentReport');
    } else {
      final error = ref.read(createAssessmentProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error?.toString() ?? 'Failed to create assessment'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lgas = _selectedState != null
        ? NigerianStates.getLGAs(_selectedState!)
        : <String>[];

    return Scaffold(
      backgroundColor: AppColors.background2,
      body: Column(
        children: [
          // Header with gradient
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16,
              right: 16,
              bottom: 24,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF062B35),
                  AppColors.primary,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left,
                          color: Colors.white, size: 28),
                      onPressed: () => context.goNamed('home'),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'New Assessment',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text(
                    'Enter the land details to get instant soil\nhealth analysis and agricultural suitability\ninsights.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Form content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Form fields card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // State — searchable autocomplete
                          _buildLabel(Icons.account_balance, 'State *'),
                          const SizedBox(height: 8),
                          Autocomplete<String>(
                            optionsBuilder: (value) {
                              if (value.text.isEmpty) {
                                return NigerianStates.stateNames;
                              }
                              final q = value.text.toLowerCase();
                              return NigerianStates.stateNames
                                  .where((s) => s.toLowerCase().contains(q));
                            },
                            onSelected: (selection) {
                              setState(() {
                                _selectedState = selection;
                                _selectedLGA = null;
                                _lgaController.clear();
                              });
                            },
                            fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
                              // Sync controller text on change, but not during build
                              return _buildAutocompleteField(
                                controller: controller,
                                focusNode: focusNode,
                                hint: 'Type to search state...',
                                icon: Icons.account_balance,
                              );
                            },
                            optionsViewBuilder: (context, onSelected, options) {
                              return _buildOptionsView(options, onSelected);
                            },
                          ),

                          const SizedBox(height: 20),

                          // LGA — searchable autocomplete
                          _buildLabel(Icons.location_on_outlined, 'Local Government Area (LGA)'),
                          const SizedBox(height: 8),
                          _selectedState == null
                              ? _buildDisabledField('Select a state first')
                              : SizedBox(
                                  width: double.infinity,
                                  child: Autocomplete<String>(
                                    key: ValueKey(_selectedState),
                                    optionsBuilder: (value) {
                                      if (value.text.isEmpty) return lgas;
                                      final q = value.text.toLowerCase();
                                      return lgas.where(
                                          (l) => l.toLowerCase().contains(q));
                                    },
                                    onSelected: (selection) {
                                      setState(() {
                                        _selectedLGA = selection;
                                      });
                                    },
                                    fieldViewBuilder:
                                        (context, controller, focusNode, onSubmitted) {
                                      return _buildAutocompleteField(
                                        controller: controller,
                                        focusNode: focusNode,
                                        hint: 'Type to search LGA...',
                                        icon: Icons.location_on_outlined,
                                      );
                                    },
                                    optionsViewBuilder:
                                        (context, onSelected, options) {
                                      return _buildOptionsView(options, onSelected);
                                    },
                                  ),
                                ),

                          const SizedBox(height: 20),

                          // Specific Location
                          _buildLabel(Icons.pin_drop_outlined, 'Specific Location/Address'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _locationController,
                            maxLines: 2,
                            decoration: InputDecoration(
                              hintText: 'e.g., Along Badagry Express...',
                              hintStyle: TextStyle(
                                  color: AppColors.grey500, fontSize: 14),
                              filled: true,
                              fillColor: AppColors.background2,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(AppSizes.radiusMd),
                                borderSide: BorderSide(color: AppColors.border),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(AppSizes.radiusMd),
                                borderSide: BorderSide(color: AppColors.border),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(AppSizes.radiusMd),
                                borderSide:
                                    BorderSide(color: AppColors.primary),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 14),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Land Size — dropdown (finite list, no need for search)
                          _buildLabel(Icons.crop_square, 'Approximate Land Size *'),
                          const SizedBox(height: 8),
                          _buildDropdown<String>(
                            value: _selectedLandSize,
                            hint: 'Select land size',
                            items: _landSizes.keys
                                .map((s) => DropdownMenuItem(
                                    value: s, child: Text(s)))
                                .toList(),
                            onChanged: (val) =>
                                setState(() => _selectedLandSize = val),
                          ),

                          const SizedBox(height: 20),

                          // Purpose
                          _buildLabel(Icons.eco_outlined, 'Intended Purpose'),
                          const SizedBox(height: 8),
                          _buildDropdown<String>(
                            value: _selectedPurpose,
                            hint: 'Select purpose',
                            items: _purposes
                                .map((p) => DropdownMenuItem(
                                    value: p, child: Text(p)))
                                .toList(),
                            onChanged: (val) =>
                                setState(() => _selectedPurpose = val),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Buttons
                    AppButton(
                      label: 'Generate Assessment',
                      onPressed: _submit,
                      showTrailingArrow: false,
                      isLoading: _isSubmitting,
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      label: 'Cancel',
                      variant: AppButtonVariant.secondary,
                      onPressed: () => context.goNamed('home'),
                      showTrailingArrow: false,
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAutocompleteField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.grey500, fontSize: 14),
        prefixIcon: Icon(icon, size: 18, color: AppColors.primary),
        filled: true,
        fillColor: AppColors.background2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
  }

  Widget _buildDisabledField(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.background2,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Icon(Icons.location_on_outlined, size: 18, color: AppColors.grey500),
          const SizedBox(width: 12),
          Text(text,
              style: TextStyle(color: AppColors.grey500, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildOptionsView(
    Iterable<String> options,
    AutocompleteOnSelected<String> onSelected,
  ) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(12),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 200),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options.elementAt(index);
              return ListTile(
                title: Text(option,
                    style: const TextStyle(fontSize: 14)),
                onTap: () => onSelected(option),
                dense: true,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: AppColors.secondary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    T? value,
    required String hint,
    required List<DropdownMenuItem<T>> items,
    ValueChanged<T?>? onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.background2,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Text(hint,
              style: TextStyle(color: AppColors.grey500, fontSize: 14)),
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, color: AppColors.grey500),
          items: items,
          onChanged: onChanged,
          dropdownColor: Colors.white,
          style: TextStyle(color: AppColors.secondary, fontSize: 14),
        ),
      ),
    );
  }
}
