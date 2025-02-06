package nl.digizorg.event

import com.luscii.sdk.actions.ActionFlowResult
import io.flutter.plugin.common.EventChannel
import nl.digizorg.extensions.toStatusString

class EventHandler : EventChannel.StreamHandler {
    private var eventSink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    fun handleActionFlowResult(actionFlow: ActionFlowResult) {
        val data: Map<String, Any> = mapOf(
            "actionID" to actionFlow.actionId.toString(),
            "status" to actionFlow.toStatusString()
        )
        sendEvent(data)
    }

    private fun sendEvent(event: Any) {
        eventSink?.success(event)
    }
}