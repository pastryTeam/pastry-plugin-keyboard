package asp.citic.ptframework.plugin.keyboards.securitykeyboard;

import android.view.View;

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
 * <td>Apr 6, 20163:30:37 PM </td>
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
public interface PTSecurityKeyboardInputChangeListener {
	/**
	 * 键盘输入改变的回调
	 * @param view 键盘对应的View
	 */
	void onInputChange(View view);
}
