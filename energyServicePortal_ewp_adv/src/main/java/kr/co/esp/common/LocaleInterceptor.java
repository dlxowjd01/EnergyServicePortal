package kr.co.esp.common;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Locale;

public class LocaleInterceptor extends HandlerInterceptorAdapter {

	private static final Logger logger = LoggerFactory.getLogger(LocaleInterceptor.class);

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		logger.debug("++++++++++++++++LocateInterceptor start++++++++++++++++");

		HttpSession session = request.getSession();
		String sessionLang = (String) session.getAttribute("sessionLang");

		String lang = request.getParameter("lang");
		if (lang == null || "".equals(lang)) {
			if (sessionLang == null || "".equals(sessionLang)) {
				lang = "ko";
			} else {
				lang = sessionLang;
			}
		}

		//step. 파라메터에 따라서 로케일 생성, 기본은 KOREAN
		Locale lo = null;
		if (lang.matches("en")) {
			lo = Locale.ENGLISH;
		} else {
			lo = Locale.KOREAN;
		}

		// step. Locale을 새로 설정한다.
		session.setAttribute("sessionLocale", lo);
		session.setAttribute("sessionLang", lang);
		session.setAttribute("sessionLangNm", lang.toUpperCase());

		return super.preHandle(request, response, handler);
	}
	
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		logger.debug("++++++++++++++++LocateInterceptor end++++++++++++++++");
		super.postHandle(request, response, handler, modelAndView);
	}
}