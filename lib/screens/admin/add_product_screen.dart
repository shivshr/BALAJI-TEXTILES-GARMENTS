import 'dart:io';
import 'package:balaji_textile_and_garments/core/constants/app_colors.dart';
import 'package:balaji_textile_and_garments/core/utils/validators.dart';
import 'package:balaji_textile_and_garments/models/product_model.dart';
import 'package:balaji_textile_and_garments/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

// ── Subcategories per category ─────────────────────────────
const Map<String, List<String>> kSubCategories = {
  'men': [
    'Casual Shirt', 'Formal Shirt', 'T-Shirt', 'Jeans', 'Formal Pant',
    'Pant Shirt Fabric Gift Set', 'Night Pant', 'Shirts', 'Underwear',
    'Vest / Sandow', 'Lungi / Loungy', 'Dhoti / Panchha', 'Towel',
  ],
  'women': [
    'Saree', 'Chudidar', 'Long Gown', 'Ghagra Set', 'Sharara Set',
    'Jeans Top', 'Kurtis', 'Leggings', 'Plazo Pant', 'Skirt',
    'Patiala Pants', 'Saree Petticoat', 'Blouse', 'Nighty / Night Suit',
    'Dupatta / Stole', 'Bra / Panties / Slips / Tights',
  ],
  'kids': [
    'Top Wear', 'Bottom Wear', 'Ethnic', 'Casual', 'Footwear', 'Accessories',
  ],
  'ethnic_women': [
    'Saree', 'Chudidar', 'Ghagra Set', 'Sharara Set',
  ],
  'ethnic_men': [
    'Kurta Pajama Set', 'Casual Kurta', 'Ramraj Dhoti Set',
  ],
};

class AddProductScreen extends ConsumerStatefulWidget {
  final dynamic product;
  const AddProductScreen({this.product, super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {

  final _formKey          = GlobalKey<FormState>();
  final _nameCtrl         = TextEditingController();
  final _descCtrl         = TextEditingController();
  final _priceCtrl        = TextEditingController();
  final _comparePriceCtrl = TextEditingController();
  final _stockCtrl        = TextEditingController();
  final _tagsCtrl         = TextEditingController();
  final _imageUrlCtrl     = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  String  _category    = 'men';
  String? _subCategory;
  String? _gender;
  String? _ageGroup;
  int?    _age;

  final List<String> _imageUrls    = [];
  final List<File>   _pickedImages = [];

  bool _isFeatured = false;
  bool _isActive   = true;
  bool _saving     = false;

  final _categories    = ['men', 'women', 'kids', 'ethnic'];
  final _genders       = ['boy', 'girl'];
  final _ethnicGenders = ['men', 'women'];

  final _ageGroups = [
    '0-3 Months', '4-6 Months', '7-9 Months', '10-12 Months',
    '1-2 Years', '3-5 Years', '6-8 Years', '9-11 Years', '12-14 Years',
  ];

  List<int>? get _ageOptions {
    switch (_ageGroup) {
      case '1-2 Years':   return [1, 2];
      case '3-5 Years':   return [3, 4, 5];
      case '6-8 Years':   return [6, 7, 8];
      case '9-11 Years':  return [9, 10, 11];
      case '12-14 Years': return [12, 13, 14];
      default:            return null;
    }
  }

  // Ethnic ke liye gender-based subcategories, baaki normal
  List<String> get _currentSubCategories {
    if (_category == 'ethnic') {
      if (_gender == null) return [];
      return kSubCategories['ethnic_$_gender'] ?? [];
    }
    return kSubCategories[_category] ?? [];
  }

  void _addImageUrl() {
    final url = _imageUrlCtrl.text.trim();
    if (url.isEmpty) return;
    setState(() {
      _imageUrls.add(url);
      _imageUrlCtrl.clear();
    });
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() => _pickedImages.add(File(image.path)));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (_imageUrls.isEmpty && _pickedImages.isEmpty) {
      _showError('Add at least one image');
      return;
    }

    if (_category == 'kids') {
      if (_gender == null) { _showError('Please select gender'); return; }
      if (_ageGroup == null) { _showError('Please select age group'); return; }
      if (_ageOptions != null && _age == null) { _showError('Please select age'); return; }
    }

    if (_category == 'ethnic' && _gender == null) {
      _showError('Please select Men or Women for Ethnic');
      return;
    }

    setState(() => _saving = true);

    try {
      final productId = const Uuid().v4();
      final stock     = int.parse(_stockCtrl.text);
      final tags      = _tagsCtrl.text
          .split(',')
          .map((t) => t.trim().toLowerCase())
          .where((t) => t.isNotEmpty)
          .toList();

      final product = ProductModel(
        productId:    productId,
        name:         _nameCtrl.text.trim(),
        description:  _descCtrl.text.trim(),
        price:        double.parse(_priceCtrl.text),
        comparePrice: _comparePriceCtrl.text.isNotEmpty
            ? double.tryParse(_comparePriceCtrl.text)
            : null,
        category:    _category,
        subCategory: _subCategory ?? '',
        gender:      (_category == 'kids' || _category == 'ethnic') ? _gender : null,
        ageGroup:    _category == 'kids' ? _ageGroup : null,
        age:         _category == 'kids' ? _age      : null,
        tags:        tags,
        imageUrls:   _imageUrls,
        sizes:       [],
        stock:       stock,
        inStock:     stock > 0,
        stockStatus: ProductModel.deriveStockStatus(stock),
        isFeatured:  _isFeatured,
        isActive:    _isActive,
      );

      await ProductService().addProduct(product);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product added!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() => _saving = false);
      _showError('Error: $e');
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppColors.error),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _comparePriceCtrl.dispose();
    _stockCtrl.dispose();
    _tagsCtrl.dispose();
    _imageUrlCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Product Name ─────────────────────────────
              TextFormField(
                controller: _nameCtrl,
                validator: (v) => Validators.required(v, 'Product name'),
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  prefixIcon: Icon(Icons.shopping_bag_outlined),
                ),
              ),
              const SizedBox(height: 12),

              // ── Description ──────────────────────────────
              TextFormField(
                controller: _descCtrl,
                validator: (v) => Validators.required(v, 'Description'),
                decoration: const InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.description_outlined),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),

              // ── Price Row ────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceCtrl,
                      keyboardType: TextInputType.number,
                      validator: Validators.price,
                      decoration: const InputDecoration(
                        labelText: 'Price (₹)',
                        prefixIcon: Icon(Icons.currency_rupee),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _comparePriceCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Compare Price (₹)',
                        prefixIcon: Icon(Icons.currency_rupee),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ── Stock ────────────────────────────────────
              TextFormField(
                controller: _stockCtrl,
                keyboardType: TextInputType.number,
                validator: Validators.stock,
                decoration: const InputDecoration(
                  labelText: 'Stock Quantity',
                  prefixIcon: Icon(Icons.inventory_2_outlined),
                ),
              ),
              const SizedBox(height: 12),

              // ── Tags ─────────────────────────────────────
              TextFormField(
                controller: _tagsCtrl,
                decoration: const InputDecoration(
                  labelText: 'Tags (comma separated)',
                  prefixIcon: Icon(Icons.label_outline),
                  hintText: 'e.g. cotton, casual, summer',
                ),
              ),
              const SizedBox(height: 20),

              // ── Images ───────────────────────────────────
              const Text(
                'Product Images',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _imageUrlCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Paste Image URL',
                        prefixIcon: Icon(Icons.link),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    color: const Color(0xFF0F6C5C),
                    onPressed: _addImageUrl,
                    tooltip: 'Add URL',
                  ),
                  IconButton(
                    icon: const Icon(Icons.photo_library_outlined),
                    color: const Color(0xFF0F6C5C),
                    onPressed: _pickImage,
                    tooltip: 'Pick from Gallery',
                  ),
                ],
              ),
              const SizedBox(height: 10),

              if (_imageUrls.isNotEmpty || _pickedImages.isNotEmpty) ...[
                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ..._imageUrls.map((url) => _imageThumb(NetworkImage(url))),
                      ..._pickedImages.map((img) => _imageThumb(FileImage(img))),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],

              const SizedBox(height: 6),

              // ── Category ─────────────────────────────────
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: _categories.map((c) => DropdownMenuItem(
                  value: c,
                  child: Text(c.toUpperCase()),
                )).toList(),
                onChanged: (v) => setState(() {
                  _category    = v!;
                  _subCategory = null;
                  _gender      = null;
                  _ageGroup    = null;
                  _age         = null;
                }),
              ),
              const SizedBox(height: 12),

              // ── ETHNIC SECTION ───────────────────────────
              if (_category == 'ethnic') ...[
                // Header banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFFFE082)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.diamond_outlined, color: Color(0xFFFFA000)),
                      SizedBox(width: 8),
                      Text(
                        'Ethnic — Select type first',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFFA000),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // STEP 1 — Men / Women
                DropdownButtonFormField<String>(
                  value: _gender,
                  decoration: const InputDecoration(
                    labelText: 'Step 1 — Men or Women?',
                    prefixIcon: Icon(Icons.wc_outlined),
                  ),
                  items: _ethnicGenders.map((g) => DropdownMenuItem(
                    value: g,
                    child: Row(
                      children: [
                        Icon(
                          g == 'men' ? Icons.male : Icons.female,
                          size: 18,
                          color: g == 'men' ? Colors.blue : Colors.pink,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          g == 'men' ? 'Men Ethnic' : 'Women Ethnic',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )).toList(),
                  onChanged: (v) => setState(() {
                    _gender      = v;
                    _subCategory = null;
                  }),
                ),

                // STEP 2 — SubCategory (only after gender selected)
                if (_gender != null) ...[
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _subCategory,
                    decoration: InputDecoration(
                      labelText: 'Step 2 — ${_gender == 'men' ? 'Men' : 'Women'} Ethnic Sub Category',
                      prefixIcon: const Icon(Icons.style_outlined),
                    ),
                    items: _currentSubCategories.map((c) => DropdownMenuItem(
                      value: c,
                      child: Text(c),
                    )).toList(),
                    onChanged: (v) => setState(() => _subCategory = v),
                  ),
                ],

                const SizedBox(height: 12),
              ],

              // ── SubCategory (non-ethnic categories) ──────
              if (_category != 'ethnic') ...[
                DropdownButtonFormField<String>(
                  value: _subCategory,
                  decoration: const InputDecoration(
                    labelText: 'Sub Category',
                    prefixIcon: Icon(Icons.style_outlined),
                  ),
                  items: _currentSubCategories.map((c) => DropdownMenuItem(
                    value: c,
                    child: Text(c),
                  )).toList(),
                  onChanged: (v) => setState(() => _subCategory = v),
                ),
                const SizedBox(height: 12),
              ],

              // ── KIDS SECTION ─────────────────────────────
              if (_category == 'kids') ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F7ED),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFA5D6A7)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.child_care, color: Color(0xFF0F6C5C)),
                      SizedBox(width: 8),
                      Text(
                        'Kids Details',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F6C5C),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Gender
                DropdownButtonFormField<String>(
                  value: _gender,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    prefixIcon: Icon(Icons.wc_outlined),
                  ),
                  items: _genders.map((g) => DropdownMenuItem(
                    value: g,
                    child: Row(
                      children: [
                        Icon(
                          g == 'boy' ? Icons.male : Icons.female,
                          size: 18,
                          color: g == 'boy' ? Colors.blue : Colors.pink,
                        ),
                        const SizedBox(width: 8),
                        Text(g[0].toUpperCase() + g.substring(1)),
                      ],
                    ),
                  )).toList(),
                  onChanged: (v) => setState(() => _gender = v),
                ),
                const SizedBox(height: 12),

                // Age Group
                DropdownButtonFormField<String>(
                  value: _ageGroup,
                  decoration: const InputDecoration(
                    labelText: 'Age Group',
                    prefixIcon: Icon(Icons.cake_outlined),
                  ),
                  items: _ageGroups.map((a) => DropdownMenuItem(
                    value: a,
                    child: Text(a),
                  )).toList(),
                  onChanged: (v) => setState(() {
                    _ageGroup = v;
                    _age      = null;
                  }),
                ),

                // Specific Age (only for 1Y+ groups)
                if (_ageGroup != null && _ageOptions != null) ...[
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    value: _age,
                    decoration: const InputDecoration(
                      labelText: 'Age (Years)',
                      prefixIcon: Icon(Icons.numbers_outlined),
                    ),
                    items: _ageOptions!.map((a) => DropdownMenuItem(
                      value: a,
                      child: Text('$a Years'),
                    )).toList(),
                    onChanged: (v) => setState(() => _age = v),
                  ),
                ],
                const SizedBox(height: 12),
              ],

              // ── Featured / Active Toggles ─────────────────
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SwitchListTile(
                        title: const Text(
                          'Featured',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        subtitle: const Text(
                          'Show on home',
                          style: TextStyle(fontSize: 11),
                        ),
                        value: _isFeatured,
                        activeColor: const Color(0xFF0F6C5C),
                        onChanged: (v) => setState(() => _isFeatured = v),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 56,
                      color: Colors.grey.shade200,
                    ),
                    Expanded(
                      child: SwitchListTile(
                        title: const Text(
                          'Active',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        subtitle: const Text(
                          'Visible in app',
                          style: TextStyle(fontSize: 11),
                        ),
                        value: _isActive,
                        activeColor: const Color(0xFF0F6C5C),
                        onChanged: (v) => setState(() => _isActive = v),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ── Save Button ───────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F6C5C),
                    disabledBackgroundColor: const Color(0xFF0F6C5C).withOpacity(0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _saving
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_outline, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Save Product',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageThumb(ImageProvider image) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(image: image, fit: BoxFit.cover),
        border: Border.all(color: Colors.grey.shade300),
      ),
    );
  }
}