package com.reis.reis

import android.graphics.drawable.Icon
import android.os.Build
import android.service.quicksettings.Tile
import android.service.quicksettings.TileService
import androidx.annotation.RequiresApi
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

@RequiresApi(Build.VERSION_CODES.N)
class QuickCaptureTileService : TileService() {
    
    private var flutterEngine: FlutterEngine? = null
    private var methodChannel: MethodChannel? = null
    
    companion object {
        private const val CHANNEL = "com.reis.reis/quick_capture"
    }
    
    override fun onCreate() {
        super.onCreate()
        initializeFlutterEngine()
    }
    
    private fun initializeFlutterEngine() {
        flutterEngine = FlutterEngine(applicationContext)
        flutterEngine?.dartExecutor?.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )
        
        methodChannel = MethodChannel(
            flutterEngine!!.dartExecutor.binaryMessenger,
            CHANNEL
        )
    }
    
    override fun onClick() {
        super.onClick()
        
        // Update tile to show in-progress state
        qsTile?.apply {
            state = Tile.STATE_ACTIVE
            label = "Capturing..."
            updateTile()
        }
        
        // Trigger photo capture via Flutter
        methodChannel?.invokeMethod("quickCapture", null, object : MethodChannel.Result {
            override fun success(result: Any?) {
                // Show success state
                qsTile?.apply {
                    label = "Photo Saved!"
                    updateTile()
                }
                
                // Reset after 2 seconds
                android.os.Handler(mainLooper).postDelayed({
                    resetTile()
                }, 2000)
            }
            
            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                // Show error state
                qsTile?.apply {
                    label = "Capture Failed"
                    state = Tile.STATE_INACTIVE
                    updateTile()
                }
                
                // Reset after 2 seconds
                android.os.Handler(mainLooper).postDelayed({
                    resetTile()
                }, 2000)
            }
            
            override fun notImplemented() {
                resetTile()
            }
        })
    }
    
    override fun onTileAdded() {
        super.onTileAdded()
        resetTile()
    }
    
    override fun onStartListening() {
        super.onStartListening()
        resetTile()
    }
    
    private fun resetTile() {
        qsTile?.apply {
            state = Tile.STATE_INACTIVE
            label = "Quick Capture"
            updateTile()
        }
    }
    
    override fun onDestroy() {
        flutterEngine?.destroy()
        flutterEngine = null
        methodChannel = null
        super.onDestroy()
    }
}
