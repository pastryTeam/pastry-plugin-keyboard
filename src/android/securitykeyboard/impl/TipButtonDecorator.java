package asp.citic.ptframework.plugin.keyboards.securitykeyboard.impl;

import android.content.Context;
import android.content.res.Resources;
import android.graphics.Color;
import android.graphics.drawable.BitmapDrawable;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnTouchListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.LinearLayout.LayoutParams;
import android.widget.PopupWindow;

import asp.citic.ptframework.common.device.PTDeviceUtil;
import asp.citic.ptframework.plugin.keyboards.securitykeyboard.tools.PTInvokeLater;


/**
 * 系统名称: 中信网科移动基础框架-Pastry<br />
 * 模块名称: <br />
 * 软件版权: Copyright (c) 2016 CHINA ASP CITIC<br />
 * 功能说明: <br />
 * 系统版本: 1.0<br />
 * 相关文档: <br />
 * .<br />
 * <b>修订记录</b>
 * <table>
 * <tr>
 * <td>日期</td>
 * <td>编号</td>
 * <td>修改人</td>
 * <td>备注</td>
 * </tr>
 * <tr>
 * <td>Apr 7, 20163:53:15 PM </td>
 * <td>0000</td>
 * <td>majian</td>
 * <td>创建</td>
 * </tr>
 * </table>
 *
 * @author majian
 * @version 1.0
 * @since 1.0
 */
public class TipButtonDecorator implements ViewDecorator{
	private PopupWindow popupWindow;
	private OnTouchListener touchListener;
	private float textSize;
	private LayoutParams lp;
	private Context context;
	private Resources mResources;

	/**
	 * @param parent
	 */
	public TipButtonDecorator(final View parent) {
		context = parent.getContext();
		mResources = context.getResources();
		popupWindow = new PopupWindow(context);
		final Button tipBtn = new Button(context);
		tipBtn.setBackgroundColor(Color.WHITE);
		tipBtn.setGravity(Gravity.CENTER | Gravity.TOP);
		tipBtn.setTextSize(PTDeviceUtil.sp2px(18));
		tipBtn.setTextColor(Color.BLACK);
		popupWindow.setContentView(tipBtn);
		popupWindow.setWidth(PTDeviceUtil.dip2px(70));
		popupWindow.setHeight(PTDeviceUtil.dip2px(135));
		popupWindow.setFocusable(false);
		popupWindow.setTouchable(false);
		popupWindow.setBackgroundDrawable(new BitmapDrawable(context.getResources()));
		int txtSizeId = mResources.getIdentifier("cyberpay_fw_key_textSize", "dimen", context.getPackageName());
		textSize = context.getResources().getDimension(txtSizeId);

		int sp = PTDeviceUtil.dip2px(3);
		lp = new LayoutParams(0,ViewGroup.LayoutParams.MATCH_PARENT);
		lp.weight = 1;
		lp.setMargins(sp, sp, sp, sp);

		touchListener = new OnTouchListener() {
			private boolean needHide;

			private Runnable tipHideTask = new Runnable() {

				@Override
				public void run() {
					if(needHide){
						popupWindow.dismiss();
					}
				}
			};

			@Override
			public boolean onTouch(View v, MotionEvent event) {
				if(event.getAction()==MotionEvent.ACTION_DOWN){
					needHide = false;

					tipBtn.setText(((Button)v).getText());

					int[] location = new int[2];
					v.getLocationOnScreen(location);
					int w = v.getWidth();
					int x = 0;
					//超出右边视窗
					if((popupWindow.getWidth()/2 + location[0] + w/2) > PTDeviceUtil.getScreenWidth()){
						int rightResId = mResources.getIdentifier("fw_select_right", "drawable", context.getPackageName());
						popupWindow.getContentView().setBackgroundResource(rightResId);
						x = location[0] + w - popupWindow.getWidth() + 3;
					}else if(location[0] + w/2 -popupWindow.getWidth()/2 < 0 ){
						int leftResId = mResources.getIdentifier("fw_select_left", "drawable", context.getPackageName());
						popupWindow.getContentView().setBackgroundResource(leftResId);
						x = location[0];
					}else{
						int middleResId = mResources.getIdentifier("fw_select_middle", "drawable", context.getPackageName());
						popupWindow.getContentView().setBackgroundResource(middleResId);
						x = location[0]-(popupWindow.getWidth()-w)/2;
					}
					int y = (int) (location[1]-popupWindow.getHeight()*1.01 + v.getHeight() + 5);
					if(popupWindow.isShowing()){
						popupWindow.update(x, y,popupWindow.getWidth(),popupWindow.getHeight());
					}else {
						popupWindow.showAtLocation(parent.getRootView(), Gravity.LEFT|Gravity.TOP, x, y);
					}
				}else if(event.getAction()==MotionEvent.ACTION_UP){
					needHide = true;
					PTInvokeLater.postDelayed(tipHideTask, 200);
				}
				return false;
			}
		};
	}

	@Override
	public void decorate(View view) {
		if (view instanceof Button) {
			Button btn = (Button) view;
			btn.setLayoutParams(lp);
			btn.setOnTouchListener(touchListener);
			btn.setSoundEffectsEnabled(false);
			btn.setTextSize(textSize);
			btn.setTextColor(Color.BLACK);
			btn.setPadding(0, 0, 0, 0);
			btn.setSingleLine(true);
			btn.setGravity(Gravity.CENTER);
			int normalResId = mResources.getIdentifier("fw_kb_key_normal", "drawable", context.getPackageName());
			btn.setBackgroundResource(normalResId);
//			btn.setText(btn.getTag().toString().toUpperCase(Locale.getDefault()));
			btn.setText(btn.getTag().toString());
		}
	}

	@Override
	public void release() {
		popupWindow.dismiss();
	}
}
