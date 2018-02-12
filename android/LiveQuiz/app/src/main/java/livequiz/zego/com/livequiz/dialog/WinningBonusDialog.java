package livequiz.zego.com.livequiz.dialog;

import android.content.Context;
import android.support.v7.app.AlertDialog;
import android.support.v7.widget.DefaultItemAnimator;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.StaggeredGridLayoutManager;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.TextView;

import livequiz.zego.com.livequiz.R;
import livequiz.zego.com.livequiz.adapter.UserAdapter;

/**
 * Created by zego on 2018/2/12.
 */

public class WinningBonusDialog {


    private Context context;

    public WinningBonusDialog(Context context) {
        this.context = context;
    }

    public void showInningBonusDialog() {
        android.support.v7.app.AlertDialog.Builder builder = new android.support.v7.app.AlertDialog.Builder(context, R.style.LoadDialog);
        View view = View
                .inflate(context, R.layout.winning_bonus_dialog, null);
        builder.setView(view);
        builder.setCancelable(true);
        AlertDialog dialog = builder.create();

        //获得当前窗体
        Window window = dialog.getWindow();
        //设置为顶部
        WindowManager.LayoutParams lp = window.getAttributes();
        window.setGravity(Gravity.CENTER_HORIZONTAL | Gravity.CENTER_VERTICAL);
        window.setAttributes(lp);
        dialog.show();

    }
}
