abstract class AssetsManagementState {}

class AssetsManagementInitialState extends AssetsManagementState {}

class AssetsManagementLoadingState extends AssetsManagementState {}

class AssetsManagementDoneState extends AssetsManagementState {}

class AssetsManagementErrorState extends AssetsManagementState {}


class GetAssetsCategoryListLoadingState extends AssetsManagementState {}
class AddAssetCategoryLoadingState extends AssetsManagementState {}

class GetAssetsCategoryListErrorState extends AssetsManagementState {
  final String errorMessage;
  GetAssetsCategoryListErrorState({required this.errorMessage});
}

class AddAssetCategoryErrorState extends AssetsManagementState {
  final String errorMessage;
  AddAssetCategoryErrorState({required this.errorMessage});
}

class GetAssetsCategoryListDoneState extends AssetsManagementState {
  final String message;
  GetAssetsCategoryListDoneState({required this.message});
}

class AddAssetCategoryDoneState extends AssetsManagementState {
  final String message;
  AddAssetCategoryDoneState({required this.message});
}


class GetVendorListLoadingState extends AssetsManagementState {}
class GetVendorListDoneState extends AssetsManagementState {
  final String message;
  GetVendorListDoneState({required this.message});
}
class GetVendorListErrorState extends AssetsManagementState {
  final String errorMessage;
  GetVendorListErrorState({required this.errorMessage});
}

class AddVendorLoadingState extends AssetsManagementState {}
class AddVendorDoneState extends AssetsManagementState {
  final String message;
  AddVendorDoneState({required this.message});
}
class AddVendorErrorState extends AssetsManagementState {
  final String errorMessage;
  AddVendorErrorState({required this.errorMessage});
}

class OnShowListDataErrorState extends AssetsManagementState {
  final String errorMessage;
  OnShowListDataErrorState({required this.errorMessage});
}


class OnShowListDataDoneState extends AssetsManagementState {
  final String message;
  OnShowListDataDoneState({required this.message});
}

class AddAssetLoadingState extends AssetsManagementState {}

class AddAssetDoneState extends AssetsManagementState {
  final String message;
  AddAssetDoneState({required this.message});
}

class AddAssetErrorState extends AssetsManagementState {
  final String errorMessage;
  AddAssetErrorState({required this.errorMessage});
}


class GetAssetFilterListLoadingState extends AssetsManagementState {}

class GetAssetFilterListDoneState extends AssetsManagementState {
  final String message;
  GetAssetFilterListDoneState({required this.message});
}

class GetAssetFilterListErrorState extends AssetsManagementState {
  final String errorMessage;
  GetAssetFilterListErrorState({required this.errorMessage});
}
class GetAssetListLoadingState extends AssetsManagementState {}

class GetAssetListDoneState extends AssetsManagementState {
  final String message;
  GetAssetListDoneState({required this.message});
}

class GetAssetListErrorState extends AssetsManagementState {
  final String errorMessage;
  GetAssetListErrorState({required this.errorMessage});
}


class GetAssetDetailListLoadingState extends AssetsManagementState {}

class GetAssetDetailListDoneState extends AssetsManagementState {
  final String message;
  GetAssetDetailListDoneState({required this.message});
}

class GetAssetDetailListErrorState extends AssetsManagementState {
  final String errorMessage;
  GetAssetDetailListErrorState({required this.errorMessage});
}

class ChangeAssetStatusLoadingState extends AssetsManagementState {}

class ChangeAssetStatusDoneState extends AssetsManagementState {
  final String message;
  ChangeAssetStatusDoneState({required this.message});
}

class ChangeAssetStatusErrorState extends AssetsManagementState {
  final String errorMessage;
  ChangeAssetStatusErrorState({required this.errorMessage});
}
class UpdateAssetLoadingState extends AssetsManagementState {}

class UpdateAssetDoneState extends AssetsManagementState {
  final String message;
  UpdateAssetDoneState({required this.message});
}

class UpdateAssetErrorState extends AssetsManagementState {
  final String errorMessage;
  UpdateAssetErrorState({required this.errorMessage});
}
class AssetMemberListLoadingState extends AssetsManagementState {}

class AssetMemberListDoneState extends AssetsManagementState {
  final String message;
  AssetMemberListDoneState({required this.message});
}

class AssetMemberListErrorState extends AssetsManagementState {
  final String errorMessage;
  AssetMemberListErrorState({required this.errorMessage});
}
class CheckBarcodeLoadingState extends AssetsManagementState {}

class CheckBarcodeDoneState extends AssetsManagementState {
  final String message;
  final String barcode;
  final bool isAssign;
  final int? assetId;
  CheckBarcodeDoneState({required this.message,required this.barcode,required this.isAssign, this.assetId});
}

class CheckBarcodeErrorState extends AssetsManagementState {
  final String errorMessage;
  CheckBarcodeErrorState({required this.errorMessage});
}
class GetUnassignedBarcodesAssetsLoadingState extends AssetsManagementState {}

class GetUnassignedBarcodesAssetsDoneState extends AssetsManagementState {
  final String message;
  GetUnassignedBarcodesAssetsDoneState({required this.message});
}

class GetUnassignedBarcodesAssetsErrorState extends AssetsManagementState {
  final String errorMessage;
  GetUnassignedBarcodesAssetsErrorState({required this.errorMessage});
}
class AssignBarcodeToAssetLoadingState extends AssetsManagementState {}

class AssignBarcodeToAssetDoneState extends AssetsManagementState {
  final String message;
  AssignBarcodeToAssetDoneState({required this.message});
}

class AssignBarcodeToAssetErrorState extends AssetsManagementState {
  final String errorMessage;
  AssignBarcodeToAssetErrorState({required this.errorMessage});
}

class GetMyAssetListLoadingState extends AssetsManagementState {}

class GetMyAssetListDoneState extends AssetsManagementState {
  final String message;
  GetMyAssetListDoneState({required this.message});
}

class  GetMyAssetListErrorState extends AssetsManagementState {
  final String errorMessage;
  GetMyAssetListErrorState({required this.errorMessage});
}

class GetAssetsLocationListLoadingState extends AssetsManagementState {}

class GetAssetsLocationListDoneState extends AssetsManagementState {
  final String message;
  GetAssetsLocationListDoneState({required this.message});
}

class  GetAssetsLocationListErrorState extends AssetsManagementState {
  final String errorMessage;
  GetAssetsLocationListErrorState({required this.errorMessage});
}
class AssetConfirmationLoadingState extends AssetsManagementState {}

class AssetConfirmationDoneState extends AssetsManagementState {
  final String message;
  AssetConfirmationDoneState({required this.message});
}

class  AssetConfirmationErrorState extends AssetsManagementState {
  final String errorMessage;
  AssetConfirmationErrorState({required this.errorMessage});
}

class MyLiabilityListLoadingState extends AssetsManagementState {}

class MyLiabilityListDoneState extends AssetsManagementState {
  final String message;
  MyLiabilityListDoneState({required this.message});
}

class  MyLiabilityListErrorState extends AssetsManagementState {
  final String errorMessage;
  MyLiabilityListErrorState({required this.errorMessage});
}
class SendAssetAcceptReminderLoadingState extends AssetsManagementState {}

class SendAssetAcceptReminderDoneState extends AssetsManagementState {
  final String message;
  SendAssetAcceptReminderDoneState({required this.message});
}

class  SendAssetAcceptReminderErrorState extends AssetsManagementState {
  final String errorMessage;
  SendAssetAcceptReminderErrorState({required this.errorMessage});
}

class GetAssetHistoryLoadingState extends AssetsManagementState {}

class GetAssetHistoryDoneState extends AssetsManagementState {
  final String message;
  GetAssetHistoryDoneState({required this.message});
}

class  GetAssetHistoryErrorState extends AssetsManagementState {
  final String errorMessage;
  GetAssetHistoryErrorState({required this.errorMessage});
}
