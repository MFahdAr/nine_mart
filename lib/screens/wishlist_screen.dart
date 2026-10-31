import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    double totalWishlistEstimate = provider.wishlist.fold(0, (sum, item) => sum + item.price);

    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Keinginan Saya')),
      body: provider.wishlist.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 60, color: AppColors.greyText),
                  SizedBox(height: 10),
                  Text('Belum ada barang di Wishlist Anda.', style: TextStyle(color: AppColors.greyText)),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    physics: const BouncingScrollPhysics(),
                    itemCount: provider.wishlist.length,
                    itemBuilder: (context, index) {
                      final product = provider.wishlist[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(imageUrl: product.thumbnail, width: 70, height: 70, fit: BoxFit.cover),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(product.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                  const SizedBox(height: 4),
                                  Text('\$${product.price}', style: const TextStyle(color: AppColors.deepBlue, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.deepBlue,
                                      minimumSize: const Size(0, 32),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    icon: const Icon(Icons.shopping_bag_outlined, size: 14, color: Colors.white),
                                    label: const Text('Pindahkan ke Keranjang', style: TextStyle(fontSize: 11, color: Colors.white)),
                                    onPressed: () {
                                      provider.addToCart(product);
                                      provider.toggleWishlist(product);
                                    },
                                  )
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () => provider.toggleWishlist(product),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
                
                // Bottom Wishlist Bar
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total Perkiraan', style: TextStyle(fontSize: 11, color: AppColors.greyText)),
                          Text('\$${totalWishlistEstimate.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.deepBlue)),
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.deepBlue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          provider.addAllWishlistToCart();
                          context.go('/cart');
                        },
                        child: const Text('Masukkan Semua ke Keranjang', style: TextStyle(color: Colors.white)),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
