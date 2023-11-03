import 'package:flutter/material.dart';

class ChapterLoadingError extends StatelessWidget {
  const ChapterLoadingError({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(Icons.list_rounded),
          )
        ],
      ),
      body: const Center(
        child: Text("Tải dữ liệu chapter error"),
      ),
    );
  }
}
