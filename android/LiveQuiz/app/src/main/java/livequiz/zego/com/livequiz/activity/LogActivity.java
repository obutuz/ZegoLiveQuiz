package livequiz.zego.com.livequiz.activity;

import android.os.Bundle;
import android.os.Handler;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;


import livequiz.zego.com.livequiz.R;
import livequiz.zego.com.livequiz.adapter.LogListAdapter;
import livequiz.zego.com.livequiz.application.ZegoApiManager;
import livequiz.zego.com.livequiz.module.ui.ModuleActivity;
import livequiz.zego.com.livequiz.utils.AppLogger;

public class LogActivity extends ModuleActivity {

    private AppLogger.OnLogChangedListener mLogDataChangedListener;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_log);

        final RecyclerView logView = findViewById(R.id.log_view_area);

        logView.setLayoutManager(new LinearLayoutManager(this));

        LogListAdapter adapter = new LogListAdapter(this);

        logView.setAdapter(adapter);

        adapter.setData(AppLogger.getInstance().getAllLog());

        mLogDataChangedListener = new AppLogger.OnLogChangedListener() {
            @Override
            public void onLogDataChanged() {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        LogListAdapter adapter = (LogListAdapter) logView.getAdapter();
                        adapter.setData(AppLogger.getInstance().getAllLog());
                    }
                });
            }
        };

        AppLogger.getInstance().registerLogChangedListener(mLogDataChangedListener);

        Button button = findViewById(R.id.update_log);
        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                ZegoApiManager.getInstance().getZegoLiveRoom().uploadLog();
                new Handler().postDelayed(new Runnable() {
                    public void run() {
                        Toast.makeText(LogActivity.this, getString(R.string.update_log_ok), Toast.LENGTH_LONG).show();
                    }
                }, 1000);

            }
        });
    }

    /**
     * Take care of popping the fragment back stack or finishing the activity
     * as appropriate.
     */
    @Override
    public void onBackPressed() {
        goBack();
    }


    private void goBack() {
        if (mLogDataChangedListener != null) {
            AppLogger.getInstance().unregisterLogChangedListener(mLogDataChangedListener);
        }
        finish();
    }
}
