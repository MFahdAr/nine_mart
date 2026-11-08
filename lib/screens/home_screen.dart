import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.deepBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('9mart', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => context.go('/cart'),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.mintIce,
              child: Icon(Icons.person, color: AppColors.deepBlue, size: 20),
            ),
          )
        ],
      ),      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.deepBlue,
        onPressed: () => context.push('/product-form'),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.initData(),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: AppColors.mintIce.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  onSubmitted: (query) => provider.searchProducts(query),
                  decoration: const InputDecoration(
                    hintText: 'Cari produk impianmu...',
                    prefixIcon: Icon(Icons.search, color: AppColors.deepBlue),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Banner Diskon Pembukaan 9mart
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.mintIce, AppColors.primaryBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
                      child: const Text('Spesial Peluncuran', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.deepBlue)),
                    ),
                    const SizedBox(height: 8),
                    const Text('Diskon Pembukaan\n9mart hingga 50%', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.deepBlue, height: 1.2)),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.deepBlue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Jelajahi Promo ->', style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Kategori Populer
              const Text('Kategori Populer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText)),
              const SizedBox(height: 10),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: provider.categories.length,
                  itemBuilder: (context, index) {
                    final cat = provider.categories[index];
                    final isSelected = provider.selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(cat),
                        selected: isSelected,
                        selectedColor: AppColors.deepBlue,
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.darkText, fontWeight: FontWeight.w600),
                        onSelected: (_) => provider.selectCategory(cat),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Katalog Rekomendasi Grid
              const Text('Katalog Rekomendasi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText)),
              const SizedBox(height: 12),

              if (provider.isLoading)
                const Center(child: Padding(padding: EdgeInsets.all(40.0), child: CircularProgressIndicator()))
              else if (provider.products.isEmpty)
                const Center(child: Text("Produk tidak ditemukan."))
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.68,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final product = provider.products[index];
                    final isFav = provider.isInWishlist(product);
                    return GestureDetector(
                      onTap: () => context.push('/detail', extra: product),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                  child: Hero(
                                    tag: 'prod_${product.id}',
                                    child: CachedNetworkImage(
                                      imageUrl: product.thumbnail,
                                      height: 140,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () => provider.toggleWishlist(product),
                                    child: CircleAvatar(
                                      radius: 14,
                                      backgroundColor: Colors.white.withOpacity(0.9),
                                      child: Icon(
                                        isFav ? Icons.favorite : Icons.favorite_border,
                                        size: 16,
                                        color: isFav ? Colors.red : AppColors.deepBlue,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(product.category.toUpperCase(), style: const TextStyle(fontSize: 10, color: AppColors.greyText, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 2),
                                  Text(product.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.darkText), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('\$${product.price}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.deepBlue)),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        icon: const Icon(Icons.add_shopping_cart, size: 20, color: AppColors.deepBlue),
                                        onPressed: () {
                                          provider.addToCart(product);
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${product.title} ditambah ke keranjang'), duration: const Duration(seconds: 1)));
                                        },
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
