package livequiz.zego.com.livequiz.utils;

import android.app.ActivityManager;
import android.content.Context;


import java.util.List;

import livequiz.zego.com.livequiz.application.ZegoApplication;

/**
 * Copyright © 2017 Zego. All rights reserved.
 */

public class SystemUtil {
    public static boolean isAppForeground() {

        ActivityManager activityManager = (ActivityManager) ZegoApplication.sApplicationContext
                .getSystemService(Context.ACTIVITY_SERVICE);
        List<ActivityManager.RunningAppProcessInfo> appProcesses = activityManager
                .getRunningAppProcesses();

        for (ActivityManager.RunningAppProcessInfo appProcess : appProcesses) {
            if (appProcess.processName.equals(ZegoApplication.sApplicationContext.getPackageName())) {
                if (appProcess.importance == ActivityManager.RunningAppProcessInfo.IMPORTANCE_FOREGROUND) {
                    return true;
                } else {
                    return false;
                }
            }
        }
        return false;
    }
}
