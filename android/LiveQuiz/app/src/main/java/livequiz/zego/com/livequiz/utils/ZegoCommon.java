package livequiz.zego.com.livequiz.utils;

import android.text.TextUtils;
import android.util.Log;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.google.gson.Gson;
import com.google.gson.JsonArray;

import org.json.JSONException;
import org.json.JSONObject;

import java.nio.ByteBuffer;
import java.util.HashMap;
import java.util.Map;

import livequiz.zego.com.livequiz.application.ZegoApiManager;

/**
 * Created by zego on 2018/2/1.
 */

public class ZegoCommon {

    public final static String roomlist = "https://liveroom%d-api.zego.im/demo/roomlist?appid=%d";


    private static ZegoCommon sInstance = null;


    public static ZegoCommon getInstance() {
        if (sInstance == null) {
            synchronized (ZegoApiManager.class) {
                if (sInstance == null) {
                    sInstance = new ZegoCommon();
                }
            }
        }
        return sInstance;
    }

    /**
     * 转换成map字符串
     *
     * @param json
     * @return
     */
    public Map<String, String> getMapFromJson(String json) {
        if (TextUtils.isEmpty(json)) {
            return null;
        }

        JSONArray jsonArray = JSON.parseArray(json);

        Map<String, String> map;

        map = jsonArray.getObject(0, Map.class);

        return map;
    }

    /**
     * 转换成map<object>
     *
     * @param json
     * @return
     */
    public Map<String, Object> getMapFromJsonToObject(String json) {
        if (TextUtils.isEmpty(json)) {
            return null;
        }

        Gson gson = new Gson();
        Map<String, Object> map = new HashMap<>();
        map = gson.fromJson(json, map.getClass());

        return map;
    }


    /**
     * 转换成JSONObject对象
     *
     * @param byteBuffer
     * @param dataLen
     * @return
     * @throws JSONException
     */
    public JSONObject getJsonObjectFrom(ByteBuffer byteBuffer, int dataLen) throws JSONException {
        byte[] temp = new byte[dataLen - 4];
        for (int i = 0; i < dataLen - 4; i++) {
            temp[i] = byteBuffer.get(i + 4);
        }
        JSONObject jsonObject = new JSONObject(new String(temp));
        Log.w("getJsonObjectFrom", String.format("json: %s", jsonObject.toString()));
        return jsonObject;
    }


    /**
     * 回复答题Json格式
     * @param activityId
     * @param questionid
     * @param answer
     * @param userDate
     * @return
     * @throws JSONException
     */
    public JSONObject getJsonDateFrom(String activityId, String questionid, String answer, String userDate) throws JSONException {

        JSONObject jsonObject = new JSONObject();
        jsonObject.put("activity_id", activityId);
        jsonObject.put("question_id", questionid);
        jsonObject.put("answer", answer);
        jsonObject.put("user_data", userDate);

        Log.w("getJsonDateFrom", String.format("json: %s", jsonObject.toString()));
        return jsonObject;
    }


}
