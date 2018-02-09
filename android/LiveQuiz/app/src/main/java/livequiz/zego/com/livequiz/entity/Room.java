package livequiz.zego.com.livequiz.entity;

import java.io.Serializable;

/**
 * Created by zego on 2018/2/2.
 */

public class Room implements Serializable {


    public String room_id;
    public String room_name;
    public String anchor_id_name;
    public String anchor_nick_name;

    public String getRoom_id() {
        return room_id;
    }

    public void setRoom_id(String room_id) {
        this.room_id = room_id;
    }

    public String getRoom_name() {
        return room_name;
    }

    public void setRoom_name(String room_name) {
        this.room_name = room_name;
    }

    public String getAnchor_id_name() {
        return anchor_id_name;
    }

    public void setAnchor_id_name(String anchor_id_name) {
        this.anchor_id_name = anchor_id_name;
    }

    public String getAnchor_nick_name() {
        return anchor_nick_name;
    }

    public void setAnchor_nick_name(String anchor_nick_name) {
        this.anchor_nick_name = anchor_nick_name;
    }

}
