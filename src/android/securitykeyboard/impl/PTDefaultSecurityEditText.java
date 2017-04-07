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
 * <td>Apr 7, 20164:19:42 PM </td>
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
public class PTDefaultSecurityEditText extends EditText {
    private static final int DEFAULT_MAXLENGTH = 20;

    private PTSecurityKeyboard keyboard = null;

    private JSONObject keyboardCfg;

    @SuppressWarnings("javadoc")
    public PTDefaultSecurityEditText(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        init();
    }

    @SuppressWarnings("javadoc")
    public PTDefaultSecurityEditText(Context context, AttributeSet attrs) {
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
            //encryptor = "false";
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
            //数字乱序字母不乱序
            boolean randomNum = attrs.getAttributeBooleanValue(null, PTSecurityKeyboard.ATTR_NUM_RANDOM, false);
            keyboardCfg.put(PTSecurityKeyboard.ATTR_NUM_RANDOM, randomNum);

        } catch (JSONException e) {
//			PTLogger.t(e);
        }
        init();
    }

    @SuppressWarnings("javadoc")
    public PTDefaultSecurityEditText(Context context) {
        super(context);
        init();
    }

    private void init() {
        PTSoftInputMethodUtil.disabelSoftInputMethod(this);
        if (!isInEditMode()) {
//            keyboard = PTFramework.getSecurityKeyboard();
            keyboard = new PTNormalSecurityKeyboard();
        }

        setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                PTSoftInputMethodUtil.hideSoftInputMethod(PTDefaultSecurityEditText.this);
                //显示键盘
//                PTInvokeLater.postDelayed(new Runnable() {
//                    @Override
//                    public void run() {
                keyboard.show(PTDefaultSecurityEditText.this, keyboardCfg);
//                    }
//                }, 1000);
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

    public void clear() {
        keyboard. clear();
    }

    public String getKeyBoardText() {
        return keyboard.getText();
    }

    public String getKeyBoardValue() {
        return keyboard.getValue();
    }

    public void setKeyBoardValue(String value)
    {

    }

    public String getPainTextValue() {
        return keyboard.getPainText();
    }
}
