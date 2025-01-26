package com.kevin.fntest

import android.annotation.SuppressLint
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.MenuItem
import android.widget.Button
import android.widget.TextView
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import androidx.fragment.app.FragmentActivity
import com.google.android.material.bottomnavigation.BottomNavigationView
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragment

class MainActivity : AppCompatActivity() {
    private lateinit var counterLabel: TextView
    private var flutterFragment: FlutterFragment? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContentView(R.layout.activity_main)
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }

//        counterLabel = findViewById(R.id.counter_label)
//
//        val button = findViewById<Button>(R.id.launch_button)
//
//        button.setOnClickListener {
//            val intent = FlutterActivity
//                .withCachedEngine(ENGINE_ID)
//                .build(this)
//            startActivity(intent)
//        }
//        val buttonFragment =findViewById<Button>(R.id.launch_fragment_activity)
//        buttonFragment.setOnClickListener {
//            startActivity(Intent(this@MainActivity,FNFragmentActivity::class.java))
//        }
//        flutterFragment = FlutterFragment.withCachedEngine(FRAGMENT_ENGINE_ID).build<FlutterFragment>()
        flutterFragment = FlutterFragment.withNewEngine().dartEntrypoint("testN").build()
        val fragmentTransaction = supportFragmentManager.beginTransaction()
        val firstFragment = FirstFragment()
        fragmentTransaction.add(R.id.fl_container, firstFragment)
        fragmentTransaction.add(R.id.fl_container,flutterFragment!!)
        fragmentTransaction.show(firstFragment)
        fragmentTransaction.hide(flutterFragment!!)
        fragmentTransaction.commit()
        var bnv = findViewById<BottomNavigationView>(R.id.bnv)
        bnv.setOnItemSelectedListener { menuItem ->
            when (menuItem.itemId) {
                R.id.menu_home -> {
                    supportFragmentManager.beginTransaction().apply {
                        show(firstFragment)
                    flutterFragment?.let {
                        hide(it)
                    }
                    commit()
                    }
                    return@setOnItemSelectedListener true
                }

                R.id.menu_flutter -> {
                    supportFragmentManager.beginTransaction().apply {
                        hide(firstFragment)
                        flutterFragment?.let {
                            Log.i("MainActivity","execute=====~~~")
                            show(it)
                        }
                        commit()
                    }
                    return@setOnItemSelectedListener true
                }
            }
            false
        }
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