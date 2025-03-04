package com.kevin.fntest

// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import android.content.Intent
import android.os.Bundle
import android.os.Parcelable
import androidx.appcompat.app.AppCompatActivity
import androidx.core.os.BundleCompat
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import java.util.*
import kotlin.collections.ArrayList

// There are 3 files in this sample. MainActivity and ListAdapter are just
// fictional setups. FlutterViewEngine is instructional and demonstrates the
// various plumbing needed for a functioning FlutterView integration.
/**
 * Main activity for this demo that shows a page with a `RecyclerView`.
 *
 * There are 3 files in this sample. MainActivity and ListAdapter are just fictional setups.
 * FlutterViewEngine is instructional and demonstrates the various plumbing needed for a functioning
 * FlutterView integration.
 */
class FlutterViewActivity : AppCompatActivity() {

    private lateinit var flutterViewEngine: FlutterViewEngine
    private lateinit var recyclerView: RecyclerView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setContentView(R.layout.activity_flutter_view)

        // TODO: create a multi-engine version after
        // https://github.com/flutter/flutter/issues/72009 is built.
        val engine = FlutterEngine(applicationContext)
        engine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint(
                FlutterInjector.instance().flutterLoader().findAppBundlePath(),
                "showCell"
            )
        )

        flutterViewEngine = FlutterViewEngine(engine)
        // The activity and FlutterView have different lifecycles.
        // Attach the activity right away but only start rendering when the
        // view is also scrolled into the screen.
        flutterViewEngine.attachToActivity(this)

        val layoutManager = LinearLayoutManager(this)
        recyclerView = findViewById<RecyclerView>(R.id.recyclerView)
        val adapter = ListAdapter(this, flutterViewEngine)
        recyclerView.layoutManager = layoutManager
        recyclerView.adapter = adapter

        // If the activity was restarted, keep track of the previous scroll
        // position and of the previous cell indices that were randomly selected
        // as Flutter cells to preserve immersion.
        if (savedInstanceState != null) {
            val state = BundleCompat.getParcelable<Parcelable>(
                savedInstanceState,
                "layoutManager",
                Parcelable::class.java
            )
            layoutManager.onRestoreInstanceState(state)
        }
        val previousFlutterCellsArray = savedInstanceState?.getIntegerArrayList("adapter")
        if (previousFlutterCellsArray != null) {
            adapter.previousFlutterCells = TreeSet(previousFlutterCellsArray)
        }
    }

    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        outState.putParcelable("layoutManager", recyclerView.layoutManager?.onSaveInstanceState())
        val previousFlutterCells = (recyclerView.adapter as? ListAdapter)?.previousFlutterCells
        if (previousFlutterCells != null) {
            outState.putIntegerArrayList(
                "adapter",
                ArrayList(previousFlutterCells)
            )
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        flutterViewEngine.detachActivity()
    }

    // These below aren't used here in this demo but would be needed for Flutter plugins that may
    // consume these events.

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        flutterViewEngine.onRequestPermissionsResult(requestCode, permissions, grantResults)
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        flutterViewEngine.onActivityResult(requestCode, resultCode, data)
        super.onActivityResult(requestCode, resultCode, data)
    }

    override fun onUserLeaveHint() {
        flutterViewEngine.onUserLeaveHint()
        super.onUserLeaveHint()
    }
}
