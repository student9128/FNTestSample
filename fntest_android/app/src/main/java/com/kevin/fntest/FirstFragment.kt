package com.kevin.fntest

import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.TextView
import androidx.fragment.app.Fragment
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterActivityLaunchConfigs

class FirstFragment:Fragment() {
    private lateinit var counterLabel: TextView
    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.fragment_first,container,false)
        counterLabel =view.findViewById(R.id.counter_label)

        val button = view.findViewById<Button>(R.id.launch_button)

        button.setOnClickListener {
            val intent = FlutterActivity
                .withCachedEngine(ENGINE_ID)
                .backgroundMode(FlutterActivityLaunchConfigs.BackgroundMode.transparent)//解决切换页面时闪烁问题
                .build(view.context)
            startActivity(intent)
        }
        val button2 = view.findViewById<Button>(R.id.launch_button2)

        button2.setOnClickListener {
            val intent = FlutterActivity
                .withNewEngine()
                .initialRoute("/main")
                .backgroundMode(FlutterActivityLaunchConfigs.BackgroundMode.transparent)
                .build(view.context)
            startActivity(intent)
        }
        val button3 = view.findViewById<Button>(R.id.launch_button3)
        button3.setOnClickListener {
            startActivity(Intent(context,FlutterViewActivity::class.java))
        }
        return view
    }
}