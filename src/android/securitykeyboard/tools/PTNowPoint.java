package asp.citic.ptframework.plugin.keyboards.securitykeyboard.tools;

import android.view.MotionEvent;

/**
 * Created by Mystery on 16/6/23.
 */
public enum PTNowPoint {

    INSTANCE;
    private MotionEvent event = null;

    private PTNowPoint() {

    }

    public synchronized MotionEvent getEvent() {
        return event;
    }

    public synchronized void setEvent(MotionEvent event) {
        this.event = event;
    }
}
