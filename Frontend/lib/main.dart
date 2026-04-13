import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/service_locator.dart' as di;
import 'features/pricing/presentation/bloc/pricing_bloc.dart';
import 'features/pricing/presentation/screen/home_page.dart';

void main() async {
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Retail Pricing App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      // ✅ Inject Bloc using get_it
      home: BlocProvider(
        create: (_) => di.sl<PricingBloc>()..add(LoadPricing()),
        child: const HomePage(),
      ),
    );
  }
}