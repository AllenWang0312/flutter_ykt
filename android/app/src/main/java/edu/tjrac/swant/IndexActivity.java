package edu.tjrac.swant;

import androidx.appcompat.app.AppCompatActivity;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

import edu.tjrac.swant.flutter_ykt_3.R;
import io.flutter.embedding.android.FlutterActivity;

public class IndexActivity extends AppCompatActivity implements View.OnClickListener{

    Button bt,channel,ffragment;
    SharedPreferences sp;
    @SuppressLint("MissingInflatedId")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_android_native);
        sp = getPreferences(Activity.MODE_PRIVATE);
        int i = sp.getInt("index",-1);
        if(i>=0){
            onClick(i);
        }
        bt = findViewById(R.id.bt);
        channel= findViewById(R.id.bt_channel);
        ffragment = findViewById(R.id.bt_ffragment);
        bt.setOnClickListener((view)->{
            onClick(0);
        });
        channel.setOnClickListener((view)->{
            onClick(1);
        });
        ffragment.setOnClickListener((view)->{
            onClick(2);
        });

    }

    @Override
    public void onClick(View view) {
       onClick(view.getId());
    }

    private void onClick(int id) {
        sp.edit().putInt("index",id).apply();

        switch (id){
            case 0:
                startActivity(
                        FlutterActivity
                                .withNewEngine()
                                .initialRoute("login")
                                .build(this)
                );
                break;
            case 1:
                startActivity(
                        FlutterChannelActivity
                                .withNewEngine()
                                .build(this)
                );
                break;
            case 2:
                startActivity(
                        new Intent(this, FlutterFragmentActivity.class)
                );
                break;
        }
    }
}