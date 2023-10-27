import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:ubook/utils/directory_utils.dart';
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
          // if (state is LoadedLocalExts) {
          //   Navigator.pushReplacementNamed(context, RoutesName.bottomNav);
          // } else if (state is LocalExtsEmpty) {
          //   Navigator.pushReplacementNamed(context, RoutesName.installExt);
          // }
        },
        // child: const ListTest(),
        child: Center(
          child: ElevatedButton(
              onPressed: () async {
                // final path = await DirectoryUtils.getDirectoryDownloadBook(100);
                // print(path);
                // // IsolateNameServer
                // final taskId = await FlutterDownloader.enqueue(
                //     url:
                //         "https://github.com/lamphuchai-dev/uBook/raw/main/ext-book/extensions/say_truyen/icon.png",
                //     headers: {}, // optional: header send with url (auth token etc)
                //     savedDir: path,
                //     fileName: "test.png",
                //     showNotification:
                //         true, // show download progress in status bar (for Android)
                //     openFileFromNotification:
                //         false, // click on notification to open downloaded file (for Android)
                //     saveInPublicStorage: true);
                // print(taskId);
              },
              child: const Text("EST")),
        ),
        //   child: const Stack(
        //     fit: StackFit.expand,
        //     children: [
        //       // Align(
        //       //     child: Image.asset(
        //       //   AppAssets.iconApp,
        //       //   width: 80,
        //       //   height: 80,
        //       // )),
        //       Positioned(
        //         bottom: 16,
        //         left: 0,
        //         right: 0,
        //         child: LoadingWidget(
        //           radius: 15,
        //         ),
        //       )
        //     ],
        //   ),
      ),
    );
  }
}
