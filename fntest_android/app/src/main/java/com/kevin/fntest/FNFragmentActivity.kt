package com.kevin.fntest

import android.annotation.SuppressLint
import android.content.Intent
import android.os.Bundle
import androidx.annotation.NonNull
import androidx.fragment.app.FragmentActivity
import androidx.fragment.app.FragmentManager
import io.flutter.embedding.android.FlutterFragment

class FNFragmentActivity : FragmentActivity() {
    companion object {
        // Define a tag String to represent the FlutterFragment within this
        // Activity's FragmentManager. This value can be whatever you'd like.
        private const val TAG_FLUTTER_FRAGMENT = "flutter_fragment"
    }

    // Declare a local variable to reference the FlutterFragment so that you
    // can forward calls to it later.
    private var flutterFragment: FlutterFragment? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Inflate a layout that has a container for your FlutterFragment. For
        // this example, assume that a FrameLayout exists with an ID of
        // R.id.fragment_container.
        setContentView(R.layout.activity_fn_fragment)

        flutterFragment = FlutterFragment.withCachedEngine(FRAGMENT_ENGINE_ID).build<FlutterFragment>()

//        val fragmentManager: FragmentManager = supportFragmentManager
//        flutterFragment = fragmentManager
//            .findFragmentByTag(TAG_FLUTTER_FRAGMENT) as FlutterFragment?
        supportFragmentManager.beginTransaction().add(R.id.fragment_container,flutterFragment!!).commit()

        // Create and attach a FlutterFragment if one does not exist.
//        if (flutterFragment == null) {
//            var newFlutterFragment = FlutterFragment.createDefault()
//            flutterFragment = newFlutterFragment
//            fragmentManager
//                .beginTransaction()
//                .add(
//                    R.id.fragment_container,
//                    newFlutterFragment,
//                    TAG_FLUTTER_FRAGMENT
//                )
//                .commit()
//        }
    }

    override fun onPostResume() {
        super.onPostResume()
        flutterFragment!!.onPostResume()
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        flutterFragment!!.onNewIntent(intent);
    }

    override fun onBackPressed() {
        super.onBackPressed()
        flutterFragment!!.onBackPressed()
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<String?>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        flutterFragment!!.onRequestPermissionsResult(
            requestCode,
            permissions,
            grantResults
        )
    }

    override fun onActivityResult(
        requestCode: Int,
        resultCode: Int,
        data: Intent?
    ) {
        super.onActivityResult(requestCode, resultCode, data)
        flutterFragment!!.onActivityResult(
            requestCode,
            resultCode,
            data
        )
    }

    override fun onUserLeaveHint() {
        flutterFragment!!.onUserLeaveHint()
    }

    @SuppressLint("MissingSuperCall")
    override fun onTrimMemory(level: Int) {
        super.onTrimMemory(level)
        flutterFragment!!.onTrimMemory(level)
    }
}