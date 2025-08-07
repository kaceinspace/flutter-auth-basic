import 'package:flutter/material.dart';
import 'package:xii_rpl_3/models/product_model.dart';
import 'package:xii_rpl_3/pages/product/product_create_screen.dart';
import 'package:xii_rpl_3/pages/product/product_detail_screen.dart';
import 'package:xii_rpl_3/services/product_service.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    _futureProducts = ProductService.fetchProducts();
  }

  Future<void> _refreshProducts() async {
    setState(() {
      _loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ProductCreateScreen()),
          );
          _refreshProducts(); // refresh setelah kembali
        },
      ),
      body: FutureBuilder<List<Product>>(
        future: _futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.isEmpty)
            return Center(child: Text("No products"));

          return RefreshIndicator(
            onRefresh: _refreshProducts,
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final product = snapshot.data![index];
                return ListTile(
                  leading: Image.network(
                    'http://127.0.0.1:8000/storage/${product.image}',
                    width: 50,
                    errorBuilder: (_, __, ___) =>
                        Icon(Icons.image_not_supported),
                  ),
                  title: Text(product.name),
                  subtitle: Text('Rp ${product.price}'),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ProductDetailScreen(productId: product.id),
                      ),
                    );
                    _refreshProducts(); // refresh setelah kembali dari detail/edit
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
