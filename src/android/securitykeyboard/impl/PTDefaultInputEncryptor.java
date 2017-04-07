package asp.citic.ptframework.plugin.keyboards.securitykeyboard.impl;

import asp.citic.ptframework.common.algorithm.PTHex;
import asp.citic.ptframework.common.constants.PTFrameworkConstants;
import asp.citic.ptframework.common.tools.PTStringUtil;
import asp.citic.ptframework.secretkeys.PTSecretKeyManager;
import asp.citic.ptframework.security.PT3Des;
import asp.citic.ptframework.plugin.keyboards.securitykeyboard.PTInputEncryptor;
import asp.citic.ptframework.session.PTSessionManager;


/**
 * 密码键盘
 */
public enum PTDefaultInputEncryptor implements PTInputEncryptor{
	/**
	 * 默认安全键盘加密机实例
	 */
	INSTANCE;

	private byte[] encryptKey;
	private String inputValue;
	private String cipher;

	private PTDefaultInputEncryptor(){

		if (PTSessionManager.getSessionState()== PTFrameworkConstants.PTSessionStatus.STATE_HANDSHAKE_SUCCESS) {
			//握手已成功，组装密钥
			String key1 = PTSecretKeyManager.subSR();
			String key2 = PTSecretKeyManager.subCR();
			String key3 = PTSecretKeyManager.sessionkey;
			encryptKey = (key1+key2+key3).getBytes();
		}else {
			//TODO 初始随机密钥
			encryptKey = "000000000000000000000000".getBytes();
		}
//
//		PTMessageCenter.addListener(new PTFrameworkListener.SessionEventListener() {
//
//			@Override
//			public void onSessionEvent(int event, Object data) {
//				switch (event) {
//				case PTMessageCenter.EVENT_HANDSHAKESUCCESS:
//					//握手成功
//					String key1 = PTSessionManager.getDESRKey();
//					String key2 = PTSessionManager.getCRKey();
//					String key3 = PTSessionManager.getSessionkey();
//
//					encryptKey = (key1+key2+key3).getBytes();
//
//					//TODO 密钥更新，重新加密
//
////					PTLogger.d("键盘更新密钥成功：key="+encryptKey);
//					break;
//				default:
//					break;
//				}
//			}
//		});
	}

	public PTInputEncryptor getInstance(){
		return this;
	}

	public void reset(){
		this.inputValue = "";
		this.cipher = "";
	}

	@Override
	public void input(char input) {
		inputValue = inputValue + input;
		cipher = cipher + PTHex.encode(PT3Des.encrypt(new byte[]{(byte) input}, PTSecretKeyManager.getEncryptKey()));

	}

	@Override
	public void delete() {
		if(!PTStringUtil.isEmpty(inputValue) && inputValue.length() > 0){
			inputValue = inputValue.substring(0,inputValue.length()-1);
		}
		if(!PTStringUtil.isEmpty(cipher)){
			cipher = cipher.substring(0,cipher.length()-16);
		}
	}

	@Override
	public String getValue() {
		return cipher;
	}
}
