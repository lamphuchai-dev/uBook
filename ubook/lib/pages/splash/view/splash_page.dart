import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubook/app/constants/assets.dart';
import 'package:ubook/app/routes/routes_name.dart';
import 'package:ubook/widgets/widgets.dart';
import '../cubit/splash_cubit.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  // late SplashCubit _splashCubit;
  @override
  void initState() {
    // _splashCubit = context.read<SplashCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        child: Stack(
          fit: StackFit.expand,
          children: [
            Align(
                child: Image.asset(
              AppAssets.iconApp,
              width: 80,
              height: 80,
            )),
            const Positioned(
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
