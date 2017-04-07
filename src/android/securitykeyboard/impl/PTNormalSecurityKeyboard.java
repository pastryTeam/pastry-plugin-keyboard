package asp.citic.ptframework.plugin.keyboards.securitykeyboard.impl;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.animation.ValueAnimator;
import android.content.Context;
import android.graphics.drawable.BitmapDrawable;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnTouchListener;
import android.view.ViewGroup;
import android.webkit.WebView;
import android.widget.EditText;
import android.widget.PopupWindow;

import org.json.JSONObject;

import asp.citic.ptframework.PTFramework;
import asp.citic.ptframework.R;
import asp.citic.ptframework.common.device.PTDeviceUtil;
import asp.citic.ptframework.common.tools.PTStringUtil;
import asp.citic.ptframework.plugin.keyboards.securitykeyboard.PTInputEncryptor;
import asp.citic.ptframework.plugin.keyboards.securitykeyboard.PTInputEncryptorManager;
import asp.citic.ptframework.plugin.keyboards.securitykeyboard.PTInputStatistician;
import asp.citic.ptframework.plugin.keyboards.securitykeyboard.PTSecurityKeyboard;
import asp.citic.ptframework.plugin.keyboards.securitykeyboard.PTSecurityKeyboardInputChangeListener;
import asp.citic.ptframework.plugin.keyboards.securitykeyboard.PTSecurityKeyboardListener;
import asp.citic.ptframework.plugin.keyboards.securitykeyboard.PTTopActivityManager;
import asp.citic.ptframework.plugin.keyboards.securitykeyboard.tools.PTInvokeLater;
import asp.citic.ptframework.plugin.keyboards.securitykeyboard.tools.PTKeyBoardUtil;
import asp.citic.ptframework.plugin.keyboards.securitykeyboard.tools.PTNowPoint;
import asp.citic.ptframework.plugin.keyboards.securitykeyboard.tools.PTSoftInputMethodUtil;

/**
 * 系统名称: 中信网科移动基础框架-Pastry<br />
 */
public class PTNormalSecurityKeyboard implements PTSecurityKeyboard {

    private static final int DEFAULT_KEYBOARD_TYPE = SubKeyboardViewBase.KEYBOARDTYPE_FULLALPHABET;
    private static final long DELAY_HIDE = 150;
    private PopupWindow keyboardWindow;
    private PTDefaultSecurityKeyboardView keyboardView;
    private String value;
    private String text;
    private String plaintext;
    private View currentInputView;
    private View pushView;
    private int pushView_layout_height;
    private boolean mask;
    private boolean random;
    private int keyboardHeight;
    private PTSecurityKeyboardListener securityKeyboardListener;
    private int maxLength;
    private int keyboardType = 0;
    private PTInputEncryptor encryptor;
    private volatile boolean requireShowKeyboard;
    private PTInputStatistician statistician = new PTDefaultInputStatistician();

    private boolean isPush = false;

    private boolean pushType = false;

    public PTNormalSecurityKeyboard() {
        Context context = PTFramework.getContext();
        keyboardHeight = (int) (PTDeviceUtil.getScreenHeight() * 0.4);
        keyboardWindow = new PopupWindow(context);
        keyboardWindow.setBackgroundDrawable(new BitmapDrawable(context
                .getResources()));
        keyboardWindow.setFocusable(false);
        keyboardWindow.setTouchable(true);
        keyboardWindow.setAnimationStyle(R.style.popwindow_bottom);
        keyboardWindow.setWidth(PTDeviceUtil.getScreenWidth());
        keyboardWindow.setHeight(keyboardHeight);
        PTSecurityKeyboardListener listener = new PTSecurityKeyboardListener() {

            @Override
            public void onInput(char input) {
                if (maxLength > 0 && !PTStringUtil.isEmpty(text)
                        && text.length() >= maxLength) {
                    return;
                }
                statistician.input(input);
                plaintext = plaintext + input;
                if (encryptor != null) {
                    encryptor.input(input);
                    value = encryptor.getValue();
                    if (mask) {
                        text = text + "*";
                    } else {
                        text = text + input;
                    }
                } else {
                    value = value + input;
                    if (mask) {
                        text = text + "*";
                    } else {
                        text = value;
                    }
                }
                if (currentInputView instanceof EditText) {
                    EditText inputView = (EditText) currentInputView;
                    inputView.setText(text);
                    inputView.setTag(value);
                    inputView.setSelection(text.length());
                } else if (currentInputView instanceof WebView) {
                    securityKeyboardListener.onInput(input);
                }
                Object topObject = PTTopActivityManager.getTopObject();
                if (topObject instanceof PTSecurityKeyboardInputChangeListener) {
                    ((PTSecurityKeyboardInputChangeListener) topObject)
                            .onInputChange(currentInputView);
                }
            }

            @Override
            public void onDelete() {
                if (text.length() <= 0) {
                    return;
                }
                statistician.delete();
                if (encryptor != null) {
                    encryptor.delete();
                    value = encryptor.getValue();
                    text = text.substring(0, text.length() - 1);
                } else {
                    value = value.substring(0, value.length() - 1);
                    text = value;
                }
                plaintext = plaintext.substring(0, plaintext.length() - 1);

                if (currentInputView instanceof EditText) {
                    EditText inputView = (EditText) currentInputView;
                    String input = inputView.getText().toString();
                    if (input.length() > 0) {
                        inputView.setText(text);
                        inputView.setTag(value);
                        inputView.setSelection(text.length());
                    }
                } else if (currentInputView instanceof WebView) {
                    securityKeyboardListener.onDelete();
                }

                Object topObject = PTTopActivityManager.getTopObject();
                if (topObject instanceof PTSecurityKeyboardInputChangeListener) {
                    ((PTSecurityKeyboardInputChangeListener) topObject)
                            .onInputChange(currentInputView);
                }
            }

            @Override
            public void onDone() {
                if (currentInputView instanceof EditText) {
                    currentInputView.setTag(value);
                    hide();
                } else if (currentInputView instanceof WebView) {
                    securityKeyboardListener.onDone();
                }
            }

            @Override
            public void onCancel() {
                if (currentInputView instanceof EditText) {
                    hide();
                    currentInputView.setTag("");
                } else if (currentInputView instanceof WebView) {
                    securityKeyboardListener.onCancel();
                }

                Object topObject = PTTopActivityManager.getTopObject();
                if (topObject instanceof PTSecurityKeyboardInputChangeListener) {
                    ((PTSecurityKeyboardInputChangeListener) topObject)
                            .onInputChange(currentInputView);
                }
            }

            @Override
            public void onKeyboardPopup() {
            }

        };
        keyboardView = new PTDefaultSecurityKeyboardView(listener);
        keyboardWindow.setContentView(keyboardView);
    }

    private void showAndConfigKeyboard(final JSONObject conf) {
        // 隐藏原生键盘
        PTSoftInputMethodUtil.hideSoftInputMethod(currentInputView);
        PTInvokeLater.postDelayed(new Runnable() {
            @Override
            public void run() {
                // 标记需要显示键盘
                requireShowKeyboard = true;
                if (isShowing()) {
                    configKeyboard(conf);
                    clear();
                } else {
                    if (pushType == true) {
                        //代表WebView页面需要弹出键盘
                        final View rootView = currentInputView.getRootView();
                        PTSoftInputMethodUtil.hideSoftInputMethod(rootView);
                        keyboardView.setRootView(rootView);
                        MotionEvent event = PTNowPoint.INSTANCE.getEvent();
                        if (event != null) {
                            System.out.println("PTNormalSecurityKeyboard " + "X=" + event.getX() + ",Y=" + event.getY());
                            int x = (int) event.getX();
                            int y = (int) event.getY();
                            boolean viewHasPushed = PTKeyBoardUtil.INSTANCE.isRootViewisPush();
                            if (viewHasPushed) {
                                //代表页面应推动了
                                if (y + 60 + 2 * keyboardHeight >= PTDeviceUtil.getScreenHeight()) {
                                    pushView_layout_height = keyboardHeight;
                                    ValueAnimator animator = ValueAnimator.ofFloat(0, pushView_layout_height);
                                    animator.setTarget(rootView);
                                    animator.setDuration(400);
                                    animator.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
                                        @Override
                                        public void onAnimationUpdate(ValueAnimator animation) {
                                            float a = (Float) animation.getAnimatedValue();
                                            rootView.scrollTo(0, (int) a);
                                        }
                                    });
                                    animator.start();
                                    isPush = true;
                                }
                            } else {
                                //代表页面没有被推动
                                if (y + 60 + keyboardHeight >= PTDeviceUtil.getScreenHeight()) {
                                    pushView_layout_height = keyboardHeight;
                                    ValueAnimator animator = ValueAnimator.ofFloat(0, pushView_layout_height);
                                    animator.setTarget(rootView);
                                    animator.setDuration(400);
                                    animator.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
                                        @Override
                                        public void onAnimationUpdate(ValueAnimator animation) {
                                            float a = (Float) animation.getAnimatedValue();
                                            rootView.scrollTo(0, (int) a);
                                        }
                                    });
                                    animator.start();
                                    isPush = true;
                                    PTKeyBoardUtil.INSTANCE.setRootViewisPush(true);
                                }
                            }
                        } else {

                        }
                        if (currentInputView instanceof WebView) {
                            // 通知WebView键盘弹出
                            securityKeyboardListener.onKeyboardPopup();
                        }
                        keyboardWindow.showAtLocation(rootView, Gravity.BOTTOM
                                | Gravity.LEFT, 0, 0);
                        configKeyboard(conf);
                        clear();
                    } else {
                        configKeyboard(conf);
                        ShowkeyBoard(conf);
                        clear();
                    }
                }
            }
        }, 40);
    }

    private void ShowkeyBoard(JSONObject conf) {
        final View rootView = currentInputView.getRootView();
        /**
         * 推动页面思路：
         * 首先得到edittext的高度
         * 判断键盘的高度+edittext的绝对高度是否超过屏幕，
         * 如果超过屏幕将屏幕一部分上移
         */
        int editTextHeight = currentInputView.getHeight();
        int[] location = new int[2];
        currentInputView.getLocationOnScreen(location);
        if (editTextHeight + location[1] + keyboardHeight > PTDeviceUtil.getScreenHeight()) {
            rootView.getLayoutParams().height = rootView.getHeight()
                    - keyboardHeight;
            pushView_layout_height = (location[1] + editTextHeight + keyboardHeight) - PTDeviceUtil.getScreenHeight();
            ValueAnimator animator = ValueAnimator.ofFloat(0, pushView_layout_height);
            animator.setTarget(rootView);
            animator.setDuration(200).start();
            animator.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
                @Override
                public void onAnimationUpdate(ValueAnimator animation) {
                    float a = (Float) animation.getAnimatedValue();
                    rootView.scrollTo(0, (int) a);
                }
            });
            isPush = true;
        }
        keyboardView.setRootView(rootView);
        keyboardWindow.showAtLocation(rootView, Gravity.BOTTOM
                | Gravity.LEFT, 0, 0);
        // 配置键盘
        configKeyboard(conf);
        // 清除输入
        clear();
    }

    @Override
    public void show(WebView webView, PTSecurityKeyboardListener listener,
                     JSONObject conf) {
        currentInputView = webView;
        final View rootView = currentInputView.getRootView();
        pushView = webView;
        this.securityKeyboardListener = listener;
        keyboardWindow.setOutsideTouchable(true);
        keyboardWindow.setTouchInterceptor(new OnTouchListener() {
            @Override
            public boolean onTouch(View view, MotionEvent event) {
                if (event.getAction() == MotionEvent.ACTION_OUTSIDE) {
                    keyboardView.onCancel();
                    return true;
                }
                return false;
            }
        });
        pushType = true;
        showAndConfigKeyboard(conf);
    }

    @Override
    public void show(final EditText input, JSONObject conf) {
        if (input.getWindowToken() != null) {
            currentInputView = input;
            pushView = ((ViewGroup) input.getRootView()).getChildAt(0);
            keyboardWindow.setOutsideTouchable(false);
            keyboardWindow.setTouchInterceptor(null);
            pushType = false;
            showAndConfigKeyboard(conf);
        }
    }

    private void configKeyboard(JSONObject conf) {
        if (conf == null) {
            // 默认值
            conf = new JSONObject();
        }
        mask = conf.optBoolean(ATTR_MASK, true);
        maxLength = conf.optInt(ATTR_MAX_LENGTH, DEFAULT_MAX_LENGTH);
        random = conf.optBoolean(ATTR_RANDOM, false);
        keyboardView.doRandom(random);
        keyboardType = conf.optInt(ATTR_KEYBOARD_TYPE, DEFAULT_KEYBOARD_TYPE);
        keyboardView.setKeyboardType(keyboardType);
        String encryptorName = conf.optString(ATTR_ENCRYPTOR, null);
        encryptor = PTInputEncryptorManager.getEncrypterInstance(encryptorName);
    }

    @Override
    public void hide() {
        if (currentInputView != null
                && currentInputView.getWindowToken() != null
                && keyboardWindow != null && keyboardWindow.isShowing()) {
            requireShowKeyboard = false;
            PTInvokeLater.postDelayed(new Runnable() {
                @Override
                public void run() {
                    if (!requireShowKeyboard && keyboardWindow.isShowing()) {
                        //新加的隐藏键盘
                        final View rootView = currentInputView.getRootView();
                        if (pushType == false) {
                            if (isPush) {
                                rootView.getLayoutParams().height = rootView.getHeight()
                                        + keyboardHeight;
                                ValueAnimator animator = ValueAnimator.ofFloat(0, pushView_layout_height);
                                animator.setTarget(rootView);
                                animator.setDuration(150).start();
                                animator.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
                                    @Override
                                    public void onAnimationUpdate(ValueAnimator animation) {
                                        float a = (Float) animation.getAnimatedValue();
                                        rootView.scrollTo(0, pushView_layout_height - (int) a);
                                    }
                                });
                                animator.addListener(new AnimatorListenerAdapter() {
                                    @Override
                                    public void onAnimationEnd(Animator animation) {
                                        pushView_layout_height = 0;
                                    }
                                });
                            }
                        } else {
                            if (isPush) {
                                ValueAnimator animator = ValueAnimator.ofFloat(0, pushView_layout_height);
                                animator.setTarget(rootView);
                                animator.setDuration(150).start();
                                animator.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
                                    @Override
                                    public void onAnimationUpdate(ValueAnimator animation) {
                                        float a = (Float) animation.getAnimatedValue();
                                        rootView.scrollTo(0, pushView_layout_height - (int) a);
                                    }
                                });
                                animator.addListener(new AnimatorListenerAdapter() {
                                    @Override
                                    public void onAnimationEnd(Animator animation) {
                                        pushView_layout_height = 0;
                                    }
                                });
                                //PTKeyBoardUtil.INSTANCE.setRootViewisPush(false);
                            }
                            //原来的隐藏键盘
                           /* if (pushView.getHeight() + keyboardHeight <= PTDeviceUtil
                                    .getScreenHeight()) {
//							pushView.getLayoutParams().height = pushView
//									.getHeight() + keyboardHeight;
                                pushView.getLayoutParams().height = pushView_layout_height;
                                pushView.requestLayout();
                            }*/
                        }
                        keyboardWindow.dismiss();
                        keyboardView.release();
                    }
                }
            }, DELAY_HIDE);
        }
    }

    @Override
    public String getValue() {
        return value;
    }

    /**
     * 邵志 1014 增加 start
     */
    @Override
    public String getText() {
        return text;
    }

    @Override
    public String getPainText() {
        return plaintext;
    }

    /**
     * 邵志 1014 增加 end
     */

    @Override
    public boolean isEncrypt() {
        return encryptor != null;
    }

    @Override
    public void setInputStatistician(PTInputStatistician statistician) {
        this.statistician = statistician;
    }

    @Override
    public PTInputStatistician getInputStatistician() {
        return statistician;
    }

    @Override
    public boolean isShowing() {
        if (keyboardWindow != null && keyboardWindow.isShowing()) {
            return true;
        }
        return false;
    }

    @Override
    public void clear() {
        value = "";
        text = "";
        plaintext = "";
        if (encryptor != null) {
            encryptor.reset();
        }
        if (statistician != null) {
            statistician.reset();
        }
        if (currentInputView instanceof EditText) {
            ((EditText) currentInputView).setText("");
        }
    }
}
