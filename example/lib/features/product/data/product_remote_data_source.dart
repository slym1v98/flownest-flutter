import 'package:kappa/kappa.dart';
import '../domain/product_entity.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductEntity>> getProducts(int page);
}

class MockProductRemoteDataSource implements ProductRemoteDataSource {
  @override
  Future<List<ProductEntity>> getProducts(int page) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    if (page > 3) return []; // Limit to 3 pages

    return List.generate(10, (index) {
      final id = (page - 1) * 10 + index;
      return ProductEntity(
        id: id.toString(),
        title: 'Premium Product $id',
        description: 'This is a high-quality product description for item $id.',
        price: 29.99 + id,
        imageUrl: 'https://picsum.photos/200/300?random=$id',
      );
    });
  }
}
