package asp.citic.ptframework.plugin.keyboards.securitykeyboard;
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
 * <td>Apr 6, 20163:29:00 PM </td>
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
public interface PTInputStatistician {
	/**
	 * 强度等级常量：高强度
	 */
	static final int STRENGTH_HIGH	= 3;
	
	/**
	 * 强度等级常量：中强度
	 */
	static final int STRENGTH_NORMAL	= 2;
	
	/**
	 * 强度等级常量：低强度
	 */
	static final int STRENGTH_LOW	= 1;
	
	/**
	 * 输入符串
	 * @param in 输入字符串
	 */
	void input(char in);
	
	/**
	 * 删除字符
	 */
	void delete();
	
	
	/**
	 * 获取输入的密码强度
	 * @return 输入密码强度
	 */
	int getStrength();
	
	/**
	 * 重置统计
	 */
	void reset();
}
