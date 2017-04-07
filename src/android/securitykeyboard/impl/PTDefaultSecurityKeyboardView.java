package asp.citic.ptframework.plugin.keyboards.securitykeyboard.impl;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.res.Resources;
import android.util.SparseArray;
import android.view.View;
import android.widget.LinearLayout;

import asp.citic.ptframework.PTFramework;
import asp.citic.ptframework.plugin.keyboards.securitykeyboard.PTSecurityKeyboardListener;

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
 * <td>Apr 7, 20164:15:01 PM </td>
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
@SuppressLint("ViewConstructor")
public class PTDefaultSecurityKeyboardView extends LinearLayout implements SubKeyboardViewListener {
	private final SparseArray<SubKeyboardViewBase> subKeyboardViewMap = new SparseArray<SubKeyboardViewBase>();

	private PTSecurityKeyboardListener listener;

	private int keyboardType = -1;

	private SubKeyboardViewBase currentSubKeyboard;

	private View rootView;
	private boolean keyrandom;
	private Context mContext;
	private Resources mRes;

	@SuppressWarnings("javadoc")
	public PTDefaultSecurityKeyboardView(PTSecurityKeyboardListener listener) {
		super(PTFramework.getContext());
		this.listener = listener;
		mContext = PTFramework.getContext();
		mRes = mContext.getResources();
		init();
	}

	private void init() {
		SubKeyboardViewBase subKeyboardView;

		subKeyboardView = new FullAlphabetSubKeyboardView(this, this);
		subKeyboardViewMap.put(SubKeyboardViewBase.KEYBOARDTYPE_FULLALPHABET, subKeyboardView);
		//首次初始化键盘，传入乱序数字
		subKeyboardView = new FullSymbolSubKeyboardView(this, this,new String[] {KeyList.getRandomNumStr()+"-/:;()$&@\".,?!`","[]{}#%^*+=_\\|~<>€£¥·.,?!'" });
		subKeyboardViewMap.put(SubKeyboardViewBase.KEYBOARDTYPE_FULLSYMBOL, subKeyboardView);

		subKeyboardView = new SmallNumberSubKeyboardView(this, this);
		subKeyboardViewMap.put(SubKeyboardViewBase.KEYBOARDTYPE_SMALLNUMBER, subKeyboardView);
		int bgColorId = mRes.getIdentifier("keyboard_char_main_bg", "color", mContext.getPackageName());
		setBackgroundColor(getResources().getColor(bgColorId));


		setKeyboardType(SubKeyboardViewBase.KEYBOARDTYPE_FULLALPHABET);
	}

	/**
	 * 设置键盘类型
	 * @param type 键盘配型
	 */
	public void setKeyboardType(int type) {
		if (keyboardType != type) {
			keyboardType = type;
			removeAllViews();
			if(currentSubKeyboard!=null){
				currentSubKeyboard.release();
			}
			if (type == SubKeyboardViewBase.KEYBOARDTYPE_FULLSYMBOL){
				//切换键盘，数字乱序一次
				doNumRandom(true);
			}
			currentSubKeyboard = subKeyboardViewMap.get(type);
			addView(currentSubKeyboard.getView());

		}
		reinit(type);

//		currentSubKeyboard.randomKey(keyrandom);
	}

	/**
	 * 重新初始化
	 */
	private void reinit(int type){
//		subKeyboardViewMap.get(SubKeyboardViewBase.KEYBOARDTYPE_FULLALPHABET).reInit();
//		subKeyboardViewMap.get(SubKeyboardViewBase.KEYBOARDTYPE_FULLSYMBOL).reInit();
//		subKeyboardViewMap.get(SubKeyboardViewBase.KEYBOARDTYPE_SMALLNUMBER).reInit();

		subKeyboardViewMap.get(keyboardType).reinit();
	}

	@Override
	public void onInput(char input) {
		listener.onInput(input);
	}

	@Override
	public void onDelete() {
		listener.onDelete();
	}

	@Override
	public void onDone() {
		listener.onDone();
	}

	@Override
	public void onSwitchKeyboardType(int type) {
		setKeyboardType(type);
	}

	@Override
	public void onCancel() {
		listener.onCancel();
	}

	@SuppressWarnings("javadoc")
	public void setRootView(View rootView) {
		this.rootView=rootView;
	}

	@Override
	public View getRootView() {
		return rootView;
	}

	/**
	 * 释放资源
	 */
	public void release() {
		if(currentSubKeyboard!=null){
			currentSubKeyboard.release();
		}
	}

	public void requestRandom(boolean random){
		keyrandom = random;
	}

	public void doRandom(boolean random){
		requestRandom(random);
		currentSubKeyboard.randomKey(keyrandom);
	}

	public void doNumRandom(boolean numRandom){
		currentSubKeyboard.randomNumKey(numRandom);
	}
}
