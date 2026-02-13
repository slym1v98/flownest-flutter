import 'package:kappa/kappa.dart';

class ProductEntity extends BaseEntity {
  final String id;
  final String name;
  final double price;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.price,
  });

  @override
  List<Object?> get props => [id, name, price];
}
