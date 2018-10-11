package kr.co.ewp.ewpsp.common;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import kr.co.ewp.ewpsp.common.util.UserUtil;

public class SessionCheckInterceptor extends HandlerInterceptorAdapter {

	private static final Logger logger = LoggerFactory.getLogger(SessionCheckInterceptor.class);

	// controller보다 먼저 수행
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		logger.debug("++++++++++++++++SessionCheckInterceptor start++++++++++++++++");
		Map userInfo = UserUtil.getUserInfo(request);
		if (userInfo == null) {
			response.sendRedirect("/login");
			return false;
		} else {
			return super.preHandle(request, response, handler); // true
		}
	}
}
