package nl.digizorg

import android.content.Context
import androidx.annotation.NonNull
import com.luscii.sdk.Luscii
import dagger.hilt.android.EntryPointAccessors

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import nl.digizorg.errors.LusciiFlutterSdkError
import nl.digizorg.hilt.LusciiEntryPoint
import javax.inject.Singleton


class LusciiPatientActionsSdkPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel

    private lateinit var luscii: Luscii

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "luscii_patient_actions_sdk_android")
        channel.setMethodCallHandler(this)

        val appContext = flutterPluginBinding.applicationContext

        val hiltEntryPoint = EntryPointAccessors.fromApplication(appContext, LusciiEntryPoint::class.java)
        luscii = hiltEntryPoint.getLuscii()
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "authenticate") {
            val value = call.arguments<String>() ?: return result.error(LusciiFlutterSdkError.INVALID_ARGUMENTS.code,
                LusciiFlutterSdkError.INVALID_ARGUMENTS.message,
                null)

            if (value.isBlank()) {
                return result.error(LusciiFlutterSdkError.INVALID_ARGUMENTS.code,
                    LusciiFlutterSdkError.INVALID_ARGUMENTS.message,
                    null)
            }
            // Launch a coroutine in the IO context
            CoroutineScope(Dispatchers.IO).launch {
                try {
                    // Perform the suspend function in the IO context
                    val authResult = luscii.authenticate(value)

                    when(authResult) {
                        is Luscii.AuthenticateResult.Success -> {
                            result.success(null);
                            return@launch
                        }
                        is Luscii.AuthenticateResult.Invalid -> {
                            result.error(LusciiFlutterSdkError.UNAUTHORIZED.code,
                                LusciiFlutterSdkError.UNAUTHORIZED.message,
                                null)
                            return@launch
                        }
                    }
                } catch (e: Exception) {
                    // Handle any exception and send an error response
                    result.error(LusciiFlutterSdkError.UNKNOWN.code,
                        LusciiFlutterSdkError.UNKNOWN.message,
                        e.message)
                    return@launch
                }
            }
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}