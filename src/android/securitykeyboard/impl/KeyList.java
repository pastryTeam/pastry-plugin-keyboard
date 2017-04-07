package asp.citic.ptframework.plugin.keyboards.securitykeyboard.impl;

import android.annotation.SuppressLint;
import android.content.Context;
import android.widget.Button;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Random;

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
 * <td>Apr 7, 20164:06:48 PM </td>
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
public class KeyList {
	private int pageIndex = 0;
	private String[] pages;
	private Button[] btns;
	private byte[] order;
	private ViewDecorator keyDecorator;

	private static byte[] getRandomOrder(int n) {
		Random random = new Random();
		byte[] order = new byte[n];
		// 生成顺序序列
		for (int i = 0; i < order.length; i++) {
			order[i] = (byte) i;
		}
		// 随机调换，生成随机序列
		int p1, p2;
		for (int i = 0; i < order.length; i++) {
			p1 = random.nextInt(n);
			p2 = random.nextInt(n);
			if (p1 != p2) {
				order[p1] = (byte) (order[p1] ^ order[p2]);
				order[p2] = (byte) (order[p1] ^ order[p2]);
				order[p1] = (byte) (order[p1] ^ order[p2]);
			}
		}
		return order;
	}

	/**
	 * 恢复按键顺序
	 */
	public void initOrder() {
		this.order = null;
		refreshButtons();
	}

	/**
	 * 打乱按键顺序
	 */
	public void confuseOrder() {
		this.order = getRandomOrder(pages[0].length());
		refreshButtons();
	}
	/**
	 * 只打乱数字按键顺序
	 */
	public void confuseNumOrder() {
		byte[] order = new byte[10];
		// 生成乱序序列
		for (int i = 0; i < order.length; i++) {
			order[i] = (byte) i;
		}
		this.order = getRandomOrder(pages[0].length());
		refreshButtons();
	}

	/**
	 * 构造函数
	 * 
	 * @param subKeyboardViewBase
	 *            子键盘对象
	 * @param pages
	 *            按键数据
	 */
	public KeyList(SubKeyboardViewBase subKeyboardViewBase, String[] pages) {
		this(subKeyboardViewBase, pages, new TipButtonDecorator(
				subKeyboardViewBase.getMainKeyboardView()));
	}

	/**
	 * 构造函数
	 * 
	 * @param subKeyboardViewBase
	 *            子键盘对象
	 * @param pages
	 *            按键数据
	 * @param keyDecorator
	 *            按键装饰器
	 */
	@SuppressLint("InlinedApi")
	public KeyList(final SubKeyboardViewBase subKeyboardViewBase,
			String[] pages, ViewDecorator keyDecorator) {
		this.pages = pages;
		this.keyDecorator = keyDecorator;

		final Context context = subKeyboardViewBase.getView().getContext();

		btns = new Button[pages[0].length()];
		for (int i = 0; i < btns.length; i++) {
			btns[i] = new Button(context);
			btns[i].setOnClickListener(subKeyboardViewBase);
			btns[i].setTag(getKeyText(i));
			if (keyDecorator != null) {
				keyDecorator.decorate(btns[i]);
			}
		}
	}

	private void refreshButtons() {
		for (int i = 0; i < btns.length; i++) {
			btns[i].setTag(getKeyText(i));
			keyDecorator.decorate(btns[i]);
		}
	}

	private String getKeyText(int index) {
		if (order != null) {
			index = order[index];
		}
		return pages[pageIndex].substring(index, index + 1);
	}

	/**
	 * 切换按键列表页
	 */
	public void switchPage() {
		if (++pageIndex >= pages.length) {
			pageIndex = 0;
		}
		setPage(pageIndex);
	}

	/**
	 * 设置按键列表页
	 * 
	 * @param page
	 */
	public void setPage(int page) {
		if (page > pages.length - 1) {
			this.pageIndex = pages.length - 1;
		} else if (page < 0) {
			this.pageIndex = 0;
		} else {
			this.pageIndex = page;
		}
		refreshButtons();
	}

	/**
	 * 根据索引返回按键对象
	 * 
	 * @param index
	 *            按键索引
	 * @return 按键对象
	 */
	public Button getKey(int index) {
		return btns[index];
	}

	/**
	 * 释放资源
	 */
	public void release() {
		keyDecorator.release();
	}

	/**
	 * 获取数字的乱序键盘
	 * @return
	 */
	public static String getRandomNumStr(){
		StringBuffer numStr = new StringBuffer();
		int[] randomList = getRandomNum();
		for (int i = 0; i < randomList.length; i++) {
			numStr = numStr.append(randomList[i]);
		}
		return numStr.toString();
	}
	/**
	 * 获得随机数字0-9
	 * @return
	 */
	private static int[] getRandomNum() {
		int[] arr = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 0 };
		int temp;
		Random random = new Random();
		for (int i = 0; i < 10; i++) {
			int rnd = Math.abs(random.nextInt()) % 10;
			if (rnd < arr.length) {
				temp = arr[rnd];
				arr[rnd] = arr[0];
				arr[0] = temp;
			}
		}
		return shuffleINumList(arr);
	}
	/**
	 * 随机打乱数字键盘
	 *
	 * @param array
	 * @return
	 */
	private static int[] shuffleINumList(int[] array) {
		int[] rArray = new int[array.length];
		ArrayList<Integer> list = new ArrayList<Integer>();
		if (array != null && array.length > 0) {
			for (int i = 0; i < array.length; i++) {
				list.add(array[i]);
			}
			Collections.shuffle(list);
			for (int i = 0; i < list.size(); i++) {
				rArray[i] = list.get(i);
			}
		}
		return rArray;
	}
}
