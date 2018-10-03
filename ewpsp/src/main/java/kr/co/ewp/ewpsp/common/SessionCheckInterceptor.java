package kr.co.ewp.ewpsp.common;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import kr.co.ewp.ewpsp.common.util.UserUtil;

public class SessionCheckInterceptor extends HandlerInterceptorAdapter {
	
	// controller보다 먼저 수행
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		System.out.println("++++++++++++++++SessionCheckInterceptor start++++++++++++++++");
//		HttpSession session = request.getSession();
//		Map userInfo = new HashMap<String, Object>();
//		userInfo = (Map) session.getAttribute(UserUtil.USER_SESSION_ID);
//		if(userInfo == null) {
//			Map user = new HashMap<String, Object>();
//			user.put("", "");
//			session.setAttribute(UserUtil.USER_SESSION_ID, user);
//			response.sendRedirect("/siteMain");
//			return false; // 더이상 controller로 안감
//		} else {
//			return true; // controller로 이동
//		}
//		// preHandle의 return은 컨트롤러 요청 uri로 가도 되냐 안되냐를 허가하는 의미임
//		
//		
////		return super.preHandle(request, response, handler);
		return true; // controller로 이동
	}
	
	// controller 수행 후 화면에 보여지기 직전에 수행
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		System.out.println("++++++++++++++++SessionCheckInterceptor end++++++++++++++++");
//		super.postHandle(request, response, handler, modelAndView);
	}

}
