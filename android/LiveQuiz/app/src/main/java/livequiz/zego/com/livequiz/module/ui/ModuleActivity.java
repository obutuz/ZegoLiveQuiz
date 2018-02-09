package livequiz.zego.com.livequiz.module.ui;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.annotation.Nullable;
import android.view.WindowManager;

import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
import com.google.gson.internal.Primitives;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

import livequiz.zego.com.livequiz.application.ZegoApplication;


/**
 * Instrumented test, which will execute on an Android device.
 *
 * @see <a href="http://d.android.com/tools/testing">Testing documentation</a>
 */

public class ModuleActivity extends Activity {


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);


    }

    public void stcartActivity(Context context, Class activity, Bundle bundle) {
        Intent intent = new Intent(context, activity);
        intent.putExtra("value", bundle);
        context.startActivity(intent);
    }

    public Object getEntity(String name) {
        Bundle bundle = getIntent().getBundleExtra("value");
        return bundle.getSerializable(name);
    }


    @Override
    protected void onStart() {
        super.onStart();
    }

    @Override
    protected void onStop() {
        super.onStop();
    }

    @Override
    protected void onResume() {
        super.onResume();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }

    @Override
    protected void onPause() {
        super.onPause();
    }


    public void httpReturn(String body, String red) {


    }

    Handler handler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            Map<String, String> map = (Map<String, String>) msg.obj;
            httpReturn(map.get("body"), map.get("red"));
        }
    };

    public void httpUrl(final String url, final String red) {
        RequestQueue mQueue = Volley.newRequestQueue(ZegoApplication.sApplicationContext);
        StringRequest request = new StringRequest(url,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String body) {
                        Map<String, String> map = new HashMap<>();
                        map.put("body", body);
                        map.put("red", red);
                        handler.sendMessage(handler.obtainMessage(0, map));
                    }
                }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Map<String, String> map = new HashMap<>();
                map.put("body", "error");
                map.put("red", red);
                handler.sendMessage(handler.obtainMessage(0, map));
            }
        });
        mQueue.add(request);

    }


}