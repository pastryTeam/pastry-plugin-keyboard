package asp.citic.ptframework.plugin.keyboards.securitykeyboard;

import android.app.Activity;

/**
 * 系统名称: 中信网科移动基础框架-Pastry<br />
 */
public enum PTTopActivityManager {
	/**
	 * 顶层窗口管理器实例
	 */
	INSTANCE;

	//private ActivityManager am = (ActivityManager) CBFramework.getApplication().getSystemService(Context.ACTIVITY_SERVICE);

	private Activity topActivity;

	/**
	 * 需在Activity的onResume中调用
	 * @param activity
	 */
	public static void onActivityResume(Activity activity) {
		INSTANCE.topActivity = activity;
	}

	/**
	 * 需在Activity的onResume中调用
	 */
	public static void onActivityPause() {
		INSTANCE.topActivity = null;
	}

	/**
	 * 获取顶层对象
	 * @return 顶层对象
	 */
	public static Object getTopObject(){
		/*
		if (INSTANCE.topActivity!=null) {
			if ((INSTANCE.topActivity.getClass().getName().equals(INSTANCE.am.getRunningTasks(1).get(0).topActivity.getClassName()))){
				return INSTANCE.topActivity;
			}else {
				return null;
			}
		}
		return null;*/
		return INSTANCE.topActivity;
	}
}
