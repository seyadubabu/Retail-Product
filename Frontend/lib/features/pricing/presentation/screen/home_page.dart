import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/pricing_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        context.read<PricingBloc>().add(LoadMorePricing());
      }
    });
  }

  Future<void> _onRefresh() async {
    context.read<PricingBloc>().add(RefreshPricing());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Retail Pricing'),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: () {
              context.read<PricingBloc>().add(UploadCSVFromAssetsEvent());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search SKU...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    context.read<PricingBloc>().add(
                      SearchPricing(_searchController.text),
                    );
                  },
                ),
              ),
            ),
          ),

          Expanded(
            child: BlocBuilder<PricingBloc, PricingState>(
              builder: (context, state) {
                if (state is PricingLoading || state is PricingUploading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PricingLoaded) {
                  return RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: state.data.length + 1,
                        itemBuilder: (_, i) {
                          if (i == state.data.length) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          final item = state.data[i];

                          return Card(
                            margin: const EdgeInsets.all(10),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item['productName'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 5),
                                  Text('SKU: ${item['sku']}'),
                                  Text('Store: ${item['storeId']}'),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('₹ ${item['price']}'),
                                      Text(item['date']
                                          .toString()
                                          .substring(0, 10)),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                  );
                } else if (state is PricingError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}