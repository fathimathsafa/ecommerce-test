import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/theme_controller.dart';
import '../controller/cart_controller.dart';
import '../widgets/cart_item_card.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.watch<ThemeController>(); 
    final cartController = context.watch<CartController>();
    final items = cartController.items;

    return Scaffold(
      backgroundColor: AppColors.bgMain,
      appBar: AppBar(
        title: const Text('My Cart', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (items.isNotEmpty)
            TextButton(
              onPressed: () => _showClearCartConfirmation(context, cartController),
              child: Text('Clear All', style: TextStyle(color: AppColors.wishlist, fontWeight: FontWeight.bold)),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: items.isEmpty
          ? _buildEmptyState(context)
          : Stack(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.only(bottom: 220), // reserve space for sticky bottom checkout sheet
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return CartItemCard(
                      item: item,
                      onRemove: () => cartController.removeFromCart(item.product.id),
                      onQuantityChanged: (newQty) => cartController.updateQuantity(item.product.id, newQty),
                    );
                  },
                ),

                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: AppColors.bgCard,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowColor,
                          blurRadius: 16,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Subtotal', style: TextStyle(color: AppColors.textSecondary)),
                            Text('\$${cartController.subtotal.toStringAsFixed(2)}', style: AppTextStyles.subSectionHeader),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Delivery Charges', style: TextStyle(color: AppColors.textSecondary)),
                            Text(
                              cartController.deliveryCharge == 0.0 ? 'FREE' : '\$${cartController.deliveryCharge.toStringAsFixed(2)}',
                              style: AppTextStyles.subSectionHeader.copyWith(
                                color: cartController.deliveryCharge == 0.0 ? AppColors.accent : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        Divider(height: 24, color: AppColors.borderLight),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total Amount', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                            Text(
                              '\$${cartController.totalAmount.toStringAsFixed(2)}',
                              style: AppTextStyles.productPrice.copyWith(fontSize: 20),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _simulateCheckout(context, cartController),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            child: const Text('Proceed to Checkout', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_basket_outlined,
                size: 64,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Your Cart is Empty',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              'Looks like you haven’t added any items to your cart yet.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, height: 1.4),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('Go Shopping', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCartConfirmation(BuildContext context, CartController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cart?'),
        content: const Text('Are you sure you want to remove all items from your shopping cart?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              controller.clearCart();
              Navigator.pop(context);
            },
            child: Text('Clear', style: TextStyle(color: AppColors.wishlist, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _simulateCheckout(BuildContext context, CartController controller) {
    final navigator = Navigator.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        Future.delayed(const Duration(seconds: 2), () {
          if (!context.mounted) return;
          controller.clearCart();
          navigator.pop(); 
          showDialog(
            context: context,
            builder: (successContext) => AlertDialog(
              title: const Text('Order Placed Successfully!'),
              content: const Text('Thank you for your purchase. Your order will be delivered soon.'),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(successContext).pop(); 
                    navigator.pop(); 
                  },
                  child: const Text('Awesome', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          );
        });

        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: AppColors.primary),
              const SizedBox(height: 16),
              const Text('Processing order, please wait...', style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        );
      },
    );
  }
}
