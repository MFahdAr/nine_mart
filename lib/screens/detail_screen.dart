import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/app_models.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class DetailScreen extends StatefulWidget {
  final Product product;
  const DetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int quantity = 1;
  int selectedShade = 0;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final isFav = provider.isInWishlist(widget.product);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
        actions: [
          IconButton(
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : AppColors.deepBlue),
            onPressed: () => provider.toggleWishlist(widget.product),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main Image View
                  Hero(
                    tag: 'prod_${widget.product.id}',
                    child: Container(
                      height: 280,
                      width: double.infinity,
                      color: Colors.white,
                      child: CachedNetworkImage(imageUrl: widget.product.thumbnail, fit: BoxFit.contain),
                    ),
                  ),
                  
                  // Product Content Sheet
                  Container(
                    transform: Matrix4.translationValues(0, -15, 0),
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: AppColors.creamBackground,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(widget.product.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                            ),
                            Text('\$${widget.product.price}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.deepBlue)),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Rating info
                        Row(
                          children: [
                            const Icon(Icons.star, color: AppColors.starGold, size: 18),
                            const SizedBox(width: 4),
                            Text('${widget.product.rating}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(width: 8),
                            const Text('• 128 ulasan pembeli', style: TextStyle(color: AppColors.greyText, fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Pilihan Shade (Jika kategori kecantikan/aksesoris)
                        const Text('Pilihan Shade / Varian', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            ChoiceChip(
                              label: const Text('Black Velvet'),
                              selected: selectedShade == 0,
                              selectedColor: AppColors.deepBlue,
                              labelStyle: TextStyle(color: selectedShade == 0 ? Colors.white : AppColors.darkText),
                              onSelected: (_) => setState(() => selectedShade = 0),
                            ),
                            const SizedBox(width: 10),
                            ChoiceChip(
                              label: const Text('Deep Brown'),
                              selected: selectedShade == 1,
                              selectedColor: AppColors.deepBlue,
                              labelStyle: TextStyle(color: selectedShade == 1 ? Colors.white : AppColors.darkText),
                              onSelected: (_) => setState(() => selectedShade = 1),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Pengatur Jumlah (Quantity Control)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Pengatur Jumlah', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                Text('Tersedia ${widget.product.stock} buah di gudang', style: const TextStyle(fontSize: 11, color: AppColors.greyText)),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(color: AppColors.mintIce, borderRadius: BorderRadius.circular(20)),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove, size: 18, color: AppColors.deepBlue),
                                    onPressed: () {
                                      if (quantity > 1) setState(() => quantity--);
                                    },
                                  ),
                                  Text('$quantity', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  IconButton(
                                    icon: const Icon(Icons.add, size: 18, color: AppColors.deepBlue),
                                    onPressed: () {
                                      if (quantity < widget.product.stock) setState(() => quantity++);
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Deskripsi Produk
                        const Text('Deskripsi Produk', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 8),
                        Text(widget.product.description, style: const TextStyle(color: AppColors.greyText, height: 1.5)),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Dynamic Button
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deepBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  provider.addToCart(widget.product, qty: quantity);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Berhasil menambahkan $quantity barang ke Keranjang!')),
                  );
                },
                child: Text(
                  'Tambahkan ke Keranjang — \$${(widget.product.price * quantity).toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
