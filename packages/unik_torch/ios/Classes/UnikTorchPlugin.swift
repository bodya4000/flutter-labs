import AVFoundation
import Flutter
import UIKit

public final class UnikTorchPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "unik_torch/channel",
      binaryMessenger: registrar.messenger()
    )
    let plug = UnikTorchPlugin()
    channel.setMethodCallHandler(plug.handle(_:result:))
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "turnOn":
      result(setTorch(enabled: true))
    case "turnOff":
      result(setTorch(enabled: false))
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func setTorch(enabled: Bool) -> Bool {
    guard let device = AVCaptureDevice.default(for: .video) else {
      return false
    }
    guard device.hasTorch else {
      return false
    }
    do {
      try device.lockForConfiguration()
      defer { device.unlockForConfiguration() }
      if enabled {
        let level = AVCaptureDevice.maxAvailableTorchLevel
        try device.setTorchModeOn(level: level)
      } else {
        device.torchMode = .off
      }
      return true
    } catch {
      return false
    }
  }
}
