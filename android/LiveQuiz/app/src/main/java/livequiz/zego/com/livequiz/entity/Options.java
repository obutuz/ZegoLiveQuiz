package livequiz.zego.com.livequiz.entity;

import java.io.Serializable;

/**
 * Created by zego on 2018/2/5.
 */

public class Options implements Serializable {


    private String answer;


    private String option;


    private String user_count;

    public void setOption(String option) {
        this.option = option;
    }

    public String getAnswer() {
        return answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }

    public String getOption() {
        return option;
    }

    public String getUser_count() {
        return user_count;
    }

    public void setUser_count(String user_count) {
        this.user_count = user_count;
    }

}
