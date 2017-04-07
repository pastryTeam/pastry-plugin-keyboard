package asp.citic.ptframework.plugin.keyboards.securitykeyboard.tools;

import android.content.Context;
import android.text.InputType;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;

import java.lang.reflect.Method;

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
 * <td>Apr 7, 20164:22:06 PM </td>
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
public class PTSoftInputMethodUtil {

	/**
	 * 隐藏系统软键盘
	 * @param view
	 */
	public static void hideSoftInputMethod(View view){
		Context context = view.getContext();
		InputMethodManager inputMethodManager = (InputMethodManager) context.getSystemService(Context.INPUT_METHOD_SERVICE);
		inputMethodManager.hideSoftInputFromWindow(view.getWindowToken(), 0);
	}

	/**
	 * 禁用系统软键盘
	 * @param editText
	 */
	public static void disabelSoftInputMethod(EditText editText){
		if (android.os.Build.VERSION.SDK_INT>10) {
			//3.0及以上
			Class<EditText> clazz = EditText.class;
			Method setShowSoftInputOnFocus = null;
			try {
				setShowSoftInputOnFocus = clazz.getMethod("setShowSoftInputOnFocus", boolean.class);
			} catch (Exception e) {
//				CBLogger.d(e.getMessage());
				try {
					setShowSoftInputOnFocus = clazz.getMethod("setSoftInputShownOnFocus", boolean.class);
				} catch (NoSuchMethodException ex) {
//					CBLogger.d(ex.getMessage());
				}
			}
			if (setShowSoftInputOnFocus!=null) {
				setShowSoftInputOnFocus.setAccessible(false);
				try {
					setShowSoftInputOnFocus.invoke(editText, false);
				} catch (Exception e) {
//					CBLogger.d(e.getMessage());
				}
			}else {
//				CBLogger.e("hideSoftInputMethod failed!");
			}
		}else {
			//3.0以下
			editText.setInputType(InputType.TYPE_NULL);
		}
	}
}
