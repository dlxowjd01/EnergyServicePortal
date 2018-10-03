package kr.co.ewp.ewpsp.common.util;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public class UserUtil {

	public final static String USER_SESSION_ID = "userInfo";

	public static Map getUserInfo(HttpSession session) {
		Map userInfo = (Map)session.getAttribute(UserUtil.USER_SESSION_ID);
		return userInfo;
	}

	public static Map getUserInfo(HttpServletRequest request) {
		return UserUtil.getUserInfo(request.getSession());
	}
}
