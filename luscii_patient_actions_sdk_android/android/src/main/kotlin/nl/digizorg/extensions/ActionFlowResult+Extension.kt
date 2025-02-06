package nl.digizorg.extensions

import com.luscii.sdk.actions.ActionFlowResult

fun ActionFlowResult.toStatusString(): String = when (this) {
    is ActionFlowResult.Completed -> "completed"
    is ActionFlowResult.Cancelled -> "cancelled"
    is ActionFlowResult.Error -> "error:${reason.localizedMessage ?: ""}"
}