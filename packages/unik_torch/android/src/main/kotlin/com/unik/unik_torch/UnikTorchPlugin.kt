package com.unik.unik_torch

import android.content.Context
import android.hardware.camera2.CameraCharacteristics
import android.hardware.camera2.CameraManager
import android.os.Build
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

@Suppress("unused")
class UnikTorchPlugin : FlutterPlugin, MethodCallHandler {

  private var channel: MethodChannel? = null

  private var applicationContext: Context? = null

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    applicationContext = binding.applicationContext
    val ch =
        MethodChannel(binding.binaryMessenger, "unik_torch/channel")
    ch.setMethodCallHandler(this)
    channel = ch
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel?.setMethodCallHandler(null)
    channel = null
    applicationContext = null
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    val ctx = applicationContext
    if (ctx == null) {
      result.success(false)
      return
    }
    when (call.method) {
      "turnOn" -> result.success(setTorch(ctx, true))
      "turnOff" -> result.success(setTorch(ctx, false))
      else -> result.notImplemented()
    }
  }

  private fun setTorch(ctx: Context, on: Boolean): Boolean {
    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
      return false
    }
    return try {
      val cm = ctx.getSystemService(Context.CAMERA_SERVICE) as CameraManager
      val cameraId = findBackTorchCamera(cm) ?: return false
      cm.setTorchMode(cameraId, on)
      true
    } catch (_: Exception) {
      false
    }
  }

  private fun findBackTorchCamera(cm: CameraManager): String? =
      cm.cameraIdList.firstOrNull { id ->
        val ch = cm.getCameraCharacteristics(id)
        val flash = ch.get(CameraCharacteristics.FLASH_INFO_AVAILABLE)
        val facing = ch.get(CameraCharacteristics.LENS_FACING)
        flash == true && facing == CameraCharacteristics.LENS_FACING_BACK
      }
}
