import 'package:flutter/material.dart';

Map<String, dynamic> convertBluetoothDataToJson(List<int> data, Map<String, dynamic> device) {
  if (data.isEmpty) {
    print("⚠️ Invalid Bluetooth data, returning defaults.");
    return {
      "modelId": device['deviceId'] ?? "default",
      "modelName": device['deviceName'] ?? "default",
      "imageUrl": "assets/images/helmet_image.png",
      "adfSettings": [
        {
          "modeType": "Welding",
          "image": "assets/images/welding_img.png",
          "shade": {
            "image": "assets/images/shade_img.png",
            "min": 5.0,
            "max": 13.0,
            "default": 10.0
          },
          "sensitivity": {
            "image": "assets/images/sensitivity_img.png",
            "min": 0.0,
            "max": 5.0,
            "default": 5.0
          },
          "delay": {
            "image": "assets/images/delay_img.png",
            "min": 0.0,
            "max": 5.0,
            "default": 5.0
          }
        },
        {
          "modeType": "Cutting",
          "image": "assets/images/cutting_img.png",
          "shade": {
            "image": "assets/images/shade_img.png",
            "min": 5.0,
            "max": 13.0,
            "default": 10.0
          }
        }
      ]
    };
  }

  try {
    bool isWeldingFirst = data[10] == 1;
    double weldingShade = data[11].toDouble() / 10;
    double cuttingShade = data[12].toDouble() / 10;

    return {
      "modelId": device['deviceId'],
      "modelName": device['deviceName'],
      "imageUrl": "assets/images/helmet_image.png",
      "adfSettings": [
        {
          "modeType": "Welding",
          "image": "assets/images/welding_img.png",
          "shade": {
            "image": "assets/images/shade_img.png",
            "min": 5.0,
            "max": 13.0,
            "default": weldingShade
          },
          "sensitivity": {
            "image": "assets/images/sensitivity_img.png",
            "min": 0.0,
            "max": 5.0,
            "default": data[13].toDouble()
          },
          "delay": {
            "image": "assets/images/delay_img.png",
            "min": 0.0,
            "max": 5.0,
            "default": data[14].toDouble()
          }
        },
        {
          "modeType": "Cutting",
          "image": "assets/images/cutting_img.png",
          "shade": {
            "image": "assets/images/shade_img.png",
            "min": 5.0,
            "max": 13.0,
            "default": cuttingShade
          }
        }
      ]
    };
  } catch (e) {
    print("❌ Error parsing Bluetooth data: $e");
    return convertBluetoothDataToJson([], device); // Return default values
  }
}
