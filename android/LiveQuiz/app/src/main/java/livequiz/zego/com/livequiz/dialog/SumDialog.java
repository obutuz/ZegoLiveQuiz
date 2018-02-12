package livequiz.zego.com.livequiz.dialog;

import android.content.Context;
import android.support.v7.app.AlertDialog;
import android.support.v7.widget.DefaultItemAnimator;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.StaggeredGridLayoutManager;
import android.util.DisplayMetrics;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.TextView;

import java.util.List;

import livequiz.zego.com.livequiz.R;
import livequiz.zego.com.livequiz.adapter.UserAdapter;
import livequiz.zego.com.livequiz.entity.User;

/**
 * Created by zego on 2018/2/11.
 */

public class SumDialog {

    private Context context;

    public SumDialog(Context context) {
        this.context = context;

    }

    /**
     * 汇总弹出窗口
     *
     * @return
     */
    public AlertDialog sumWindowDialog(List<User> userList) {
        android.support.v7.app.AlertDialog.Builder builder = new android.support.v7.app.AlertDialog.Builder(context, R.style.LoadDialog);
        View view = View
                .inflate(context, R.layout.sum_dialog, null);
        builder.setView(view);
        builder.setCancelable(true);
        AlertDialog dialog = builder.create();

        RecyclerView userRecyclerView = view.findViewById(R.id.the_winners);
        UserAdapter userAdapter = new UserAdapter();
        userRecyclerView.setLayoutManager(new StaggeredGridLayoutManager(3, StaggeredGridLayoutManager.VERTICAL));
        // 设置adapter
        userRecyclerView.setAdapter(userAdapter);
        // 设置Item添加和移除的动画
        userRecyclerView.setItemAnimator(new DefaultItemAnimator());
        // 设置汇总用户信息
        userAdapter.refreshMsgTolist(userList);
        TextView numberStatistics = view.findViewById(R.id.number_statistics);
        numberStatistics.setText(String.format("%d人通关", userList.size()));

        //获得当前窗体
        Window window = dialog.getWindow();
        //设置为顶部
        WindowManager.LayoutParams lp = window.getAttributes();
        window.setGravity(Gravity.CENTER_HORIZONTAL | Gravity.TOP);
        window.setAttributes(lp);
        dialog.show();

        dialog.setCanceledOnTouchOutside(false);
        return dialog;
    }



}
