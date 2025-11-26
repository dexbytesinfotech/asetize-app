import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/util/app_theme/app_color.dart';
import '../../../core/util/app_theme/app_style.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../booking/widgets/label_widget.dart';
import '../../presentation/widgets/app_button_common.dart';
import '../../presentation/widgets/common_text_field_with_error.dart';
import '../../presentation/widgets/workplace_widgets.dart';
import 'package:asetize/widgets/common_card_view.dart';

import '../models/get_comment_list_model.dart';

class FollowUpCommentCardView extends StatefulWidget {
  final String? title;
  final String description;
  final bool? isStatusCompleted;
  final String? createdBy;
  final String? createdAt;
  final GetTaskCommentData? getTaskCommentData;

  // 👇 New dynamic callbacks
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final ValueChanged<String>? onSave;
  final VoidCallback? onCancel;

  const FollowUpCommentCardView({
    super.key,
    this.title,
    this.description =
    'Previous month payment was delayed. Please ensure timely collection.',
    this.createdBy,
    this.createdAt,
    this.getTaskCommentData,
    this.onDelete,
    this.isStatusCompleted,
    this.onEdit,
    this.onSave,
    this.onCancel,
  });

  @override
  _FollowUpCommentCardViewState createState() =>
      _FollowUpCommentCardViewState();
}

class _FollowUpCommentCardViewState extends State<FollowUpCommentCardView> {
  bool _isEditing = false;
  late TextEditingController _descriptionController;
  late FocusNode _descriptionFocusNode;

  @override
  void initState() {
    _descriptionController = TextEditingController(
      text: widget.getTaskCommentData?.comment ?? widget.description,
    );
    _descriptionFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// ✏️ Edit TextField
    Widget descriptionWidget() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonTextFieldWithError(
            controllerT: _descriptionController,
            focusNode: _descriptionFocusNode, // pass focusNode
            borderRadius: 8,
            enabledBorderColor: Colors.black38,
            inputHeight: 140,
            hintStyle: appStyles.hintTextStyle(),
            textStyle: appStyles.textFieldTextStyle(),
            maxCharLength: 500,
            minLines: 3,
            maxLines: 3,
            autoFocus: true, // allow the textfield to autofocus when shown
            isShowShadow: true,
            showCounterText: false,
            capitalization: CapitalizationText.sentences,
            cursorColor: Colors.grey,
            focusedBorderColor: AppColors.textBlueColor,
            backgroundColor: AppColors.white,
            textInputAction: TextInputAction.newline,
            borderStyle: BorderStyle.solid,
            inputKeyboardType: InputKeyboardTypeWithError.multiLine,
            placeHolderTextWidget: const LabelWidget(
              labelText: 'Edit Comment',
              isRequired: false,
            ),
            contentPadding: const EdgeInsets.all(10),
            onTextChange: (value) {
              setState(() {});
            },
            onEndEditing: (value) {},
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 4, right: 8),
              child: Text(
                "${_descriptionController.text.length}/500",
                style: appStyles.hintTextStyle().copyWith(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      );
    }

    /// 🔘 Buttons for Save/Cancel
    Widget editCommentBtRow() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0).copyWith(bottom: 10),
        child: Row(
          children: [
            Flexible(
              child: AppButton(
                buttonHeight: 33,
                buttonWidth: 100,
                buttonName: 'Cancel',
                buttonBorderColor: Colors.red,
                buttonColor: Colors.transparent,
                textStyle: appStyles.buttonTextStyle1(
                    texColor: AppColors.red, fontSize: 14),
                flutterIcon: Icons.close,
                iconColor: AppColors.red,
                iconSize: const Size(20, 20),
                isShowIcon: true,
                isLoader: false,
                backCallback: () {
                  setState(() {
                    _isEditing = false;
                    _descriptionController.text =
                        widget.getTaskCommentData?.comment ?? '';
                  });
                  // unfocus the field
                  _descriptionFocusNode.unfocus();
                  widget.onCancel?.call();
                },
              ),
            ),
            const SizedBox(width: 15),
            Flexible(
              child: AppButton(
                buttonHeight: 33,
                buttonWidth: 100,
                buttonName: 'Save',
                buttonBorderColor: Colors.black,
                buttonColor: AppColors.textBlueColor,
                textStyle: appStyles.buttonTextStyle1(
                    texColor: AppColors.white, fontSize: 14),
                flutterIcon: Icons.save,
                iconSize: const Size(20, 20),
                iconColor: AppColors.white,
                isShowIcon: true,
                isLoader: false,
                backCallback: () {
                  setState(() => _isEditing = false);
                  // unfocus after saving
                  _descriptionFocusNode.unfocus();
                  widget.onSave?.call(_descriptionController.text);
                },
              ),
            ),
          ],
        ),
      );
    }

    return CommonCardView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🏷️ Title + Time + Menu
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.withOpacity(0.15),
                  ),
                  child: const Icon(
                    CupertinoIcons.clock,
                    size: 14,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Name + Menu
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              widget.createdBy ??
                                  widget.getTaskCommentData?.user?.name ??
                                  'Unknown User',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: appTextStyle.appTitleStyle(),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                widget.createdAt ??
                                    widget.getTaskCommentData?.createdAt ??
                                    '',
                                style: appTextStyle.appSubTitleStyle2(),
                              ),
                              const SizedBox(width: 8),
                              if (widget.isStatusCompleted == true)
                                GestureDetector(
                                  onTap: () {
                                    WorkplaceWidgets.commonEditDeleteBottomSheet(
                                      context: context,
                                      onEdit: () {
                                        setState(() {
                                          _isEditing = true;
                                          _descriptionController.text =
                                              widget.getTaskCommentData?.comment ??
                                                  widget.description;
                                        });

                                        // notify parent once
                                        widget.onEdit?.call();

                                        // request focus and set cursor at end after frame renders
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          if (mounted) {
                                            _descriptionFocusNode.requestFocus();
                                            _descriptionController.selection =
                                                TextSelection.fromPosition(
                                                  TextPosition(
                                                    offset: _descriptionController
                                                        .text.length,
                                                  ),
                                                );
                                          }
                                        });
                                      },
                                      editTitle: "Edit Comment",
                                      onDeleteConfirmed: () {
                                        widget.onDelete?.call();
                                      },
                                      deleteTitle: "Delete Comment",
                                      deleteMessage:
                                      "Are you sure you want to delete this comment?",
                                    );
                                  },
                                  child: const Icon(
                                    CupertinoIcons.ellipsis_vertical,
                                    size: 20,
                                    color: Colors.black87,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      /// 📄 Comment or Editor
                      if (!_isEditing) ...[
                        Text(
                          widget.getTaskCommentData?.comment ?? '',
                          style: appTextStyle.appSubTitleStyle3(),
                        ),
                      ] else ...[
                        descriptionWidget(),
                        const SizedBox(height: 10),
                        editCommentBtRow(),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
