package asp.citic.ptframework.plugin.keyboards.securitykeyboard.impl;

import android.content.Context;
import android.content.res.Resources;
import android.graphics.Color;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
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
 * <td>Apr 7, 20164:02:24 PM </td>
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
public abstract class SubKeyboardViewBase implements OnClickListener{
	/**
	 * 子键盘类型：字母全键盘
	 */
	public static final int KEYBOARDTYPE_FULLALPHABET = 0;

	/**
	 * 子键盘类型：符号全键盘
	 */
	public static final int KEYBOARDTYPE_FULLSYMBOL = 1;

	/**
	 * 子键盘类型：九宫键盘
	 */
	public static final int KEYBOARDTYPE_SMALLNUMBER = 2;

	protected static final int KEYTYPE_NUMBER = 0;
	protected static final int KEYTYPE_ALPHABET = 1;
	protected static final int KEYTYPE_SYMBOL = 2;

	protected ViewGroup keyboardView;
	protected SubKeyboardViewListener listener;
	protected ViewGroup mainKeyboardView;

	private float textSize;
	private Resources activityRes;
	private Context mContext;


	/**
	 * 构造函数
	 * @param mainKeyboardView 主键盘View
	 * @param listener
	 */
	public SubKeyboardViewBase(ViewGroup mainKeyboardView,SubKeyboardViewListener listener) {
		this.mainKeyboardView=mainKeyboardView;
		this.listener=listener;
		this.mContext = mainKeyboardView.getContext();
		activityRes = mainKeyboardView.getContext().getResources();
		int txtSizeId = activityRes.getIdentifier("cyberpay_fw_key_textSize", "dimen", mainKeyboardView.getContext().getPackageName());
		textSize = mainKeyboardView.getContext().getResources().getDimension(txtSizeId);
	}

	/**
	 * 获取子键盘View
	 * @return 子键盘View
	 */
	public View getView(){
		return keyboardView;
	}

	/**
	 * 重新键盘初始化
	 */
	public void reinit(){
	}

	@Override
	public void onClick(View v) {
		Object tag = v.getTag();
		if (tag instanceof String) {
			listener.onInput(((String)tag).charAt(0));
		}else if (tag instanceof Integer) {
			handleKeyClick(v,(Integer) tag);
		}
	}

	protected boolean handleKeyClick(View keyView,int keyCode) {
		switch (keyCode) {
		case KeyEvent.KEYCODE_SPACE:
			//空格
			listener.onInput(' ');
			return true;
		case KeyEvent.KEYCODE_ENTER:
			//回车
			listener.onDone();
			return true;
		case KeyEvent.KEYCODE_DEL:
			//删除
			listener.onDelete();
			return true;
		default:
			//未知按键
			return false;
		}
	}

	protected Button getFnKey(int keyCode) {
		int sp = PTDeviceUtil.dip2px(3);
		Button btn = new Button(keyboardView.getContext());
		LayoutParams params = new LayoutParams(0,
				ViewGroup.LayoutParams.MATCH_PARENT);
		params.weight = 1;
		params.setMargins(sp, sp, sp, sp);
		btn.setLayoutParams(params);
		btn.setTag(keyCode);
		btn.setSoundEffectsEnabled(false);
		btn.setOnClickListener(this);
		btn.setTextSize(textSize);
		btn.setTextColor(Color.BLACK);
		int funkeyResId = activityRes.getIdentifier("fw_kb_funkey_selector", "drawable", this.mContext.getPackageName());
		btn.setBackgroundResource(funkeyResId);
		btn.setPadding(0, 0, 0, 0);
		btn.setSingleLine(true);
		btn.setGravity(Gravity.CENTER);
		return btn;
	}

	protected LayoutParams getBtnLayoutParams(Button btn){
		LayoutParams lp = (LayoutParams)btn.getLayoutParams();
		return lp;
	}

	/**
	 * 获取主键盘View
	 * @return 主键盘View
	 */
	public ViewGroup getMainKeyboardView() {
		return mainKeyboardView;
	}

	/**
	 * 释放资源
	 */
	public abstract void release();

	public abstract void randomKey(boolean random);

	public abstract void randomNumKey(boolean random);
}
