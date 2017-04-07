package asp.citic.ptframework.plugin.keyboards.securitykeyboard;

import android.webkit.WebView;
import android.widget.EditText;

import org.json.JSONObject;

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
 * <td>Apr 6, 20163:29:39 PM </td>
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
public interface PTSecurityKeyboard {

	/** 键盘输入是否遮盖 **/
	static final String ATTR_MASK = "mask";

	/** 键盘最大输入长度 **/
	static final String ATTR_MAX_LENGTH = "maxLength";

	/** 键盘类型 **/
	static final String ATTR_KEYBOARD_TYPE = "keyboardType";

	/** 键盘加密机类型 **/
	static final String ATTR_ENCRYPTOR = "encryptor";

	/** 默认最大长度 **/
	static final int DEFAULT_MAX_LENGTH = 20;

	static final String ATTR_RANDOM = "random";
	/** 数字乱序&字母不乱序 **/
	static final String ATTR_NUM_RANDOM = "numRandom";

	/**
	 * 显示键盘
	 *
	 * @param input 输入框对象
	 * @param conf 键盘配置
	 *
	 */
	void show(EditText input, JSONObject conf);

	/**
	 * 显示键盘
	 * @param webView 浏览器对象
	 * @param listener 键盘监听器
	 * @param conf 键盘配置
	 */
	void show(WebView webView, PTSecurityKeyboardListener listener, JSONObject conf);

	/**
	 * 隐藏键盘
	 */
	void hide();

	/**
	 * 返回键盘输入的值，如果加密返回的是密文
	 * @return 键盘输入的值
	 */
	String getValue();

	/** 邵志 1014 增加 start */
	/**
	 * 返回键盘输入的明文值
	 * @return 键盘输入的值
	 */
	String getText();

	String getPainText();

	/** 邵志 1014 增加 end */
	/**
	 * 返回键盘是否启用了加密
	 * @return 加密返回true、不加密返回false
	 */
	boolean isEncrypt();

	/**
	 * 设置输入统计器
	 * @param statistician 输入统计器
	 */
	void setInputStatistician(PTInputStatistician statistician);


	/**
	 * 获取输入统计器
	 * @return 输入统计器
	 */
	PTInputStatistician getInputStatistician();

	/**
	 * 键盘是否显示
	 * @return 键盘是否正在显示
	 */
	boolean isShowing();

	/**
	 * 清空键盘输入
	 */
	void clear();
}
