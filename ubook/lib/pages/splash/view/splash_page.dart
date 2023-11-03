import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubook/app/routes/routes_name.dart';
import 'package:ubook/widgets/widgets.dart';

import '../cubit/splash_cubit.dart';
import 'web_view.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return MyApp();
    return Scaffold(
      body: BlocListener<SplashCubit, SplashState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) {
          if (state is LoadedLocalExts) {
            Navigator.pushReplacementNamed(context, RoutesName.bottomNav);
          } else if (state is LocalExtsEmpty) {
            Navigator.pushReplacementNamed(context, RoutesName.installExt);
          }
        },
        // child: VideoWidget(),
        // child: const ListTest(),
        // child: Center(
        //   child:
        //       ElevatedButton(onPressed: () async {}, child: const Text("EST")),
        // ),
        child: const Stack(
          fit: StackFit.expand,
          children: [
            // Align(
            //     child: Image.asset(
            //   AppAssets.iconApp,
            //   width: 80,
            //   height: 80,
            // )),
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: LoadingWidget(
                radius: 15,
              ),
            )
          ],
        ),
      ),
    );
  }
}
