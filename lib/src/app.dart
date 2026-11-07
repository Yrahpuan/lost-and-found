import 'package:flutter/material.dart';

import 'features/items/items_controller.dart';
import 'features/items/items_page.dart';

class LostAndFoundApp extends StatefulWidget {
  const LostAndFoundApp({super.key, this.startupError});

  final String? startupError;

  @override
  State<LostAndFoundApp> createState() => _LostAndFoundAppState();
}

class _LostAndFoundAppState extends State<LostAndFoundApp> {
  late final ItemsController _controller = ItemsController(
    startupError: widget.startupError,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Achados e Perdidos UESPI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF176B52)),
        useMaterial3: true,
      ),
      home: ItemsPage(controller: _controller),
    );
  }
}
