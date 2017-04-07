package asp.citic.ptframework.plugin.keyboards.securitykeyboard.tools;

import android.os.Handler;
import android.os.Looper;

/**
 * 系统名称: 中信网科移动基础框架-Pastry<br />
 */
public class PTInvokeLater {

	/** 主线程的处理器. */
	private static Handler handler = new Handler(Looper.getMainLooper());

	/**
	 * 提交请求.
	 *
	 * @param task
	 *            可执行对象
	 */
	public static void post(Runnable task){
		handler.post(task);
	}

	/**
	 * 延迟提交请求.
	 *
	 * @param task 可执行对象
	 * @param delayMillis 延迟时间，单位毫秒
	 */
	public static void postDelayed(Runnable task, long delayMillis){
		handler.postDelayed(task, delayMillis);
	}
}
