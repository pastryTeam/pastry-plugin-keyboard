package asp.citic.ptframework.plugin.keyboards;

import android.content.Context;
import android.os.Handler;
import android.util.Log;
import android.webkit.WebView;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.engine.SystemWebView;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import asp.citic.ptframework.PTFramework;
import asp.citic.ptframework.common.util.PTInvokeLater;
import asp.citic.ptframework.plugin.browser.PTWindowActivity;
import asp.citic.ptframework.securitykeyboard.PTInputEncryptorManager;
import asp.citic.ptframework.securitykeyboard.PTSecurityKeyboard;
import asp.citic.ptframework.securitykeyboard.PTSecurityKeyboardListener;

/**
 * Created by mj on 4/21/16.
 */
public class PTKeyboards extends CordovaPlugin{
    private String TAG = "PTKeyboards";
    private PTSecurityKeyboard securityKeyboard;
    private Context mContext;
    private PTWindowActivity me;
    private CallbackContext callback;

    private PTSecurityKeyboardListener securityKeyboardListener = new PTSecurityKeyboardListener() {
        private static final int OPTYPE_POPUP = 0;
        private static final int OPTYPE_INPUT = 1;
        private static final int OPTYPE_DELETE = 2;
        private static final int OPTYPE_SUBMIT = 3;
        static final String ATTR_DATA = "data";
        static final String ATTR_TYPE = "optype";
        private void doSecurityKeyboardCallback(int optype, boolean returnValue, boolean complete) {
            if (callback == null) {
                return;
            }
            JSONObject response = new JSONObject();
            try {
                JSONObject data = new JSONObject();
                data.put(ATTR_TYPE, optype);
                if (returnValue) {
                    // 需要返回密码值
                    data.put("value", securityKeyboard.getValue());
                }
                data.put("text", securityKeyboard.getText());
                data.put("strength", securityKeyboard.getInputStatistician()
                        .getStrength());
                response.put(ATTR_DATA, data);
                //callback.success(response);
                String dataStr = response.getString("data");
                switch (optype){
                    case OPTYPE_INPUT:
                        Log.d(TAG, "OPTYPE_INPUT====>" + dataStr);
                        me.dojs("cordova.fireDocumentEvent('keyboard.input', " + dataStr + ");");
                        break;
                    case OPTYPE_POPUP:
                        break;
                    case OPTYPE_DELETE:
                        Log.d(TAG, "OPTYPE_DELETE====>" + dataStr);
                        me.dojs("cordova.fireDocumentEvent('keyboard.delete', " + dataStr + ");");
                        break;
                    case OPTYPE_SUBMIT:
                        me.dojs("cordova.fireDocumentEvent('keyboard.submit');");
                        break;
                }

            } catch (Exception e) {
                doSecurityKeyboardCallback(OPTYPE_SUBMIT, true, true);
                //callback.error(e.getMessage());
            }
        }

        @Override
        public void onKeyboardPopup() {
            // 调用js桥，不返回密码，命令继续
            doSecurityKeyboardCallback(OPTYPE_POPUP, false, false);
        }

        @Override
        public void onInput(char c) {
            // 调用js桥，返回密码，命令继续
            doSecurityKeyboardCallback(OPTYPE_INPUT, true, false);
        }

        @Override
        public void onDelete() {
            // 调用js桥，返回密码，命令继续
            doSecurityKeyboardCallback(OPTYPE_DELETE, true, false);
        }

        @Override
        public void onDone() {
            // 调用js桥，返回密码，命令完成
            doSecurityKeyboardCallback(OPTYPE_SUBMIT, true, true);
            // 关闭密码键盘
            hideSecurityKeyboard();
        }

        @Override
        public void onCancel() {
            if(callback == null){
                return;
            }
            JSONObject response = new JSONObject();
            try {
                JSONObject data = new JSONObject();
                data.put(ATTR_TYPE, OPTYPE_SUBMIT);
                response.put(ATTR_DATA, data);
                //callback.success(response);
                doSecurityKeyboardCallback(OPTYPE_SUBMIT, true, true);
            } catch (Exception e) {
                //callback.error(e.getMessage());
                doSecurityKeyboardCallback(OPTYPE_SUBMIT, true, true);
            }
            hideSecurityKeyboard();
        }
    };

    public void hideSecurityKeyboard() {
        if (securityKeyboard != null) {
            me.dojs("cordova.fireDocumentEvent('keyboard.submit');");
            securityKeyboard.hide();
        }
    }

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        Log.d(TAG, "act=======>" + action);
        Log.d(TAG, "args=======>" + args.toString());
        this.callback = callbackContext;
        mContext = cordova.getActivity();
        me = (PTWindowActivity)cordova.getActivity();

       // ((PTWindowActivity) cordova.getActivity()).dojs("cordova.fireDocumentEvent('keyboard.input');");
        if (action.equals("jsShowKeyboards")){
            JSONObject jsonObj = new JSONObject(args.getString(0));
            String keyboardData = jsonObj.getString("data");
            final JSONObject keyboardObj = new JSONObject(keyboardData);
            //加密机配置
            String encryptor = keyboardObj.optString(PTSecurityKeyboard.ATTR_ENCRYPTOR, null);
            if (encryptor==null) {
                encryptor = PTInputEncryptorManager.DEFAULT_ENCRYPTOR;
            }else if ("false".equalsIgnoreCase(encryptor)) {
                encryptor = null;
            }
            if (encryptor!=null) {
                keyboardObj.put(PTSecurityKeyboard.ATTR_ENCRYPTOR, encryptor);
            }

            Log.d(TAG, "activity name====>" + cordova.getActivity().getLocalClassName());

            final WebView webView = (SystemWebView)me.getAppView().getEngine().getView();

            securityKeyboard = PTFramework.getSecurityKeyboard();
            PTInvokeLater.post(new Runnable() {
                @Override
                public void run() {
                    securityKeyboard.show(webView, securityKeyboardListener,
                            keyboardObj);
                }
            });

        }else if (action.equals("jsHideKeyboards")){
            PTInvokeLater.post(new Runnable() {
                @Override
                public void run() {
                    hideSecurityKeyboard();
                }
            });
        }
        return super.execute(action, args, callbackContext);
    }
}
