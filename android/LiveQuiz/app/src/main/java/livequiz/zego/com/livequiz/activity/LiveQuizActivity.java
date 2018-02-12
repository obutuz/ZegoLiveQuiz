package livequiz.zego.com.livequiz.activity;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.databinding.DataBindingUtil;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.annotation.Nullable;
import android.support.v7.widget.DefaultItemAnimator;
import android.support.v7.widget.LinearLayoutManager;
import android.text.TextUtils;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.widget.TextView;

import com.zego.zegoliveroom.ZegoLiveRoom;
import com.zego.zegoliveroom.callback.IZegoLivePlayerCallback;
import com.zego.zegoliveroom.callback.IZegoLoginCompletionCallback;
import com.zego.zegoliveroom.callback.IZegoMediaSideCallback;
import com.zego.zegoliveroom.callback.IZegoRelayCallback;
import com.zego.zegoliveroom.callback.IZegoRoomCallback;
import com.zego.zegoliveroom.callback.im.IZegoBigRoomMessageCallback;
import com.zego.zegoliveroom.callback.im.IZegoIMCallback;
import com.zego.zegoliveroom.constants.ZegoConstants;
import com.zego.zegoliveroom.constants.ZegoIM;
import com.zego.zegoliveroom.constants.ZegoRelay;
import com.zego.zegoliveroom.entity.ZegoBigRoomMessage;
import com.zego.zegoliveroom.entity.ZegoConversationMessage;
import com.zego.zegoliveroom.entity.ZegoRoomMessage;
import com.zego.zegoliveroom.entity.ZegoStreamInfo;
import com.zego.zegoliveroom.entity.ZegoStreamQuality;
import com.zego.zegoliveroom.entity.ZegoUser;
import com.zego.zegoliveroom.entity.ZegoUserState;

import org.json.JSONException;
import org.json.JSONObject;

import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import livequiz.zego.com.livequiz.R;
import livequiz.zego.com.livequiz.adapter.RoomMsgAdapter;
import livequiz.zego.com.livequiz.application.ZegoApiManager;
import livequiz.zego.com.livequiz.databinding.ActivityLiveQuizBinding;
import livequiz.zego.com.livequiz.dialog.SumDialog;
import livequiz.zego.com.livequiz.dialog.WinningBonusDialog;
import livequiz.zego.com.livequiz.entity.BigMessage;
import livequiz.zego.com.livequiz.entity.Options;
import livequiz.zego.com.livequiz.entity.SerializableMap;
import livequiz.zego.com.livequiz.entity.User;
import livequiz.zego.com.livequiz.module.ui.ModuleActivity;
import livequiz.zego.com.livequiz.utils.AnswerDialog;
import livequiz.zego.com.livequiz.utils.AppLogger;
import livequiz.zego.com.livequiz.utils.SystemUtil;
import livequiz.zego.com.livequiz.utils.ZegoCommon;
import livequiz.zego.com.livequiz.utils.ZegoStream;


public class LiveQuizActivity extends ModuleActivity {

    private SerializableMap roomMap = null;
    private ZegoLiveRoom mZegoLiveRoom = ZegoApiManager.getInstance().getZegoLiveRoom();
    final int ANSWER_DIALOG = 0;
    final int ATATISTICS_ANSWER = 1;
    final int SUM_ANSWER = 3;
    int mediaSeq = -1;

    public ActivityLiveQuizBinding binding;
    /**
     * 流
     */
    private ZegoStream mZegoStream;

    /**
     * 标记app是否在后台.
     */
    private boolean mIsAppInBackground = true;
    /**
     * 房间ID
     */
    private String room_id;
    /**
     * 题目去重map
     */
    private Map<String, Boolean> question = new HashMap<>();
    /**
     * 答案去重map
     */
    private Map<String, Boolean> answer = new HashMap<>();
    /**
     * 汇总去重map
     */
    private Map<String, Boolean> activity_id = new HashMap<>();

    AnswerDialog answerDialog;
    String stream_id;

    @SuppressLint("HandlerLeak")
    Handler retryHandler = new Handler() {
        @Override
        public void handleMessage(final Message msg) {
            //答题内容
            final String relayDate = (String) msg.obj;
            //发送答题信息
            mZegoLiveRoom.relay(ZegoRelay.RelayTypeDati, relayDate, new IZegoRelayCallback() {
                @Override
                public void onRelay(int errorCode, String roomID, String relayResult) {
                    int msgWhat = msg.what;
                    AppLogger.getInstance().writeLog(this.getClass(), "onRelay errorCode:%d  roomID:%s   relayResult:%s  relayDate:%s  msgWhat:%s", errorCode, roomID, relayResult, relayDate, msgWhat);
                    //如果发送失败,则1秒重复发送一次
                    if (errorCode != 0 && msgWhat < 5) {
                        msgWhat = msgWhat + 1;
                        retryHandler.sendMessageDelayed(retryHandler.obtainMessage(msgWhat, relayDate), 1000);
                    }
                }
            });
        }
    };


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        binding = DataBindingUtil.setContentView(this, R.layout.activity_live_quiz);
        if (getIntent() != null) {
            roomMap = (SerializableMap) getEntity("room");
            initView();
            //拉流
            startPlay();
            answerDialog = new AnswerDialog(this, onAnswerClick);

        }


    }

    RoomMsgAdapter roomAdapter = new RoomMsgAdapter();

    private void initView() {
        LinearLayoutManager mLinearLayoutManager = new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false);
        mLinearLayoutManager.setStackFromEnd(true);
        binding.roomUserList.setLayoutManager(mLinearLayoutManager);
        // 设置adapter
        binding.roomUserList.setAdapter(roomAdapter);
        // 设置Item添加和移除的动画
        binding.roomUserList.setItemAnimator(new DefaultItemAnimator());

        binding.editSend.setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView textView, int actionId, KeyEvent event) {
                String msg = textView.getText().toString();
                AppLogger.getInstance().writeLog(this.getClass(), "onEditorAction msg:%s ", msg);
                textView.setText("");
                if (!"".equals(msg) && msg != null) {
                    sendBigRoomMsg(msg);
                }
                return true;
            }
        });
        binding.backImage.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        binding.logLook.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                /**
                 * 跳转Activity
                 */
                stcartActivity(LiveQuizActivity.this, LogActivity.class, null);
            }
        });
    }

    /**
     * 发送房间不可靠消息
     *
     * @param msg 消息内容
     */
    private void sendBigRoomMsg(String msg) {
        AppLogger.getInstance().writeLog(this.getClass(), "sendBigRoomMsg msg %s", msg);
        BigMessage bigMessage = new BigMessage();
        bigMessage.setContent(msg);
        bigMessage.setFromUserName(android.os.Build.MODEL);
        roomAdapter.addMsgToString(bigMessage);
        mZegoLiveRoom.sendBigRoomMessage(ZegoIM.MessageType.Text, ZegoIM.MessageCategory.Chat, msg, new IZegoBigRoomMessageCallback() {
            @Override
            public void onSendBigRoomMessage(int errorCode, String roomID, String messageID) {
                AppLogger.getInstance().writeLog(this.getClass(), "sendBigRoomMsg errorCode %d  roomID %s  messageID  %s", errorCode, roomID, messageID);

            }
        });

    }


    @SuppressLint("HandlerLeak")
    Handler handler = new Handler() {

        @Override
        public void handleMessage(Message msg) {
            if (msg.what == ANSWER_DIALOG) {
                Map<String, Object> map = (Map<String, Object>) msg.obj;
                List<Options> optionsList = (List<Options>) map.get("optionsList");
                String title = (String) map.get("title");
                String index = (String) map.get("index");
                String id = (String) map.get("id");
                String activity_id = (String) map.get("activity_id");
                answerDialog(optionsList, title, activity_id, id, index);
            } else if (msg.what == ATATISTICS_ANSWER) {
                Map<String, Object> map = (Map<String, Object>) msg.obj;
                List<Options> answerStatList = (List<Options>) map.get("answer_statList");
                String correctAnswer = (String) map.get("correct_answer");
                String id = (String) map.get("id");
                String activity_id = (String) map.get("activity_id");
                atatisticsAnswer(answerStatList, activity_id, id, correctAnswer);
            } else if (msg.what == SUM_ANSWER) {
                Map<String, Object> map = (Map<String, Object>) msg.obj;
                List<User> user_list = (List<User>) map.get("user_list");
                String room_id = (String) map.get("room_id");
                String activity_id = (String) map.get("activity_id");
                sumAnswer(room_id, activity_id, user_list);

            }


        }


    };


    private void startPlay() {

        List<Map<String, String>> stream_info = (List<Map<String, String>>) roomMap.getMap().get("stream_info");
        stream_id = stream_info.get(0).get("stream_id");
        room_id = (String) roomMap.getMap().get("room_id");
        Log.w("zego_live:", String.format("stream_id : %s room_id : %s", stream_id, room_id));
        mZegoStream = new ZegoStream(stream_info.get(0).get("stream_id"), binding.liveView);

        /**
         * 登陆房间
         */
        mZegoLiveRoom.loginRoom((String) roomMap.getMap().get("room_id"), ZegoConstants.RoomRole.Audience, new IZegoLoginCompletionCallback() {
            @Override
            public void onLoginCompletion(int errCode, ZegoStreamInfo[] zegoStreamInfos) {

                AppLogger.getInstance().writeLog(this.getClass(), "to loginRoom state: %d  zegoStreamSize : %d", errCode, zegoStreamInfos.length);

                if (errCode == 0) {

                    for (ZegoStreamInfo streamInfo : zegoStreamInfos) {
                        if (!TextUtils.isEmpty(streamInfo.extraInfo)) {
                            ZegoUser zegoUser = new ZegoUser();
                            zegoUser.userID = streamInfo.userID;
                            zegoUser.userName = streamInfo.userName;
                            AppLogger.getInstance().writeLog(this.getClass(), "userID :%s userName :%s ", zegoUser.userID, zegoUser.userName);
                        }
                    }

                }
            }
        });

        mZegoLiveRoom.setZegoLivePlayerCallback(new IZegoLivePlayerCallback() {
            @Override
            public void onPlayStateUpdate(int errCode, String streamID) {

            }

            @Override
            public void onPlayQualityUpdate(String streamID, ZegoStreamQuality zegoStreamQuality) {

            }

            @Override
            public void onInviteJoinLiveRequest(int i, String s, String s1, String s2) {

            }

            @Override
            public void onRecvEndJoinLiveCommand(String s, String s1, String s2) {

            }

            @Override
            public void onVideoSizeChangedTo(String s, int width, int height) {



            }

        });

        mZegoLiveRoom.setZegoRoomCallback(new IZegoRoomCallback() {
            @Override
            public void onKickOut(int reason, String roomID) {

            }

            @Override
            public void onDisconnect(int errorCode, String roomID) {

            }

            @Override
            public void onReconnect(int i, String s) {

            }

            @Override
            public void onTempBroken(int i, String s) {

            }

            @Override
            public void onStreamUpdated(final int type, final ZegoStreamInfo[] listStream, final String roomID) {

            }

            @Override
            public void onStreamExtraInfoUpdated(ZegoStreamInfo[] zegoStreamInfos, String s) {

            }

            @Override
            public void onRecvCustomCommand(String userID, String userName, String content, String roomID) {

            }
        });


        /**
         * 设置回调,接收媒体次要信息
         */
        mZegoLiveRoom.setZegoMediaSideCallback(new IZegoMediaSideCallback() {
            @Override
            public void onRecvMediaSideInfo(String streamID, ByteBuffer byteBuffer, int dataLen) {
                try {
                    if (dataLen == 0) {
                        AppLogger.getInstance().writeLog(this.getClass(), "onRecvMediaSideInfo data is empty");
                        return;
                    }
                    //转换成JSONObject格式
                    JSONObject jsonObject = ZegoCommon.getInstance().getJsonObjectFrom(byteBuffer, dataLen);
                    JSONObject jsonObjectData = jsonObject.getJSONObject("data");
                    /**
                     * 显示答题
                     */
                    if (!jsonObject.isNull("type") && "question".equals(jsonObject.getString("type"))) {
                        if (question.containsKey(jsonObjectData.getString("id")) && question.get(jsonObjectData.getString("id"))) {
                            AppLogger.getInstance().writeLog(this.getClass(), "the question_id to weight question");
                            return;
                        } else {
                            question.put(jsonObjectData.getString("id"), true);
                            AppLogger.getInstance().writeLog(this.getClass(), "add question_id  to weight question");

                        }
                        //转换成map格式
                        Map<String, Object> map = ZegoCommon.getInstance().getMapFromJsonToMapQuestion(jsonObjectData);
                        //当前线程是子线程,需要用handler在主线程控制
                        handler.sendMessage(handler.obtainMessage(ANSWER_DIALOG, map));
                        /**
                         * 答案处理
                         */
                    } else if (!jsonObject.isNull("type") && "answer".equals(jsonObject.getString("type"))) {
                        if (answer.containsKey(jsonObjectData.getString("id")) && answer.get(jsonObjectData.getString("id"))) {
                            AppLogger.getInstance().writeLog(this.getClass(), "the answer_id to weight answer");
                            return;
                        } else {
                            AppLogger.getInstance().writeLog(this.getClass(), "add answer_id to weight answer");
                            answer.put(jsonObjectData.getString("id"), true);
                        }
                        //转换成map格式
                        Map<String, Object> map = ZegoCommon.getInstance().getMapFromJsonToMapAnswer(jsonObjectData);
                        //当前线程是子线程,需要用handler在主线程控制
                        handler.sendMessage(handler.obtainMessage(ATATISTICS_ANSWER, map));
                        /**
                         * 汇总处理
                         */
                    } else if (!jsonObject.isNull("type") && "sum".equals(jsonObject.getString("type"))) {
                        if (activity_id.containsKey(jsonObjectData.getString("activity_id")) && activity_id.get(jsonObjectData.getString("activity_id"))) {
                            AppLogger.getInstance().writeLog(this.getClass(), "the activity_id to weight sum");
                            return;
                        } else {
                            AppLogger.getInstance().writeLog(this.getClass(), "add activity_id to weight sum");
                            activity_id.put(jsonObjectData.getString("activity_id"), true);
                        }
                        //转换成map格式
                        Map<String, Object> map = ZegoCommon.getInstance().getMapFromJsonToMapSum(jsonObjectData);
                        //当前线程是子线程,需要用handler在主线程控制
                        handler.sendMessage(handler.obtainMessage(SUM_ANSWER, map));
                    }

                } catch (org.json.JSONException e) {
                    AppLogger.getInstance().writeLog(this.getClass(), "json data is conversion exception");

                    e.printStackTrace();
                }
            }
        });

        mZegoLiveRoom.setZegoIMCallback(new IZegoIMCallback() {
            @Override
            public void onUserUpdate(ZegoUserState[] zegoUserStates, int i) {

            }

            @Override
            public void onRecvRoomMessage(String s, ZegoRoomMessage[] zegoRoomMessages) {

            }

            @Override
            public void onRecvConversationMessage(String s, String s1, ZegoConversationMessage zegoConversationMessage) {

            }

            @Override
            public void onUpdateOnlineCount(String roomId, int onlineCount) {
                if (roomId != null && roomId.equals(room_id)) {
                    binding.currentQueueCount.setText(String.valueOf(onlineCount));
                }
            }

            @Override
            public void onRecvBigRoomMessage(String roomID, ZegoBigRoomMessage[] zegoBigRoomMessages) {
                if (roomID == null && !roomID.equals(room_id)) {
                    AppLogger.getInstance().writeLog(this.getClass(), "receive big room message, but roomId mismatch, abandon roomId:%s", roomID);
                    return;
                }
                if (zegoBigRoomMessages.length == 0) {
                    AppLogger.getInstance().writeLog(this.getClass(), "receive big room message, but messageList is 0 zegoBigRoomMessages:%d", zegoBigRoomMessages.length);
                    return;
                }
                AppLogger.getInstance().writeLog(this.getClass(), "onRecvBigRoomMessage Im receive  roomID: %s", roomID);
                for (int i = 0; i < zegoBigRoomMessages.length; i++) {
                    BigMessage bigMessage = new BigMessage();
                    bigMessage.setContent(zegoBigRoomMessages[i].content);
                    bigMessage.setFromUserName(zegoBigRoomMessages[i].fromUserName);
                    AppLogger.getInstance().writeLog(this.getClass(), "onRecvBigRoomMessage Im receive  content: %s userName: %s", zegoBigRoomMessages[i].content, zegoBigRoomMessages[i].fromUserName);
                    roomAdapter.addMsgToString(bigMessage);
                }
            }
        });

    }


    /**
     * 汇总窗口弹出
     *
     * @param room_id     房间id
     * @param activity_id 活动ID
     * @param user_list   用户列表
     */
    private void sumAnswer(String room_id, String activity_id, List<User> user_list) {
        AppLogger.getInstance().writeLog(this.getClass(), "sumAnswer room_id : %s activityId %s", room_id, activity_id);
        if (room_id.equals(this.room_id)) {
            SumDialog sumDialog = new SumDialog(LiveQuizActivity.this);
            sumDialog.sumWindowDialog(user_list);
        }
    }


    /**
     * 答题窗口
     *
     * @param optionsList
     */
    private void answerDialog(List<Options> optionsList, String title, String activityId, String id, String index) {
        AppLogger.getInstance().writeLog(this.getClass(), "answerDialog title : %s activityId : %s id :%s index : %s", title, activityId, id, index);
        answerDialog.setIsShow(true);
        answerDialog.setActivityId(activityId);
        answerDialog.setQuestionId(id);
        answerDialog.setIndex(index);
        answerDialog.addAnswerView(optionsList);
        answerDialog.setAnswerTitle(title);
        answerDialog.startAnswerCountdown(8000);
    }


    /**
     * 答案窗口
     */
    private void atatisticsAnswer(List<Options> answerStatList, String activityId, String id, String correct_answer) {
        AppLogger.getInstance().writeLog(this.getClass(), "current activityId : %s  answerDialog activityId : %s id :%s correct_answer : %s", answerDialog.getActivityId(), activityId, id, correct_answer);
        if (activityId.equals(answerDialog.getActivityId())) {
            answerDialog.setIsShow(true);
            answerDialog.setCorrect_answer(correct_answer);
            answerDialog.resultsAnswerCountdown(4000, answerStatList);

        }
    }


    /**
     * 用户选择题目监听事件
     */
    AnswerDialog.OnAnswerClick onAnswerClick = new AnswerDialog.OnAnswerClick() {
        @Override
        public void onClick(String activityId, String questionId, String answer, String userDate) {
            AppLogger.getInstance().writeLog(this.getClass(),
                    "onAnswerClick onClick activityId : %s questionId : %s answer : %s userDate :%s", activityId, questionId, answer, userDate);
            try {
                String relayDate = ZegoCommon.getInstance().getJsonDateFrom(activityId, questionId, answer, userDate).toString();
                retryHandler.sendMessage(retryHandler.obtainMessage(0, relayDate));
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
    };


    @Override
    protected void onResume() {
        super.onResume();
        if (mIsAppInBackground) {
            mIsAppInBackground = false;
            /**
             * 播放流
             */
            mZegoStream.playStream(100, stream_id);
            AppLogger.getInstance().writeLog(this.getClass(),
                    "PlayActivity: App comes to foreground");


        }
    }

    @Override
    protected void onStop() {
        super.onStop();
        if (!SystemUtil.isAppForeground()) {
            mIsAppInBackground = true;
            AppLogger.getInstance().writeLog(this.getClass(),
                    "PlayActivity: App goes to background");

            if (mZegoStream != null) {
                mZegoStream.stopPlayStream();
            }
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (mZegoStream != null) {
            AppLogger.getInstance().writeLog(this.getClass(),
                    "PlayActivity: App onDestroy");
            mZegoStream.stopPlayStream();
        }
    }
}
