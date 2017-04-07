package asp.citic.ptframework.plugin.keyboards.securitykeyboard.impl;

import android.content.Context;
import android.content.res.Resources;
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
 * <td>Apr 7, 20164:08:44 PM </td>
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
public class FullSymbolSubKeyboardView extends SubKeyboardViewBase {

	private KeyList symbolkeyList;
	private Button btnShift;
	private Context context;
	private Resources mRes;
	/**
	 * 构造函数
	 * @param mainKeybaordView 主键盘View
	 * @param listener 子键盘事件监听器
	 */
	public FullSymbolSubKeyboardView(ViewGroup mainKeybaordView,
			SubKeyboardViewListener listener,String[] keyStr) {
		super(mainKeybaordView, listener);

		context = mainKeybaordView.getContext();
		mRes = context.getResources();

		keyboardView = new LinearLayout(context);

		symbolkeyList = new KeyList(this,keyStr);

		((LinearLayout)keyboardView).setOrientation(LinearLayout.VERTICAL);
		LinearLayout row;
		Button btn;

		// 符号0-9
		row = new LinearLayout(context);
		for (int i = 0; i < 10; i++) {
			btn = getSymbolKey(i);
			row.addView(btn);
		}
		keyboardView.addView(row,getRowLayoutParams());

		// 符号10-19
		row = new LinearLayout(context);
		for (int i = 10; i < 20; i++) {
			btn = getSymbolKey(i);
			row.addView(btn);
		}
		keyboardView.addView(row,getRowLayoutParams());

		row = new LinearLayout(context);
		btnShift = getFnKey(KeyEvent.KEYCODE_SHIFT_LEFT);
		btnShift.setText("#+=");
		getBtnLayoutParams(btnShift).weight = 3;
		row.addView(btnShift);
		for (int i = 20; i < 25; i++) {
			btn = getSymbolKey(i);
			getBtnLayoutParams(btn).weight = 2;
			row.addView(btn);
		}
		btn = getFnKey(KeyEvent.KEYCODE_DEL);
//		btn.setText("<");
		getBtnLayoutParams(btn).weight = 3;
		int backResId = mRes.getIdentifier("fw_keyboard_backspace", "drawable", context.getPackageName());
		btn.setBackgroundResource(backResId);
		row.addView(btn);
		keyboardView.addView(row,getRowLayoutParams());

		row = new LinearLayout(context);
		btn = getFnKey(KeyEvent.KEYCODE_SYM);
		btn.setText("ABC");
		getBtnLayoutParams(btn).weight = 3;
		row.addView(btn);
		btn = getFnKey(KeyEvent.KEYCODE_SPACE);
		btn.setText("空格");
		getBtnLayoutParams(btn).weight = 4;
		int normalResId = mRes.getIdentifier("fw_kb_key_normal", "drawable", context.getPackageName());
		btn.setBackgroundResource(normalResId);
		row.addView(btn);
		btn = getFnKey(KeyEvent.KEYCODE_ENTER);
		btn.setText("完成");
		getBtnLayoutParams(btn).weight = 3;
		row.addView(btn);
		keyboardView.addView(row,getRowLayoutParams());
	}

	private Button getSymbolKey(int index){
		return symbolkeyList.getKey(index);
	}

	private LayoutParams getRowLayoutParams(){
		int height = (int) (PTDeviceUtil.getScreenHeight()*0.4/4);
		LayoutParams lp = new LayoutParams(PTDeviceUtil.getScreenWidth(),height);
		return lp;
	}

	public void reinit(){
		btnShift.setText("#+=");
		symbolkeyList.setPage(0);
		symbolkeyList.initOrder();
	}

	@Override
	protected boolean handleKeyClick(View keyView, int keyCode) {
		if(!super.handleKeyClick(keyView, keyCode)){
			//父类没有处理的按键
			switch (keyCode) {
			case KeyEvent.KEYCODE_SHIFT_LEFT:
				//shift
				symbolkeyList.switchPage();
				if("#+=".equals(btnShift.getText().toString())){
					btnShift.setText("123");
				}else {
					btnShift.setText("#+=");
				}
				return true;

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
		symbolkeyList.release();
	}

	@Override
	public void randomKey(boolean random) {
		if(random){
			symbolkeyList.confuseOrder();
		}else{
			symbolkeyList.initOrder();
		}
	}

	@Override
	public void randomNumKey(boolean random) {
		if(random){
		}else{
			symbolkeyList.initOrder();
		}
	}


}
