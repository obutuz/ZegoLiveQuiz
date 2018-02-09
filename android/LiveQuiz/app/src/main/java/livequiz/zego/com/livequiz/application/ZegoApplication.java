package livequiz.zego.com.livequiz.application;

import android.app.Application;
import android.content.Context;

import livequiz.zego.com.livequiz.utils.AppLogger;


public class ZegoApplication extends Application {

    public static Context sApplicationContext;

    @Override
    public void onCreate() {
        super.onCreate();
        sApplicationContext = this;
        // 初始化sdk
        ZegoApiManager.getInstance().initSDK(this);
        AppLogger.getInstance().writeLog(this.getClass(), "initSDK");

    }

    public Context getApplicationContext() {
        return sApplicationContext;
    }

}


