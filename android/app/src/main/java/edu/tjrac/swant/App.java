package edu.tjrac.swant;

import static edu.tjrac.swant.FlutterChannelActivity.FLAG_DEFAULT_FLUTTER_ENGINE;

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
                .put(FLAG_DEFAULT_FLUTTER_ENGINE, flutterEngine);
    }

    @Override
    public void onTerminate() {
        flutterEngine.destroy();
        super.onTerminate();

    }
}
