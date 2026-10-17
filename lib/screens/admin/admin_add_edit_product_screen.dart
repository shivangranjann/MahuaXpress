import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../models/product_model.dart';
import '../../providers/app_provider.dart';

class AdminAddEditProductScreen extends StatefulWidget {
  final ProductModel? editingProduct;

  const AdminAddEditProductScreen({super.key, this.editingProduct});

  @override
  State<AdminAddEditProductScreen> createState() => _AdminAddEditProductScreenState();
}

class _AdminAddEditProductScreenState extends State<AdminAddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _unitController;
  late TextEditingController _priceController;
  late TextEditingController _mrpController;
  late TextEditingController _stockController;
  late TextEditingController _imageUrlController;
  late TextEditingController _descController;
  late TextEditingController _subCategoryController;

  String _selectedCategory = 'Dairy, Bread & Eggs';
  bool _isBestseller = false;
  bool _inStock = true;

  final List<Map<String, String>> _sampleImages = [
    {'name': 'Milk Bottle', 'url': 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=500&auto=format&fit=crop&q=80'},
    {'name': 'Fresh Veggies', 'url': 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=500&auto=format&fit=crop&q=80'},
    {'name': 'Potato Chips', 'url': 'https://images.unsplash.com/photo-1566478989037-eec170784d0b?w=500&auto=format&fit=crop&q=80'},
    {'name': 'Soft Drink', 'url': 'https://images.unsplash.com/photo-1622483767028-3f66f32aef97?w=500&auto=format&fit=crop&q=80'},
    {'name': 'Wheat Atta', 'url': 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=500&auto=format&fit=crop&q=80'},
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.editingProduct;
    _nameController = TextEditingController(text: p?.name ?? '');
    _unitController = TextEditingController(text: p?.unit ?? '500 g');
    _priceController = TextEditingController(text: p != null ? p.price.toStringAsFixed(0) : '45');
    _mrpController = TextEditingController(text: p != null ? p.mrp.toStringAsFixed(0) : '50');
    _stockController = TextEditingController(text: p != null ? p.stockQuantity.toString() : '50');
    _imageUrlController = TextEditingController(
      text: p?.imageUrl ?? 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=500&auto=format&fit=crop&q=80',
    );
    _descController = TextEditingController(text: p?.description ?? '');
    _subCategoryController = TextEditingController(text: p?.subCategory ?? 'General');
    _selectedCategory = p?.category ?? 'Dairy, Bread & Eggs';
    _isBestseller = p?.isBestseller ?? false;
    _inStock = p?.inStock ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _unitController.dispose();
    _priceController.dispose();
    _mrpController.dispose();
    _stockController.dispose();
    _imageUrlController.dispose();
    _descController.dispose();
    _subCategoryController.dispose();
    super.dispose();
  }

  void _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final app = Provider.of<AppProvider>(context, listen: false);

    final product = ProductModel(
      id: widget.editingProduct?.id ?? 'prod_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
      category: _selectedCategory,
      subCategory: _subCategoryController.text.trim().isEmpty ? 'General' : _subCategoryController.text.trim(),
      unit: _unitController.text.trim(),
      price: double.tryParse(_priceController.text.trim()) ?? 0.0,
      mrp: double.tryParse(_mrpController.text.trim()) ?? 0.0,
      imageUrl: _imageUrlController.text.trim(),
      description: _descController.text.trim(),
      stockQuantity: int.tryParse(_stockController.text.trim()) ?? 50,
      inStock: _inStock,
      isBestseller: _isBestseller,
      deliveryMinutes: 9,
    );

    await app.updateProduct(product);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.editingProduct != null
                ? 'Product updated successfully!'
                : 'New product added to store catalog!',
          ),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context);
    final isEditing = widget.editingProduct != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        title: Text(
          isEditing ? 'Edit Product' : 'Add New Product',
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
        ),
        actions: [
          TextButton(
            onPressed: _saveProduct,
            child: const Text(
              'SAVE',
              style: TextStyle(color: AppColors.brandYellow, fontWeight: FontWeight.w900, fontSize: 15),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image Preview
              Center(
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      _imageUrlController.text,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image_rounded, size: 40, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Sample Image Presets
              const Text('Quick Pick Product Photo:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _sampleImages.map((s) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ActionChip(
                        label: Text(s['name']!),
                        backgroundColor: AppColors.background,
                        onPressed: () {
                          setState(() {
                            _imageUrlController.text = s['url']!;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'Image CDN URL',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onChanged: (val) => setState(() {}),
                validator: (val) => val == null || val.isEmpty ? 'Image URL is required' : null,
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name (e.g. Amul Taaza Fresh Milk)',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                validator: (val) => val == null || val.isEmpty ? 'Enter product name' : null,
              ),
              const SizedBox(height: 14),

              // Category Selector
              DropdownButtonFormField<String>(
                initialValue: app.categories.any((c) => c.name == _selectedCategory)
                    ? _selectedCategory
                    : app.categories.first.name,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                items: app.categories.map((c) {
                  return DropdownMenuItem(
                    value: c.name,
                    child: Text('${c.iconEmoji} ${c.name}'),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedCategory = val;
                    });
                  }
                },
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _subCategoryController,
                      decoration: const InputDecoration(
                        labelText: 'Sub-Category',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _unitController,
                      decoration: const InputDecoration(
                        labelText: 'Unit / Pack Size (e.g. 500 ml, 1 kg)',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      validator: (val) => val == null || val.isEmpty ? 'Enter unit' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Selling Price (₹)',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      validator: (val) => val == null || val.isEmpty ? 'Enter price' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _mrpController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'MRP (₹)',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      validator: (val) => val == null || val.isEmpty ? 'Enter MRP' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _stockController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Stock Units',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description & Highlights',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),

              // Toggles
              SwitchListTile(
                title: const Text('In Stock & Available for Delivery'),
                subtitle: const Text('Customer can immediately order this item'),
                value: _inStock,
                activeThumbColor: AppColors.brandGreen,
                contentPadding: EdgeInsets.zero,
                onChanged: (val) {
                  setState(() {
                    _inStock = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Mark as Bestseller'),
                subtitle: const Text('Display on Home Screen Bestsellers carousel'),
                value: _isBestseller,
                activeThumbColor: AppColors.brandGreen,
                contentPadding: EdgeInsets.zero,
                onChanged: (val) {
                  setState(() {
                    _isBestseller = val;
                  });
                },
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _saveProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandGreen,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: Text(
                  isEditing ? 'UPDATE PRODUCT' : 'ADD PRODUCT TO STORE',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
