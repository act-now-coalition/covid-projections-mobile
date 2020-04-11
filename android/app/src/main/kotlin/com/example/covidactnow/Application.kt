package com.example.covidactnow

import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService

// For firebase messaging.
// See: https://pub.dev/packages/firebase_messaging

 class Application : FlutterApplication(), PluginRegistrantCallback {
   override fun onCreate() {
     super.onCreate()
     FlutterFirebaseMessagingService.setPluginRegistrant(this)
   }

   override fun registerWith(registry: PluginRegistry) {
     FirebaseCloudMessagingPluginRegistrant.registerWith(registry)
   }
 }
 