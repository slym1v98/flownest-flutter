import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kappa/kappa.dart';
import 'package:kappa/src/presentation/widgets/common/kappa_button.dart';
import 'product_cubit.dart';
import 'product_detail_page.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().fetchItems(isRefresh: true);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<ProductCubit>().fetchItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kappa Store'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => SL.call<ThemeCubit>().toggleTheme(),
          ),
        ],
      ),
      body: BlocBuilder<ProductCubit, ProductPaginationState>(
        builder: (context, state) {
          if (state.isLoading && state.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () => context.read<ProductCubit>().fetchItems(isRefresh: true),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: state.items.length + (state.isLastPage ? 0 : 1),
              itemBuilder: (context, index) {
                if (index == state.items.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final product = state.items[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Hero(
                      tag: 'product_image_${product.id}',
                      child: Image.network(product.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                    ),
                    title: Text(product.title),
                    subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProductDetailPage(product: product),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          SL.call<LoaderCubit>().setLoading(true);
          Future.delayed(const Duration(seconds: 2), () {
            SL.call<LoaderCubit>().setLoading(false);
            KappaUI.showSnackBar('Background Task Finished!');
          });
        },
        child: const Icon(Icons.sync),
      ),
    );
  }
}
