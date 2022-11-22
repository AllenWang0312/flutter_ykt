package edu.tjrac.swant.flutter_ykt_3;

import androidx.appcompat.app.AppCompatActivity;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.widget.Button;

import io.flutter.embedding.android.FlutterActivity;

public class AndroidNativeActivity extends AppCompatActivity {

    Button bt,channel;
    @SuppressLint("MissingInflatedId")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_android_native);
        bt = findViewById(R.id.bt);
        channel= findViewById(R.id.bt_channel);
        bt.setOnClickListener((view)->{
            startActivity(
                    FlutterActivity
                            .withNewEngine()
                            .initialRoute("login")
                            .build(this)


            );
        });
        channel.setOnClickListener((view)->{
            startActivity(
                    ChannelFlutterActivity
                            .withNewEngine()
                            .build(this)
            );
        });

    }
}