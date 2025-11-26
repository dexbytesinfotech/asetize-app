  import '../../../imports.dart';

abstract class AssetsManagementEvent {}


class OnGetAssetsCategoryList extends AssetsManagementEvent {
  final BuildContext? mContext;
  OnGetAssetsCategoryList({required this.mContext});
}



  class OnGetAssetsLocationList extends AssetsManagementEvent {
    final BuildContext? mContext;
    OnGetAssetsLocationList({required this.mContext});
  }


class OnAddAssetCategoryEvent extends AssetsManagementEvent {
  final BuildContext? mContext;
  final String title;
  OnAddAssetCategoryEvent({required this.mContext, required this.title});
}

class OnGetVendorList extends AssetsManagementEvent {
  final BuildContext mContext;
  OnGetVendorList({required this.mContext});
}

class OnAddVendorEvent extends AssetsManagementEvent {
  final BuildContext mContext;
  final String name;
  OnAddVendorEvent({required this.mContext, required this.name});
}

class OnAddAssetEvent extends AssetsManagementEvent {
  final String title;
  final int assetCategoryId;
  final int vendorId;
  final String purChaseDate;
  final String smallDescription;
  final int? expiryMonths;
  final int? warrantyMonths;
  final double purchaseCost;
  final String? modelNumber;
  final String? manufacturer;
  final String? licenseKey;
  final String? accountCredential;
  final String? longDescription;
  final String? barcode;
  final String? assetLocation;
  final List<String>? invoiceFile;


  OnAddAssetEvent({
    required this.title,
    required this.assetCategoryId,
    required this.vendorId,
    required this.purChaseDate,
    required this.smallDescription,
    this.expiryMonths,
    this.warrantyMonths,
    required this.purchaseCost,
    this.modelNumber,
    this.manufacturer,
    this.licenseKey,
    this.accountCredential,
    this.longDescription,
    this.invoiceFile,
    this.assetLocation,
    this.barcode
  });
}

  class OnGetAssetFilterList extends AssetsManagementEvent {
    final BuildContext? mContext;
    OnGetAssetFilterList({ this.mContext});
  }
  class OnGetAssetListEvent extends AssetsManagementEvent {
    final int? assetCategoryId;
    final int? vendorId;
    final String? search;
    final String? status;
    final bool? isClearAssetList;
    final BuildContext? mContext;
    final int? nextPageKey;


    OnGetAssetListEvent({
      this.assetCategoryId,
      this.vendorId,
      this.search,
      this.status,
      this.isClearAssetList = false,
      this.mContext,
      this.nextPageKey,

    });
  }



  class OnGetMyLiabilityListEvent extends AssetsManagementEvent {
    final int? assetCategoryId;
    final int? vendorId;
    final String? search;
    final String? status;
    final bool? isClearAssetList;
    final BuildContext? mContext;
    final int? nextPageKey;
    final int? myLiability;

    OnGetMyLiabilityListEvent({
      this.assetCategoryId,
      this.vendorId,
      this.search,
      this.status,
      this.isClearAssetList = false,
      this.mContext,
      this.nextPageKey,
      this.myLiability
    });
  }



  class OnGetMyAssetListEvent extends AssetsManagementEvent {
    final int? assetCategoryId;
    final int? vendorId;
    final String? search;
    final String? status;
    final bool? isClearAssetList;
    final BuildContext? mContext;
    final int? nextPageKey;

    OnGetMyAssetListEvent({
      this.assetCategoryId,
      this.vendorId,
      this.search,
      this.status,
      this.isClearAssetList = false,
      this.mContext,
      this.nextPageKey
    });
  }



  class OnGetAssetDetailListEvent extends AssetsManagementEvent {
    final int assetId;
    final BuildContext? mContext;
    OnGetAssetDetailListEvent({
      required this.assetId,
      this.mContext,
    });
  }


  class OnChangeAssetStatusEvent extends AssetsManagementEvent {
    final int? assetId;
    final int? userId;
    final String status;
    final BuildContext? mContext;
    OnChangeAssetStatusEvent({
      required this.assetId,
       this.userId,
      required this.status,
      this.mContext,
    });
  }


  class OnUpdateAssetEvent extends AssetsManagementEvent {
    final int assetId;
    final String title;
    final int assetCategoryId;
    final int vendorId;
    final String purChaseDate;
    final String smallDescription;
    final int? expiryMonths;
    final String? warrantyMonths;
    final double purchaseCost;
    final String? modelNumber;
    final String? manufacturer;
    final String? licenseKey;
    final String? accountCredential;
    final String? longDescription;
    final List<String>? invoiceFile;
    final String? assetLocation;



    OnUpdateAssetEvent({
      required this.assetId,
      required this.title,
      required this.assetCategoryId,
      required this.vendorId,
      required this.purChaseDate,
      required this.smallDescription,
      this.expiryMonths,
      this.warrantyMonths,
      required this.purchaseCost,
      this.modelNumber,
      this.manufacturer,
      this.licenseKey,
      this.accountCredential,
      this.longDescription,
      this.invoiceFile,
      this.assetLocation
    });
  }

  class OnAssetMemberListEvent extends AssetsManagementEvent {
    final BuildContext mContext;
    OnAssetMemberListEvent({required this.mContext});
  }

  class OnCheckBarcodeEvent extends AssetsManagementEvent {
    final BuildContext mContext;
    final String barcode;
    OnCheckBarcodeEvent({required this.mContext, required this.barcode});
  }



  // /api/barcodes/unassigned-assets


  // class OnGetUnassignedBarcodesAssetsList extends AssetsManagementEvent {
  //   final BuildContext? mContext;
  //   OnGetUnassignedBarcodesAssetsList({ this.mContext});
  // }

  class OnGetUnassignedBarcodesAssetsList extends AssetsManagementEvent {
    final int? assetCategoryId;
    final int? vendorId;
    final String? search;
    final String? status;
    final bool? isClearAssetList;
    final BuildContext? mContext;
    final int? nextPageKeyForAssignBarcode;


    OnGetUnassignedBarcodesAssetsList({
      this.assetCategoryId,
      this.vendorId,
      this.search,
      this.status,
      this.isClearAssetList = false,
      this.mContext,
      this.nextPageKeyForAssignBarcode
    });
  }


  class OnAssignBarcodeToAsset extends AssetsManagementEvent {
    final BuildContext? mContext;
    final String barcode;
    final int productId;
    // {
    // "barcode": "OXVRZM-0000069",
    // "product_id": 1
    // }
    OnAssignBarcodeToAsset({ this.mContext, required this.barcode, required this.productId,  });
  }


  class OnAssetConfirmationEvent extends AssetsManagementEvent {
    final int assetId;
    final String status;
    final String? isGoodCondition;
    final BuildContext? mContext;
    OnAssetConfirmationEvent({
      required this.assetId,
      required this.status,
      this.isGoodCondition,
      this.mContext,
    });
  }



  class OnSendAssetAcceptReminderEvent extends AssetsManagementEvent {
    final int assetId;
    OnSendAssetAcceptReminderEvent({
      required this.assetId,
    });
  }

  class OnGetAssetHistoryEvent extends AssetsManagementEvent {
    final int assetId;
    OnGetAssetHistoryEvent({
      required this.assetId,
    });
  }