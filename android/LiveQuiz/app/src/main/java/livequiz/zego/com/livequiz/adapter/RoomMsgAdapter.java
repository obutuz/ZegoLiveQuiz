package livequiz.zego.com.livequiz.adapter;

import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import livequiz.zego.com.livequiz.R;
import java.util.ArrayList;
import java.util.List;

import livequiz.zego.com.livequiz.entity.BigMessage;


/**
 * Created by zego on 2018/2/6.
 */

public class RoomMsgAdapter extends RecyclerView.Adapter {

    List<BigMessage> list = new ArrayList<>();


    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {

        View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.message_list, parent, false);

        MyViewHolder viewHolder = new MyViewHolder(v);

        return viewHolder;

    }


    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int position) {
        MyViewHolder myViewHolder = (MyViewHolder) holder;
        myViewHolder.textView.setText(String.format("%s : %s", list.get(position).getFromUserName(), list.get(position).getContent()));

    }

    @Override
    public int getItemCount() {
        return list.size();
    }

    public void addMsgToString(BigMessage msg) {
        List<BigMessage> mlist = new ArrayList();
        mlist.addAll(list);
        mlist.add(msg);
        list.clear();
        list = mlist;
        notifyDataSetChanged();
    }

    public static class MyViewHolder extends RecyclerView.ViewHolder {
        TextView textView;

        public MyViewHolder(View itemView) {
            super(itemView);
            textView = itemView.findViewById(R.id.msg);
        }
    }

}

