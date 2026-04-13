import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/pricing_bloc.dart';

class EditPricingPage extends StatefulWidget {
  final Map item;

  const EditPricingPage({super.key, required this.item});

  @override
  State<EditPricingPage> createState() => _EditPricingPageState();
}

class _EditPricingPageState extends State<EditPricingPage> {
  late TextEditingController priceController;

  @override
  void initState() {
    super.initState();
    priceController = TextEditingController(
        text: widget.item['price'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Pricing')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(widget.item['productName']),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Price'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final updated = {
                  'price': double.parse(priceController.text)
                };

                context.read<PricingBloc>().add(
                  UpdatePricingEvent(widget.item['_id'], updated),
                );

                Navigator.pop(context);
              },
              child: const Text('Save'),
            )
          ],
        ),
      ),
    );
  }
}