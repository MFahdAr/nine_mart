import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/detail_screen.dart';
import '../screens/wishlist_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/product_form_screen.dart';
import '../models/app_models.dart';
import '../theme/app_theme.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => MainNavigationShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/wishlist',
          builder: (context, state) => const WishlistScreen(),
        ),
        GoRoute(
          path: '/cart',
          builder: (context, state) => const CartScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const Scaffold(
            body: Center(child: Text("Halaman Profil Pengguna", style: TextStyle(fontSize: 18))),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/detail',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final product = state.extra as Product;
        return DetailScreen(product: product);
      },
    ),    GoRoute(
      path: '/product-form',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) =>
          ProductFormScreen(product: state.extra as Product?),
    ),
  ],
); 


class MainNavigationShell extends StatelessWidget {
  final Widget child;
  const MainNavigationShell({Key? key, required this.child}) : super(key: key);

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/wishlist')) return 1;
    if (location.startsWith('/cart')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: AppColors.deepBlue,
        unselectedItemColor: AppColors.greyText,
        backgroundColor: AppColors.creamBackground,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/wishlist');
              break;
            case 2:
              context.go('/cart');
              break;
            case 3:
              context.go('/profile');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Wishlist'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'Keranjang'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
        ],
      ),
    );
  }
}
