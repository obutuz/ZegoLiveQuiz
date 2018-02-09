package livequiz.zego.com.livequiz.entity;

import java.io.Serializable;

/**
 * Created by zego on 2018/2/6.
 */

public class BigMessage implements Serializable {

    public String content;
    public String fromUserID;
    public String fromUserName;

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getFromUserID() {
        return fromUserID;
    }

    public void setFromUserID(String fromUserID) {
        this.fromUserID = fromUserID;
    }

    public String getFromUserName() {
        return fromUserName;
    }

    public void setFromUserName(String fromUserName) {
        this.fromUserName = fromUserName;
    }
}
