package asp.citic.ptframework.plugin.keyboards.securitykeyboard;

import java.util.HashMap;

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
 * <td>Apr 6, 20163:32:16 PM </td>
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
public enum PTInputEncryptorManager {
	
	/**
	 * 安全键盘机密机管理器实例
	 */
	INSTANCE;
	
	/**
	 * 默认加密机
	 */
	public final static String DEFAULT_ENCRYPTOR = "default";
	
	private HashMap<String, PTInputEncryptor> encrypers = new HashMap<String, PTInputEncryptor>();
	
	/**
	 * 注册加密机
	 * @param name 加密机名称
	 * @param encryptor 加密机对象
	 */
	public static void registEncryptor(String name,PTInputEncryptor encryptor){
		INSTANCE.encrypers.put(name, encryptor);
	}
	
	/**
	 * 获取加密机对象
	 * @param name 加密机名称
	 * @return 加密机对象
	 */
	public static PTInputEncryptor getEncrypter(String name){
		return INSTANCE.encrypers.get(name);
	}
	
	/**
	 * 获取加密机实例
	 * @param name 加密机名称
	 * @return 加密机实例
	 */
	public static PTInputEncryptor getEncrypterInstance(String name){
		PTInputEncryptor encryper = INSTANCE.encrypers.get(name);
		if(encryper!=null){
			return INSTANCE.encrypers.get(name).getInstance();	
		}
		return null;
	}
	
}
