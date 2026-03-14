// import 'dart:io';
// import 'package:fashion_app/core/constants/app_colors.dart';
// import 'package:fashion_app/core/utils/validators.dart';
// import 'package:fashion_app/models/product_model.dart';
// import 'package:fashion_app/services/product_service.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:uuid/uuid.dart';

// class AddProductScreen extends ConsumerStatefulWidget {
//   final dynamic product;
//   const AddProductScreen({this.product, super.key});

//   @override
//   ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
// }

// class _AddProductScreenState extends ConsumerState<AddProductScreen> {

//   final _formKey         = GlobalKey<FormState>();
//   final _nameCtrl        = TextEditingController();
//   final _descCtrl        = TextEditingController();
//   final _priceCtrl       = TextEditingController();
//   final _comparePriceCtrl= TextEditingController();
//   final _stockCtrl       = TextEditingController();
//   final _tagsCtrl        = TextEditingController();
//   final _imageUrlCtrl    = TextEditingController();

//   final ImagePicker _picker = ImagePicker();

//   String  _category    = 'men';
//   String? _subCategory = 'topwear';
//   String? _gender;
//   String? _ageGroup;
//   int?    _age;         // NEW

//   final List<String> _selectedSizes = [];
//   final List<String> _imageUrls     = [];
//   final List<File>   _pickedImages  = [];

//   bool _isFeatured = false;
//   bool _isActive   = true;
//   bool _saving     = false;

//   final _categories    = ['men', 'women', 'kids', 'ethnic'];
//   final _subCategories = [null, 'topwear', 'bottomwear', 'footwear', 'accessories', 'ethnic', 'sports'];
//   final _sizes         = ['XS','S','M','L','XL','XXL','3XL','Free Size'];
//   final _genders       = ['boy', 'girl'];

//   final _ageGroups = [
//     '0-3 Months',
//     '4-6 Months',
//     '7-9 Months',
//     '10-12 Months',
//     '1-2 Years',
//     '3-5 Years',
//     '6-8 Years',
//     '9-11 Years',
//     '12-14 Years',
//   ];

//   // Returns age list for selected age group, null = no age field needed
//   List<int>? get _ageOptions {
//     switch (_ageGroup) {
//       case '1-2 Years':  return [1,2];
//       case '3-5 Years':  return [3, 4, 5];
//       case '6-8 Years':  return [6, 7, 8];
//       case '9-11 Years':  return [9, 10, 11];
//       case '12-14 Years': return [12, 13, 14];
//       default:           return null; // 0-6M and 6-24M → no age
//     }
//   }

//   void _addImageUrl() {
//     final url = _imageUrlCtrl.text.trim();
//     if (url.isEmpty) return;
//     setState(() { _imageUrls.add(url); _imageUrlCtrl.clear(); });
//   }

//   Future<void> _pickImage() async {
//     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//     if (image == null) return;
//     setState(() => _pickedImages.add(File(image.path)));
//   }

//   Future<void> _save() async {
//     if (!_formKey.currentState!.validate()) return;

//     if (_imageUrls.isEmpty && _pickedImages.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Add at least one image'), backgroundColor: AppColors.error),
//       );
//       return;
//     }

//     if (_category == 'kids') {
//       if (_gender == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please select gender'), backgroundColor: AppColors.error),
//         );
//         return;
//       }
//       if (_ageGroup == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please select age group'), backgroundColor: AppColors.error),
//         );
//         return;
//       }
//       if (_ageOptions != null && _age == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please select age'), backgroundColor: AppColors.error),
//         );
//         return;
//       }
//     }

//     setState(() => _saving = true);

//     try {
//       final productId = const Uuid().v4();
//       final stock     = int.parse(_stockCtrl.text);
//       final tags      = _tagsCtrl.text
//           .split(',')
//           .map((t) => t.trim().toLowerCase())
//           .where((t) => t.isNotEmpty)
//           .toList();

//       final product = ProductModel(
//         productId:    productId,
//         name:         _nameCtrl.text.trim(),
//         description:  _descCtrl.text.trim(),
//         price:        double.parse(_priceCtrl.text),
//         comparePrice: _comparePriceCtrl.text.isNotEmpty
//             ? double.tryParse(_comparePriceCtrl.text)
//             : null,
//         category:    _category,
//         subCategory: _subCategory ?? '',
//         gender:      _category == 'kids' ? _gender   : null,
//         ageGroup:    _category == 'kids' ? _ageGroup : null,
//         age:         _category == 'kids' ? _age      : null,  // NEW
//         tags:        tags,
//         imageUrls:   _imageUrls,
//         sizes:       _selectedSizes,
//         stock:       stock,
//         inStock:     stock > 0,
//         stockStatus: ProductModel.deriveStockStatus(stock),
//         isFeatured:  _isFeatured,
//         isActive:    _isActive,
//       );

//       await ProductService().addProduct(product);

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Product added!'), backgroundColor: AppColors.success),
//         );
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       setState(() => _saving = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Add Product')),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [

//               TextFormField(
//                 controller: _nameCtrl,
//                 validator: (v) => Validators.required(v, 'Product name'),
//                 decoration: const InputDecoration(labelText: 'Product Name'),
//               ),
//               const SizedBox(height: 12),

//               TextFormField(
//                 controller: _descCtrl,
//                 validator: (v) => Validators.required(v, 'Description'),
//                 decoration: const InputDecoration(labelText: 'Description'),
//                 maxLines: 3,
//               ),
//               const SizedBox(height: 12),

//               TextFormField(
//                 controller: _priceCtrl,
//                 keyboardType: TextInputType.number,
//                 validator: Validators.price,
//                 decoration: const InputDecoration(labelText: 'Price (₹)'),
//               ),
//               const SizedBox(height: 12),

//               TextFormField(
//                 controller: _stockCtrl,
//                 keyboardType: TextInputType.number,
//                 validator: Validators.stock,
//                 decoration: const InputDecoration(labelText: 'Stock Quantity'),
//               ),
//               const SizedBox(height: 16),

//               // Images
//               const Text("Product Images", style: TextStyle(fontWeight: FontWeight.w600)),
//               const SizedBox(height: 10),
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _imageUrlCtrl,
//                       decoration: const InputDecoration(labelText: 'Paste Image URL'),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   IconButton(icon: const Icon(Icons.add), onPressed: _addImageUrl),
//                   IconButton(icon: const Icon(Icons.photo_library), onPressed: _pickImage),
//                 ],
//               ),
//               const SizedBox(height: 10),

//               if (_imageUrls.isNotEmpty || _pickedImages.isNotEmpty)
//                 SizedBox(
//                   height: 100,
//                   child: ListView(
//                     scrollDirection: Axis.horizontal,
//                     children: [
//                       ..._imageUrls.map((url) => _imageThumb(NetworkImage(url))),
//                       ..._pickedImages.map((img) => _imageThumb(FileImage(img))),
//                     ],
//                   ),
//                 ),

//               const SizedBox(height: 16),

//               // Category
//               Row(
//                 children: [
//                   Expanded(
//                     child: DropdownButtonFormField<String>(
//                       value: _category,
//                       decoration: const InputDecoration(labelText: 'Category'),
//                       items: _categories.map((c) => DropdownMenuItem(
//                         value: c, child: Text(c.toUpperCase()),
//                       )).toList(),
//                       onChanged: (v) => setState(() {
//                         _category = v!;
//                         _gender   = null;
//                         _ageGroup = null;
//                         _age      = null;
//                       }),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: DropdownButtonFormField<String?>(
//                       value: _subCategory,
//                       decoration: const InputDecoration(labelText: 'SubCategory'),
//                       items: _subCategories.map((c) => DropdownMenuItem(
//                         value: c, child: Text(c ?? 'None'),
//                       )).toList(),
//                       onChanged: (v) => setState(() => _subCategory = v),
//                     ),
//                   ),
//                 ],
//               ),

//               // Kids fields
//               if (_category == 'kids') ...[
//                 const SizedBox(height: 16),

//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFE6F7ED),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: const Row(
//                     children: [
//                       Icon(Icons.child_care, color: Color(0xFF0F6C5C)),
//                       SizedBox(width: 8),
//                       Text("Kids Details",
//                           style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF0F6C5C))),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 12),

//                 // Gender
//                 DropdownButtonFormField<String>(
//                   value: _gender,
//                   decoration: const InputDecoration(
//                     labelText: 'Gender',
//                     prefixIcon: Icon(Icons.wc_outlined),
//                   ),
//                   items: _genders.map((g) => DropdownMenuItem(
//                     value: g,
//                     child: Row(
//                       children: [
//                         Icon(
//                           g == 'boy' ? Icons.male : Icons.female,
//                           size: 18,
//                           color: g == 'boy' ? Colors.blue : Colors.pink,
//                         ),
//                         const SizedBox(width: 8),
//                         Text(g[0].toUpperCase() + g.substring(1)),
//                       ],
//                     ),
//                   )).toList(),
//                   onChanged: (v) => setState(() => _gender = v),
//                 ),

//                 const SizedBox(height: 12),

//                 // Age Group
//                 DropdownButtonFormField<String>(
//                   value: _ageGroup,
//                   decoration: const InputDecoration(
//                     labelText: 'Age Group',
//                     prefixIcon: Icon(Icons.cake_outlined),
//                   ),
//                   items: _ageGroups.map((a) => DropdownMenuItem(
//                     value: a, child: Text(a),
//                   )).toList(),
//                   onChanged: (v) => setState(() {
//                     _ageGroup = v;
//                     _age      = null; // reset age when group changes
//                   }),
//                 ),

//                 // Age — only shown for 2Y+ groups
//                 if (_ageGroup != null && _ageOptions != null) ...[
//                   const SizedBox(height: 12),
//                   DropdownButtonFormField<int>(
//                     value: _age,
//                     decoration: const InputDecoration(
//                       labelText: 'Age (Years)',
//                       prefixIcon: Icon(Icons.numbers_outlined),
//                     ),
//                     items: _ageOptions!.map((a) => DropdownMenuItem(
//                       value: a,
//                       child: Text('$a Years'),
//                     )).toList(),
//                     onChanged: (v) => setState(() => _age = v),
//                   ),
//                 ],
//               ],

//               const SizedBox(height: 24),

//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: _saving ? null : _save,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF0F6C5C),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   ),
//                   child: _saving
//                       ? const SizedBox(
//                           height: 22, width: 22,
//                           child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
//                       : const Text('Add Product',
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//                 ),
//               ),
//               const SizedBox(height: 32),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _imageThumb(ImageProvider image) {
//     return Container(
//       width: 90,
//       margin: const EdgeInsets.only(right: 8),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         image: DecorationImage(image: image, fit: BoxFit.cover),
//       ),
//     );
//   }
// }









import 'dart:io';
import 'package:fashion_app/core/constants/app_colors.dart';
import 'package:fashion_app/core/utils/validators.dart';
import 'package:fashion_app/models/product_model.dart';
import 'package:fashion_app/services/product_service.dart';
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
  'ethnic': [
    // Women ethnic
    'Saree', 'Chudidar', 'Ghagra Set', 'Sharara Set',
    // Men ethnic
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
  String? _gender;       // for kids AND ethnic
  String? _ageGroup;
  int?    _age;

  final List<String> _imageUrls    = [];
  final List<File>   _pickedImages = [];

  bool _isFeatured = false;
  bool _isActive   = true;
  bool _saving     = false;

  final _categories = ['men', 'women', 'kids', 'ethnic'];
  final _sizes      = ['XS','S','M','L','XL','XXL','3XL','Free Size'];
  final _genders    = ['boy', 'girl'];
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

  List<String> get _currentSubCategories => kSubCategories[_category] ?? [];

  void _addImageUrl() {
    final url = _imageUrlCtrl.text.trim();
    if (url.isEmpty) return;
    setState(() { _imageUrls.add(url); _imageUrlCtrl.clear(); });
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() => _pickedImages.add(File(image.path)));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (_imageUrls.isEmpty && _pickedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one image'), backgroundColor: AppColors.error),
      );
      return;
    }

    if (_category == 'kids') {
      if (_gender == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select gender'), backgroundColor: AppColors.error),
        );
        return;
      }
      if (_ageGroup == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select age group'), backgroundColor: AppColors.error),
        );
        return;
      }
      if (_ageOptions != null && _age == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select age'), backgroundColor: AppColors.error),
        );
        return;
      }
    }

    if (_category == 'ethnic' && _gender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select Men or Women for Ethnic'), backgroundColor: AppColors.error),
      );
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
          const SnackBar(content: Text('Product added!'), backgroundColor: AppColors.success),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error),
      );
    }
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

              // ── Basic Info ──────────────────────────────
              TextFormField(
                controller: _nameCtrl,
                validator: (v) => Validators.required(v, 'Product name'),
                decoration: const InputDecoration(labelText: 'Product Name'),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _descCtrl,
                validator: (v) => Validators.required(v, 'Description'),
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceCtrl,
                      keyboardType: TextInputType.number,
                      validator: Validators.price,
                      decoration: const InputDecoration(labelText: 'Price (₹)'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _comparePriceCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Compare Price (₹)'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _stockCtrl,
                keyboardType: TextInputType.number,
                validator: Validators.stock,
                decoration: const InputDecoration(labelText: 'Stock Quantity'),
              ),
              const SizedBox(height: 16),

              // ── Images ──────────────────────────────────
              const Text("Product Images", style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _imageUrlCtrl,
                      decoration: const InputDecoration(labelText: 'Paste Image URL'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(icon: const Icon(Icons.add), onPressed: _addImageUrl),
                  IconButton(icon: const Icon(Icons.photo_library), onPressed: _pickImage),
                ],
              ),
              const SizedBox(height: 10),

              if (_imageUrls.isNotEmpty || _pickedImages.isNotEmpty)
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

              const SizedBox(height: 16),

              // ── Category ────────────────────────────────
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(labelText: 'Category'),
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

              // ── SubCategory (dynamic per category) ──────
              DropdownButtonFormField<String>(
                value: _subCategory,
                decoration: const InputDecoration(labelText: 'Sub Category'),
                items: _currentSubCategories.map((c) => DropdownMenuItem(
                  value: c, child: Text(c),
                )).toList(),
                onChanged: (v) => setState(() => _subCategory = v),
              ),

              // ── Ethnic gender ────────────────────────────
              if (_category == 'ethnic') ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.diamond_outlined, color: Color(0xFFFFA000)),
                      SizedBox(width: 8),
                      Text("Ethnic Type",
                          style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFFFA000))),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _gender,
                  decoration: const InputDecoration(
                    labelText: 'Men / Women Ethnic',
                    prefixIcon: Icon(Icons.wc_outlined),
                  ),
                  items: _ethnicGenders.map((g) => DropdownMenuItem(
                    value: g,
                    child: Text(g.toUpperCase()),
                  )).toList(),
                  onChanged: (v) => setState(() {
                    _gender      = v;
                    _subCategory = null; // reset subcategory when gender changes
                  }),
                ),
              ],

              // ── Kids fields ──────────────────────────────
              if (_category == 'kids') ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F7ED),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.child_care, color: Color(0xFF0F6C5C)),
                      SizedBox(width: 8),
                      Text("Kids Details",
                          style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF0F6C5C))),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

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
                        Icon(g == 'boy' ? Icons.male : Icons.female,
                            size: 18, color: g == 'boy' ? Colors.blue : Colors.pink),
                        const SizedBox(width: 8),
                        Text(g[0].toUpperCase() + g.substring(1)),
                      ],
                    ),
                  )).toList(),
                  onChanged: (v) => setState(() => _gender = v),
                ),
                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  value: _ageGroup,
                  decoration: const InputDecoration(
                    labelText: 'Age Group',
                    prefixIcon: Icon(Icons.cake_outlined),
                  ),
                  items: _ageGroups.map((a) => DropdownMenuItem(
                    value: a, child: Text(a),
                  )).toList(),
                  onChanged: (v) => setState(() { _ageGroup = v; _age = null; }),
                ),

                if (_ageGroup != null && _ageOptions != null) ...[
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    value: _age,
                    decoration: const InputDecoration(
                      labelText: 'Age (Years)',
                      prefixIcon: Icon(Icons.numbers_outlined),
                    ),
                    items: _ageOptions!.map((a) => DropdownMenuItem(
                      value: a, child: Text('$a Years'),
                    )).toList(),
                    onChanged: (v) => setState(() => _age = v),
                  ),
                ],
              ],

              const SizedBox(height: 16),

              // ── Featured / Active ────────────────────────
              Row(
                children: [
                  Expanded(
                    child: SwitchListTile(
                      title: const Text('Featured'),
                      value: _isFeatured,
                      activeColor: const Color(0xFF0F6C5C),
                      onChanged: (v) => setState(() => _isFeatured = v),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  Expanded(
                    child: SwitchListTile(
                      title: const Text('Active'),
                      value: _isActive,
                      activeColor: const Color(0xFF0F6C5C),
                      onChanged: (v) => setState(() => _isActive = v),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ── Save ─────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F6C5C),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _saving
                      ? const SizedBox(
                          height: 22, width: 22,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Add Product',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
      ),
    );
  }
}