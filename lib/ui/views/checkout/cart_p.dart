import 'dart:io';
import 'package:aadab/ui/widgets/login_required_popup.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:aadab/core/models/product.dart';
import 'package:aadab/core/models/payment_response.dart';

import 'package:aadab/core/services/phonepe_s.dart';
import 'package:aadab/core/services/product_s.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'package:get_ip_address/get_ip_address.dart';
import 'package:provider/provider.dart';
import 'package:aadab/core/models/user_address.dart';
import 'package:aadab/core/models/add_to_cart.dart';
import 'package:aadab/core/providers/add_to_cart_pr.dart';
import 'package:aadab/core/providers/coupon_pr.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/core/providers/order_pr.dart';
import 'package:aadab/core/providers/product_pr.dart';
import 'package:aadab/core/providers/user_wallet_pr.dart';
import 'package:aadab/core/providers/user_address_pr.dart';
import 'package:aadab/locator.dart';
import 'package:aadab/ui/shared/font_sh.dart';
import 'package:aadab/ui/views/products/shops_p.dart';
import 'package:aadab/ui/views/profile/address_p.dart';
import 'package:aadab/ui/views/promocodes/promocodes_p.dart';
import 'package:aadab/ui/widgets/common_product_card.dart';
import 'package:aadab/core/services/favourite_wholesaler_s.dart';

import '../../../core/providers/wish_list_pr.dart';
import '../products/product_id_p.dart';

import 'package:badges/badges.dart' as badges;

class CartPage extends StatefulWidget {
  final isProfile;
  final arguments;

  const CartPage({Key? key, this.arguments, this.isProfile}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String coupon = '';
  String couponId = '';
  bool buttonLoading = false;
  int? loadingItemIndex; // Which cart item is loading
  String? quantityLoadingAction; // 'increment' or 'decrement'
  bool couponValidationLoading = false;
  double couponValue = 0;
  UserAddress address = UserAddress();
  Map<String, dynamic> _CartData = {
    'kindOfFlower': '',
    'flavour': '',
    'writeOnCake': '',
    'pack': '',
    'is_add_to_cart': false
  };
  String usedCoupon = '';
  int useWalletPoint = 0;
  bool _isLoading = true;

  final PhonePeService _phonePeService = locator<PhonePeService>();
  String result = "";

  // Helper to get active role
  String get _activeRole {
    final configModel = Provider.of<ConfigModel>(context, listen: false);
    return configModel.activeRole;
  }

  // Helper to find correct price object for a pack
  ProductPrices? _getProductPriceObj(Product product, String? packId) {
    if (packId != null && product.productPrices != null) {
      try {
        return product.productPrices!.firstWhere(
          (price) => price.productPackId.toString() == packId.toString(),
          orElse: () => product.productPrices![0],
        );
      } catch (e) {
        return product.productPrices?.isNotEmpty == true
            ? product.productPrices![0]
            : null;
      }
    } else if (product.productPrices?.isNotEmpty == true) {
      return product.productPrices![0];
    }
    return null;
  }

  // Helper to get effective price based on active role
  double _getEffectivePrice(ProductPrices? priceObj, {Product? product}) {
    if (priceObj == null) return 0.0;

    double price = 0.0;
    if (_activeRole == 'Distributor') {
      // Distributor Logic
      price =
          double.tryParse(priceObj.distributorPrice?.toString() ?? '0') ?? 0.0;

      // If distributor price is missing/zero, fallback to standard price
      if (price <= 0) {
        price = double.tryParse(priceObj.price?.toString() ?? '0') ?? 0.0;
      }

      // Check for distributor offer (if exists)
      double offer =
          double.tryParse(priceObj.distributorOfferPrice?.toString() ?? '0') ??
              0.0;
      if (offer > 0 && offer < price) {
        price = offer;
      }

      // Apply Favourite Wholesaler Discount (from Local Fetch)
      if (product != null) {
        double? discountPercent;

        // Priority 1: Check Local Fetch (App Side)
        if (_isDiscountsLoaded && _localDiscounts.containsKey(product.id)) {
          discountPercent = _localDiscounts[product.id];
        }
        // Priority 2: Fallback to API injected value (if local not ready or missing)
        else if (product.favWholesalerDiscount != null &&
            product.favWholesalerDiscount! > 0) {
          discountPercent = product.favWholesalerDiscount;
        }

        if (discountPercent != null && discountPercent > 0) {
          double discountAmount = (price * discountPercent) / 100;
          price -= discountAmount;
          // Temporarily attach to product for UI display if using local
          product.favWholesalerDiscount = discountPercent;
        }
      }

      return price;
    } else {
      // Standard User Logic (existing logic)
      price = double.tryParse(priceObj.price?.toString() ?? '0') ?? 0.0;
      double offer =
          double.tryParse(priceObj.offerPrice?.toString() ?? '0') ?? 0.0;
      if (offer > 0 && offer < price) {
        return offer;
      }
      return price;
    }
  }

  // Helper to get original price (for strikethrough display)
  double _getOriginalPrice(ProductPrices? priceObj) {
    if (priceObj == null) return 0.0;
    if (_activeRole == 'Distributor') {
      double price =
          double.tryParse(priceObj.distributorPrice?.toString() ?? '0') ?? 0.0;
      if (price <= 0)
        price = double.tryParse(priceObj.price?.toString() ?? '0') ?? 0.0;
      return price;
    } else {
      return double.tryParse(priceObj.price?.toString() ?? '0') ?? 0.0;
    }
  }

  // Selection state for cart items
  Set<int> _selectedCartItemIds = {};
  bool _selectAll = true;

  // Method to validate coupon against current cart total
  Future<void> _validateAppliedCoupon() async {
    if (usedCoupon.isNotEmpty && couponValue > 0) {
      setState(() {
        couponValidationLoading = true;
      });

      final CouponModel _couponModel =
          Provider.of<CouponModel>(context, listen: false);

      // Get current cart total
      final cartTotal = _calculateSelectedItemsTotal();

      // Re-verify the coupon to get updated data
      await _couponModel.verifyCoupon(usedCoupon);

      // Check if we have coupon data and validate minimum amount
      if (_couponModel.coupons != null && _couponModel.coupons!.isNotEmpty) {
        final appliedCoupon = _couponModel.coupons!.first;

        // If cart total is less than minimum order value, remove coupon
        if (appliedCoupon.minOrderValue! >= cartTotal) {
          setState(() {
            usedCoupon = '';
            couponValue = 0;
            couponId = '';
            coupon = '';
          });

          // Show message to user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Coupon removed as cart total is less than minimum amount of RS ${appliedCoupon.minOrderValue}'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }

      setState(() {
        couponValidationLoading = false;
      });
    }
  }

  // Method to recalculate rewards points based on current cart total
  Future<void> _recalculateRewards() async {
    final UserWalletModel _userWalletModel =
        Provider.of<UserWalletModel>(context, listen: false);

    // Only recalculate if rewards are currently being used
    if (_activeRole == 'Distributor') {
      if (useWalletPoint > 0) {
        setState(() {
          useWalletPoint = 0;
        });
      }
      return;
    }
    if (useWalletPoint > 0) {
      setState(() {
        // Calculate 25% of item total after coupon discount
        final cartTotal = _calculateSelectedItemsTotal();
        // Calculate using new method: item total = cartTotal / 105 * 100
        final itemTotal = (cartTotal / 105) * 100;
        // Item total is already calculated after coupon discount
        final cartAfterCoupon = itemTotal;

        final calculatedPoints = (cartAfterCoupon * 0.25).round();
        final availablePoints = _userWalletModel.totaRemainingPoint;
        useWalletPoint = calculatedPoints > availablePoints
            ? availablePoints
            : calculatedPoints;
      });
    }
  }
  // bool type = true;

  Payment? payment;

  // Initialize selection with all in-stock items selected
  void _initializeSelection() {
    final addToCartModel = Provider.of<AddToCartModel>(context, listen: false);
    if (addToCartModel.addToCarts != null) {
      _selectedCartItemIds.clear();
      for (var item in addToCartModel.addToCarts!) {
        if (item.id != null) {
          _selectedCartItemIds.add(item.id!);
        }
      }
      _updateSelectAllState();
    }
  }

  // Update select all checkbox state based on current selections (async to check stock)
  Future<void> _updateSelectAllStateAsync() async {
    final addToCartModel = Provider.of<AddToCartModel>(context, listen: false);
    if (addToCartModel.addToCarts != null &&
        addToCartModel.addToCarts!.isNotEmpty) {
      // Get only in-stock items
      List<int> inStockItemIds = [];
      for (var item in addToCartModel.addToCarts!) {
        if (item.id != null) {
          final availableQty = await _getAvailableQty(item);
          if (availableQty > 0) {
            inStockItemIds.add(item.id!);
          }
        }
      }
      setState(() {
        _selectAll = inStockItemIds.isNotEmpty &&
            inStockItemIds.every((id) => _selectedCartItemIds.contains(id));
      });
    } else {
      setState(() {
        _selectAll = false;
      });
    }
  }

  // Sync version for immediate UI updates
  void _updateSelectAllState() {
    final addToCartModel = Provider.of<AddToCartModel>(context, listen: false);
    if (addToCartModel.addToCarts != null &&
        addToCartModel.addToCarts!.isNotEmpty) {
      final selectableItems =
          addToCartModel.addToCarts!.where((item) => item.id != null).toList();
      // Simple check - will be corrected by async version if needed
      _selectAll = _selectedCartItemIds.isNotEmpty &&
          _selectedCartItemIds.length >= selectableItems.length;
    } else {
      _selectAll = false;
    }
  }

  // Toggle selection for a single item
  void _toggleItemSelection(int itemId) {
    setState(() {
      if (_selectedCartItemIds.contains(itemId)) {
        _selectedCartItemIds.remove(itemId);
      } else {
        _selectedCartItemIds.add(itemId);
      }
    });
    // Update select all state asynchronously to check stock status
    _updateSelectAllStateAsync();
  }

  // Toggle select all (only in-stock items)
  Future<void> _toggleSelectAll(bool? value) async {
    final addToCartModel = Provider.of<AddToCartModel>(context, listen: false);
    if (addToCartModel.addToCarts == null) return;

    if (value == true) {
      // Select all in-stock items only
      Set<int> newSelection = {};
      for (var item in addToCartModel.addToCarts!) {
        if (item.id != null) {
          final availableQty = await _getAvailableQty(item);
          if (availableQty > 0) {
            newSelection.add(item.id!);
          }
        }
      }
      setState(() {
        _selectedCartItemIds = newSelection;
        _selectAll = true;
      });
    } else {
      // Deselect all items
      setState(() {
        _selectedCartItemIds.clear();
        _selectAll = false;
      });
    }
  }

  // Remove out-of-stock items from selection
  Future<void> _removeOutOfStockFromSelection() async {
    final addToCartModel = Provider.of<AddToCartModel>(context, listen: false);
    if (addToCartModel.addToCarts == null) return;

    for (var item in addToCartModel.addToCarts!) {
      if (item.id != null) {
        final availableQty = await _getAvailableQty(item);
        if (availableQty <= 0) {
          _selectedCartItemIds.remove(item.id!);
        }
      }
    }
    setState(() {
      _updateSelectAllState();
    });
  }

  // Sync selection state with actual cart items (remove stale selections)
  void _syncSelectionsWithCart() {
    final addToCartModel = Provider.of<AddToCartModel>(context, listen: false);
    if (addToCartModel.addToCarts == null) {
      _selectedCartItemIds.clear();
      return;
    }

    // Get all current cart item IDs
    final currentCartItemIds = addToCartModel.addToCarts!
        .where((item) => item.id != null)
        .map((item) => item.id!)
        .toSet();

    // Remove any selected IDs that are no longer in the cart
    _selectedCartItemIds.removeWhere((id) => !currentCartItemIds.contains(id));

    setState(() {
      _updateSelectAllState();
    });
  }

  // Get selected cart items
  List<AddToCart> _getSelectedCartItems() {
    final addToCartModel = Provider.of<AddToCartModel>(context, listen: false);
    if (addToCartModel.addToCarts == null) return [];
    return addToCartModel.addToCarts!
        .where(
            (item) => item.id != null && _selectedCartItemIds.contains(item.id))
        .toList();
  }

  // Calculate total for selected items only
  int _calculateSelectedItemsTotal() {
    final addToCartModel = Provider.of<AddToCartModel>(context, listen: false);
    if (addToCartModel.addToCarts == null) return 0;

    double total = 0;
    for (var item in addToCartModel.addToCarts!) {
      if (item.id != null && _selectedCartItemIds.contains(item.id)) {
        // Find price object
        ProductPrices? priceObj = _getProductPriceObj(item.product!, item.pack);
        // Get effective price using helper
        double price = _getEffectivePrice(priceObj, product: item.product);
        total += price * (item.qty ?? 1);
      }
    }
    return total.toInt();
  }

  // Calculate total favourite wholesaler discount amount
  double _calculateTotalFavWholesalerDiscount() {
    final addToCartModel = Provider.of<AddToCartModel>(context, listen: false);
    if (addToCartModel.addToCarts == null) return 0.0;

    double totalDiscount = 0.0;
    for (var item in addToCartModel.addToCarts!) {
      if (item.id != null &&
          _selectedCartItemIds.contains(item.id) &&
          item.product != null) {
        ProductPrices? priceObj = _getProductPriceObj(item.product!, item.pack);

        // Calculate base distributor price (before fav discount)
        double price = 0.0;
        if (_activeRole == 'Distributor') {
          price =
              double.tryParse(priceObj?.distributorPrice?.toString() ?? '0') ??
                  0.0;
          if (price <= 0)
            price = double.tryParse(priceObj?.price?.toString() ?? '0') ?? 0.0;

          double offer = double.tryParse(
                  priceObj?.distributorOfferPrice?.toString() ?? '0') ??
              0.0;
          if (offer > 0 && offer < price) {
            price = offer;
          }

          // Calculate Discount Amount
          double? discountPercent;
          if (_isDiscountsLoaded &&
              _localDiscounts.containsKey(item.product!.id)) {
            discountPercent = _localDiscounts[item.product!.id];
          } else if (item.product!.favWholesalerDiscount != null &&
              item.product!.favWholesalerDiscount! > 0) {
            discountPercent = item.product!.favWholesalerDiscount;
          }

          if (discountPercent != null && discountPercent > 0) {
            double discountAmount = (price * discountPercent) / 100;
            totalDiscount += discountAmount * (item.qty ?? 1);
          }
        }
      }
    }
    return totalDiscount;
  }

  // Get favourite wholesaler discount percentage(s) for display
  String _getFavWholesalerDiscountPercentage() {
    final addToCartModel = Provider.of<AddToCartModel>(context, listen: false);
    if (addToCartModel.addToCarts == null) return '';

    Set<double> percentages = {};

    for (var item in addToCartModel.addToCarts!) {
      if (item.id != null &&
          _selectedCartItemIds.contains(item.id) &&
          item.product != null &&
          _activeRole == 'Distributor') {
        double? discountPercent;
        if (_isDiscountsLoaded &&
            _localDiscounts.containsKey(item.product!.id)) {
          discountPercent = _localDiscounts[item.product!.id];
        } else if (item.product!.favWholesalerDiscount != null &&
            item.product!.favWholesalerDiscount! > 0) {
          discountPercent = item.product!.favWholesalerDiscount;
        }

        if (discountPercent != null && discountPercent > 0) {
          percentages.add(discountPercent);
        }
      }
    }

    if (percentages.isEmpty) return '';
    if (percentages.length == 1) {
      return ' (' + percentages.first.toStringAsFixed(0) + '%)';
    } else {
      // If multiple different percentages, just show '(%)' or handle as needed
      return ' (%)';
    }
  }

  bool _isOnlyMadaniProducts() {
    final addToCartModel = Provider.of<AddToCartModel>(context, listen: false);
    if (addToCartModel.addToCarts == null) return false;

    var selectedItems = addToCartModel.addToCarts!
        .where(
            (item) => item.id != null && _selectedCartItemIds.contains(item.id))
        .toList();

    if (selectedItems.isEmpty) return false;

    for (var item in selectedItems) {
      String productName = item.product?.name?.toLowerCase() ?? '';
      if (!productName.contains('madani')) {
        return false;
      }
    }
    return true;
  }

  double _calculateTotalPayable() {
    final configModel = Provider.of<ConfigModel>(context, listen: false);
    int cartTotal = _calculateSelectedItemsTotal();
    double deliveryCharges = double.tryParse(
            configModel.user?.companies?[0].deliveryCharges?.toString() ??
                '0') ??
        0;
    double packagingCharges = double.tryParse(
            configModel.user?.companies?[0].packagingCharges?.toString() ??
                '0') ??
        0;
    double platformFeeValue = double.tryParse(
            configModel.user?.companies?[0].platformFee?.toString() ?? '0') ??
        0;
    return cartTotal +
        deliveryCharges +
        packagingCharges +
        platformFeeValue -
        couponValue -
        useWalletPoint;
  }

  bool _addGst = false;

  bool _isDiscountsLoaded = false;
  Map<int, double> _localDiscounts = {};

  Future<void> _fetchDiscounts() async {
    if (_activeRole != 'Distributor') return;

    final user = Provider.of<ConfigModel>(context, listen: false).user;
    if (user != null && user.id != null) {
      final service = locator<FavouriteWholesalerService>();
      final discounts = await service.getDiscounts(user.id!);

      if (mounted) {
        setState(() {
          _localDiscounts = {
            for (var d in discounts)
              d['product_id'] as int: (d['discount'] is int
                  ? (d['discount'] as int).toDouble()
                  : d['discount'] as double)
          };
          _isDiscountsLoaded = true;
        });
      }
    }
  }

  @override
  void initState() {
    initializePhonePe();
    // Initialize address from arguments if provided
    if (widget.arguments != null && widget.arguments['address'] != null) {
      address = UserAddress.fromJson(widget.arguments['address']);
    }
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
      _initializeSelection();
      _removeOutOfStockFromSelection();
      _fetchDiscounts();
    });
  }

  void initializePhonePe() async {
    try {
      await _phonePeService.initializePhonePe();
      setState(() {
        result = "PhonePe SDK Initialized";
      });
    } catch (error) {
      setState(() {
        result = "Error Initializing SDK: $error";
      });
    }

    print('Check $result');
  }

  // Helper method to get available quantity for a cart item
  Future<int> _getAvailableQty(cartItem) async {
    try {
      debugPrint(
          '_getAvailableQty: Fetching for productId=${cartItem.productId}, pack=${cartItem.pack}');
      final productService = locator<ProductService>();
      final product =
          await productService.getProductById(cartItem.productId ?? 0);

      if (product != null &&
          product.productPacks != null &&
          product.productPacks!.isNotEmpty) {
        debugPrint(
            '_getAvailableQty: Found ${product.productPacks!.length} packs');
        try {
          final matchingPack = product.productPacks!.firstWhere(
            (pack) => pack.id.toString() == cartItem.pack,
          );
          debugPrint(
              '_getAvailableQty: Found matching pack with qty=${matchingPack.qty}');
          return matchingPack.qty ?? 0;
        } catch (e) {
          debugPrint(
              '_getAvailableQty: No matching pack found, using first pack');
          if (product.productPacks!.isNotEmpty) {
            return product.productPacks!.first.qty ?? 0;
          }
        }
      }
      debugPrint(
          '_getAvailableQty: Falling back to product qty=${cartItem.product?.qty}');
      return cartItem.product?.qty ?? 0;
    } catch (e) {
      debugPrint('_getAvailableQty ERROR: $e');
      return 0;
    }
  }

  // Helper method to get list of out of stock items (checks only selected items)
  // Returns map with 'outOfStock' and 'insufficientStock' lists
  Future<Map<String, List<Map<String, dynamic>>>> _getOutOfStockItems() async {
    List<Map<String, dynamic>> outOfStockItems = [];
    List<Map<String, dynamic>> insufficientStockItems = [];
    final addToCartModel = Provider.of<AddToCartModel>(context, listen: false);

    if (addToCartModel.addToCarts != null) {
      for (var cartItem in addToCartModel.addToCarts!) {
        // Only check selected items
        if (cartItem.id != null && _selectedCartItemIds.contains(cartItem.id)) {
          final availableQty = await _getAvailableQty(cartItem);
          final orderedQty = cartItem.qty ?? 1;

          if (availableQty <= 0) {
            outOfStockItems.add({
              'name': cartItem.product?.name ?? 'Unknown Product',
              'orderedQty': orderedQty,
              'availableQty': availableQty,
            });
          } else if (orderedQty > availableQty) {
            insufficientStockItems.add({
              'name': cartItem.product?.name ?? 'Unknown Product',
              'orderedQty': orderedQty,
              'availableQty': availableQty,
            });
          }
        }
      }
    }
    return {
      'outOfStock': outOfStockItems,
      'insufficientStock': insufficientStockItems,
    };
  }

  Future<void> _startTransaction(int amount, String mobileNumber,
      Map<String, dynamic> payload, BuildContext context) async {
    debugPrint("PhonePe V2 Transaction initiated");

    // Store provider references before async operation to avoid accessing deactivated widget
    final OrderModel orderModel =
        Provider.of<OrderModel>(context, listen: false);
    final navigator = Navigator.of(context);

    setState(() {
      _isLoading = true;
    });

    // try {
    // Generate unique merchant order ID as per V2 documentation
    final merchantOrderId = DateTime.now().millisecondsSinceEpoch.toString();

    debugPrint("PhonePe V2 Transaction Details:");
    debugPrint("Amount: ${amount * 100} paisa");
    debugPrint("Merchant Order ID: $merchantOrderId");

    // Start transaction using V2 documentation compliant method
    payment = await _phonePeService.startTransaction(
      merchantOrderId: merchantOrderId,
      // amount: 100, // Amount in paisa as per docs
      amount: amount * 100, // Amount in paisa as per docs
    );

    // Check if widget is still mounted after async operation
    if (!mounted) return;

    debugPrint("Transaction completed with state: ${payment?.state}");

    if (payment?.state == 'COMPLETED') {
      payload['transaction_id'] = payment?.transactionId.toString();
      payload['payment_type'] = payment?.paymentInstrument?.type.toString();
      payload['account_type'] =
          payment?.paymentInstrument?.accountType.toString();
      payload['merchant_transaction_id'] =
          payment?.merchantTransactionId.toString();
      payload['merchant_id'] = payment?.merchantId.toString();
      payload['utr'] = payment?.paymentInstrument?.utr.toString();

      // Use the pre-stored orderModel reference
      final OrderModel _orderModel = orderModel;

      // Create payment details string with transaction info
      String paymentDetails =
          'Online Payment - Transaction ID: ${payment!.transactionId}';
      if (payment!.transactionId != null) {
        paymentDetails += ', Order ID: ${payment!.transactionId}';
      }

      // Use selected items only for the order
      final selectedItems = _getSelectedCartItems();

      bool orderResponse = await _orderModel.placedOrder(
        selectedItems,
        payload['cartTotal'],
        payload['addressId'],
        payload['isGift'],
        payload['useWalletPoint'],
        payload['couponId'],
        paymentDetails,
        payload['deliveryMethod'],
        payload['couponValue'],
        payload['gstAmount'],
        payload['platformFee'],
        payload['gstNumber'], // Add GST Number
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      if (orderResponse == true) {
        navigator.pushNamed('/successPage');
      }
    } else if (payment?.state == 'PENDING') {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }

      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Text("Payment Pending"),
              content: Text(
                  "Your payment is being processed. You will receive a confirmation shortly. Check your order status in the app."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("OK", style: TextStyle(color: Colors.black)),
                ),
              ],
            );
          },
        );
      }
    } else if (payment?.state == 'FAILED' || payment?.state == 'FAILURE') {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Text("Payment Failed"),
              content: Text(
                  "Payment failed: ${payment?.state}. Please try again or contact support."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("OK", style: TextStyle(color: Colors.black)),
                ),
              ],
            );
          },
        );
      }
    } else {
      // Handle unknown or other states
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Text("Transaction Status"),
              content: Text(
                  "Transaction status: ${payment?.state ?? 'Unknown'}. Please check your order status or contact support."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("OK", style: TextStyle(color: Colors.black)),
                ),
              ],
            );
          },
        );
      }
      // .then((_) {
      //   Navigator.pop(context);
      //   Navigator.pushNamed(
      //     context,
      //     '/bookingReview',
      //     arguments: {"payloadData": widget.payload['payloadData']},
      //   );
      // });
    }
  }

  Future<void> _loadData() async {
    try {
      var productId = '';

      // Load all required data
      // Load all required data in parallel
      await Future.wait(<Future<dynamic>>[
        Provider.of<AddToCartModel>(context, listen: false)
            .getAddToCart('', '', _CartData),
        Provider.of<ProductModel>(context, listen: false).getRandomProducts(),
        // Provider.of<OrderModel>(context, listen: false).getOrder(), // Unused call removed
        Provider.of<UserWalletModel>(context, listen: false).getMyUserWallets(),
        Provider.of<WishListModel>(context, listen: false)
            .getWishLists(productId),
        Provider.of<UserAddressModel>(context, listen: false)
            .getUserAddresses(),
      ]);

      // Update calculations after data is loaded
      if (mounted) {
        setState(() {
          _isLoading = false;

          // Initialize address from saved addresses if user has any
          final userAddressModel =
              Provider.of<UserAddressModel>(context, listen: false);

          debugPrint('Debug: Address ID before check: ${address.id}');
          debugPrint(
              'Debug: User Addresses count: ${userAddressModel.userAddresses?.length}');

          // Only set address if not already set from arguments and user has saved addresses
          if (address.id == null &&
              userAddressModel.userAddresses != null &&
              userAddressModel.userAddresses!.isNotEmpty) {
            // Debug the raw addresses
            for (var addr in userAddressModel.userAddresses!) {
              debugPrint(
                  'Debug: Address ID: ${addr.id}, isDefault: ${addr.isDefault} (Type: ${addr.isDefault.runtimeType})');
            }

            // Check for default address
            final defaultAddresses = userAddressModel.userAddresses!
                .where((element) => element.isDefault == 1);

            debugPrint(
                'Debug: Found ${defaultAddresses.length} default addresses');

            if (defaultAddresses.isNotEmpty) {
              address = defaultAddresses.first;
              debugPrint('Debug: Set default address: ${address.id}');
            }
          }

          // Auto-fill GST Number from user profile
          final configModel = locator<ConfigModel>();
          if (configModel.user?.gstNumber != null &&
              configModel.user!.gstNumber!.isNotEmpty) {
            _gstController.text = configModel.user!.gstNumber!;
            _addGst = true;
          }
          // Calculate 25% of item total after coupon discount
          final addToCartModel =
              Provider.of<AddToCartModel>(context, listen: false);
          final cartTotal =
              num.parse(addToCartModel.cartTotal.toString()).toInt();
          // Calculate GST on cart total after applying coupon discount
          final cartTotalAfterCoupon = cartTotal - couponValue;
          // Calculate using new method: item total = cartTotalAfterCoupon / 105 * 100
          final itemTotal = (cartTotalAfterCoupon / 105) * 100;
          // Item total is already calculated after coupon discount
          final cartAfterCoupon = itemTotal;

          final calculatedPoints = (cartAfterCoupon * 0.25).round();
          final availablePoints =
              Provider.of<UserWalletModel>(context, listen: false)
                  .totaRemainingPoint;
          useWalletPoint = calculatedPoints > availablePoints
              ? availablePoints
              : calculatedPoints;
        });
      }
    } catch (e) {
      debugPrint('Error loading cart data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Show error message if it's a network error
        if (e.toString().contains('SocketException') ||
            e.toString().contains('Connection') ||
            e.toString().contains('Failed host lookup')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('No internet connection. Please check your network.'),
              action: SnackBarAction(
                label: 'Retry',
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                  });
                  _loadData();
                },
              ),
            ),
          );
        }
      }
    }
  }

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  String? identifier = '';

  Future<void> initPlatformState() async {
    try {
      if (Platform.isAndroid) {
        _deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      }
    } on PlatformException {
      _deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    // identifier = _deviceData['id'] + '@' + _deviceData['model'] + 'gmail.com';
    identifier = _deviceData['id'] + '@gmail.com';
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'systemFeatures': build.systemFeatures,
      // 'displaySizeInches':
      //     ((build.displayMetrics.sizeInches * 10).roundToDouble() / 10),
      // 'displayWidthPixels': build.displayMetrics.widthPx,
      // 'displayWidthInches': build.displayMetrics.widthInches,
      // 'displayHeightPixels': build.displayMetrics.heightPx,
      // 'displayHeightInches': build.displayMetrics.heightInches,
      // 'displayXDpi': build.displayMetrics.xDpi,
      // 'displayYDpi': build.displayMetrics.yDpi,
      'serialNumber': build.serialNumber,
    };
  }

  TextEditingController _controller = TextEditingController();
  TextEditingController _gstController = TextEditingController();
  List<Map<String, dynamic>> paymentOptions = [
    {
      "name": 'Cash on Delivery',
      "icon": "assets/images/cash-on-delivery-logo-free-png.webp",
    },
    {
      "name": "UPI - Online",
      "icon": "assets/images/PhonePe-Logo.wine.png",
    }
  ];

  var paymentOption = '';

  bool isGift = false;

  // Store order details for Razorpay
  Map<String, dynamic> _orderDetails = {};

  // void _handlePaymentSuccess(PaymentSuccessResponse response) async {
  //   // Payment success, now place the order
  //   debugPrint('Payment Success: ${response.paymentId}');
  //   debugPrint('Payment Order ID: ${response.orderId}');
  //   debugPrint('Payment Signature: ${response.signature}');

  //   final AddToCartModel _addToCartModel =
  //       Provider.of<AddToCartModel>(context, listen: false);
  //   final OrderModel _orderModel =
  //       Provider.of<OrderModel>(context, listen: false);

  //   // Create payment details string with transaction info
  //   String paymentDetails =
  //       'Online Payment - Transaction ID: ${response.paymentId}';
  //   if (response.orderId != null) {
  //     paymentDetails += ', Order ID: ${response.orderId}';
  //   }

  //   bool orderResponse = await _orderModel.placedOrder(
  //     _addToCartModel.addToCarts!.toList(),
  //     _orderDetails['cartTotal'],
  //     _orderDetails['addressId'],
  //     _orderDetails['isGift'],
  //     _orderDetails['useWalletPoint'],
  //     _orderDetails['couponId'],
  //     paymentDetails,
  //     _orderDetails['deliveryMethod'],
  //     _orderDetails['couponValue'],
  //   );

  //   if (orderResponse == true) {
  //     Navigator.pushNamed(context, '/successPage');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while data is being loaded
    if (_isLoading) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFFEF9), Color(0xFFFFFDF7), Colors.white],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFEED056).withOpacity(0.15),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFFEED056)),
                    strokeWidth: 3,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Loading...',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 16.0.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff232323),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final AddToCartModel _addToCartModel =
        Provider.of<AddToCartModel>(context, listen: false);
    final ConfigModel _configModel = locator<ConfigModel>();
    final OrderModel _orderModel =
        Provider.of<OrderModel>(context, listen: false);
    final CouponModel _couponModel =
        Provider.of<CouponModel>(context, listen: false);
    final UserWalletModel _userWaletModel =
        Provider.of<UserWalletModel>(context, listen: false);
    final ProductModel _productModel =
        Provider.of<ProductModel>(context, listen: false);

    // Note: User's saved addresses are loaded in _loadData() and set there if available

    double discountPrice = 0.0;
    return WillPopScope(
      onWillPop: () async {
        if (widget.isProfile != null && widget.isProfile['isProfile'] == true) {
          Navigator.pushReplacementNamed(context, '/profilePage');
        } else {
          Navigator.pop(context);
        }
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: _buildBottomNavigationBar(context, _configModel,
            _addToCartModel, _addToCartModel.addToCarts?.length ?? 0),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFFEF9), Color(0xFFFFFDF7), Colors.white],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFEED056),
                                Color(0xFFF6E27F),
                              ],
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30.r),
                              bottomRight: Radius.circular(30.r),
                            ),
                          ),
                          padding: EdgeInsets.fromLTRB(20.w, 10.w, 20.w, 25.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (widget.isProfile != null &&
                                          widget.isProfile['isProfile'] ==
                                              true) {
                                        Navigator.pushReplacementNamed(
                                            context, '/profilePage');
                                      } else {
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(8.0.w),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.arrow_back_ios_new,
                                        size: 16.0.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  // SizedBox(width: 12.0.w),
                                  Text(
                                    'My Cart',
                                    textAlign: TextAlign.center,
                                    style: MyGoogleFontStyle(
                                      fontFamily: 'Urbanist',
                                      fontSize: 20.0.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(''),
                                ],
                              ),
                              SizedBox(height: 30.0.w),
                              Container(
                                height: 45.0.w,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.0.w, vertical: 2.0.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.0.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.search,
                                      color: Color(0xFF909090),
                                      size: 20.0.sp,
                                    ),
                                    SizedBox(width: 12.0.w),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _controller,
                                        onChanged: (value) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ShopsPage(
                                                  initialText:
                                                      value.toString()),
                                            ),
                                          );
                                          _controller.clear();
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'Search',
                                          hintStyle: TextStyle(
                                            color: Color(0xFFAAAAAA),
                                            fontSize: 14.0.sp,
                                            fontFamily: 'Urbanist',
                                            fontWeight: FontWeight.w400,
                                          ),
                                          border: InputBorder.none,
                                          contentPadding:
                                              EdgeInsets.symmetric(vertical: 0),
                                          isDense: true,
                                        ),
                                        style: TextStyle(
                                          color: Color(0xff232323),
                                          fontSize: 14.0.sp,
                                          fontFamily: 'Urbanist',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Body
                        Container(
                          width: 1.0.sw - 50,
                          // height: 1.0.sh - 250,
                          child: _addToCartModel.addToCarts!.isEmpty
                              ? Column(
                                  children: [
                                    SizedBox(
                                      height: 60,
                                      child:
                                          Center(child: Text('Cart is empty')),
                                    ),
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height -
                                                530,
                                          ),
                                          Text(
                                            'Add More Items',
                                            style: MyGoogleFontStyle(
                                              fontFamily: 'Urbanist',
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xff000000),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.35,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: _productModel
                                                          .productsLoader
                                                      ? Center(
                                                          child:
                                                              LinearProgressIndicator())
                                                      : (_productModel.randomProducts ==
                                                                  null ||
                                                              _productModel
                                                                  .randomProducts!
                                                                  .isEmpty)
                                                          ? Center(
                                                              child: Text(
                                                                'No products available',
                                                                style:
                                                                    MyGoogleFontStyle(
                                                                  fontFamily:
                                                                      'Urbanist',
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                            )
                                                          : ListView.builder(
                                                              // padding:
                                                              //     const EdgeInsets.only(left: 5, right: 8),
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              shrinkWrap: true,
                                                              itemCount: _productModel
                                                                      .randomProducts
                                                                      ?.length ??
                                                                  0,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                return Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              12.0),
                                                                  child: () {
                                                                    final product =
                                                                        _productModel
                                                                            .randomProducts![index];
                                                                    double
                                                                        discountPrice =
                                                                        0.0;
                                                                    if (product
                                                                            .productPrices
                                                                            ?.isNotEmpty ??
                                                                        false) {
                                                                      final configModel =
                                                                          context
                                                                              .watch<ConfigModel>();
                                                                      final isDistributor =
                                                                          configModel.activeRole ==
                                                                              'Distributor';
                                                                      final priceObj =
                                                                          product
                                                                              .productPrices![0];

                                                                      double
                                                                          price =
                                                                          double.tryParse(priceObj.price?.toString() ?? '0') ??
                                                                              0;
                                                                      double
                                                                          offerPrice =
                                                                          double.tryParse(priceObj.offerPrice?.toString() ?? '0') ??
                                                                              0;

                                                                      if (isDistributor) {
                                                                        double?
                                                                            distPrice =
                                                                            double.tryParse(priceObj.distributorPrice?.toString() ??
                                                                                '');
                                                                        double?
                                                                            distOfferPrice =
                                                                            double.tryParse(priceObj.distributorOfferPrice?.toString() ??
                                                                                '');

                                                                        if (distPrice !=
                                                                                null &&
                                                                            distPrice >
                                                                                0)
                                                                          price =
                                                                              distPrice;
                                                                        if (distOfferPrice !=
                                                                                null &&
                                                                            distOfferPrice >
                                                                                0)
                                                                          offerPrice =
                                                                              distOfferPrice;
                                                                      }

                                                                      if (price > 0 &&
                                                                          offerPrice >
                                                                              0 &&
                                                                          offerPrice <
                                                                              price) {
                                                                        discountPrice = ((price -
                                                                                offerPrice) /
                                                                            price *
                                                                            100);
                                                                      }
                                                                    }
                                                                    return CommonProductCard(
                                                                      product:
                                                                          product,
                                                                      discountPrice:
                                                                          discountPrice,
                                                                    );
                                                                  }(),
                                                                );
                                                              },
                                                            ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 40,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Select All Checkbox Row
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 4.0.w, vertical: 8.0.w),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.0.w, vertical: 10.0.w),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(16.0.r),
                                        border: Border.all(
                                          color: Color(0xFFEED056),
                                          width: 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xFFEED056)
                                                .withOpacity(0.1),
                                            blurRadius: 12,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 24,
                                            child: Checkbox(
                                              value: _selectAll,
                                              onChanged: (value) =>
                                                  _toggleSelectAll(value),
                                              activeColor: Color(0xFFC7B456),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              'Select All Items',
                                              style: TextStyle(
                                                fontFamily: 'Urbanist',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF1A1A1A),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '${_selectedCartItemIds.length}/${_addToCartModel.addToCarts!.length} selected',
                                            style: TextStyle(
                                              fontFamily: 'Urbanist',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF909090),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Cart Items List
                                    ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      padding: EdgeInsets.only(bottom: 20),
                                      scrollDirection: Axis.vertical,
                                      itemCount:
                                          _addToCartModel.addToCarts!.length,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        // Find the correct price based on the selected pack
                                        final cartItem =
                                            _addToCartModel.addToCarts![index];
                                        final product = cartItem.product!;

                                        ProductPrices? correctPrice =
                                            _getProductPriceObj(
                                                product, cartItem.pack);

                                        double effectivePrice =
                                            _getEffectivePrice(correctPrice,
                                                product: product);
                                        double originalPrice =
                                            _getOriginalPrice(correctPrice);

                                        double discountPrice = 0.0;
                                        if (originalPrice > 0 &&
                                            effectivePrice > 0 &&
                                            effectivePrice < originalPrice) {
                                          discountPrice = ((originalPrice -
                                                  effectivePrice) /
                                              originalPrice *
                                              100);
                                        }

                                        Map<String, dynamic> _cartData =
                                            cartItem.toJson();
                                        return Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 8.0.w,
                                              horizontal: 4.0.w),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(24.0.r),
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Colors.white,
                                                Color(0xFFFFFDF7)
                                              ],
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0xFFEED056)
                                                    .withOpacity(0.15),
                                                blurRadius: 15,
                                                offset: const Offset(0, 8),
                                              ),
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.03),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(12.0.w),
                                            child: Row(
                                              children: [
                                                // Checkbox for item selection
                                                FutureBuilder<int>(
                                                  future: _getAvailableQty(
                                                      cartItem),
                                                  builder: (context,
                                                      checkboxStockSnapshot) {
                                                    final isOutOfStockForCheckbox =
                                                        checkboxStockSnapshot
                                                                .hasData &&
                                                            checkboxStockSnapshot
                                                                    .data! <=
                                                                0;
                                                    final cartItemId =
                                                        cartItem.id;
                                                    return SizedBox(
                                                      width: 28,
                                                      height: 28,
                                                      child: Checkbox(
                                                        value: cartItemId !=
                                                                null &&
                                                            _selectedCartItemIds
                                                                .contains(
                                                                    cartItemId) &&
                                                            !isOutOfStockForCheckbox,
                                                        onChanged: isOutOfStockForCheckbox ||
                                                                cartItemId ==
                                                                    null
                                                            ? null
                                                            : (value) =>
                                                                _toggleItemSelection(
                                                                    cartItemId),
                                                        activeColor:
                                                            Color(0xFFC7B456),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                                SizedBox(width: 8.0.w),
                                                FutureBuilder<int>(
                                                  future: _getAvailableQty(
                                                      cartItem),
                                                  builder:
                                                      (context, stockSnapshot) {
                                                    final isOutOfStock =
                                                        stockSnapshot.hasData &&
                                                            stockSnapshot
                                                                    .data! <=
                                                                0;
                                                    return InkWell(
                                                      onTap: () {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    ProductIdPage(
                                                                        arguments: {
                                                                          'product':
                                                                              product.toJson(),
                                                                          'product_images':
                                                                              product.productImages
                                                                        })));
                                                      },
                                                      child: Container(
                                                        width: 100.0.w,
                                                        height: 120.0.h,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0.r),
                                                          color: const Color(
                                                              0x0c000000),
                                                        ),
                                                        foregroundDecoration:
                                                            isOutOfStock
                                                                ? BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15.0.r),
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.55),
                                                                  )
                                                                : null,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0.r),
                                                          child: Builder(
                                                            builder: (context) {
                                                              final matchingImages = product
                                                                  .productImages!
                                                                  .where((image) =>
                                                                      image.unit
                                                                          ?.name ==
                                                                      cartItem
                                                                          .flavour)
                                                                  .toList();

                                                              final mediaUrl =
                                                                  _configModel
                                                                          .apiConfig[
                                                                      'mediaURL'];
                                                              String imageUrl =
                                                                  '';

                                                              if (mediaUrl !=
                                                                  null) {
                                                                if (matchingImages
                                                                    .isNotEmpty) {
                                                                  imageUrl =
                                                                      '$mediaUrl${matchingImages[0].imagepath}';
                                                                } else if (product
                                                                    .productImages!
                                                                    .isNotEmpty) {
                                                                  imageUrl =
                                                                      '$mediaUrl${product.productImages!.first.imagepath}';
                                                                }
                                                              }

                                                              if (imageUrl
                                                                  .isEmpty) {
                                                                return const Icon(
                                                                    Icons.image,
                                                                    size: 50,
                                                                    color: Colors
                                                                        .grey);
                                                              }

                                                              return Image
                                                                  .network(
                                                                imageUrl,
                                                                fit: BoxFit
                                                                    .cover,
                                                                width: double
                                                                    .infinity,
                                                                height: double
                                                                    .infinity,
                                                                errorBuilder: (context,
                                                                        error,
                                                                        stackTrace) =>
                                                                    Icon(
                                                                        Icons
                                                                            .image,
                                                                        size:
                                                                            50,
                                                                        color: Colors
                                                                            .grey),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                                SizedBox(width: 12.0.w),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        product.name.toString(),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            MyGoogleFontStyle(
                                                          fontFamily:
                                                              'Urbanist',
                                                          fontSize: 14.0.sp,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                              Color(0xff000000),
                                                        ),
                                                      ),
                                                      SizedBox(height: 4.0.h),
                                                      if (correctPrice != null)
                                                        originalPrice >
                                                                effectivePrice
                                                            ? Wrap(
                                                                spacing: 4.0,
                                                                runSpacing: 2.0,
                                                                children: [
                                                                  Text.rich(
                                                                    TextSpan(
                                                                      children: [
                                                                        TextSpan(
                                                                          text:
                                                                              '₹${originalPrice.toInt()}',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.grey,
                                                                            decoration:
                                                                                TextDecoration.lineThrough,
                                                                            fontSize:
                                                                                13.0.sp,
                                                                            fontFamily:
                                                                                'Poppins',
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                        ),
                                                                        TextSpan(
                                                                          text:
                                                                              ' ₹${effectivePrice.toInt()}',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                const Color(0x99000000),
                                                                            fontSize:
                                                                                13.0.sp,
                                                                            fontFamily:
                                                                                'Poppins',
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  if (discountPrice >
                                                                      0.0)
                                                                    Text(
                                                                      '(${discountPrice.round()}% Off)',
                                                                      style:
                                                                          MyGoogleFontStyle(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        fontSize:
                                                                            13.0.sp,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        color: const Color(
                                                                            0x99000000),
                                                                      ),
                                                                    ),
                                                                ],
                                                              )
                                                            : Text(
                                                                '₹${effectivePrice.toInt()}',
                                                                style:
                                                                    MyGoogleFontStyle(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontSize:
                                                                      13.0.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: const Color(
                                                                      0x99000000),
                                                                ),
                                                              ),
                                                      SizedBox(height: 6.0.h),
                                                      SizedBox(height: 6.0.h),
                                                      Wrap(
                                                        spacing: 8.0.w,
                                                        runSpacing: 4.0.h,
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        8.0.w,
                                                                    vertical:
                                                                        4.0.h),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                  0xFFFFFEF9),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6.0.r),
                                                              border: Border.all(
                                                                  color: Color(
                                                                          0xFFEED056)
                                                                      .withOpacity(
                                                                          0.3)),
                                                            ),
                                                            child: Text(
                                                              'Size: ${_addToCartModel.addToCarts![index].kindOfFlower}',
                                                              style:
                                                                  MyGoogleFontStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize:
                                                                    11.0.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Color(
                                                                    0xff606060),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        8.0.w,
                                                                    vertical:
                                                                        4.0.h),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                  0xFFFFFEF9),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6.0.r),
                                                              border: Border.all(
                                                                  color: Color(
                                                                          0xFFEED056)
                                                                      .withOpacity(
                                                                          0.3)),
                                                            ),
                                                            child: Text(
                                                              'Colour: ${_addToCartModel.addToCarts![index].flavour}',
                                                              style:
                                                                  MyGoogleFontStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize:
                                                                    11.0.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Color(
                                                                    0xff606060),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      // Align(
                                                      //   alignment:
                                                      //       Alignment.centerLeft,
                                                      //   child: Row(
                                                      //     children: [
                                                      //       Icon(
                                                      //         Icons.star,
                                                      //         color: Colors.amber,
                                                      //       ),
                                                      //       Text(
                                                      //         ' ( ${(_addToCartModel.addToCarts![index].product!.reviews == null ? 0 : _addToCartModel.addToCarts![index].product!.reviews?.length)} ratings )',
                                                      //         style: TextStyle(
                                                      //             fontSize: 12),
                                                      //       ),
                                                      //     ],
                                                      //   ),
                                                      // ),
                                                      SizedBox(height: 8.0.h),
                                                      FutureBuilder<int>(
                                                        future: _getAvailableQty(
                                                            _addToCartModel
                                                                    .addToCarts![
                                                                index]),
                                                        builder: (context,
                                                            stockSnapshot) {
                                                          final isOutOfStock =
                                                              stockSnapshot
                                                                      .hasData &&
                                                                  stockSnapshot
                                                                          .data! <=
                                                                      0;
                                                          // Hide increment/decrement when out of stock
                                                          if (isOutOfStock) {
                                                            return Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          12.0
                                                                              .w,
                                                                      vertical:
                                                                          8.0.h),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .red
                                                                    .withOpacity(
                                                                        0.1),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0.r),
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .red
                                                                        .withOpacity(
                                                                            0.3)),
                                                              ),
                                                              child: Text(
                                                                'Out of Stock',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontSize:
                                                                      12.0.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                          return Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          24.0.r),
                                                              border: Border.all(
                                                                  color: Color(
                                                                      0xFFF0F0F0)),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.03),
                                                                  blurRadius: 4,
                                                                  offset:
                                                                      Offset(
                                                                          0, 2),
                                                                ),
                                                              ],
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                InkWell(
                                                                  onTap: loadingItemIndex !=
                                                                          null
                                                                      ? null
                                                                      : () async {
                                                                          setState(
                                                                              () {
                                                                            loadingItemIndex =
                                                                                index;
                                                                            quantityLoadingAction =
                                                                                'decrement';
                                                                          });

                                                                          bool
                                                                              minus =
                                                                              false;
                                                                          _cartData['is_add_to_cart'] =
                                                                              true;
                                                                          await _addToCartModel.getAddToCart(
                                                                              _addToCartModel.addToCarts![index].product!.id,
                                                                              minus,
                                                                              _cartData);

                                                                          // Sync selections with current cart items (removes stale selections)
                                                                          _syncSelectionsWithCart();

                                                                          setState(
                                                                              () {});
                                                                          await _validateAppliedCoupon();
                                                                          await _recalculateRewards();

                                                                          setState(
                                                                              () {
                                                                            loadingItemIndex =
                                                                                null;
                                                                            quantityLoadingAction =
                                                                                null;
                                                                          });
                                                                        },
                                                                  child:
                                                                      Container(
                                                                    padding: EdgeInsets
                                                                        .all(8.0
                                                                            .w),
                                                                    child: (loadingItemIndex ==
                                                                                index &&
                                                                            quantityLoadingAction ==
                                                                                'decrement')
                                                                        ? SizedBox(
                                                                            width:
                                                                                16.0.w,
                                                                            height:
                                                                                16.0.w,
                                                                            child:
                                                                                CircularProgressIndicator(
                                                                              strokeWidth: 2,
                                                                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFEED056)),
                                                                            ),
                                                                          )
                                                                        : Icon(
                                                                            Icons
                                                                                .remove,
                                                                            size:
                                                                                18.0.sp,
                                                                            color: Colors.black87),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              12.0.w),
                                                                  child: Text(
                                                                    _addToCartModel
                                                                        .addToCarts![
                                                                            index]
                                                                        .qty
                                                                        .toString(),
                                                                    style:
                                                                        MyGoogleFontStyle(
                                                                      fontFamily:
                                                                          'Urbanist',
                                                                      fontSize:
                                                                          14.0.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                ),
                                                                FutureBuilder<
                                                                    int>(
                                                                  future: _getAvailableQty(
                                                                      _addToCartModel
                                                                              .addToCarts![
                                                                          index]),
                                                                  builder: (context,
                                                                      snapshot) {
                                                                    final currentQty =
                                                                        _addToCartModel.addToCarts![index].qty ??
                                                                            0;
                                                                    final availableQty =
                                                                        snapshot.data ??
                                                                            0;

                                                                    debugPrint(
                                                                        'FutureBuilder: currentQty=$currentQty, availableQty=$availableQty, snapshot.hasData=${snapshot.hasData}');

                                                                    // Hide plus button if qty limit reached
                                                                    if (availableQty >
                                                                            0 &&
                                                                        currentQty >=
                                                                            availableQty) {
                                                                      debugPrint(
                                                                          'FutureBuilder: HIDING plus button (limit reached)');
                                                                      return SizedBox(
                                                                          width:
                                                                              34.0.w); // Empty space to maintain layout
                                                                    }

                                                                    return InkWell(
                                                                      onTap: loadingItemIndex !=
                                                                              null
                                                                          ? null
                                                                          : () async {
                                                                              // Check available quantity before incrementing
                                                                              final cartItem = _addToCartModel.addToCarts![index];
                                                                              final currentQty = cartItem.qty ?? 0;

                                                                              setState(() {
                                                                                loadingItemIndex = index;
                                                                                quantityLoadingAction = 'increment';
                                                                              });

                                                                              // Fetch fresh product data with packs
                                                                              final productService = locator<ProductService>();
                                                                              final product = await productService.getProductById(cartItem.productId ?? 0);

                                                                              int availableQty = 0;
                                                                              if (product != null && product.productPacks != null && product.productPacks!.isNotEmpty) {
                                                                                // Find the matching pack based on cart item's pack ID
                                                                                try {
                                                                                  final matchingPack = product.productPacks!.firstWhere(
                                                                                    (pack) => pack.id.toString() == cartItem.pack,
                                                                                  );
                                                                                  availableQty = matchingPack.qty ?? 0;
                                                                                } catch (e) {
                                                                                  // If no matching pack found, use first pack or product qty
                                                                                  if (product.productPacks!.isNotEmpty) {
                                                                                    availableQty = product.productPacks!.first.qty ?? 0;
                                                                                  } else {
                                                                                    availableQty = product.qty ?? 0;
                                                                                  }
                                                                                }
                                                                              } else {
                                                                                // Fallback to product qty if no packs
                                                                                availableQty = cartItem.product?.qty ?? 0;
                                                                              }

                                                                              debugPrint('Increment check: current=$currentQty, available=$availableQty, pack=${cartItem.pack}');

                                                                              // Check if available quantity is set and if limit reached
                                                                              if (availableQty > 0 && currentQty >= availableQty) {
                                                                                setState(() {
                                                                                  loadingItemIndex = null;
                                                                                  quantityLoadingAction = null;
                                                                                });
                                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                                  SnackBar(
                                                                                    content: Text('Maximum available quantity is $availableQty'),
                                                                                    backgroundColor: Colors.orange,
                                                                                    duration: Duration(seconds: 2),
                                                                                  ),
                                                                                );
                                                                                return;
                                                                              }

                                                                              bool type = true;
                                                                              _cartData['is_add_to_cart'] = true;
                                                                              await _addToCartModel.getAddToCart(_addToCartModel.addToCarts![index].product!.id, type, _cartData);
                                                                              setState(() {});
                                                                              await _validateAppliedCoupon();
                                                                              await _recalculateRewards();

                                                                              setState(() {
                                                                                loadingItemIndex = null;
                                                                                quantityLoadingAction = null;
                                                                              });
                                                                            },
                                                                      child:
                                                                          Container(
                                                                        padding:
                                                                            EdgeInsets.all(8.0.w),
                                                                        child: (loadingItemIndex == index &&
                                                                                quantityLoadingAction == 'increment')
                                                                            ? SizedBox(
                                                                                width: 16.0.w,
                                                                                height: 16.0.w,
                                                                                child: CircularProgressIndicator(
                                                                                  strokeWidth: 2,
                                                                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFEED056)),
                                                                                ),
                                                                              )
                                                                            : Icon(Icons.add, size: 18.0.sp, color: Colors.black87),
                                                                      ),
                                                                      // ),
                                                                    );
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                        ),
                        if (_addToCartModel.addToCarts!.length != 0)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            child: Container(
                              width: 1.0.sw - 50,
                              child: Column(
                                children: [
                                  // Beautiful Coupon Section
                                  Container(
                                    padding: EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      gradient: usedCoupon.isNotEmpty
                                          ? LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Color(0xFFE8F5E9),
                                                Color(0xFFC8E6C9)
                                              ],
                                            )
                                          : LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Colors.white,
                                                Color(0xFFF8F9FA)
                                              ],
                                            ),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: usedCoupon.isNotEmpty
                                            ? Color(0xFF4CAF50)
                                            : Color(0xFFE0E0E0),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.04),
                                          blurRadius: 8,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        Column(
                                          children: [
                                            // Applied Coupon Display
                                            if (usedCoupon.isNotEmpty)
                                              Row(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFF4CAF50)
                                                          .withOpacity(0.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Icon(
                                                        Icons
                                                            .local_offer_rounded,
                                                        color:
                                                            Color(0xFF4CAF50),
                                                        size: 20),
                                                  ),
                                                  SizedBox(width: 12),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          usedCoupon,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Urbanist',
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: Color(
                                                                0xFF2E7D32),
                                                          ),
                                                        ),
                                                        Text(
                                                          'You saved RS ${couponValue.toStringAsFixed(2)}',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Urbanist',
                                                            fontSize: 12,
                                                            color: Color(
                                                                0xFF388E3C),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        usedCoupon = '';
                                                        couponValue = 0;
                                                        couponId = '';
                                                        coupon = '';
                                                      });
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 6),
                                                      decoration: BoxDecoration(
                                                        color: Colors.red
                                                            .withOpacity(0.1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                      ),
                                                      child: Text(
                                                        'Remove',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Urbanist',
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            // Coupon Input Form
                                            if (usedCoupon.isEmpty)
                                              Form(
                                                key: _formKey,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFFF5F5F5),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: Icon(
                                                          Icons
                                                              .discount_rounded,
                                                          color:
                                                              Color(0xFFC7B456),
                                                          size: 20),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Expanded(
                                                      child: Container(
                                                        height: 44,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xFFF8F9FA),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          border: Border.all(
                                                              color: Color(
                                                                  0xFFE0E0E0)),
                                                        ),
                                                        child: TextFormField(
                                                          decoration:
                                                              InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            12,
                                                                        vertical:
                                                                            10),
                                                            hintText:
                                                                'Enter promo code',
                                                            hintStyle:
                                                                TextStyle(
                                                              fontFamily:
                                                                  'Urbanist',
                                                              fontSize: 13,
                                                              color: Color(
                                                                  0xFFAAAAAA),
                                                            ),
                                                          ),
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Urbanist',
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Color(
                                                                0xFF1A1A1A),
                                                          ),
                                                          onSaved: (value) {
                                                            coupon = value
                                                                .toString();
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    InkWell(
                                                      onTap: buttonLoading
                                                          ? null
                                                          : () async {
                                                              _formKey
                                                                  .currentState!
                                                                  .save();
                                                              if (coupon
                                                                  .trim()
                                                                  .isEmpty) {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  const SnackBar(
                                                                    content: Text(
                                                                        'Please enter a promo code'),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                  ),
                                                                );
                                                                return;
                                                              }
                                                              setState(() {
                                                                buttonLoading =
                                                                    true;
                                                              });

                                                              await _couponModel
                                                                  .verifyCoupon(
                                                                      coupon);
                                                              // print(_couponModel.coupons![0].minOrderValue);
                                                              if (_couponModel
                                                                          .coupons !=
                                                                      null &&
                                                                  _couponModel
                                                                      .coupons!
                                                                      .isNotEmpty) {
                                                                final firstCoupon =
                                                                    _couponModel
                                                                        .coupons![0];
                                                                final cartTotal =
                                                                    num.parse(_addToCartModel
                                                                            .cartTotal
                                                                            .toString())
                                                                        .toInt();

                                                                // Check coupon usage count
                                                                final orderModel =
                                                                    Provider.of<
                                                                            OrderModel>(
                                                                        context,
                                                                        listen:
                                                                            false);
                                                                final usageCount =
                                                                    await orderModel.getCouponUsageCount(
                                                                        firstCoupon
                                                                            .id
                                                                            .toString());

                                                                if (firstCoupon
                                                                            .noPerUser !=
                                                                        null &&
                                                                    firstCoupon
                                                                            .noPerUser! >
                                                                        0 &&
                                                                    usageCount >=
                                                                        firstCoupon
                                                                            .noPerUser!) {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder: (BuildContext
                                                                            context) =>
                                                                        AlertDialog(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(20)),
                                                                      title: Text(
                                                                          "Coupon Usage Limit Reached"),
                                                                      content: Text(
                                                                          "You have already used this coupon ${firstCoupon.noPerUser} time${firstCoupon.noPerUser! > 1 ? 's' : ''}. This is the maximum allowed per user."),
                                                                      actions: <Widget>[
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Text('Ok'),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                } else if (firstCoupon
                                                                        .minOrderValue! <
                                                                    cartTotal) {
                                                                  setState(() {
                                                                    // Calculate item total (cart total without GST)
                                                                    final itemTotal =
                                                                        (cartTotal /
                                                                                105) *
                                                                            100;

                                                                    // Check coupon type and calculate value accordingly
                                                                    final couponType = firstCoupon
                                                                        .type
                                                                        ?.toLowerCase()
                                                                        .trim();
                                                                    final isPercentage = couponType == 'percentage' ||
                                                                        couponType ==
                                                                            'percent' ||
                                                                        couponType ==
                                                                            '%';

                                                                    if (isPercentage) {
                                                                      // Calculate percentage of item total
                                                                      final percentageValue =
                                                                          double.parse(firstCoupon.value.toString()) /
                                                                              100;
                                                                      couponValue =
                                                                          itemTotal *
                                                                              percentageValue;
                                                                    } else {
                                                                      // Flat discount - use value directly
                                                                      couponValue = double.parse(firstCoupon
                                                                          .value
                                                                          .toString());
                                                                    }
                                                                    couponId =
                                                                        firstCoupon
                                                                            .id
                                                                            .toString();
                                                                    usedCoupon =
                                                                        firstCoupon
                                                                            .name
                                                                            .toString();
                                                                  });
                                                                } else {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder: (BuildContext
                                                                            context) =>
                                                                        AlertDialog(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(20)),
                                                                      title:
                                                                          Text(
                                                                        "Coupon Cannot Be Applied",
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontSize:
                                                                              18,
                                                                        ),
                                                                      ),
                                                                      content:
                                                                          Text(
                                                                        "This coupon requires a minimum cart total of RS ${firstCoupon.minOrderValue.toString()}. Your current cart total is RS ${cartTotal.toString()}. Please add more items to use this coupon.",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14),
                                                                      ),
                                                                      actions: <Widget>[
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Text('Understood'),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                }
                                                              } else {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      Dialog(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20),
                                                                    ),
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          20.0),
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          Container(
                                                                            padding:
                                                                                const EdgeInsets.all(15),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: const Color(0xFFFFF2F2),
                                                                              shape: BoxShape.circle,
                                                                            ),
                                                                            child:
                                                                                const Icon(
                                                                              Icons.error_outline_rounded,
                                                                              color: Colors.red,
                                                                              size: 32,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                              height: 16),
                                                                          const Text(
                                                                            "Invalid Coupon",
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: 'Urbanist',
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 18,
                                                                              color: Color(0xFF1A1A1A),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                              height: 8),
                                                                          const Text(
                                                                            "The promo code you entered is not valid. Please check and try again.",
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: 'Urbanist',
                                                                              fontSize: 14,
                                                                              color: Color(0xFF757575),
                                                                              height: 1.5,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                              height: 24),
                                                                          SizedBox(
                                                                            width:
                                                                                double.infinity,
                                                                            child:
                                                                                ElevatedButton(
                                                                              onPressed: () {
                                                                                Navigator.pop(context);
                                                                              },
                                                                              style: ElevatedButton.styleFrom(
                                                                                backgroundColor: const Color(0xFF1A1A1A),
                                                                                foregroundColor: Colors.white,
                                                                                padding: const EdgeInsets.symmetric(vertical: 12),
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(12),
                                                                                ),
                                                                                elevation: 0,
                                                                              ),
                                                                              child: const Text(
                                                                                'Okay, Got it',
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Urbanist',
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontSize: 15,
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

                                                              setState(() {
                                                                buttonLoading =
                                                                    false;
                                                              });
                                                            },
                                                      child: Container(
                                                        height: 44,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 16),
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                            colors: [
                                                              Color(0xFFC7B456),
                                                              Color(0xFFAA9A40)
                                                            ],
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Center(
                                                          child: buttonLoading
                                                              ? SizedBox(
                                                                  width: 18,
                                                                  height: 18,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        2,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                )
                                                              : Text(
                                                                  'Apply',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Urbanist',
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                        if (couponValidationLoading)
                                          Positioned.fill(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withOpacity(0.7),
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                              ),
                                              child: Center(
                                                child: SizedBox(
                                                  width: 24,
                                                  height: 24,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: Color(0xFFC7B456),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  // View Promocodes Link
                                  InkWell(
                                    onTap: () async {
                                      try {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PromocodesPage()),
                                        );

                                        if (result != null &&
                                            result['name'] != null) {
                                          setState(() {
                                            couponValidationLoading = true;
                                          });

                                          await _couponModel
                                              .verifyCoupon(result['name']);

                                          if (_couponModel.coupons != null &&
                                              _couponModel
                                                  .coupons!.isNotEmpty) {
                                            final firstCoupon =
                                                _couponModel.coupons![0];
                                            final cartTotal = num.parse(
                                                    _addToCartModel.cartTotal
                                                        .toString())
                                                .toInt();

                                            // Check coupon usage count
                                            final orderModel =
                                                Provider.of<OrderModel>(context,
                                                    listen: false);
                                            final usageCount = await orderModel
                                                .getCouponUsageCount(
                                                    firstCoupon.id.toString());

                                            if (firstCoupon.noPerUser != null &&
                                                firstCoupon.noPerUser! > 0 &&
                                                usageCount >=
                                                    firstCoupon.noPerUser!) {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  title: Text(
                                                      "Coupon Usage Limit Reached"),
                                                  content: Text(
                                                      "You have already used this coupon ${firstCoupon.noPerUser} time${firstCoupon.noPerUser! > 1 ? 's' : ''}. This is the maximum allowed per user."),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('Ok'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            } else if (firstCoupon
                                                    .minOrderValue! <
                                                cartTotal) {
                                              // Combine all setState calls into one
                                              setState(() {
                                                usedCoupon =
                                                    firstCoupon.name.toString();

                                                // Calculate item total (cart total without GST)
                                                final itemTotal =
                                                    (cartTotal / 105) * 100;

                                                // Check coupon type and calculate value accordingly
                                                final couponType = firstCoupon
                                                    .type
                                                    ?.toLowerCase()
                                                    .trim();
                                                final isPercentage =
                                                    couponType ==
                                                            'percentage' ||
                                                        couponType ==
                                                            'percent' ||
                                                        couponType == '%';

                                                if (isPercentage) {
                                                  // Calculate percentage of item total
                                                  final percentageValue =
                                                      double.parse(firstCoupon
                                                              .value
                                                              .toString()) /
                                                          100;
                                                  couponValue = itemTotal *
                                                      percentageValue;
                                                } else {
                                                  // Flat discount - use value directly
                                                  couponValue = double.parse(
                                                      firstCoupon.value
                                                          .toString());
                                                }
                                                couponId =
                                                    firstCoupon.id.toString();
                                              });
                                            } else {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  title: Text(
                                                    "Coupon Cannot Be Applied",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                  content: Text(
                                                    "This coupon requires a minimum cart total of RS ${firstCoupon.minOrderValue.toString()}. Your current cart total is RS ${cartTotal.toString()}. Please add more items to use this coupon.",
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('Understood'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'No valid coupon found'),
                                                backgroundColor: Colors.orange,
                                              ),
                                            );
                                          }
                                        }
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Error applying coupon: $e'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }

                                      setState(() {
                                        couponValidationLoading = false;
                                      });
                                      // });
                                      // print(result);
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.local_offer_outlined,
                                              size: 16,
                                              color: Color(0xFFC7B456)),
                                          SizedBox(width: 6),
                                          Text(
                                            'Browse All Promo Codes',
                                            style: TextStyle(
                                              fontFamily: 'Urbanist',
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFFC7B456),
                                            ),
                                          ),
                                          SizedBox(width: 4),
                                          Icon(Icons.arrow_forward_ios,
                                              size: 12,
                                              color: Color(0xFFC7B456)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // SizedBox(
                                  //   height: 10,
                                  // ),
                                  // if (_addToCartModel.addToCarts!.length != 0)
                                  //   Row(
                                  //     children: [
                                  //       Text(
                                  //         'Total:',
                                  //         style: MyGoogleFontStyle(
                                  //           fontFamily: 'Urbanist',
                                  //           fontWeight: FontWeight.w700,
                                  //           color: Color(0xff808080),
                                  //         ),
                                  //       ),
                                  //       Expanded(
                                  //         child: Text(
                                  //           _addToCartModel.cartTotal.toString() != null
                                  //               ? 'RS' +
                                  //                   ' ' +
                                  //                   (int.parse(_addToCartModel.cartTotal
                                  //                               .toString()) -
                                  //                           int.parse(
                                  //                               couponValue.toString()))
                                  //                       .toString()
                                  //               : 'RS' + '0',
                                  //           textAlign: TextAlign.right,
                                  //           style: MyGoogleFontStyle(
                                  //             fontFamily: 'Inter',
                                  //             fontWeight: FontWeight.w700,
                                  //             color: Color(0xff303030),
                                  //           ),
                                  //         ),
                                  //       )
                                  //     ],
                                  //   ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  // _addToCartModel.addToCarts!.length != 0
                                  //     ? Container(
                                  //         margin: EdgeInsets.fromLTRB(0.89, 0, 0, 0),
                                  //         child: TextButton(
                                  //           onPressed: () {
                                  //             Navigator.of(context).push(
                                  //                 MaterialPageRoute(
                                  //                     builder: (context) =>
                                  //                         CheckoutPage(arguments: {
                                  //                           'cartTotal': _addToCartModel
                                  //                               .cartTotal
                                  //                               .toString(),
                                  //                           'cartItems': _addToCartModel
                                  //                               .addToCarts,
                                  //                           'address': _orderModel
                                  //                                   .orders.isNotEmpty
                                  //                               ? _orderModel
                                  //                                   .orders[0].address!
                                  //                                   .toJson()
                                  //                               : null,
                                  //                           'couponValue': couponValue,
                                  //                           'couponId': couponId
                                  //                         })));
                                  //           },
                                  //           style: TextButton.styleFrom(
                                  //             padding: EdgeInsets.zero,
                                  //           ),
                                  //           child: Container(
                                  //             width: 321,
                                  //             height: 53,
                                  //             decoration: BoxDecoration(
                                  //               color: Color(0xff1e1e1e),
                                  //               borderRadius: BorderRadius.circular(10),
                                  //             ),
                                  //             child: Center(
                                  //               child: Text(
                                  //                 'Checkout',
                                  //                 style: MyGoogleFontStyle(
                                  //                   fontFamily: 'Urbanist',
                                  //                   fontWeight: FontWeight.w700,
                                  //                   color: Color(0xffffffff),
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       )
                                  //     : Text(''),
                                  Container(
                                    margin: EdgeInsets.only(top: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Shipping Address - Beautiful Card Design
                                        Container(
                                          margin: EdgeInsets.only(bottom: 16),
                                          padding: EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Colors.white,
                                                Color(0xFFF8F9FA),
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.04),
                                                blurRadius: 10,
                                                offset: Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFFE8F5E9),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Icon(
                                                      Icons.location_on_rounded,
                                                      color: Color(0xFF4CAF50),
                                                      size: 20,
                                                    ),
                                                  ),
                                                  SizedBox(width: 12),
                                                  Expanded(
                                                    child: Text(
                                                      'Delivery Address',
                                                      style: TextStyle(
                                                        fontFamily: 'Urbanist',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            Color(0xFF1A1A1A),
                                                      ),
                                                    ),
                                                  ),
                                                  if (address.id != null)
                                                    InkWell(
                                                      onTap: () async {
                                                        final result =
                                                            await Navigator.of(
                                                                    context)
                                                                .push(
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    AddressPage(
                                                              arguments: {
                                                                'cartTotal':
                                                                    _addToCartModel
                                                                        .cartTotal
                                                                        .toString(),
                                                                'cartItems':
                                                                    _addToCartModel
                                                                        .addToCarts,
                                                                'couponValue':
                                                                    couponValue,
                                                                'isAddress':
                                                                    true
                                                              },
                                                            ),
                                                          ),
                                                        );
                                                        if (result != null &&
                                                            result['address'] !=
                                                                null) {
                                                          setState(() {
                                                            address = UserAddress
                                                                .fromJson(result[
                                                                    'address']);
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 12,
                                                                vertical: 6),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xFFF5F5F5),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        child: Text(
                                                          'Change',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Urbanist',
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Color(
                                                                0xFF666666),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                              if (address.id != null) ...[
                                                SizedBox(height: 12),
                                                Container(
                                                  padding: EdgeInsets.all(12),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFF8F9FA),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        color:
                                                            Color(0xFFE0E0E0)),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        4),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                      0xFFC7B456)
                                                                  .withOpacity(
                                                                      0.2),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4),
                                                            ),
                                                            child: Text(
                                                              address.label
                                                                      ?.toString()
                                                                      .toUpperCase() ??
                                                                  'HOME',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Urbanist',
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Color(
                                                                    0xFFC7B456),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 8),
                                                          Expanded(
                                                            child: Text(
                                                              address.fullName
                                                                      ?.toString() ??
                                                                  '',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Urbanist',
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Color(
                                                                    0xFF1A1A1A),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 8),
                                                      Text(
                                                        [
                                                          address.fullName,
                                                          address.add1,
                                                          address.add2,
                                                          address.add3,
                                                          address.city,
                                                          address.state,
                                                          address.pincode
                                                        ]
                                                            .where((e) =>
                                                                e != null &&
                                                                e
                                                                    .toString()
                                                                    .isNotEmpty)
                                                            .join(', '),
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Urbanist',
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color:
                                                              Color(0xFF666666),
                                                          height: 1.5,
                                                        ),
                                                      ),
                                                      if (address.phone !=
                                                          null) ...[
                                                        SizedBox(height: 6),
                                                        Row(
                                                          children: [
                                                            Icon(Icons.phone,
                                                                size: 14,
                                                                color: Color(
                                                                    0xFF888888)),
                                                            SizedBox(width: 6),
                                                            Text(
                                                              address.phone
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Urbanist',
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Color(
                                                                    0xFF444444),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                ),
                                              ],
                                              if (address.id == null)
                                                InkWell(
                                                  onTap: () async {
                                                    final result =
                                                        await Navigator.of(
                                                                context)
                                                            .push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            AddressPage(
                                                          arguments: {
                                                            'cartTotal':
                                                                _addToCartModel
                                                                    .cartTotal
                                                                    .toString(),
                                                            'cartItems':
                                                                _addToCartModel
                                                                    .addToCarts,
                                                            'couponValue':
                                                                couponValue,
                                                            'isAddress': true
                                                          },
                                                        ),
                                                      ),
                                                    );
                                                    if (result != null &&
                                                        result['address'] !=
                                                            null) {
                                                      setState(() {
                                                        address = UserAddress
                                                            .fromJson(result[
                                                                'address']);
                                                      });
                                                    }
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        top: 12),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 14),
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Color(0xFF2A2A2A),
                                                          Color(0xFF1A1A1A)
                                                        ],
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                            Icons
                                                                .add_location_alt_rounded,
                                                            color: Colors.white,
                                                            size: 18),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          'Add Delivery Address',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Urbanist',
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        // Payment Options - Beautiful Card Design
                                        Container(
                                          margin: EdgeInsets.only(bottom: 16),
                                          padding: EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Colors.white,
                                                Color(0xFFF8F9FA)
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.04),
                                                blurRadius: 10,
                                                offset: Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFFE3F2FD),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Icon(
                                                      Icons.payment_rounded,
                                                      color: Color(0xFF1976D2),
                                                      size: 20,
                                                    ),
                                                  ),
                                                  SizedBox(width: 12),
                                                  Text(
                                                    'Payment Method',
                                                    style: TextStyle(
                                                      fontFamily: 'Urbanist',
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Color(0xFF1A1A1A),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 16),
                                              // COD Option
                                              if (_activeRole != 'Distributor')
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      paymentOption =
                                                          'Cash On Delivery';
                                                    });
                                                  },
                                                  child: AnimatedContainer(
                                                    duration: Duration(
                                                        milliseconds: 200),
                                                    padding: EdgeInsets.all(14),
                                                    decoration: BoxDecoration(
                                                      color: paymentOption ==
                                                              'Cash On Delivery'
                                                          ? Color(0xFFF5F0E0)
                                                          : Color(0xFFF8F9FA),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      border: Border.all(
                                                        color: paymentOption ==
                                                                'Cash On Delivery'
                                                            ? Color(0xFFC7B456)
                                                            : Color(0xFFE0E0E0),
                                                        width: paymentOption ==
                                                                'Cash On Delivery'
                                                            ? 2
                                                            : 1,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: 40,
                                                          height: 40,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.green
                                                                .withOpacity(
                                                                    0.1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: Icon(
                                                            Icons.money_rounded,
                                                            color: Colors.green,
                                                            size: 22,
                                                          ),
                                                        ),
                                                        SizedBox(width: 12),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Cash on Delivery',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Urbanist',
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Color(
                                                                      0xFF1A1A1A),
                                                                ),
                                                              ),
                                                              Text(
                                                                'Pay when you receive',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Urbanist',
                                                                  fontSize: 11,
                                                                  color: Color(
                                                                      0xFF888888),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        AnimatedContainer(
                                                          duration: Duration(
                                                              milliseconds:
                                                                  200),
                                                          width: 22,
                                                          height: 22,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: paymentOption ==
                                                                    'Cash On Delivery'
                                                                ? Color(
                                                                    0xFFC7B456)
                                                                : Colors
                                                                    .transparent,
                                                            border: Border.all(
                                                              color: paymentOption ==
                                                                      'Cash On Delivery'
                                                                  ? Color(
                                                                      0xFFC7B456)
                                                                  : Color(
                                                                      0xFFBDBDBD),
                                                              width: 2,
                                                            ),
                                                          ),
                                                          child: paymentOption ==
                                                                  'Cash On Delivery'
                                                              ? Icon(
                                                                  Icons.check,
                                                                  size: 14,
                                                                  color: Colors
                                                                      .white)
                                                              : null,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              SizedBox(height: 10),
                                              // UPI/PhonePe Option
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    paymentOption =
                                                        'UPI/PhonePe';
                                                  });
                                                },
                                                child: AnimatedContainer(
                                                  duration: Duration(
                                                      milliseconds: 200),
                                                  padding: EdgeInsets.all(14),
                                                  decoration: BoxDecoration(
                                                    color: paymentOption ==
                                                            'UPI/PhonePe'
                                                        ? Color(0xFFF5F0E0)
                                                        : Color(0xFFF8F9FA),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    border: Border.all(
                                                      color: paymentOption ==
                                                              'UPI/PhonePe'
                                                          ? Color(0xFFC7B456)
                                                          : Color(0xFFE0E0E0),
                                                      width: paymentOption ==
                                                              'UPI/PhonePe'
                                                          ? 2
                                                          : 1,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: 40,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Color(
                                                                  0xFF5F259F)
                                                              .withOpacity(0.1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Icon(
                                                          Icons
                                                              .smartphone_rounded,
                                                          color:
                                                              Color(0xFF5F259F),
                                                          size: 22,
                                                        ),
                                                      ),
                                                      SizedBox(width: 12),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'UPI / PhonePe',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Urbanist',
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Color(
                                                                    0xFF1A1A1A),
                                                              ),
                                                            ),
                                                            Text(
                                                              'Fast & secure payment',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Urbanist',
                                                                fontSize: 11,
                                                                color: Color(
                                                                    0xFF888888),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      AnimatedContainer(
                                                        duration: Duration(
                                                            milliseconds: 200),
                                                        width: 22,
                                                        height: 22,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: paymentOption ==
                                                                  'UPI/PhonePe'
                                                              ? Color(
                                                                  0xFFC7B456)
                                                              : Colors
                                                                  .transparent,
                                                          border: Border.all(
                                                            color: paymentOption ==
                                                                    'UPI/PhonePe'
                                                                ? Color(
                                                                    0xFFC7B456)
                                                                : Color(
                                                                    0xFFBDBDBD),
                                                            width: 2,
                                                          ),
                                                        ),
                                                        child: paymentOption ==
                                                                'UPI/PhonePe'
                                                            ? Icon(Icons.check,
                                                                size: 14,
                                                                color: Colors
                                                                    .white)
                                                            : null,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Send as Gift - Beautiful Toggle Card
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isGift = !isGift;
                                            });
                                            if (isGift == true) {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  title: Text(
                                                      "Is it the same address as mentioned above?"),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: Text('Yes',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16)),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        Navigator.pop(context);
                                                        final result =
                                                            await Navigator.of(
                                                                    context)
                                                                .push(
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    AddressPage(
                                                              arguments: {
                                                                'cartTotal':
                                                                    _addToCartModel
                                                                        .cartTotal
                                                                        .toString(),
                                                                'cartItems':
                                                                    _addToCartModel
                                                                        .addToCarts,
                                                                'couponValue':
                                                                    couponValue,
                                                                'isAddress':
                                                                    true
                                                              },
                                                            ),
                                                          ),
                                                        );
                                                        if (result != null &&
                                                            result['address'] !=
                                                                null) {
                                                          setState(() {
                                                            address = UserAddress
                                                                .fromJson(result[
                                                                    'address']);
                                                          });
                                                        }
                                                      },
                                                      child: Text('No',
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 16)),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                          },
                                          child: AnimatedContainer(
                                            duration:
                                                Duration(milliseconds: 200),
                                            margin: EdgeInsets.only(bottom: 16),
                                            padding: EdgeInsets.all(14),
                                            decoration: BoxDecoration(
                                              gradient: isGift
                                                  ? LinearGradient(
                                                      colors: [
                                                        Color(0xFFFFF8E1),
                                                        Color(0xFFFFECB3)
                                                      ],
                                                    )
                                                  : LinearGradient(
                                                      colors: [
                                                        Colors.white,
                                                        Color(0xFFF8F9FA)
                                                      ],
                                                    ),
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              border: Border.all(
                                                color: isGift
                                                    ? Color(0xFFC7B456)
                                                    : Color(0xFFE0E0E0),
                                                width: isGift ? 2 : 1,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.03),
                                                  blurRadius: 8,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color: isGift
                                                        ? Color(0xFFC7B456)
                                                            .withOpacity(0.2)
                                                        : Color(0xFFF5F5F5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Icon(
                                                    Icons.card_giftcard_rounded,
                                                    color: isGift
                                                        ? Color(0xFFC7B456)
                                                        : Color(0xFF888888),
                                                    size: 22,
                                                  ),
                                                ),
                                                SizedBox(width: 14),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Send as a Gift',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Urbanist',
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              Color(0xFF1A1A1A),
                                                        ),
                                                      ),
                                                      Text(
                                                        'We\'ll add a special touch',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Urbanist',
                                                          fontSize: 11,
                                                          color:
                                                              Color(0xFF888888),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                AnimatedContainer(
                                                  duration: Duration(
                                                      milliseconds: 200),
                                                  width: 46,
                                                  height: 26,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            13),
                                                    color: isGift
                                                        ? Color(0xFFC7B456)
                                                        : Color(0xFFE0E0E0),
                                                  ),
                                                  child: AnimatedAlign(
                                                    duration: Duration(
                                                        milliseconds: 200),
                                                    alignment: isGift
                                                        ? Alignment.centerRight
                                                        : Alignment.centerLeft,
                                                    child: Container(
                                                      width: 22,
                                                      height: 22,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 2),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.1),
                                                            blurRadius: 4,
                                                            offset:
                                                                Offset(0, 2),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        // GST Input - Beautiful Card Design
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 16.0),
                                          child: Consumer<ConfigModel>(
                                            builder:
                                                (context, configModel, child) {
                                              print(
                                                  "${configModel.user?.gstNumber}");

                                              return Container(
                                                padding: EdgeInsets.all(20),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.03),
                                                      blurRadius: 8,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Color(
                                                                0xFFE3F2FD),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                          child: Icon(
                                                            Icons
                                                                .assignment_outlined,
                                                            color: Color(
                                                                0xFF2196F3),
                                                            size: 20,
                                                          ),
                                                        ),
                                                        SizedBox(width: 14),
                                                        Text(
                                                          'GST Number (Optional)',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Urbanist',
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: Color(
                                                                0xFF1A1A1A),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 16),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFFF8F9FA),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        border: Border.all(
                                                            color: Colors
                                                                .grey.shade200),
                                                      ),
                                                      child: CheckboxListTile(
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        12),
                                                        activeColor:
                                                            Color(0xFF2196F3),
                                                        title: Text(
                                                          "Use GST Number",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Urbanist',
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Color(
                                                                0xFF1A1A1A),
                                                          ),
                                                        ),
                                                        value: _addGst,
                                                        onChanged: (val) {
                                                          setState(() {
                                                            _addGst =
                                                                val ?? false;
                                                            if (_addGst) {
                                                              // Restore from profile if available using locator for robustness
                                                              final userConfig =
                                                                  locator<
                                                                      ConfigModel>();
                                                              if (userConfig
                                                                          .user
                                                                          ?.gstNumber !=
                                                                      null &&
                                                                  userConfig
                                                                      .user!
                                                                      .gstNumber!
                                                                      .isNotEmpty) {
                                                                _gstController
                                                                        .text =
                                                                    userConfig
                                                                        .user!
                                                                        .gstNumber!;
                                                              }
                                                            } else {
                                                              _gstController
                                                                  .clear();
                                                            }
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    if (_addGst) ...[
                                                      SizedBox(height: 16),
                                                      TextFormField(
                                                        controller:
                                                            _gstController,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              'Enter GST Number',
                                                          hintStyle: TextStyle(
                                                            fontFamily:
                                                                'Urbanist',
                                                            color: Colors
                                                                .grey[400],
                                                            fontSize: 14,
                                                          ),
                                                          filled: true,
                                                          fillColor:
                                                              Color(0xFFF8F9FA),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                            borderSide:
                                                                BorderSide.none,
                                                          ),
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 16,
                                                            vertical: 14,
                                                          ),
                                                        ),
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Urbanist',
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              Color(0xFF1A1A1A),
                                                        ),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        // Order Summary - Beautiful Card Design
                                        Container(
                                          width: 1.0.sw - 50,
                                          margin: EdgeInsets.only(top: 12),
                                          padding: EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Colors.white,
                                                Color(0xFFF8F9FA)
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.06),
                                                blurRadius: 16,
                                                offset: Offset(0, 8),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Header
                                              Row(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFFFFF3E0),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: Icon(
                                                      Icons
                                                          .receipt_long_rounded,
                                                      color: Color(0xFFFF9800),
                                                      size: 20,
                                                    ),
                                                  ),
                                                  SizedBox(width: 14),
                                                  Text(
                                                    'Order Summary',
                                                    style: TextStyle(
                                                      fontFamily: 'Urbanist',
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Color(0xFF1A1A1A),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 20),
                                              Divider(
                                                  height: 1,
                                                  color: Color(0xFFEEEEEE)),
                                              SizedBox(height: 16),
                                              // Item Total Row (Selected Items Only)
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'Item Total (${_selectedCartItemIds.length} selected)',
                                                      style: TextStyle(
                                                        fontFamily: 'Urbanist',
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Color(0xFF666666),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    'RS ' +
                                                        (((_calculateSelectedItemsTotal() +
                                                                    _calculateTotalFavWholesalerDiscount()) /
                                                                105 *
                                                                100))
                                                            .toStringAsFixed(2),
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(0xFF1A1A1A),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              if (_calculateTotalFavWholesalerDiscount() >
                                                  0)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 14.0),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'Fav. Wholesaler Disc.' +
                                                              _getFavWholesalerDiscountPercentage(),
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Urbanist',
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.green,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        '- RS ' +
                                                            ((_calculateTotalFavWholesalerDiscount() /
                                                                    105 *
                                                                    100))
                                                                .toStringAsFixed(
                                                                    2),
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: TextStyle(
                                                          fontFamily: 'Inter',
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.green,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              SizedBox(height: 14),
                                              if ((double.tryParse(_configModel
                                                              .user
                                                              ?.companies?[0]
                                                              .deliveryCharges
                                                              ?.toString() ??
                                                          '0') ??
                                                      0) >
                                                  0)
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        'Delivery Charges',
                                                        style:
                                                            MyGoogleFontStyle(
                                                          fontFamily:
                                                              'Urbanist',
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              Color(0xff666666),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      'RS ${double.tryParse(_configModel.user?.companies?[0].deliveryCharges?.toString() ?? '0')?.toStringAsFixed(2) ?? '0'}',
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: MyGoogleFontStyle(
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            Color(0xff303030),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              if ((double.tryParse(_configModel
                                                              .user
                                                              ?.companies?[0]
                                                              .deliveryCharges
                                                              ?.toString() ??
                                                          '0') ??
                                                      0) >
                                                  0)
                                                SizedBox(height: 14),
                                              if ((_configModel
                                                          .user
                                                          ?.companies?[0]
                                                          .packagingCharges ??
                                                      0) >
                                                  0)
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        'Packaging Charges',
                                                        style:
                                                            MyGoogleFontStyle(
                                                          fontFamily:
                                                              'Urbanist',
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              Color(0xff666666),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      'RS ${_configModel.user?.companies?[0].packagingCharges!.toStringAsFixed(2)}',
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: MyGoogleFontStyle(
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            Color(0xff303030),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              if ((_configModel
                                                          .user
                                                          ?.companies?[0]
                                                          .packagingCharges ??
                                                      0) >
                                                  0)
                                                SizedBox(height: 14),
                                              if ((_configModel
                                                          .user
                                                          ?.companies?[0]
                                                          .platformFee ??
                                                      0) >
                                                  0)
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        'Platform Fee',
                                                        style:
                                                            MyGoogleFontStyle(
                                                          fontFamily:
                                                              'Urbanist',
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              Color(0xff666666),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      'RS ${_configModel.user?.companies?[0].platformFee?.toStringAsFixed(2) ?? '0.00'}',
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: MyGoogleFontStyle(
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            Color(0xff303030),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              if ((_configModel
                                                          .user
                                                          ?.companies?[0]
                                                          .platformFee ??
                                                      0) >
                                                  0)
                                                SizedBox(height: 14),

                                              // Taxes Section
                                              if (address.state ==
                                                  'Maharashtra')
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        'SGST 2.5%',
                                                        style:
                                                            MyGoogleFontStyle(
                                                          fontFamily:
                                                              'Urbanist',
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              Color(0xff666666),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      'RS' +
                                                          ' ' +
                                                          (() {
                                                            // Calculate SGST using selected items total
                                                            int cartTotal =
                                                                _calculateSelectedItemsTotal();
                                                            // Calculate GST on cart total after applying discounts
                                                            double
                                                                cartTotalAfterDiscounts =
                                                                cartTotal -
                                                                    couponValue -
                                                                    useWalletPoint;
                                                            // Calculate using new method: item total = cartTotalAfterDiscounts / 105 * 100
                                                            double itemTotal =
                                                                (cartTotalAfterDiscounts /
                                                                        105) *
                                                                    100;
                                                            // GST = Cart Total After Discounts - Item Total
                                                            double gstAmount =
                                                                cartTotalAfterDiscounts -
                                                                    itemTotal;
                                                            double sgstAmount =
                                                                gstAmount / 2;
                                                            // SGST fixed at 2.5% of original cart total
                                                            return sgstAmount
                                                                .toStringAsFixed(
                                                                    2);
                                                          }()),
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: MyGoogleFontStyle(
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            Color(0xff303030),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              if (address.state ==
                                                  'Maharashtra')
                                                SizedBox(
                                                  height: 14,
                                                ),
                                              if (address.state ==
                                                  'Maharashtra')
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        'CGST 2.5%',
                                                        style:
                                                            MyGoogleFontStyle(
                                                          fontFamily:
                                                              'Urbanist',
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              Color(0xff666666),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      'RS' +
                                                          ' ' +
                                                          (() {
                                                            // Calculate CGST using selected items total
                                                            int cartTotal =
                                                                _calculateSelectedItemsTotal();
                                                            // Calculate GST on cart total after applying discounts
                                                            double
                                                                cartTotalAfterDiscounts =
                                                                cartTotal -
                                                                    couponValue -
                                                                    useWalletPoint;
                                                            // Calculate using new method: item total = cartTotalAfterDiscounts / 105 * 100
                                                            double itemTotal =
                                                                (cartTotalAfterDiscounts /
                                                                        105) *
                                                                    100;
                                                            // GST = Cart Total After Discounts - Item Total
                                                            double gstAmount =
                                                                cartTotalAfterDiscounts -
                                                                    itemTotal;
                                                            double cgstAmount =
                                                                gstAmount / 2;
                                                            // CGST fixed at 2.5% of original cart total
                                                            return cgstAmount
                                                                .toStringAsFixed(
                                                                    2);
                                                          }()),
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: MyGoogleFontStyle(
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            Color(0xff303030),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              if (address.state !=
                                                  'Maharashtra')
                                                SizedBox(height: 14),
                                              if (address.state !=
                                                  'Maharashtra')
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        'IGST 5%',
                                                        style:
                                                            MyGoogleFontStyle(
                                                          fontFamily:
                                                              'Urbanist',
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              Color(0xff666666),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      'RS' +
                                                          ' ' +
                                                          (() {
                                                            // Calculate IGST using selected items total
                                                            int cartTotal =
                                                                _calculateSelectedItemsTotal();
                                                            // Calculate GST on cart total after applying discounts
                                                            double
                                                                cartTotalAfterDiscounts =
                                                                cartTotal -
                                                                    couponValue -
                                                                    useWalletPoint;
                                                            // Calculate using new method: item total = cartTotalAfterDiscounts / 105 * 100
                                                            double
                                                                itemTotalCalc =
                                                                (cartTotalAfterDiscounts /
                                                                        105) *
                                                                    100;
                                                            // GST = Cart Total After Discounts - Item Total
                                                            double gstAmount =
                                                                cartTotalAfterDiscounts -
                                                                    itemTotalCalc;
                                                            double igstAmount =
                                                                gstAmount; // For IGST states, IGST = full GST
                                                            return igstAmount
                                                                .toStringAsFixed(
                                                                    2);
                                                          }()),
                                                      // (5 *
                                                      //         int.parse(_addToCartModel
                                                      //             .cartTotal
                                                      //             .toString()) /
                                                      //         100)
                                                      // .toString(),
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: MyGoogleFontStyle(
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            Color(0xff303030),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              SizedBox(height: 14),

                                              // Discounts Section
                                              if (couponValue > 0)
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .local_offer_outlined,
                                                            size: 16,
                                                            color: Colors
                                                                .green[700],
                                                          ),
                                                          SizedBox(width: 8),
                                                          Text(
                                                            'Coupon Discount',
                                                            style:
                                                                MyGoogleFontStyle(
                                                              fontFamily:
                                                                  'Urbanist',
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Colors
                                                                  .green[700],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Text(
                                                      '- RS' +
                                                          ' ' +
                                                          couponValue
                                                              .toStringAsFixed(
                                                                  2),
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: MyGoogleFontStyle(
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            Colors.green[700],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              if (couponValue > 0)
                                                SizedBox(height: 14),

                                              if (_activeRole != 'Distributor')
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          if (useWalletPoint >
                                                              0)
                                                            Icon(
                                                              Icons
                                                                  .wallet_giftcard_rounded,
                                                              size: 16,
                                                              color: Colors
                                                                  .green[700],
                                                            )
                                                          else
                                                            SizedBox(),
                                                          if (useWalletPoint >
                                                              0)
                                                            SizedBox(width: 8),
                                                          Text(
                                                            'Rewards Used',
                                                            style:
                                                                MyGoogleFontStyle(
                                                              fontFamily:
                                                                  'Urbanist',
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  useWalletPoint >
                                                                          0
                                                                      ? FontWeight
                                                                          .w600
                                                                      : FontWeight
                                                                          .w500,
                                                              color: useWalletPoint >
                                                                      0
                                                                  ? Colors.green[
                                                                      700]
                                                                  : Color(
                                                                      0xff666666),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    if (useWalletPoint != 0)
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            useWalletPoint = 0;
                                                          });
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 8.0),
                                                          child:
                                                              Text('(Remove)'),
                                                        ),
                                                      ),
                                                    if (useWalletPoint == 0)
                                                      InkWell(
                                                        onTap: () async {
                                                          await _userWaletModel
                                                              .getMyUserWallets();
                                                          setState(() {
                                                            // Calculate 25% of item total after coupon discount (using selected items)
                                                            final cartTotal =
                                                                _calculateSelectedItemsTotal();
                                                            // Calculate using new method: item total = cartTotal / 105 * 100
                                                            final itemTotal =
                                                                (cartTotal /
                                                                        105) *
                                                                    100;
                                                            // Item total is already calculated after discounts, so use it directly
                                                            final cartAfterCoupon =
                                                                itemTotal;

                                                            final calculatedPoints =
                                                                (cartAfterCoupon *
                                                                        0.25)
                                                                    .round();
                                                            final availablePoints =
                                                                _userWaletModel
                                                                    .totaRemainingPoint;
                                                            useWalletPoint =
                                                                calculatedPoints >
                                                                        availablePoints
                                                                    ? availablePoints
                                                                    : calculatedPoints;
                                                          });
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 8.0),
                                                          child: Text('(Add)'),
                                                        ),
                                                      ),
                                                    Text(
                                                      '${useWalletPoint > 0 ? "- " : ""}RS ${(useWalletPoint).toStringAsFixed(2)}',
                                                      // Division by 3 directly
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: MyGoogleFontStyle(
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: useWalletPoint >
                                                                0
                                                            ? Colors.green[700]
                                                            : Color(0xff303030),
                                                      ),
                                                    )
                                                  ],
                                                ),

                                              SizedBox(height: 20),
                                              Divider(
                                                  height: 1,
                                                  color: Color(0xFFEEEEEE),
                                                  thickness: 1),
                                              SizedBox(height: 20),

                                              // Total Row - Highlighted
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 14),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFFFF8E1),
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  border: Border.all(
                                                      color: Color(0xFFEED056)
                                                          .withOpacity(0.3)),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        'Total Payable',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Urbanist',
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          color:
                                                              Color(0xFF1A1A1A),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      'RS ' +
                                                          (() {
                                                            int cartTotal =
                                                                _calculateSelectedItemsTotal();
                                                            double
                                                                deliveryCharges =
                                                                double.tryParse(_configModel
                                                                            .user
                                                                            ?.companies?[0]
                                                                            .deliveryCharges
                                                                            ?.toString() ??
                                                                        '0') ??
                                                                    0;
                                                            double
                                                                packagingCharges =
                                                                double.tryParse(_configModel
                                                                            .user
                                                                            ?.companies?[0]
                                                                            .packagingCharges
                                                                            ?.toString() ??
                                                                        '0') ??
                                                                    0;
                                                            double
                                                                platformFeeValue =
                                                                double.tryParse(_configModel
                                                                            .user
                                                                            ?.companies?[0]
                                                                            .platformFee
                                                                            ?.toString() ??
                                                                        '0') ??
                                                                    0;
                                                            double total = cartTotal +
                                                                deliveryCharges +
                                                                packagingCharges +
                                                                platformFeeValue -
                                                                couponValue -
                                                                (_activeRole ==
                                                                        'Distributor'
                                                                    ? 0
                                                                    : useWalletPoint);
                                                            return total
                                                                .toStringAsFixed(
                                                                    2);
                                                          }()),
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color:
                                                            Color(0xFFC7B456),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        SizedBox(height: 6),
                                        // Show pay button only if there are selected items (in-stock items)
                                        Builder(
                                          builder: (context) {
                                            // If no items are selected, show warning
                                            if (_selectedCartItemIds.isEmpty) {
                                              return Container(
                                                width: double.infinity,
                                                padding: EdgeInsets.all(16),
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 16),
                                                decoration: BoxDecoration(
                                                  color: Colors.orange
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                      color: Colors.orange
                                                          .withOpacity(0.3)),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .warning_amber_rounded,
                                                      color: Colors.orange,
                                                      size: 32,
                                                    ),
                                                    SizedBox(height: 8),
                                                    Text(
                                                      'No items selected',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color:
                                                            Colors.orange[700],
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    SizedBox(height: 4),
                                                    Text(
                                                      'Please select at least one item to proceed with checkout',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color:
                                                            Colors.orange[400],
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                            // Show proceed button when items are selected
                                            return address.id != null
                                                ? Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              0.89, 0, 0, 0),
                                                      child: TextButton(
                                                        onPressed: () async {
                                                          if (paymentOption ==
                                                              '') {
                                                            showDialog(
                                                              context: context,
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  AlertDialog(
                                                                title: Text(
                                                                    'Please select payment type.'),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                        'Ok'),
                                                                  )
                                                                ],
                                                              ),
                                                            );
                                                          } else {
                                                            // Check if any items are selected
                                                            if (_selectedCartItemIds
                                                                .isEmpty) {
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                SnackBar(
                                                                  content: Text(
                                                                      'Please select at least one item to proceed'),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .orange,
                                                                  duration:
                                                                      Duration(
                                                                          seconds:
                                                                              2),
                                                                ),
                                                              );
                                                              return;
                                                            }

                                                            // Check Minimum Order Amount for Distributor (except only Madani products)
                                                            if (_activeRole ==
                                                                'Distributor') {
                                                              double
                                                                  totalPayable =
                                                                  _calculateTotalPayable();
                                                              if (totalPayable <
                                                                      10000 &&
                                                                  !_isOnlyMadaniProducts()) {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      AlertDialog(
                                                                    title: Text(
                                                                        'Minimum Order Limit'),
                                                                    content: Text(
                                                                        'Total payable amount must be at least ₹10,000 for Distributors (unless ordering only Madani products).'),
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child: Text(
                                                                            'Ok'),
                                                                      )
                                                                    ],
                                                                  ),
                                                                );
                                                                return;
                                                              }
                                                            }

                                                            // Check for out of stock and insufficient stock items before placing order
                                                            Map<
                                                                    String,
                                                                    List<
                                                                        Map<String,
                                                                            dynamic>>>
                                                                stockCheckResult =
                                                                await _getOutOfStockItems();
                                                            List<
                                                                    Map<String,
                                                                        dynamic>>
                                                                outOfStockItems =
                                                                stockCheckResult[
                                                                        'outOfStock'] ??
                                                                    [];
                                                            List<
                                                                    Map<String,
                                                                        dynamic>>
                                                                insufficientStockItems =
                                                                stockCheckResult[
                                                                        'insufficientStock'] ??
                                                                    [];

                                                            if (outOfStockItems
                                                                    .isNotEmpty ||
                                                                insufficientStockItems
                                                                    .isNotEmpty) {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    AlertDialog(
                                                                  title: Text(
                                                                      'Stock Issue'),
                                                                  content:
                                                                      SingleChildScrollView(
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        if (outOfStockItems
                                                                            .isNotEmpty) ...[
                                                                          Text(
                                                                            'Out of Stock:',
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.red),
                                                                          ),
                                                                          SizedBox(
                                                                              height: 8),
                                                                          ...outOfStockItems
                                                                              .map((item) => Padding(
                                                                                    padding: EdgeInsets.symmetric(vertical: 4),
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Icon(Icons.error_outline, color: Colors.red, size: 18),
                                                                                        SizedBox(width: 8),
                                                                                        Expanded(
                                                                                          child: Text(
                                                                                            '${item['name']}',
                                                                                            style: TextStyle(fontSize: 13),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ))
                                                                              .toList(),
                                                                          SizedBox(
                                                                              height: 12),
                                                                        ],
                                                                        if (insufficientStockItems
                                                                            .isNotEmpty) ...[
                                                                          Text(
                                                                            'Insufficient Stock:',
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.orange),
                                                                          ),
                                                                          SizedBox(
                                                                              height: 8),
                                                                          ...insufficientStockItems
                                                                              .map((item) => Padding(
                                                                                    padding: EdgeInsets.symmetric(vertical: 4),
                                                                                    child: Row(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 18),
                                                                                        SizedBox(width: 8),
                                                                                        Expanded(
                                                                                          child: Column(
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              Text(
                                                                                                '${item['name']}',
                                                                                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                                                                              ),
                                                                                              Text(
                                                                                                'Ordered: ${item['orderedQty']} | Available: ${item['availableQty']}',
                                                                                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ))
                                                                              .toList(),
                                                                          SizedBox(
                                                                              height: 12),
                                                                        ],
                                                                        Text(
                                                                          outOfStockItems.isNotEmpty
                                                                              ? 'Please remove out of stock items or reduce quantity for insufficient stock items to proceed.'
                                                                              : 'Please reduce the quantity to available stock to proceed.',
                                                                          style: TextStyle(
                                                                              fontSize: 12,
                                                                              color: Colors.grey[600]),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                        // Trigger UI refresh to update out of stock display
                                                                        setState(
                                                                            () {});
                                                                      },
                                                                      child: Text(
                                                                          'Ok'),
                                                                    )
                                                                  ],
                                                                ),
                                                              );
                                                              // Trigger UI refresh to show out of stock state
                                                              setState(() {});
                                                              return;
                                                            }

                                                            var addressId =
                                                                address.id;

                                                            // Calculate gstAmount before payment processing (using selected items)
                                                            int cartTotalForGst =
                                                                _calculateSelectedItemsTotal();
                                                            double
                                                                cartTotalAfterDiscountsForGst =
                                                                cartTotalForGst -
                                                                    couponValue -
                                                                    (_activeRole ==
                                                                            'Distributor'
                                                                        ? 0
                                                                        : useWalletPoint);
                                                            double
                                                                itemTotalForGst =
                                                                (cartTotalAfterDiscountsForGst /
                                                                        105) *
                                                                    100;
                                                            double gstAmount =
                                                                cartTotalAfterDiscountsForGst -
                                                                    itemTotalForGst;

                                                            // Payment processing

                                                            if (paymentOption ==
                                                                'UPI/PhonePe') {
                                                              // Prepare payload data for the transaction - use selected items only
                                                              final selectedItemsForPayment =
                                                                  _getSelectedCartItems();
                                                              final selectedTotalForPayment =
                                                                  _calculateSelectedItemsTotal();

                                                              Map<String,
                                                                      dynamic>
                                                                  payloadData =
                                                                  {
                                                                'cartItems':
                                                                    selectedItemsForPayment,
                                                                'cartTotal':
                                                                    selectedTotalForPayment
                                                                        .toString(),
                                                                'addressId':
                                                                    addressId,
                                                                'isGift':
                                                                    isGift,
                                                                'useWalletPoint':
                                                                    _activeRole ==
                                                                            'Distributor'
                                                                        ? 0
                                                                        : useWalletPoint,
                                                                'couponId': couponId
                                                                    .toString(),
                                                                'deliveryMethod':
                                                                    "deliveryMethod",
                                                                'couponValue':
                                                                    couponValue
                                                                        .toString(),
                                                                'gstNumber':
                                                                    _gstController
                                                                        .text, // Add GST Number
                                                              };

                                                              // Add gstAmount to payloadData for online payment
                                                              payloadData[
                                                                      'gstAmount'] =
                                                                  gstAmount
                                                                      .toStringAsFixed(
                                                                          2);
                                                              payloadData[
                                                                      'platformFee'] =
                                                                  _configModel
                                                                          .user
                                                                          ?.companies?[
                                                                              0]
                                                                          .platformFee ??
                                                                      0;

                                                              // Calculate the amount to be paid
                                                              double itemTotal =
                                                                  itemTotalForGst;
                                                              double
                                                                  sgstAmount =
                                                                  gstAmount / 2;
                                                              double
                                                                  cgstAmount =
                                                                  gstAmount / 2;

                                                              int deliveryCharges = _configModel
                                                                          .user!
                                                                          .companies![
                                                                              0]
                                                                          .deliveryCharges ==
                                                                      null
                                                                  ? 0
                                                                  : num.parse(_configModel
                                                                          .user!
                                                                          .companies![
                                                                              0]
                                                                          .deliveryCharges
                                                                          .toString())
                                                                      .toInt();
                                                              int packagingCharges = _configModel
                                                                          .user!
                                                                          .companies![
                                                                              0]
                                                                          .packagingCharges ==
                                                                      null
                                                                  ? 0
                                                                  : num.parse(_configModel
                                                                          .user!
                                                                          .companies![
                                                                              0]
                                                                          .packagingCharges
                                                                          .toString())
                                                                      .toInt();

                                                              // Calculate total amount
                                                              double
                                                                  amountAfterDiscounts =
                                                                  itemTotal;
                                                              double taxAmount =
                                                                  sgstAmount +
                                                                      cgstAmount;
                                                              double
                                                                  platformFeeAmount =
                                                                  double.tryParse(_configModel
                                                                              .user
                                                                              ?.companies?[0]
                                                                              .platformFee
                                                                              ?.toString() ??
                                                                          '0') ??
                                                                      0;
                                                              double
                                                                  totalAmount =
                                                                  amountAfterDiscounts +
                                                                      deliveryCharges +
                                                                      packagingCharges +
                                                                      platformFeeAmount +
                                                                      taxAmount;

                                                              int minumumPayable =
                                                                  totalAmount
                                                                      .round();
                                                              String
                                                                  mobileNumber =
                                                                  _configModel
                                                                      .user!
                                                                      .phone
                                                                      .toString();

                                                              // Start PhonePe transaction
                                                              _startTransaction(
                                                                  // 1,
                                                                  minumumPayable,
                                                                  mobileNumber,
                                                                  payloadData,
                                                                  context);
                                                            } else {
                                                              // Cash on Delivery - use selected items only
                                                              final selectedItems =
                                                                  _getSelectedCartItems();
                                                              final selectedTotal =
                                                                  _calculateSelectedItemsTotal();

                                                              bool response =
                                                                  await _orderModel
                                                                      .placedOrder(
                                                                selectedItems,
                                                                selectedTotal
                                                                    .toString(),
                                                                addressId,
                                                                isGift,
                                                                _activeRole ==
                                                                        'Distributor'
                                                                    ? 0
                                                                    : useWalletPoint,
                                                                couponId
                                                                    .toString(),
                                                                'Cash on Delivery',
                                                                "deliveryMethod",
                                                                couponValue
                                                                    .toString(),
                                                                gstAmount
                                                                    .toStringAsFixed(
                                                                        2),
                                                                _configModel
                                                                        .user
                                                                        ?.companies?[
                                                                            0]
                                                                        .platformFee ??
                                                                    0,
                                                                _gstController
                                                                    .text, // Pass GST Number
                                                              );

                                                              if (response ==
                                                                  true) {
                                                                Navigator.pushNamed(
                                                                    context,
                                                                    '/successPage');
                                                              }
                                                            }
                                                          }
                                                        },
                                                        style: TextButton
                                                            .styleFrom(
                                                          padding:
                                                              EdgeInsets.zero,
                                                        ),
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          height: 54,
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      16),
                                                          decoration:
                                                              BoxDecoration(
                                                            gradient:
                                                                LinearGradient(
                                                              begin: Alignment
                                                                  .topLeft,
                                                              end: Alignment
                                                                  .bottomRight,
                                                              colors: [
                                                                Color(
                                                                    0xFFD4C76A),
                                                                Color(
                                                                    0xFFC7B456),
                                                                Color(
                                                                    0xFFAA9A40)
                                                              ],
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        14),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Color(
                                                                        0xFFC7B456)
                                                                    .withOpacity(
                                                                        0.4),
                                                                blurRadius: 12,
                                                                offset: Offset(
                                                                    0, 4),
                                                              ),
                                                            ],
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                  Icons
                                                                      .shopping_bag_rounded,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 20),
                                                              SizedBox(
                                                                  width: 10),
                                                              Text(
                                                                'Proceed (${_selectedCartItemIds.length} items)',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Urbanist',
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Center(
                                                    child: InkWell(
                                                      onTap: () async {
                                                        final result =
                                                            await Navigator.of(
                                                                    context)
                                                                .push(
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    AddressPage(
                                                              arguments: {
                                                                'cartTotal':
                                                                    _addToCartModel
                                                                        .cartTotal
                                                                        .toString(),
                                                                'cartItems':
                                                                    _addToCartModel
                                                                        .addToCarts,
                                                                'couponValue':
                                                                    couponValue,
                                                                'isAddress':
                                                                    true
                                                              },
                                                            ),
                                                          ),
                                                        );
                                                        if (result != null &&
                                                            result['address'] !=
                                                                null) {
                                                          setState(() {
                                                            address = UserAddress
                                                                .fromJson(result[
                                                                    'address']);
                                                          });
                                                        }
                                                      },
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      child: Container(
                                                        width: double.infinity,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 20,
                                                                vertical: 14),
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 16),
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                            colors: [
                                                              Color(0xFF2A2A2A),
                                                              Color(0xFF1A1A1A)
                                                            ],
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.2),
                                                              blurRadius: 8,
                                                              offset:
                                                                  Offset(0, 4),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                                Icons
                                                                    .add_location_alt_rounded,
                                                                color: Colors
                                                                    .white,
                                                                size: 20),
                                                            SizedBox(width: 10),
                                                            Flexible(
                                                              child: Text(
                                                                'Add Delivery Address to Continue',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Urbanist',
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Add More Items',
                                                style: MyGoogleFontStyle(
                                                  fontFamily: 'Urbanist',
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xff000000),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.35,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: _productModel
                                                              .productsLoader
                                                          ? Center(
                                                              child:
                                                                  LinearProgressIndicator())
                                                          : (_productModel.randomProducts ==
                                                                      null ||
                                                                  _productModel
                                                                      .randomProducts!
                                                                      .isEmpty)
                                                              ? Center(
                                                                  child: Text(
                                                                    'No products available',
                                                                    style:
                                                                        MyGoogleFontStyle(
                                                                      fontFamily:
                                                                          'Urbanist',
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                  ),
                                                                )
                                                              : ListView
                                                                  .builder(
                                                                  scrollDirection:
                                                                      Axis.horizontal,
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemCount: _productModel
                                                                          .randomProducts
                                                                          ?.length ??
                                                                      0,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return Padding(
                                                                      padding: EdgeInsets.only(
                                                                          right:
                                                                              12.0),
                                                                      child:
                                                                          () {
                                                                        final product =
                                                                            _productModel.randomProducts![index];
                                                                        double
                                                                            discountPrice =
                                                                            0.0;
                                                                        if (product.productPrices?.isNotEmpty ??
                                                                            false) {
                                                                          final configModel =
                                                                              locator<ConfigModel>();
                                                                          final isDistributor =
                                                                              configModel.user?.roles?.any((r) => r.name == 'Distributor') ?? false;
                                                                          final priceObj =
                                                                              product.productPrices![0];

                                                                          double
                                                                              price =
                                                                              double.tryParse(priceObj.price?.toString() ?? '0') ?? 0;
                                                                          double
                                                                              offerPrice =
                                                                              double.tryParse(priceObj.offerPrice?.toString() ?? '0') ?? 0;

                                                                          if (isDistributor) {
                                                                            double?
                                                                                distPrice =
                                                                                double.tryParse(priceObj.distributorPrice?.toString() ?? '');
                                                                            double?
                                                                                distOfferPrice =
                                                                                double.tryParse(priceObj.distributorOfferPrice?.toString() ?? '');

                                                                            if (distPrice != null &&
                                                                                distPrice > 0)
                                                                              price = distPrice;
                                                                            if (distOfferPrice != null &&
                                                                                distOfferPrice > 0)
                                                                              offerPrice = distOfferPrice;
                                                                          }

                                                                          if (price > 0 &&
                                                                              offerPrice > 0 &&
                                                                              offerPrice < price) {
                                                                            discountPrice = ((price - offerPrice) /
                                                                                price *
                                                                                100);
                                                                          }
                                                                        }
                                                                        return CommonProductCard(
                                                                          product:
                                                                              product,
                                                                          discountPrice:
                                                                              discountPrice,
                                                                        );
                                                                      }(),
                                                                    );
                                                                  },
                                                                ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                      ],
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

  Widget _buildBottomNavigationBar(
    BuildContext context,
    ConfigModel configModel,
    AddToCartModel addToCartModel,
    int cartCount,
  ) {
    const double _bottomNavBarHeight = 90.0;
    const double _bottomNavIconSize = 24.0;
    return Container(
      height: _bottomNavBarHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFEED056).withOpacity(0.15),
            blurRadius: 25,
            spreadRadius: 0,
            offset: Offset(0, -8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: Color(0xFFEED056).withOpacity(0.2),
            width: 1.5,
          ),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        child: BottomNavigationBar(
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFFEED056),
          unselectedItemColor: Color(0xFF909090),
          selectedFontSize: 11,
          unselectedFontSize: 11,
          currentIndex: 2, // Set 'Cart' as active (Index 2)
          selectedLabelStyle: TextStyle(
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.w500,
          ),
          onTap: (value) =>
              _handleBottomNavTap(context, value, configModel, addToCartModel),
          items: [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Image.asset('assets/images/home-icon.png',
                  width: _bottomNavIconSize,
                  height: _bottomNavIconSize,
                  color: Color(0xFF909090)), // Explicitly grey
            ),
            BottomNavigationBarItem(
              label: 'Category',
              icon: Image.asset('assets/images/category-icon.png',
                  width: _bottomNavIconSize,
                  height: _bottomNavIconSize,
                  color: Color(0xFF909090)), // Explicitly grey
            ),
            BottomNavigationBarItem(
              label: 'Cart',
              icon: badges.Badge(
                badgeContent: Text('$cartCount',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
                badgeStyle: badges.BadgeStyle(
                  badgeColor: Color(0xFFEED056),
                  padding: EdgeInsets.all(6),
                ),
                child: Image.asset('assets/images/cart-icon.png',
                    width: _bottomNavIconSize,
                    height: _bottomNavIconSize,
                    color: Color(0xFFEED056)), // Active (Yellow)
              ),
            ),
            BottomNavigationBarItem(
              label: 'Profile',
              icon: Image.asset('assets/images/user-profile-icon.png',
                  width: _bottomNavIconSize,
                  height: _bottomNavIconSize,
                  color: Color(0xFF909090)), // Explicitly grey
            ),
            BottomNavigationBarItem(
              label: 'Notifs',
              icon: Image.asset('assets/images/notification-icon.png',
                  width: _bottomNavIconSize,
                  height: _bottomNavIconSize,
                  color: Color(0xFF909090)), // Explicitly grey
            ),
          ],
        ),
      ),
    );
  }

  void _handleBottomNavTap(
    BuildContext context,
    int value,
    ConfigModel configModel,
    AddToCartModel addToCartModel,
  ) async {
    if (value == 0) {
      Navigator.pushNamed(context, '/homePage');
    } else if (value == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const ShopsPage(initialText: '')));
    } else if (value == 2) {
      // Already on Cart Page
    } else if (value == 3 && configModel.user != null) {
      Navigator.pushNamed(context, '/profilePage');
    } else if (value == 4 && configModel.user != null) {
      Navigator.pushNamed(context, '/notificationPage');
    } else {
      showDialog(
          context: context, builder: (context) => LoginRequiredPopupWidget());
    }
  }
}
