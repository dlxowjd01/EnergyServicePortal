package kr.co.ewp.ewpsp.common;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.core.MethodParameter;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;

import kr.co.ewp.ewpsp.common.util.UserUtil;

// Map은 작동 안됨. (현재 안씀)
@Deprecated
public class CommonArgumentResolver implements HandlerMethodArgumentResolver {

	public boolean supportsParameter(MethodParameter parameter) {
		String name = parameter.getParameterName();

		if (name == null) {
			return false;
		}

		Class clas = parameter.getParameterType();

		// 회원정보 가져옴
		if (Map.class.isAssignableFrom(clas) && name.equals(UserUtil.USER_SESSION_ID)) {
			return true;
		} else {
			return false;
		}
	}

	public Object resolveArgument(MethodParameter parameter, ModelAndViewContainer mavContainer,
			NativeWebRequest webRequest, WebDataBinderFactory binderFactory) throws Exception {
		String name = parameter.getParameterName();

		if (name == null) {
			return null;
		}

		// 회원정보 가져옴
		if (name.equals(UserUtil.USER_SESSION_ID)) {
			HttpServletRequest request = (HttpServletRequest)webRequest.getNativeRequest();
			HttpSession session = request.getSession();
			Map userInfo = (Map)session.getAttribute(UserUtil.USER_SESSION_ID);

			if (userInfo == null) {
				userInfo = new HashMap();
			}

			return userInfo;
		}

		return null;
	}
}
