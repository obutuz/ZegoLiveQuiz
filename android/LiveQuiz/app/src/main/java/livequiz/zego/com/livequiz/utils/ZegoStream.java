package livequiz.zego.com.livequiz.utils;

import android.text.TextUtils;
import android.view.TextureView;
import android.view.View;

import com.zego.zegoliveroom.ZegoLiveRoom;
import com.zego.zegoliveroom.constants.ZegoVideoViewMode;

import livequiz.zego.com.livequiz.application.ZegoApiManager;

/**
 * Copyright © 2017 Zego. All rights reserved.
 */

public class ZegoStream {
    static final String STREAM_NOT_EXIST = "STREAM_NOT_EXIST_";


    private String mStreamID;

    private TextureView mTextureView;

    private ZegoLiveRoom mZegoLiveRoom;

    public ZegoStream(String streamID, TextureView textureView) {
        if (TextUtils.isEmpty(streamID)) {
            mStreamID = STREAM_NOT_EXIST + System.currentTimeMillis();

        } else {
            mStreamID = streamID;

        }
        mTextureView = textureView;
        mZegoLiveRoom = ZegoApiManager.getInstance().getZegoLiveRoom();
    }


    public void playStream(int volume,String  mStreamID){
        // 空流不用播放
        if (mStreamID.startsWith(STREAM_NOT_EXIST)) {
            return;
        }
        mZegoLiveRoom.startPlayingStream(mStreamID, mTextureView);
        mZegoLiveRoom.setViewMode(ZegoVideoViewMode.ScaleAspectFit, mStreamID);
        mZegoLiveRoom.setPlayVolume(volume, mStreamID);
    }

    public void stopPlayStream() {
        if (mStreamID.startsWith(STREAM_NOT_EXIST)) {
            return;
        }

        mZegoLiveRoom.stopPlayingStream(mStreamID);
    }

    public String getStreamID() {
        return mStreamID;
    }



    public void show() {
        mTextureView.setVisibility(View.VISIBLE);
        mZegoLiveRoom.setPlayVolume(100, mStreamID);
    }

    public void hide() {
        mTextureView.setVisibility(View.INVISIBLE);
        mZegoLiveRoom.setPlayVolume(0, mStreamID);
    }
}
