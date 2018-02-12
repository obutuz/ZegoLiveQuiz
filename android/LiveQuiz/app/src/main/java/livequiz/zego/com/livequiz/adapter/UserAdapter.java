package livequiz.zego.com.livequiz.adapter;

import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

import java.util.ArrayList;
import java.util.List;

import livequiz.zego.com.livequiz.R;
import livequiz.zego.com.livequiz.entity.User;


/**
 * Created by zego on 2018/2/6.
 */

public class UserAdapter extends RecyclerView.Adapter {

    List<User> list = new ArrayList<>();


    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.user_list, parent, false);
        MyViewHolder viewHolder = new MyViewHolder(v);
        return viewHolder;
    }

    @Override
    public void onBindViewHolder(final RecyclerView.ViewHolder holder, int position) {
        final MyViewHolder myViewHolder = (MyViewHolder) holder;
        myViewHolder.room_name.setText(list.get(position).getNick_name());
    }

    @Override
    public int getItemCount() {
        return list.size();
    }

    public void refreshMsgTolist(List<User> userList) {
        list = userList;
        notifyDataSetChanged();
    }

    public static class MyViewHolder extends RecyclerView.ViewHolder {
        TextView room_name;

        public MyViewHolder(View itemView) {
            super(itemView);
            room_name = itemView.findViewById(R.id.room_name);
        }
    }


}

