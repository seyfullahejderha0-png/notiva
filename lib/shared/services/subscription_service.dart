import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../modules/auth/controllers/auth_controller.dart';

final subscriptionServiceProvider = Provider((ref) => SubscriptionService(ref));

class SubscriptionService {
  final Ref _ref;
  final _firestore = FirebaseFirestore.instance;
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  // The Set of product IDs to query
  static const Set<String> _kProductIds = {
    'notiva_basic_aylik',
    'notiva_basic_yillik',
    'notiva_pro_aylik',
    'notiva_pro_yillik',
    'notiva_enterprise_aylik',
    'notiva_enterprise_yillik',
    'notiva_ek_depo_aylik',
    'notiva_ek_depo_yillik',
    'notiva_ek_alan_aylik',
    'notiva_ek_alan_yillik',
  };

  SubscriptionService(this._ref);

  Future<void> init() async {
    final bool available = await _iap.isAvailable();
    if (!available) {
      debugPrint('InAppPurchase is not available');
      return;
    }

    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onDone: () => _subscription?.cancel(),
      onError: (error) {
        debugPrint('Purchase Stream Error: $error');
      },
    );
    
    // Restore previous purchases when the app starts
    if (Platform.isIOS || Platform.isAndroid) {
      try {
        await _iap.restorePurchases();
      } catch (e) {
        debugPrint('Restore purchases error: $e');
      }
    }
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        debugPrint('Purchase is pending: ${purchaseDetails.productID}');
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        debugPrint('Purchase Error: ${purchaseDetails.error}');
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
            
        // Satın alım başarılı! Kullanıcının yetkilerini Firestore'a kaydet.
        await _verifyAndDeliverProduct(purchaseDetails);

        // Satın alım işlemini bitir (consume/acknowledge)
        if (purchaseDetails.pendingCompletePurchase) {
          await _iap.completePurchase(purchaseDetails);
        }
      }
    }
  }

  Future<void> _verifyAndDeliverProduct(PurchaseDetails purchaseDetails) async {
    final user = _ref.read(authControllerProvider).user;
    if (user == null) return;

    final productId = purchaseDetails.productID;
    String? newPlan;
    bool? hasExtraStorage;
    bool? hasExtraWorkspace;

    if (productId.contains('basic')) {
      newPlan = 'basic';
    } else if (productId.contains('pro')) {
      newPlan = 'professional';
    } else if (productId.contains('enterprise')) {
      newPlan = 'enterprise';
    } else if (productId.contains('ek_depo')) {
      hasExtraStorage = true;
    } else if (productId.contains('ek_alan')) {
      hasExtraWorkspace = true;
    }

    try {
      final updateData = <String, dynamic>{};
      if (newPlan != null && newPlan != user.subscriptionType) {
        updateData['subscriptionType'] = newPlan;
      }
      if (hasExtraStorage != null && hasExtraStorage != user.hasExtraStorage) {
        updateData['hasExtraStorage'] = hasExtraStorage;
      }
      if (hasExtraWorkspace != null && hasExtraWorkspace != user.hasExtraWorkspace) {
        updateData['hasExtraWorkspace'] = hasExtraWorkspace;
      }

      if (updateData.isNotEmpty) {
        await _firestore.collection('users').doc(user.id).update(updateData);
      }
    } catch (e) {
      debugPrint('Deliver product error: $e');
    }
  }

  Future<List<ProductDetails>> getOfferings() async {
    try {
      final ProductDetailsResponse response = await _iap.queryProductDetails(_kProductIds);
      if (response.error != null) {
        debugPrint('Query product details error: ${response.error!.message}');
        return [];
      }
      return response.productDetails;
    } catch (e) {
      debugPrint('Get offerings error: $e');
      return [];
    }
  }

  Future<bool> purchasePackage(ProductDetails product) async {
    try {
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
      return await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      debugPrint('Purchase error: $e');
      return false;
    }
  }

  void dispose() {
    _subscription?.cancel();
  }
}
