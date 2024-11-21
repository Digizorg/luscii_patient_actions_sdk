package nl.digizorg.hilt

import com.luscii.sdk.Luscii
import dagger.hilt.EntryPoint
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent

@EntryPoint
@InstallIn(SingletonComponent::class)
interface LusciiEntryPoint {
    fun getLuscii(): Luscii
}