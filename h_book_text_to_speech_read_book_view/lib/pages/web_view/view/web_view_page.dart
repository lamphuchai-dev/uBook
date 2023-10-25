import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:h_book/pages/web_view/widgets/in_app.dart';
import '../cubit/web_view_cubit.dart';
import '../widgets/browser.dart';
import '../widgets/web_view_widget.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewCubit _webViewCubit;
  @override
  void initState() {
    _webViewCubit = context.read<WebViewCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Web view")),
      body: BrowserWidget(),
    );
  }
}
