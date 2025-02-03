package nl.digizorg

import android.app.Activity
import android.content.Context
import androidx.annotation.NonNull
import androidx.fragment.app.FragmentActivity
import com.luscii.sdk.Luscii
import com.luscii.sdk.actions.setActionFlowFragmentResultListener
import dagger.hilt.android.EntryPointAccessors

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import nl.digizorg.errors.LusciiFlutterSdkError
import nl.digizorg.extensions.toMap
import nl.digizorg.hilt.LusciiEntryPoint
import javax.inject.Singleton
import androidx.fragment.app.commit


class LusciiPatientActionsSdkPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel

    private lateinit var luscii: Luscii

    private var activity: Activity? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "luscii_patient_actions_sdk_android")
        channel.setMethodCallHandler(this)

        val appContext = flutterPluginBinding.applicationContext

        val hiltEntryPoint = EntryPointAccessors.fromApplication(appContext, LusciiEntryPoint::class.java)
        luscii = hiltEntryPoint.getLuscii()
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "authenticate" -> {
                val value = call.arguments<String>() ?: return result.error(
                    LusciiFlutterSdkError.INVALID_ARGUMENTS.code,
                    LusciiFlutterSdkError.INVALID_ARGUMENTS.message,
                    null
                )

                if (value.isBlank()) {
                    return result.error(
                        LusciiFlutterSdkError.INVALID_ARGUMENTS.code,
                        LusciiFlutterSdkError.INVALID_ARGUMENTS.message,
                        null
                    )
                }
                // Launch a coroutine in the IO context
                CoroutineScope(Dispatchers.IO).launch {
                    try {
                        // Perform the suspend function in the IO context
                        val authResult = luscii.authenticate(value)

                        when (authResult) {
                            is Luscii.AuthenticateResult.Success -> {
                                result.success(null);
                                return@launch
                            }

                            is Luscii.AuthenticateResult.Invalid -> {
                                result.error(
                                    LusciiFlutterSdkError.UNAUTHORIZED.code,
                                    LusciiFlutterSdkError.UNAUTHORIZED.message,
                                    null
                                )
                                return@launch
                            }
                        }
                    } catch (e: Exception) {
                        // Handle any exception and send an error response
                        result.error(
                            LusciiFlutterSdkError.UNKNOWN.code,
                            LusciiFlutterSdkError.UNKNOWN.message,
                            e.message
                        )
                        return@launch
                    }
                }
            }

            "getActions" -> {
                CoroutineScope(Dispatchers.IO).launch {
                    try {
                        val actions = luscii.getActions().map { it.toMap() }
                        result.success(actions)
                    } catch (e: Exception) {
                        // TODO: Handle Authentication errors
                        result.error(
                            LusciiFlutterSdkError.UNKNOWN.code,
                            LusciiFlutterSdkError.UNKNOWN.message,
                            e.message
                        )
                        return@launch
                    }
                    return@launch
                }
            }
            "launchAction" -> {
                CoroutineScope(Dispatchers.IO).launch {
                    try {
                        val actionId = call.arguments<String>() ?: return@launch result.error(
                            LusciiFlutterSdkError.INVALID_ARGUMENTS.code,
                            LusciiFlutterSdkError.INVALID_ARGUMENTS.message,
                            null
                        )

                        if (actionId.isBlank()) {
                            return@launch result.error(
                                LusciiFlutterSdkError.INVALID_ARGUMENTS.code,
                                LusciiFlutterSdkError.INVALID_ARGUMENTS.message,
                                null
                            )
                        }

                        val actions = luscii.getActions()
                        val action = actions.firstOrNull { it.id.toString() == actionId }
                        if (action == null) {
                            return@launch result.error(
                                LusciiFlutterSdkError.INVALID_ARGUMENTS.code,
                                LusciiFlutterSdkError.INVALID_ARGUMENTS.message,
                                null
                            )
                        }

                        val fragment = luscii.buildActionFlowFragment(action)

                        withContext(Dispatchers.Main) {
                            (activity as FragmentActivity).supportFragmentManager.apply {
                                setActionFlowFragmentResultListener((activity as FragmentActivity)) {
                                    // Handle result, see further down in the instructions for details.
                                }

                                commit {
                                    add(fragment, "ActionFlow")
                                }
                            }
                        }
                        result.success(null)
                    } catch (e: Exception) {
                        result.error(
                            LusciiFlutterSdkError.UNKNOWN.code,
                            LusciiFlutterSdkError.UNKNOWN.message,
                            e.message
                        )
                    }
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        this.activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        this.activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        this.activity = null
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}