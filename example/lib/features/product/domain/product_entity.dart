import 'package:kappa/kappa.dart';

class ProductEntity extends BaseEntity {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [id, title, description, price, imageUrl];
}
