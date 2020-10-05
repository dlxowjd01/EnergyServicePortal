package kr.co.esp.common.listener;

import kr.co.esp.common.service.EgovProperties;

import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

public class SessionListener implements HttpSessionListener {

	private static String defaultOid = EgovProperties.getProperty("default.oid");


	@Override
	public void sessionCreated(HttpSessionEvent se) {
		if ("testkpx".equals(defaultOid)) {
			se.getSession().setMaxInactiveInterval(900); //TestKPX의 경우에는 세션 시간 15분으로 제한한다.
		} else {
			se.getSession().setMaxInactiveInterval(-1); //음수를 입력하면 세션시간 무한대
		}
	}

	@Override
	public void sessionDestroyed(HttpSessionEvent se) {}
}
