import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController promoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Keranjang Belanja')),
      body: provider.cart.isEmpty
          ? const Center(child: Text("Keranjang Anda masih kosong."))
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${provider.cart.length} Barang Pilihan Anda', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),

                  // Cart Item List
                  ...provider.cart.map((item) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(imageUrl: item.product.thumbnail, width: 60, height: 60, fit: BoxFit.cover),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.product.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                const SizedBox(height: 4),
                                Text('\$${item.product.price}', style: const TextStyle(color: AppColors.deepBlue, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),

                          // Quantity buttons
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline, size: 20),
                                onPressed: () => provider.updateCartQuantity(item.product.id, -1),
                              ),
                              Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline, size: 20),
                                onPressed: () => provider.updateCartQuantity(item.product.id, 1),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 20),

                  // Kupon Promo Section
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: promoController,
                            decoration: const InputDecoration(
                              hintText: 'Kode Promo (misal: SMARTDELIGHT)',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.deepBlue),
                          onPressed: () {
                            provider.applyPromo(promoController.text);
                            final ok = provider.discountAmount > 0;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(ok ? 'Kupon Berhasil Diterapkan!' : 'Kode promo tidak valid')),
                            );
                          },
                          child: const Text('Terapkan', style: TextStyle(color: Colors.white)),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Rincian Pembayaran
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Rincian Pembayaran', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Subtotal'),
                            Text('\$${provider.subtotalCart.toStringAsFixed(2)}'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Biaya Pengiriman'),
                            Text('Gratis', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        if (provider.discountAmount > 0) ...[
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Diskon Promo'),
                              Text('-\$${provider.discountAmount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.red)),
                            ],
                          ),
                        ],
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('TOTAL DIBAYAR', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('\$${provider.grandTotalCart.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.deepBlue)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Checkout Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.deepBlue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Pembayaran Berhasil'),
                            content: const Text('Terima kasih telah berbelanja di 9mart!'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))
                            ],
                          ),
                        );
                      },
                      child: const Text('Lanjut ke Pembayaran ->', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
