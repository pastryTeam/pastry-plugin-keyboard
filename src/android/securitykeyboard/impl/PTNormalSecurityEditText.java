package asp.citic.ptframework.plugin.keyboards.securitykeyboard.impl;

import android.content.Context;
import android.graphics.Rect;
import android.util.AttributeSet;
import android.view.View;
import android.widget.EditText;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Iterator;

import asp.citic.ptframework.common.constants.PTFrameworkConstants;
import asp.citic.ptframework.common.tools.PTStringUtil;
import asp.citic.ptframework.plugin.keyboards.securitykeyboard.PTInputEncryptorManager;
import asp.citic.ptframework.plugin.keyboards.securitykeyboard.PTSecurityKeyboard;
import asp.citic.ptframework.plugin.keyboards.securitykeyboard.tools.PTSoftInputMethodUtil;

public class PTNormalSecurityEditText extends EditText {
    private static final int DEFAULT_MAXLENGTH = 16;
    private PTSecurityKeyboard keyboard = null;
    private JSONObject keyboardCfg;

    @SuppressWarnings("javadoc")
    public PTNormalSecurityEditText(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        init();
    }

    @SuppressWarnings("javadoc")
    public PTNormalSecurityEditText(Context context, AttributeSet attrs) {
        super(context, attrs);
        keyboardCfg = new JSONObject();
        try {
            //最大出入长度
            int maxLength;
            try {
                maxLength = Integer.parseInt(attrs.getAttributeValue(PTFrameworkConstants.PTConstant.NS_RESOURCE, "maxLength"));
            } catch (Exception e) {
                maxLength = DEFAULT_MAXLENGTH;
            }
            if (maxLength > 0) {
                keyboardCfg.put(PTSecurityKeyboard.ATTR_MAX_LENGTH, maxLength);
            }

            //是否遮盖
            boolean mask = !"false".equalsIgnoreCase(attrs.getAttributeValue(PTFrameworkConstants.PTConstant.NS_RESOURCE, "password"));
            if (!mask) {
                keyboardCfg.put(PTSecurityKeyboard.ATTR_MASK, mask);
            }

            //加密机配置
            String encryptor = attrs.getAttributeValue(null, "encryptor");
            // encryptor = "false";
            if (encryptor == null) {
                encryptor = PTInputEncryptorManager.DEFAULT_ENCRYPTOR;
            } else if ("false".equalsIgnoreCase(encryptor)) {
                encryptor = null;
            }
            if (encryptor != null) {
                keyboardCfg.put(PTSecurityKeyboard.ATTR_ENCRYPTOR, encryptor);
            }

            //键盘类型配置
            String inputType = attrs.getAttributeValue(null, "inputType");
            if ("number".equals(inputType)) {
                //数字键盘
                keyboardCfg.put(PTSecurityKeyboard.ATTR_KEYBOARD_TYPE, SubKeyboardViewBase.KEYBOARDTYPE_SMALLNUMBER);
            } else {
                //全键盘
                keyboardCfg.put(PTSecurityKeyboard.ATTR_KEYBOARD_TYPE, SubKeyboardViewBase.KEYBOARDTYPE_FULLALPHABET);
            }

            boolean random = attrs.getAttributeBooleanValue(null, PTSecurityKeyboard.ATTR_RANDOM, false);
            keyboardCfg.put(PTSecurityKeyboard.ATTR_RANDOM, random);
        } catch (JSONException e) {
        }
        init();
    }

    @SuppressWarnings("javadoc")
    public PTNormalSecurityEditText(Context context) {
        super(context);
        init();
    }

    private void init() {
        PTSoftInputMethodUtil.disabelSoftInputMethod(this);
        if (!isInEditMode()) {
            keyboard = new PTNormalSecurityKeyboard();
        }

        setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                PTSoftInputMethodUtil.hideSoftInputMethod(PTNormalSecurityEditText.this);
                //显示键盘
                keyboard.show(PTNormalSecurityEditText.this, keyboardCfg);
            }
        });
        setOnLongClickListener(new OnLongClickListener() {
            @Override
            public boolean onLongClick(View v) {
                //禁用长按菜单
                return true;
            }
        });
    }


    public void refreshConfig(JSONObject jsonObject) {
        if (jsonObject == null) {
            return;
        }
        String key;
        String value;
        for (Iterator<String> iterator = jsonObject.keys(); iterator.hasNext(); ) {
            key = iterator.next();
            value = jsonObject.optString(key);
            if (!PTStringUtil.isEmpty(key)) {
                try {
                    keyboardCfg.put(key, value);
                } catch (JSONException e) {
                }
            }
        }
    }

    @Override
    protected void onFocusChanged(boolean focused, int direction,
                                  Rect previouslyFocusedRect) {
        if (focused) {
            //获取焦点，显示键盘
            keyboard.show(this, keyboardCfg);
        } else {
            //失去焦点，隐藏键盘
            keyboard.hide();
        }
        super.onFocusChanged(focused, direction, previouslyFocusedRect);
    }

    public void setText(String data) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < data.length(); i++) {
            sb.append("*");
        }
        super.setText(sb.toString());
    }

    public String getKeyBoardText() {
        return keyboard.getText();
    }

    public String getKeyBoardValue() {
        return keyboard.getValue();
    }

    public String getPainTextValue() {
        return keyboard.getPainText();
    }
}
