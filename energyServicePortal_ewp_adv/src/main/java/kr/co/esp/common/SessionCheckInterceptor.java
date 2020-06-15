package kr.co.esp.common;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import kr.co.esp.common.util.UserUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

public class SessionCheckInterceptor extends HandlerInterceptorAdapter {

	private static final Logger logger = LoggerFactory.getLogger(SessionCheckInterceptor.class);

	// controller보다 먼저 수행
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		logger.debug("++++++++++++++++SessionCheckInterceptor start++++++++++++++++");
		Map<String, Object> userInfo = UserUtil.getUserInfo(request);
		if (userInfo == null) {
			response.sendRedirect("/login.do");
			return false;
		} else {
			return super.preHandle(request, response, handler); // true
		}
	}
	
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		logger.debug("++++++++++++++++SessionCheckInterceptor end++++++++++++++++");
		super.postHandle(request, response, handler, modelAndView);
	}
}
