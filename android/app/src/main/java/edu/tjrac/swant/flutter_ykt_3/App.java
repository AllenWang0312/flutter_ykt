package edu.tjrac.swant.flutter_ykt_3;

import android.app.Application;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineCache;

public class App extends Application {

    FlutterEngine flutterEngine;

    @Override
    public void onCreate() {
        super.onCreate();
        flutterEngine = new FlutterEngine(this);
        FlutterEngineCache.getInstance()
                .put("flutterEngine", flutterEngine);
    }

    @Override
    public void onTerminate() {
        flutterEngine.destroy();
        super.onTerminate();

    }
}
