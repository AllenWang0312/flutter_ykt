package edu.tjrac.swant.flutter_ykt_3;

import android.content.Intent;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineCache;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class ChannelFlutterActivity extends FlutterActivity implements MethodChannel.MethodCallHandler {

    String channelName = "flutter.open.native.page";

    @Nullable
    @Override
    protected FlutterEngine getFlutterEngine() {
        return FlutterEngineCache.getInstance().get("flutterEngine");
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        MethodChannel channel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), channelName);
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        Intent intent = new Intent(call.method);
        intent.putExtra("url",call.<String>argument("url"));
        startActivity(intent);
    }
}
