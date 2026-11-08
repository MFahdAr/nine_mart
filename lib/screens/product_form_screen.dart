import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/app_models.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product; // null = tambah, ada isi = edit
  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _price;
  late final TextEditingController _category;
  late final TextEditingController _stock;
  late final TextEditingController _description;
  bool _saving = false;

  bool get _isEdit => widget.product != null;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _title = TextEditingController(text: p?.title ?? '');
    _price = TextEditingController(text: p != null ? '${p.price}' : '');
    _category = TextEditingController(text: p?.category ?? '');
    _stock = TextEditingController(text: p != null ? '${p.stock}' : '');
    _description = TextEditingController(text: p?.description ?? '');
  }

  @override
  void dispose() {
    _title.dispose();
    _price.dispose();
    _category.dispose();
    _stock.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final provider = context.read<AppProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);

    final title = _title.text.trim();
    final price = double.parse(_price.text.trim().replaceAll(',', '.'));
    final category = _category.text.trim();
    final stock = int.parse(_stock.text.trim());
    final description = _description.text.trim();

    final ok = _isEdit
        ? await provider.updateProduct(widget.product!,
            title: title,
            price: price,
            category: category,
            description: description,
            stock: stock)
        : await provider.addProduct(
            title: title,
            price: price,
            category: category,
            description: description,
            stock: stock);

    if (!mounted) return;
    setState(() => _saving = false);

    messenger.showSnackBar(SnackBar(
      content: Text(ok
          ? (_isEdit ? 'Produk berhasil diperbarui' : 'Produk berhasil ditambahkan')
          : 'Gagal menyimpan produk, periksa koneksi'),
    ));
    if (ok) {
      if (_isEdit) {
        router.go('/');
      } else {
        router.pop();
      }
    }
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null;

  InputDecoration _dec(String label) => InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Edit Produk' : 'Tambah Produk')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                  controller: _title, decoration: _dec('Nama produk'), validator: _required),
              const SizedBox(height: 12),
              TextFormField(
                controller: _price,
                decoration: _dec('Harga (USD)'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (_required(v) != null) return 'Wajib diisi';
                  final n = double.tryParse(v!.trim().replaceAll(',', '.'));
                  if (n == null || n <= 0) return 'Masukkan harga yang valid';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                  controller: _category, decoration: _dec('Kategori'), validator: _required),
              const SizedBox(height: 12),
              TextFormField(
                controller: _stock,
                decoration: _dec('Stok'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (_required(v) != null) return 'Wajib diisi';
                  final n = int.tryParse(v!.trim());
                  if (n == null || n < 0) return 'Masukkan stok yang valid';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _description,
                decoration: _dec('Deskripsi'),
                maxLines: 4,
                validator: _required,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deepBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _saving ? null : _submit,
                  child: _saving
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text(_isEdit ? 'Simpan Perubahan' : 'Tambah Produk',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}