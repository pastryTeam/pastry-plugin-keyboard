package asp.citic.ptframework.plugin.keyboards.securitykeyboard.tools;

/**
 * Created by Mystery on 16/6/28.
 */
public enum PTKeyBoardUtil {

    INSTANCE;
    private boolean rootViewisPush = false;

    public synchronized boolean isRootViewisPush() {
        return rootViewisPush;
    }

    public synchronized void setRootViewisPush(boolean rootViewisPush) {
        this.rootViewisPush = rootViewisPush;
    }
}
