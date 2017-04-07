package asp.citic.ptframework.plugin.keyboards.securitykeyboard.impl;

import android.content.Context;
import android.content.res.Resources;
import android.view.Gravity;
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
 * <td>Apr 7, 20164:11:15 PM </td>
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
public class FullAlphabetSubKeyboardView extends SubKeyboardViewBase {
	private KeyList alphabetKeyList;
	private boolean shiftPressed = false;
	private Context context;
	private Resources mRes;

	/**
	 * 构造函数
	 * @param mainKeybaordView 主键盘View
	 * @param listener 子键盘事件监听器
	 */
	public FullAlphabetSubKeyboardView(ViewGroup mainKeybaordView, SubKeyboardViewListener listener) {
		super(mainKeybaordView, listener);

		context = mainKeybaordView.getContext();
		mRes = context.getResources();
		keyboardView = new LinearLayout(context);

//		alphabetKeyList = new KeyList(this, new String[] { "abcdefghijklmnopqrstuvwxyz", "ABCDEFGHIJKLMNOPQRSTUVWXYZ" });
		alphabetKeyList = new KeyList(this, new String[] { "qwertyuiopasdfghjklzxcvbnm", "QWERTYUIOPASDFGHJKLZXCVBNM" });

		((LinearLayout)keyboardView).setOrientation(LinearLayout.VERTICAL);

		LinearLayout row;
		Button btn;
		// 字母0-9
		row = new LinearLayout(context);
		for (int i = 0; i < 10; i++) {
			btn = getAlphabetKey(i);
			row.addView(btn);
		}
		keyboardView.addView(row,getRowLayoutParams());
		// 字母10-18
		row = new LinearLayout(context);
		row.setGravity(Gravity.CENTER_HORIZONTAL);
		row.setWeightSum(20);
		for (int i = 10; i < 19; i++) {
			btn = getAlphabetKey(i);
			getBtnLayoutParams(btn).weight = 2;
			row.addView(btn);
		}
		keyboardView.addView(row,getRowLayoutParams());
		// 字母19-25
		row = new LinearLayout(context);
		row.setWeightSum(20);
		btn = getFnKey(KeyEvent.KEYCODE_SHIFT_LEFT);
//		btn.setText("^");
		getBtnLayoutParams(btn).weight = 3;
		int shiftResId = mRes.getIdentifier("fw_kb_shift_normal", "drawable", context.getPackageName());
		btn.setBackgroundResource(shiftResId);
		row.addView(btn);
		for (int i = 19; i < 26; i++) {
			btn = getAlphabetKey(i);
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
		// 完成
		row = new LinearLayout(context);
		row.setWeightSum(10);
		//*/
//		btn = getFnKey(KeyEvent.KEYCODE_NUM);
//		btn.setText("[123]");
//		row.addView(btn);
		//*/
		btn = getFnKey(KeyEvent.KEYCODE_SYM);
		btn.setText("#+123");
		getBtnLayoutParams(btn).weight = 3;
		row.addView(btn);
		btn = getFnKey(KeyEvent.KEYCODE_SPACE);
		getBtnLayoutParams(btn).weight = 4;
		btn.setText("空格");
		int normalResId = mRes.getIdentifier("fw_kb_key_normal", "drawable", context.getPackageName());
		btn.setBackgroundResource(normalResId);
		row.addView(btn);
		btn = getFnKey(KeyEvent.KEYCODE_ENTER);
		btn.setText("完成");
		getBtnLayoutParams(btn).weight = 3;
		row.addView(btn);
		keyboardView.addView(row,getRowLayoutParams());

	}

	public void reinit(){
		alphabetKeyList.setPage(0);
		shiftPressed = true;
		shiftClick();
	}
	private LayoutParams getRowLayoutParams(){
		int height = (int) (PTDeviceUtil.getScreenHeight()*0.4/4);
		LayoutParams lp = new LayoutParams(PTDeviceUtil.getScreenWidth(),height);
		return lp;
	}

	private Button getAlphabetKey(int index){
		return alphabetKeyList.getKey(index);
	}

	@Override
	protected boolean handleKeyClick(View keyView, int keyCode) {
		if(!super.handleKeyClick(keyView, keyCode)){
			//父类没有处理的按键
			switch (keyCode) {
			case KeyEvent.KEYCODE_SHIFT_LEFT:
				//shift
				shiftClick();
				alphabetKeyList.switchPage();
				return true;

			case KeyEvent.KEYCODE_SYM:
				//切换到字符键盘
				listener.onSwitchKeyboardType(KEYBOARDTYPE_FULLSYMBOL);
				return true;

			case KeyEvent.KEYCODE_NUM:
				//切换到数字键盘
				listener.onSwitchKeyboardType(KEYBOARDTYPE_SMALLNUMBER);
//				alphabetKeyList.confuseOrder();
				return true;

			default:
				return false;
			}
		}else {
			return true;
		}
	}

	private void shiftClick(){
		shiftPressed = !shiftPressed;
		Button btn = (Button)keyboardView.findViewWithTag(KeyEvent.KEYCODE_SHIFT_LEFT);
		//按下一次
		if(shiftPressed){
			int shiftResId = mRes.getIdentifier("fw_kb_shift_selected", "drawable", context.getPackageName());
			btn.setBackgroundResource(shiftResId);
		}else{
			int shiftResId = mRes.getIdentifier("fw_kb_shift_normal", "drawable", context.getPackageName());
			btn.setBackgroundResource(shiftResId);
		}
	}

	@Override
	public void release() {
		alphabetKeyList.release();
	}

	@Override
	public void randomKey(boolean random) {
		if(random){
			alphabetKeyList.confuseOrder();
		}else{
			alphabetKeyList.initOrder();
		}
	}

	@Override
	public void randomNumKey(boolean random) {

	}
}
