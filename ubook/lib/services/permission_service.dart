import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  /// Check permission
  /// - Permission status != granted -> request
  /// - Return `Future<bool>`
  ///
  /// Example:
  /// ```dart
  /// final cameraPermission = await PermissionService.checkAndRequestPermission(Permission.camera)
  /// print(cameraPermission) //true
  /// ```
  static Future<bool> checkAndRequestPermission(Permission permission) async {
    bool result = false;

    var statusPermission = await permission.status;

    if (statusPermission != PermissionStatus.granted) {
      statusPermission = await permission.request();
    }

    if (statusPermission == PermissionStatus.granted) {
      result = true;
    }

    return result;
  }

  /// check Device Enable or Disabled Location
  static Future<bool> isEnableLocation() async =>
      await Permission.locationWhenInUse.serviceStatus.isEnabled;

  /// Kiểm tra quyền bộ nhớ
  static Future<bool> checkPermissionStorage() async {
    return await checkAndRequestPermission(Permission.storage);
  }

  /// Kiểm tra quyền vị trí
  static Future<bool> checkPermissionLocation() async {
    return await checkAndRequestPermission(Permission.location);
  }

  /// Kiểm tra quyền pick ảnh ở thư viện
  static Future<bool> checkPermissionGallery() async {
    if (Platform.isAndroid) {
      return await checkAndRequestPermission(Permission.storage);
    } else if (Platform.isIOS) {
      return await checkAndRequestPermission(Permission.photos);
    }

    return false;
  }

  /// Kiểm tra quyền camera
  static Future<bool> checkPermissionCamera() async {
    return await checkAndRequestPermission(Permission.camera);
  }
}
