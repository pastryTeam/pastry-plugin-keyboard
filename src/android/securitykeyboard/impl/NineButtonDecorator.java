package asp.citic.ptframework.plugin.keyboards.securitykeyboard.impl;

import android.content.Context;
import android.content.res.Resources;
import android.graphics.Color;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.LinearLayout.LayoutParams;

import asp.citic.ptframework.PTFramework;
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
 * <td>Apr 7, 20164:05:15 PM </td>
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
public class NineButtonDecorator implements ViewDecorator{
	int sp = PTDeviceUtil.dip2px(0.4f);
	private Context mContext = PTFramework.getContext();
	private Resources mRes = mContext.getResources();
	@Override
	public void decorate(View view) {
		if (view instanceof Button) {
			Button btn = (Button)view;

			LayoutParams params = new LayoutParams(0,
					ViewGroup.LayoutParams.MATCH_PARENT);
			params.weight=1;
			params.setMargins(sp, sp, sp, sp);
			btn.setLayoutParams(params);
			int keyResId = mRes.getIdentifier("fw_kb_key_selector", "drawable", mContext.getPackageName());
			btn.setTextColor(Color.BLACK);
			btn.setBackgroundResource(keyResId);
			btn.setText(btn.getTag().toString());
		}
	}

	@Override
	public void release() {

	}
}
