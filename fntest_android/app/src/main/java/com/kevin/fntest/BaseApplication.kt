package com.kevin.fntest

import android.app.Application
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.FlutterEngineGroup
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

const val ENGINE_ID = "1"
const val FRAGMENT_ENGINE_ID = "2"
const val ENGINE_ID_MAIN = "3"
class BaseApplication: Application() {
    var count = 0

    private lateinit var channel: MethodChannel
    override fun onCreate() {
        super.onCreate()
        FlutterEngineGroup(this)
        val flutterEngine = FlutterEngine(this)
        flutterEngine.navigationChannel.setInitialRoute("/test")
        flutterEngine
            .dartExecutor
            .executeDartEntrypoint(
                DartExecutor.DartEntrypoint.createDefault()
            )
        FlutterEngineCache.getInstance().put(ENGINE_ID, flutterEngine)

        val flutterEngineMain = FlutterEngine(this)
        flutterEngineMain.navigationChannel.setInitialRoute("/onGenerate1")
        flutterEngineMain
            .dartExecutor
            .executeDartEntrypoint(
                DartExecutor.DartEntrypoint.createDefault()
            )
        FlutterEngineCache.getInstance().put(ENGINE_ID_MAIN, flutterEngineMain)

        val flutterEngineFragment = FlutterEngine(this)
        flutterEngineFragment
            .dartExecutor
            .executeDartEntrypoint(
                DartExecutor.DartEntrypoint.createDefault()
            )

        FlutterEngineCache.getInstance().put(FRAGMENT_ENGINE_ID, flutterEngineFragment)

        channel = MethodChannel(flutterEngine.dartExecutor, "dev.flutter.example/counter")

        channel.setMethodCallHandler { call, _ ->
            when (call.method) {
                "incrementCounter" -> {
                    count++
                    reportCounter()
                }
                "requestCounter" -> {
                    reportCounter()
                }
            }
        }
    }
    private fun reportCounter() {
        channel.invokeMethod("reportCounter", count)
    }
}