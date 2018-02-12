package livequiz.zego.com.livequiz.utils;


import android.app.Activity;
import android.content.Context;
import android.os.CountDownTimer;
import android.support.v4.content.ContextCompat;
import android.util.Log;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import livequiz.zego.com.livequiz.R;
import livequiz.zego.com.livequiz.entity.Options;

/**
 * Created by zego on 2018/2/5.
 */

public class AnswerDialog implements View.OnClickListener {

    RelativeLayout answerView;
    Context context;
    LinearLayout answer_list;
    TextView titleView, timer, count;
    FrameLayout countdownBackground;

    OnAnswerClick mOnAnswerClick;
    Map<String, View> imageMap = new HashMap<>();
    String activityId;
    String questionId;
    String index;
    String answer;
    String userData;


    String correct_answer;
    /**
     * 用户选择的答案
     */
    String userAnswer;

    public AnswerDialog(Activity activity, OnAnswerClick onAnswerClick) {
        this.mOnAnswerClick = onAnswerClick;
        this.context = activity.getApplicationContext();
        //填充对话框的布局
        answerView = activity.findViewById(R.id.answer_view);
        //答题显示题目
        answer_list = activity.findViewById(R.id.answer_list);
        //答题标题
        titleView = activity.findViewById(R.id.title);
        //答题倒计时控件
        timer = activity.findViewById(R.id.timer);
        //答题倒计时背景
        countdownBackground = activity.findViewById(R.id.countdown_bj);
        //当前是多少道题
        count = activity.findViewById(R.id.count);

    }


    /**
     * 添加答题视图
     */
    public void addAnswerView(List<Options> listAnswer) {
        AppLogger.getInstance().writeLog(this.getClass(), "addAnswerView ");

        count.setText(String.format("%s/12", getIndex()));
        isonClick = true;
        //清空视图和点击事件
        clearEventAndView(answer_list);
        if (answerView != null && listAnswer != null) {
            View answerView;
            for (Options options : listAnswer) {
                answerView = LayoutInflater.from(context).inflate(R.layout.answer_list, null);
                TextView answer = answerView.findViewById(R.id.answer);
                TextView option = answerView.findViewById(R.id.option);
                TextView sum_number = answerView.findViewById(R.id.sum_number);
                sum_number.setText("");
                answer.setText(String.format("%s .", options.getAnswer()));
                RelativeLayout relativeLayout = answerView.findViewById(R.id.selected);
                relativeLayout.setOnClickListener(this);
                relativeLayout.setTag(R.id.answer, options.getAnswer());
                relativeLayout.setTag(R.id.answer_view, answerView);

                option.setText(options.getOption());
                answer_list.addView(answerView);
            }
        }
    }

    /**
     * 设置题目标题
     *
     * @param title
     */
    public void setAnswerTitle(String title) {
        titleView.setText(title);
    }

    /**
     * 是否显示题目
     *
     * @param isShow
     */
    public void setIsShow(boolean isShow) {
        AppLogger.getInstance().writeLog(this.getClass(), "setIsShow isShow :%s",isShow);
        if (isShow) {

            answerView.setVisibility(View.VISIBLE);
        } else {
            answerView.setVisibility(View.GONE);
        }
    }

    public void countCancel(){
        if (mcountDownTimer != null) {
            mcountDownTimer.cancel();
        }
    }

    /**
     * 开始答题倒计时
     *
     * @param titme
     */
    public void startAnswerCountdown(int titme) {
        CountDownTimer mcountDownTimer = new CountDownTimer(titme, 1000) {// 第一个参数是总共时间，第二个参数是间隔触发时间
            @Override
            public void onTick(long millisUntilFinished) {
                //5
                long cont = millisUntilFinished / 1000;
                Log.w("live_zego", millisUntilFinished + "=");
                if (cont > 5) {
                    setTime(String.valueOf(cont - 2), R.dimen.font_35sp);
                    countdownBackground.setBackgroundResource(R.mipmap.countdown_seconds);
                } else if (cont <= 5) {
                    countdownBackground.setBackgroundResource(R.mipmap.countdown_three);
                    if (cont == 1) {
                        countCancel();
                        setIsShow(false);

                    } else {
                        if (cont == 2) {
                            setTime("时间到", R.dimen.font_14sp);
                        } else {
                            setTime(String.valueOf(cont - 2), R.dimen.font_35sp);
                        }
                    }
                }
            }

            @Override
            public void onFinish() {


            }
        };
        mcountDownTimer.start();

    }

    /**
     * 答题结果处理
     *
     * @param titme
     * @param answerStatList
     */
    public void resultsAnswerCountdown(int titme, List<Options> answerStatList) {
        int cont = answer_list.getChildCount();
        for (int i = 0; i < cont; i++) {
            View answerView = answer_list.getChildAt(i);
            RelativeLayout mRelativeLayout = answerView.findViewById(R.id.selected);
            TextView answer = answerView.findViewById(R.id.answer);
            TextView option = answerView.findViewById(R.id.option);
            TextView sumNumber = answerView.findViewById(R.id.sum_number);
            answer.setTextColor(ContextCompat.getColor(context, R.color.text_color_under_common_headings));
            option.setTextColor(ContextCompat.getColor(context, R.color.text_color_under_common_headings));
            String answerStr = (String) mRelativeLayout.getTag(R.id.answer);
            for (Options mOptions : answerStatList) {
                if (answerStr.equals(mOptions.getAnswer())) {
                    sumNumber.setText(mOptions.getUser_count());
                    break;
                }
            }

            if (correct_answer.equals(answerStr) ) {
                mRelativeLayout.setBackgroundResource(R.drawable.trueok);
            } else {
                if (answerStr.equals(userAnswer) && !answerStr.equals(correct_answer)) {
                    mRelativeLayout.setBackgroundResource(R.drawable.wrong);
                } else {
                    mRelativeLayout.setBackgroundResource(R.drawable.other);
                }
            }

        }
        timer.setText("");
        if (correct_answer.equals(userAnswer)) {
            timer.setBackgroundResource(R.mipmap.ok);
            countdownBackground.setBackgroundResource(R.mipmap.green_background);
        } else {
            timer.setBackgroundResource(R.mipmap.wrong);
            countdownBackground.setBackgroundResource(R.mipmap.countdown_three);
        }

        mcountDownTimer = new CountDownTimer(titme, 1000) {// 第一个参数是总共时间，第二个参数是间隔触发时间
            @Override
            public void onTick(long millisUntilFinished) {

            }

            @Override
            public void onFinish() {
                setIsShow(false);
                countCancel();
            }
        };
        mcountDownTimer.start();

    }

    CountDownTimer mcountDownTimer;

    /**
     * 清空所有视图和事件
     *
     * @param view
     */
    private void clearEventAndView(ViewGroup view) {
        timer.setBackgroundResource(0);
        int cont = view.getChildCount();
        for (int i = 0; i < cont; i++) {
            View onClickView = view.getChildAt(i);
            onClickView.setOnClickListener(null);
        }
        imageMap.clear();
        view.removeAllViews();
    }


    /**
     * 设置时间文字
     *
     * @param data
     */
    private void setTime(String data, int id) {
        timer.setText(data);
        timer.setTextSize(TypedValue.COMPLEX_UNIT_PX, context.getResources().getDimension(id));
    }

    boolean isonClick = true;

    @Override
    public void onClick(View image) {
        if (isonClick) {
            isonClick = false;
            answer = (String) image.getTag(R.id.answer);
            View answerView = (View) image.getTag(R.id.answer_view);
            RelativeLayout mRelativeLayout = (RelativeLayout) image;
            mRelativeLayout.setBackgroundResource(R.drawable.selected);
            TextView optionText = answerView.findViewById(R.id.option);
            optionText.setTextColor(ContextCompat.getColor(context, R.color.color_white));
            TextView answerText = answerView.findViewById(R.id.answer);
            answerText.setTextColor(ContextCompat.getColor(context, R.color.color_white));
            userAnswer = answer;
            mOnAnswerClick.onClick(activityId, questionId, answer, "123456");
        }
    }


    public String getActivityId() {
        return activityId;
    }

    public void setActivityId(String activityId) {
        this.activityId = activityId;
    }

    public String getQuestionId() {
        return questionId;
    }

    public void setQuestionId(String questionId) {
        this.questionId = questionId;
    }

    public String getAnswer() {
        return answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }

    public String getUserData() {
        return userData;
    }

    public void setUserData(String userData) {
        this.userData = userData;
    }

    public String getIndex() {
        return index;
    }

    public void setIndex(String index) {
        this.index = index;
    }


    public String getCorrect_answer() {
        return correct_answer;
    }

    public void setCorrect_answer(String correct_answer) {
        this.correct_answer = correct_answer;
    }


    public interface OnAnswerClick {

        public void onClick(String activityId, String questionId, String answer, String s);
    }


}
