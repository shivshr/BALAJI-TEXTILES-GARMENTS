// import 'package:fashion_app/core/constants/app_colors.dart';
// import 'package:fashion_app/core/utils/validators.dart';
// import 'package:fashion_app/models/product_model.dart';
// import 'package:fashion_app/services/product_service.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:uuid/uuid.dart';

// class AddProductScreen extends ConsumerStatefulWidget {
//   final dynamic product;
//   const AddProductScreen({this.product, super.key});

//   @override
//   ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
// }

// class _AddProductScreenState extends ConsumerState<AddProductScreen> {

//   final _formKey = GlobalKey<FormState>();

//   final _nameCtrl = TextEditingController();
//   final _descCtrl = TextEditingController();
//   final _priceCtrl = TextEditingController();
//   final _comparePriceCtrl = TextEditingController();
//   final _stockCtrl = TextEditingController();
//   final _tagsCtrl = TextEditingController();
//   final _imageUrlCtrl = TextEditingController();

//   String _category = 'men';
//   String? _subCategory = 'topwear';

//   String? _gender;
//   String? _ageGroup;

//   final List<String> _selectedSizes = [];
//   final List<String> _imageUrls = [];

//   bool _isFeatured = false;
//   bool _isActive = true;
//   bool _saving = false;

//   bool get _isEditing => widget.product != null;
//   ProductModel? get _product => widget.product as ProductModel?;

//   final _categories = ['men','women','kids','ethnic'];

//   final _subCategories = [
//     null,
//     'topwear',
//     'bottomwear',
//     'footwear',
//     'accessories',
//     'ethnic',
//     'sports'
//   ];

//   final _sizes = ['XS','S','M','L','XL','XXL','3XL','Free Size'];

//   final _genders = ['boy','girl'];

//   final _ageGroups = [
//     '0-3M','3-6M','6-12M','1-2Y','2-3Y','3-4Y','4-5Y','5-6Y'
//   ];

//   void _addImageUrl() {

//     final url = _imageUrlCtrl.text.trim();

//     if (url.isEmpty) return;

//     if (!url.startsWith('http')) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please enter a valid image URL'),
//           backgroundColor: AppColors.error,
//         ),
//       );
//       return;
//     }

//     setState(() {
//       _imageUrls.add(url);
//       _imageUrlCtrl.clear();
//     });
//   }

//   Future<void> _save() async {

//     if (!_formKey.currentState!.validate()) return;

//     if (_imageUrls.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Add at least one image'),
//           backgroundColor: AppColors.error,
//         ),
//       );
//       return;
//     }

//     setState(()=>_saving=true);

//     try {

//       final productId =
//           _isEditing ? _product!.productId : const Uuid().v4();

//       final stock = int.parse(_stockCtrl.text);

//       final tags = _tagsCtrl.text
//           .split(',')
//           .map((t)=>t.trim().toLowerCase())
//           .where((t)=>t.isNotEmpty)
//           .toList();

//       tags.addAll(_nameCtrl.text.toLowerCase().split(' '));

//       final product = ProductModel(

//         productId: productId,
//         name: _nameCtrl.text.trim(),
//         description: _descCtrl.text.trim(),

//         price: double.parse(_priceCtrl.text),
//         comparePrice: _comparePriceCtrl.text.isNotEmpty
//             ? double.tryParse(_comparePriceCtrl.text)
//             : null,

//         category: _category,
//         subCategory: _subCategory ?? '',

//         gender: _category == 'kids' ? _gender : null,
//         ageGroup: _category == 'kids' ? _ageGroup : null,

//         tags: tags.toSet().toList(),
//         imageUrls: _imageUrls,

//         sizes: _selectedSizes,

//         stock: stock,
//         inStock: stock > 0,
//         stockStatus: ProductModel.deriveStockStatus(stock),

//         isFeatured: _isFeatured,
//         isActive: _isActive,
//       );

//       final service = ProductService();

//       if (_isEditing) {
//         await service.updateProduct(productId, product.toMap());
//       } else {
//         await service.addProduct(product);
//       }

//       if (mounted) {

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(_isEditing ? 'Product updated!' : 'Product added!'),
//             backgroundColor: AppColors.success,
//           ),
//         );

//         Navigator.pop(context);
//       }

//     } catch (e) {

//       setState(()=>_saving=false);

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error: $e'),
//           backgroundColor: AppColors.error,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(

//       appBar: AppBar(
//         title: Text(_isEditing ? 'Edit Product' : 'Add Product'),
//       ),

//       body: SingleChildScrollView(

//         padding: const EdgeInsets.all(16),

//         child: Form(

//           key: _formKey,

//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,

//             children: [

//               TextFormField(
//                 controller:_nameCtrl,
//                 validator:(v)=>Validators.required(v,'Product name'),
//                 decoration: const InputDecoration(labelText:'Product Name'),
//               ),

//               const SizedBox(height:12),

//               TextFormField(
//                 controller:_descCtrl,
//                 validator:(v)=>Validators.required(v,'Description'),
//                 decoration: const InputDecoration(labelText:'Description'),
//                 maxLines:3,
//               ),

//               const SizedBox(height:12),

//               TextFormField(
//                 controller:_stockCtrl,
//                 keyboardType:TextInputType.number,
//                 validator:Validators.stock,
//                 decoration: const InputDecoration(
//                   labelText:'Stock Quantity',
//                 ),
//               ),

//               const SizedBox(height:16),

//               /// IMAGE URL INPUT
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _imageUrlCtrl,
//                       decoration: InputDecoration(
//                         hintText: "Paste image URL",
//                         labelText: "Image URL",
//                         prefixIcon: const Icon(Icons.link),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       onSubmitted: (_) => _addImageUrl(),
//                     ),
//                   ),
//                   const SizedBox(width:8),
//                   ElevatedButton(
//                     onPressed: _addImageUrl,
//                     child: const Icon(Icons.add),
//                   )
//                 ],
//               ),

//               const SizedBox(height:12),

//               if (_imageUrls.isNotEmpty)
//                 SizedBox(
//                   height:100,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: _imageUrls.length,
//                     itemBuilder:(context,index){
//                       return Stack(
//                         children:[
//                           Container(
//                             width:90,
//                             margin:const EdgeInsets.only(right:8),
//                             decoration:BoxDecoration(
//                               borderRadius:BorderRadius.circular(10),
//                               image:DecorationImage(
//                                 image:NetworkImage(_imageUrls[index]),
//                                 fit:BoxFit.cover,
//                               ),
//                             ),
//                           ),

//                           Positioned(
//                             top:2,
//                             right:10,
//                             child:GestureDetector(
//                               onTap:(){
//                                 setState(() {
//                                   _imageUrls.removeAt(index);
//                                 });
//                               },
//                               child:const CircleAvatar(
//                                 radius:10,
//                                 backgroundColor:Colors.red,
//                                 child:Icon(Icons.close,size:12,color:Colors.white),
//                               ),
//                             ),
//                           )
//                         ],
//                       );
//                     },
//                   ),
//                 ),

//               const SizedBox(height:16),

//               Row(
//                 children:[

//                   Expanded(
//                     child:DropdownButtonFormField<String>(
//                       value:_category,
//                       decoration: const InputDecoration(labelText:'Category'),
//                       items:_categories.map((c)=>DropdownMenuItem(
//                         value:c,
//                         child:Text(c.toUpperCase()),
//                       )).toList(),
//                       onChanged:(v){
//                         setState((){

//                           _category=v!;

//                           if(_category!='kids'){
//                             _gender=null;
//                             _ageGroup=null;
//                           }

//                         });
//                       },
//                     ),
//                   ),

//                   const SizedBox(width:12),

//                   Expanded(
//                     child:DropdownButtonFormField<String?>(
//                       value:_subCategory,
//                       decoration: const InputDecoration(labelText:'Sub-Category'),
//                       items:_subCategories.map((c){
//                         return DropdownMenuItem(
//                           value:c,
//                           child:Text(c==null?'None':c.capitalize),
//                         );
//                       }).toList(),
//                       onChanged:(v)=>setState(()=>_subCategory=v),
//                     ),
//                   ),
//                 ],
//               ),

//               if(_category=='kids') ...[

//                 const SizedBox(height:12),

//                 DropdownButtonFormField<String>(
//                   value:_gender,
//                   decoration: const InputDecoration(labelText:'Gender'),
//                   items:_genders.map((g){
//                     return DropdownMenuItem(
//                       value:g,
//                       child:Text(g.capitalize),
//                     );
//                   }).toList(),
//                   onChanged:(v)=>setState(()=>_gender=v),
//                 ),

//                 const SizedBox(height:12),

//                 DropdownButtonFormField<String>(
//                   value:_ageGroup,
//                   decoration: const InputDecoration(labelText:'Age Group'),
//                   items:_ageGroups.map((a){
//                     return DropdownMenuItem(
//                       value:a,
//                       child:Text(a),
//                     );
//                   }).toList(),
//                   onChanged:(v)=>setState(()=>_ageGroup=v),
//                 ),
//               ],

//               const SizedBox(height:24),

//               ElevatedButton(
//                 onPressed:_saving?null:_save,
//                 child:_saving
//                     ?const CircularProgressIndicator(color:Colors.white)
//                     :const Text('Add Product'),
//               ),

//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// extension on String {
//   String get capitalize =>
//       isEmpty ? '' : '${this[0].toUpperCase()}${substring(1)}';
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

class AddProductScreen extends ConsumerStatefulWidget {
  final dynamic product;
  const AddProductScreen({this.product, super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {

  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _comparePriceCtrl = TextEditingController();
  final _stockCtrl = TextEditingController();
  final _tagsCtrl = TextEditingController();
  final _imageUrlCtrl = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  String _category = 'men';
  String? _subCategory = 'topwear';
  String? _gender;
  String? _ageGroup;

  final List<String> _selectedSizes = [];
  final List<String> _imageUrls = [];
  final List<File> _pickedImages = [];

  bool _isFeatured = false;
  bool _isActive = true;
  bool _saving = false;

  final _categories = ['men','women','kids','ethnic'];

  final _subCategories = [
    null,
    'topwear',
    'bottomwear',
    'footwear',
    'accessories',
    'ethnic',
    'sports'
  ];

  final _sizes = ['XS','S','M','L','XL','XXL','3XL','Free Size'];

  final _genders = ['boy','girl'];

  final _ageGroups = [
    '0-3M','3-6M','6-12M','1-2Y','2-3Y','3-4Y','4-5Y','5-6Y'
  ];

  void _addImageUrl() {

    final url = _imageUrlCtrl.text.trim();

    if (url.isEmpty) return;

    setState(() {
      _imageUrls.add(url);
      _imageUrlCtrl.clear();
    });
  }

  Future<void> _pickImage() async {

    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() {
      _pickedImages.add(File(image.path));
    });
  }

  Future<void> _save() async {

    if (!_formKey.currentState!.validate()) return;

    if (_imageUrls.isEmpty && _pickedImages.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add at least one image'),
          backgroundColor: AppColors.error,
        ),
      );

      return;
    }

    setState(()=>_saving=true);

    try {

      final productId = const Uuid().v4();

      final stock = int.parse(_stockCtrl.text);

      final tags = _tagsCtrl.text
          .split(',')
          .map((t)=>t.trim().toLowerCase())
          .where((t)=>t.isNotEmpty)
          .toList();

      final product = ProductModel(

        productId: productId,
        name: _nameCtrl.text.trim(),
        description: _descCtrl.text.trim(),

        price: double.parse(_priceCtrl.text),

        comparePrice: _comparePriceCtrl.text.isNotEmpty
            ? double.tryParse(_comparePriceCtrl.text)
            : null,

        category: _category,
        subCategory: _subCategory ?? '',

        gender: _category == 'kids' ? _gender : null,
        ageGroup: _category == 'kids' ? _ageGroup : null,

        tags: tags,

        imageUrls: _imageUrls,

        sizes: _selectedSizes,

        stock: stock,
        inStock: stock > 0,
        stockStatus: ProductModel.deriveStockStatus(stock),

        isFeatured: _isFeatured,
        isActive: _isActive,
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

      setState(()=>_saving=false);

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: AppColors.error,
        ),

      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text('Add Product'),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(16),

        child: Form(

          key: _formKey,

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              TextFormField(
                controller:_nameCtrl,
                validator:(v)=>Validators.required(v,'Product name'),
                decoration: const InputDecoration(labelText:'Product Name'),
              ),

              const SizedBox(height:12),

              TextFormField(
                controller:_descCtrl,
                validator:(v)=>Validators.required(v,'Description'),
                decoration: const InputDecoration(labelText:'Description'),
                maxLines:3,
              ),

              const SizedBox(height:12),

              TextFormField(
                controller:_priceCtrl,
                keyboardType:TextInputType.number,
                validator:Validators.price,
                decoration: const InputDecoration(
                  labelText:'Price (₹)',
                ),
              ),

              const SizedBox(height:12),

              TextFormField(
                controller:_stockCtrl,
                keyboardType:TextInputType.number,
                validator:Validators.stock,
                decoration: const InputDecoration(
                  labelText:'Stock Quantity',
                ),
              ),

              const SizedBox(height:16),

              const Text(
                "Product Images",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height:10),

              Row(
                children: [

                  Expanded(
                    child: TextField(
                      controller: _imageUrlCtrl,
                      decoration: const InputDecoration(
                        labelText: "Paste Image URL",
                      ),
                    ),
                  ),

                  const SizedBox(width:8),

                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addImageUrl,
                  ),

                  IconButton(
                    icon: const Icon(Icons.photo_library),
                    onPressed: _pickImage,
                  ),
                ],
              ),

              const SizedBox(height:10),

              if (_imageUrls.isNotEmpty || _pickedImages.isNotEmpty)
                SizedBox(
                  height:100,
                  child: ListView(

                    scrollDirection: Axis.horizontal,

                    children: [

                      ..._imageUrls.map((url)=>Container(

                        width:90,
                        margin:const EdgeInsets.only(right:8),

                        decoration:BoxDecoration(
                          borderRadius:BorderRadius.circular(10),
                          image:DecorationImage(
                            image:NetworkImage(url),
                            fit:BoxFit.cover,
                          ),
                        ),

                      )),

                      ..._pickedImages.map((img)=>Container(

                        width:90,
                        margin:const EdgeInsets.only(right:8),

                        decoration:BoxDecoration(
                          borderRadius:BorderRadius.circular(10),
                          image:DecorationImage(
                            image:FileImage(img),
                            fit:BoxFit.cover,
                          ),
                        ),

                      )),

                    ],
                  ),
                ),

              const SizedBox(height:16),

              Row(
                children:[

                  Expanded(
                    child:DropdownButtonFormField<String>(
                      value:_category,
                      decoration: const InputDecoration(labelText:'Category'),
                      items:_categories.map((c)=>DropdownMenuItem(
                        value:c,
                        child:Text(c.toUpperCase()),
                      )).toList(),
                      onChanged:(v){
                        setState(() {
                          _category=v!;
                        });
                      },
                    ),
                  ),

                  const SizedBox(width:12),

                  Expanded(
                    child:DropdownButtonFormField<String?>(
                      value:_subCategory,
                      decoration: const InputDecoration(labelText:'SubCategory'),
                      items:_subCategories.map((c){
                        return DropdownMenuItem(
                          value:c,
                          child:Text(c==null?'None':c),
                        );
                      }).toList(),
                      onChanged:(v)=>setState(()=>_subCategory=v),
                    ),
                  ),

                ],
              ),

              if(_category=='kids') ...[

                const SizedBox(height:12),

                DropdownButtonFormField<String>(
                  value:_gender,
                  decoration: const InputDecoration(labelText:'Gender'),
                  items:_genders.map((g)=>DropdownMenuItem(
                    value:g,
                    child:Text(g),
                  )).toList(),
                  onChanged:(v)=>setState(()=>_gender=v),
                ),

                const SizedBox(height:12),

                DropdownButtonFormField<String>(
                  value:_ageGroup,
                  decoration: const InputDecoration(labelText:'AgeGroup'),
                  items:_ageGroups.map((a)=>DropdownMenuItem(
                    value:a,
                    child:Text(a),
                  )).toList(),
                  onChanged:(v)=>setState(()=>_ageGroup=v),
                ),
              ],

              const SizedBox(height:24),

              ElevatedButton(
                onPressed:_saving?null:_save,
                child:_saving
                    ?const CircularProgressIndicator()
                    :const Text('Add Product'),
              ),

            ],
          ),
        ),
      ),
    );
  }
}