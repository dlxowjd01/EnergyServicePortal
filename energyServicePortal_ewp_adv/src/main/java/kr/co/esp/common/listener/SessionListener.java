package kr.co.esp.common.listener;

import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

public class SessionListener implements HttpSessionListener {

	@Override
	public void sessionCreated(HttpSessionEvent se) {
		se.getSession().setMaxInactiveInterval(-1); //음수를 입력하면 세션시간 무한대
	}

	@Override
	public void sessionDestroyed(HttpSessionEvent se) {}
}
