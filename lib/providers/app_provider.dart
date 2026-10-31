import 'package:flutter/foundation.dart';
import '../models/app_models.dart';
import '../services/api_service.dart';

class AppProvider extends ChangeNotifier {
  final ApiServiceProducts _api = ApiServiceProducts();

  List<Product> _products = [];
  List<String> _categories = [];
  String _selectedCategory = 'Semua';
  bool _isLoading = false;
  String? _errorMessage;

  // Wishlist & Cart Storage
  final List<Product> _wishlist = [];
  final List<CartItem> _cart = [];
  
  // Promo Code State
  String _appliedPromo = '';
  double _discountAmount = 0.0;

  // Getters
  List<Product> get products => _products;
  List<String> get categories => ['Semua', ..._categories];
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Product> get wishlist => _wishlist;
  List<CartItem> get cart => _cart;
  double get discountAmount => _discountAmount;
  String get appliedPromo => _appliedPromo;

  // Init Data Fetching
  Future<void> initData() async {
    _isLoading = true;
    notifyListeners();
    try {
      _products = await _api.getAllProducts();
      _categories = await _api.getCategoryList();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search Products
  Future<void> searchProducts(String query) async {
    if (query.trim().isEmpty) {
      return initData();
    }
    _isLoading = true;
    notifyListeners();
    try {
      _products = await _api.searchProducts(query);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Filter By Category
  Future<void> selectCategory(String category) async {
    _selectedCategory = category;
    _isLoading = true;
    notifyListeners();
    try {
      if (category == 'Semua') {
        _products = await _api.getAllProducts();
      } else {
        _products = await _api.getProductsByCategory(category);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Wishlist Methods
  bool isInWishlist(Product product) {
    return _wishlist.any((p) => p.id == product.id);
  }

  void toggleWishlist(Product product) {
    if (isInWishlist(product)) {
      _wishlist.removeWhere((p) => p.id == product.id);
    } else {
      _wishlist.add(product);
    }
    notifyListeners();
  }

  // Cart Methods
  void addToCart(Product product, {int qty = 1}) {
    int index = _cart.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      _cart[index].quantity += qty;
    } else {
      _cart.add(CartItem(product: product, quantity: qty));
    }
    notifyListeners();
  }

  void updateCartQuantity(int productId, int delta) {
    int index = _cart.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      _cart[index].quantity += delta;
      if (_cart[index].quantity <= 0) {
        _cart.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeFromCart(int productId) {
    _cart.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void addAllWishlistToCart() {
    for (var product in _wishlist) {
      addToCart(product, qty: 1);
    }
    notifyListeners();
  }

  // Calculations
  double get subtotalCart => _cart.fold(0, (sum, item) => sum + item.totalPrice);
  double get grandTotalCart => (subtotalCart - _discountAmount) > 0 ? (subtotalCart - _discountAmount) : 0;

  void applyPromo(String code) {
    if (code.toUpperCase() == 'SMARTDELIGHT') {
      _appliedPromo = code.trim().toUpperCase();;
      _discountAmount = 10.0;
    } else {
      _appliedPromo = '';
      _discountAmount = 0.0;
    }
    notifyListeners();
  }
}
