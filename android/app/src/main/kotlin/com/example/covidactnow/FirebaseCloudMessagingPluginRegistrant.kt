package com.example.covidactnow

import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin

// from https://stackoverflow.com/questions/59446933/pluginregistry-cannot-be-converted-to-flutterengine/59490722#59490722

object FirebaseCloudMessagingPluginRegistrant {
  fun registerWith(registry: PluginRegistry) {
    if (alreadyRegisteredWith(registry)) {
      return
    }
    FirebaseMessagingPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"))
  }

  private fun alreadyRegisteredWith(registry: PluginRegistry): Boolean {
    val key = FirebaseCloudMessagingPluginRegistrant::class.java!!.getCanonicalName()
    if (registry.hasPlugin(key)) {
      return true
    }
    registry.registrarFor(key)
    return false
  }
}
