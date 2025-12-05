// add_asset_stepper_screen.dart
import 'package:flutter/material.dart';
import 'package:asetize/core/util/app_theme/app_color.dart';
import 'package:asetize/core/util/app_theme/app_style.dart';

import '../../../core/util/app_theme/app_string.dart';
import '../../presentation/widgets/appbar/common_appbar.dart';
import '../../presentation/widgets/basic_view_container/container_first.dart';
import '../model/assets_list_model.dart';
import 'add_asset_step1.dart';
import 'add_asset_step2.dart';
import 'add_asset_step3.dart';

class AddAssetStepperScreen extends StatefulWidget {
  final bool isEditMode;
  final int? assetId;
  final String? barcode;
  final AssetListData? detailData;

  const AddAssetStepperScreen({
    super.key,
    this.isEditMode = false,
    this.assetId,
    this.barcode,
    this.detailData,
  });

  @override
  State<AddAssetStepperScreen> createState() => _AddAssetStepperScreenState();
}

class _AddAssetStepperScreenState extends State<AddAssetStepperScreen> {
  int _currentStep = 0;

  // Data holder passed between steps
  final Map<String, dynamic> _stepData = {};

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  // Progress indicator (exactly like your screenshots)
  Widget _buildStepper() {
    return Row(
      children: List.generate(3, (index) {
        bool isActive = index <= _currentStep;
        bool isCompleted = index < _currentStep;

        return Expanded(
          child: Row(
            children: [
              CircleAvatar(
                radius: 18, // ⬅️ Circle size increased
                backgroundColor: isCompleted
                    ? Colors.green
                    : (isActive ? AppColors.appBlueColor : Colors.grey[300]),
                child: isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 22)
                    : Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              if (index < 2)
                Expanded(
                  flex: 1, // ⬅️ line width increased
                  child: Container(
                    height: 4,
                    color: isCompleted
                        ? Colors.green
                        : (index < _currentStep
                        ? AppColors.appBlueColor
                        : Colors.grey[300]),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }


  @override
  Widget build(BuildContext context) {
    final List<Widget> steps = [
      AddAssetStep1(
        isEditMode: widget.isEditMode,
        detailData: widget.detailData,
        barcode: widget.barcode,
        initialData: _stepData,
        onNext: (data) {
          _stepData.addAll(data);
          _nextStep();
        },
      ),
      AddAssetStep2(
        isEditMode: widget.isEditMode,
        detailData: widget.detailData,
        initialData: _stepData,
        onNext: (data) {
          _stepData.addAll(data);
          _nextStep();
        },
        onBack: _previousStep,
      ),
      AddAssetStep3(
        isEditMode: widget.isEditMode,
        assetId: widget.assetId,
        barcode: widget.barcode,
        detailData: widget.detailData,
        stepData: _stepData,
        onBack: _previousStep,
      ),
    ];

    return ContainerFirst(
      appBar: CommonAppBar(
        title: widget.isEditMode ? AppString.editAsset : AppString.addAsset,
        isThen: false,
      ),
      contextCurrentView: context,
      isSingleChildScrollViewNeed: true,
      isFixedDeviceHeight: false,
      isListScrollingNeed: false,
      isOverLayStatusBar: false, // IMPORTANT
      containChild: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildStepper(),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _currentStep == 0
                        ? "Mandatory"
                        : _currentStep == 1
                        ? "Optional"
                        : "Documents",
                    style: appStyles.texFieldPlaceHolderStyle().copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (_currentStep > 0)
                    TextButton(
                      onPressed: _previousStep,
                      child: const Text("Back"),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.3,
              child: steps[_currentStep],
            )
          ],
        ),
      ),

    );




  }
}

// 'package:flutter/src/rendering/object.dart': Failed assertion: line 5466 pos 14: '!semantics.parentDataDirty': is not true.
