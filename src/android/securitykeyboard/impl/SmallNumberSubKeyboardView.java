package asp.citic.ptframework.plugin.keyboards.securitykeyboard.impl;

import android.content.Context;
import android.content.res.Resources;
import android.graphics.Color;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.LinearLayout.LayoutParams;

import asp.citic.ptframework.common.device.PTDeviceUtil;


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
 * <td>Apr 7, 20164:04:07 PM </td>
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
public class SmallNumberSubKeyboardView extends SubKeyboardViewBase {

	private KeyList numberKeyList;
	private Context context;
	private Resources mRes;

	/**
	 * 构造函数
	 * @param mainKeybaordView 主键盘View
	 * @param listener 子键盘事件监听器
	 */
	public SmallNumberSubKeyboardView(ViewGroup mainKeybaordView,
			SubKeyboardViewListener listener) {
		super(mainKeybaordView, listener);

		context = mainKeybaordView.getContext();

		mRes = context.getResources();

		keyboardView = new LinearLayout(context);

		numberKeyList = new KeyList(this,new String[] { "0123456789" },new NineButtonDecorator());

		((LinearLayout)keyboardView).setOrientation(LinearLayout.VERTICAL);
		keyboardView.setLayoutParams(new LayoutParams(
				ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
		LinearLayout row;
		Button btn;
		int sp = PTDeviceUtil.dip2px(0.4f);
		// 1-3
		row = new LinearLayout(context);
		for (int i = 1; i < 4; i++) {
			btn = numberKeyList.getKey(i);
			getBtnLayoutParams(btn).setMargins(sp, sp, sp, sp);
			row.addView(btn);
		}
		keyboardView.addView(row,getRowLayoutParams());
		// 4-6
		row = new LinearLayout(context);
		for (int i = 4; i < 7; i++) {
			btn = numberKeyList.getKey(i);
			getBtnLayoutParams(btn).setMargins(sp, sp, sp, sp);
			row.addView(btn);
		}
		keyboardView.addView(row,getRowLayoutParams());
		// 7-9
		row = new LinearLayout(context);
		for (int i = 7; i < 10; i++) {
			btn = numberKeyList.getKey(i);
			getBtnLayoutParams(btn).setMargins(sp, sp, sp, sp);
			row.addView(btn);
		}
		keyboardView.addView(row,getRowLayoutParams());

		// 小数点/X/空 9 完成 删除
		row = new LinearLayout(context);

		//删除
		btn = getFnKey(KeyEvent.KEYCODE_DEL);
		getBtnLayoutParams(btn).setMargins(sp, sp, sp, sp);
//				btn.setText("删除");
		int backResId = mRes.getIdentifier("fw_kb_backspace_selected_selector", "drawable", context.getPackageName());
		btn.setBackgroundResource(backResId);
		row.addView(btn);

		//0
		btn = numberKeyList.getKey(0);
		getBtnLayoutParams(btn).setMargins(sp, sp, sp, sp);
		row.addView(btn);

		btn = getFnKey(KeyEvent.KEYCODE_ENTER);
		getBtnLayoutParams(btn).setMargins(sp, sp, sp, sp);
		btn.setText("完成");
		btn.setTextColor(Color.WHITE);
		int bgColorId = mRes.getIdentifier("keyboard_char_main_bg", "color", context.getPackageName());
		btn.setBackgroundColor(context.getResources().getColor(bgColorId));
		row.addView(btn);

		keyboardView.addView(row,getRowLayoutParams());
	}

	private LayoutParams getRowLayoutParams(){
		int height = (int) (PTDeviceUtil.getScreenHeight()*0.4/4);
		LayoutParams lp = new LayoutParams(PTDeviceUtil.getScreenWidth(),height);
		return lp;
	}

	@Override
	protected boolean handleKeyClick(View keyView, int keyCode) {
		if(!super.handleKeyClick(keyView, keyCode)){
			//父类没有处理的按键
			switch (keyCode) {
			case KeyEvent.KEYCODE_SYM:
				//切换到字母键盘
				listener.onSwitchKeyboardType(KEYBOARDTYPE_FULLALPHABET);
				return true;
			default:
				return false;
			}
		}else {
			return true;
		}
	}

	@Override
	public void release() {
		numberKeyList.release();
	}

	@Override
	public void randomKey(boolean random) {
		numberKeyList.confuseOrder();
		if(random){
			numberKeyList.confuseOrder();
		}else{
			numberKeyList.initOrder();
		}
	}

	@Override
	public void randomNumKey(boolean random) {

	}

	@Override
	public void reinit() {
	}

}
