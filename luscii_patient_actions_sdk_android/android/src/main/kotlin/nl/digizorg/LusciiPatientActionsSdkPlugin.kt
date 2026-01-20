package nl.digizorg

import android.app.Activity
import androidx.activity.ComponentActivity
import androidx.activity.result.ActivityResultLauncher
import com.luscii.sdk.Luscii
import com.luscii.sdk.UnauthenticatedException

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
import nl.digizorg.errors.LusciiFlutterSdkError
import nl.digizorg.extensions.toMap
import com.luscii.sdk.actions.Action
import com.luscii.sdk.onboarding.DisclaimerInput
import com.luscii.sdk.onboarding.DisclaimerResult
import com.luscii.sdk.onboarding.launch
import io.flutter.plugin.common.EventChannel
import nl.digizorg.event.EventHandler


class LusciiPatientActionsSdkPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel

    private lateinit var eventChannel: EventChannel
    private lateinit var eventHandler: EventHandler

    private var luscii: Luscii? = null

    private var activity: Activity? = null

    private var actionFlowLauncher: ActivityResultLauncher<Action>? = null
    private var disclaimerLauncher: ActivityResultLauncher<DisclaimerInput>? = null
    
    // Store the action temporarily while waiting for disclaimer result
    private var pendingAction: Action? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "luscii_patient_actions_sdk_android")
        channel.setMethodCallHandler(this)

        eventHandler = EventHandler()
        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "luscii_patient_actions_sdk_android/events")
        eventChannel.setStreamHandler(eventHandler)

        val appContext = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "initialize" -> {
                val useDynamicColors = call.argument<Boolean>("androidDynamicTheming") ?: false
                val environment = call.argument<String>("environment")

                if (environment != null && environment != "production") {
                    println("WARNING: Android environment is determined by the 'lusciiSdkArtifact' Gradle property. " +
                            "The 'environment' parameter '$environment' passed from Dart does not switch the native Android environment at runtime.")
                }

                luscii = Luscii {
                    applicationContext = activity?.applicationContext
                    this.useDynamicColors = useDynamicColors
                }
                registerLauncherIfReady()
                result.success(null)
            }
            "authenticate" -> {
                // Check if the luscii instance is initialized
                if (luscii == null) {
                    return result.error(
                        LusciiFlutterSdkError.NOT_INITIALIZED.code,
                        LusciiFlutterSdkError.NOT_INITIALIZED.message,
                        null
                    )
                }
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
                        val authResult = luscii!!.authenticate(value)

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

            "getTodayActions" -> {
                // Check if the luscii instance is initialized
                if (luscii == null) {
                    return result.error(
                        LusciiFlutterSdkError.NOT_INITIALIZED.code,
                        LusciiFlutterSdkError.NOT_INITIALIZED.message,
                        null
                    )
                }
                CoroutineScope(Dispatchers.IO).launch {
                    try {
                        val actions = luscii!!.getTodayActions().map { it.toMap() }
                        result.success(actions)
                    } catch (e: UnauthenticatedException) {
                        result.error(
                            LusciiFlutterSdkError.UNAUTHORIZED.code,
                            LusciiFlutterSdkError.UNAUTHORIZED.message,
                            e.message
                        )
                        return@launch
                    } catch (e: Exception) {
                        // TODO: Handle more errors
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
                // Check if the luscii instance is initialized
                if (luscii == null) {
                    return result.error(
                        LusciiFlutterSdkError.NOT_INITIALIZED.code,
                        LusciiFlutterSdkError.NOT_INITIALIZED.message,
                        null
                    )
                }
                
                val componentActivity = activity as? ComponentActivity
                    ?: return result.error(
                        LusciiFlutterSdkError.UNKNOWN.code,
                        "Activity is not a ComponentActivity",
                        null
                    )

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

                        val actions = luscii!!.getTodayActions()
                        val action = actions.firstOrNull { it.id.toString() == actionId }
                        if (action == null) {
                            return@launch result.error(
                                LusciiFlutterSdkError.INVALID_ARGUMENTS.code,
                                LusciiFlutterSdkError.INVALID_ARGUMENTS.message,
                                null
                            )
                        }
                        
                        // For now we always show the disclaimer before launching the action
                        // This will be changed in the future, then it will be possible to call the disclaimer
                        // directly without launching the action.
                        
                        // Store the action and launch disclaimer first
                        pendingAction = action
                        disclaimerLauncher?.launch(componentActivity)

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
            else -> result.notImplemented()
        }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.activity = binding.activity
    }

    private fun registerLauncherIfReady() {
        if ((actionFlowLauncher != null && disclaimerLauncher != null) || luscii == null || activity == null) return

        val componentActivity = activity as? ComponentActivity
            ?: return

        if (actionFlowLauncher == null) {
            actionFlowLauncher = componentActivity
                .activityResultRegistry
                .register(
                    "luscii_action_flow",
                    luscii!!.createActionFlowActivityResultContract(),
                    eventHandler::handleActionFlowResult
                )
        }

        if (disclaimerLauncher == null) {
            disclaimerLauncher = componentActivity
                .activityResultRegistry
                .register(
                    "luscii_disclaimer",
                    luscii!!.createDisclaimerActivityResultContract()
                ) { result: DisclaimerResult ->
                    when (result) {
                        is DisclaimerResult.Accepted -> {
                            // Launch the pending action if disclaimer was accepted
                            pendingAction?.let { action ->
                                actionFlowLauncher?.launch(action)
                                pendingAction = null
                            }
                        }
                        is DisclaimerResult.NotAccepted -> {
                            // Clear the pending action if disclaimer was not accepted
                            pendingAction = null
                        }
                    }
                }
        }
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