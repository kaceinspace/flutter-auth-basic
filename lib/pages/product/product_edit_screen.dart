import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xii_rpl_3/models/product_model.dart';
import 'package:xii_rpl_3/pages/menu_screen.dart';
import 'package:xii_rpl_3/pages/product/product_list_screen.dart';
import 'package:xii_rpl_3/services/product_service.dart';

class ProductEditScreen extends StatefulWidget {
  final Product product;
  const ProductEditScreen({super.key, required this.product});

  @override
  State<ProductEditScreen> createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _priceController;

  Uint8List? _imageBytes;
  String? _imageName;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.product.name);
    _descController = TextEditingController(text: widget.product.description);
    _priceController = TextEditingController(
      text: widget.product.price.toString(),
    );
    super.initState();
  }

  Future pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _imageBytes = bytes;
        _imageName = picked.name;
      });
    }
  }

  void submit() async {
    final success = await ProductService.updateProduct(
      widget.product.id,
      _nameController.text,
      _descController.text,
      double.parse(_priceController.text),
      _imageBytes,
      _imageName,
    );
    if (success) {
      // Arahkan ke halaman ListProductPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MenuScreen()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memperbarui produk')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Product")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: _descController,
                decoration: InputDecoration(labelText: "Description"),
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                onPressed: pickImage,
                child: Text("Pick New Image"),
              ),
              if (_imageBytes != null) Image.memory(_imageBytes!, height: 100),
              SizedBox(height: 20),
              ElevatedButton(onPressed: submit, child: Text("Update")),
            ],
          ),
        ),
      ),
    );
  }
}
