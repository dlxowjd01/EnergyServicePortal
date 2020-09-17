package kr.co.esp.common.filter;

import javax.servlet.*;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Cookie 언어 설정
 *
 * @author jungjaekeun
 * @version 1.0
 * @see <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2020/09/14  jungjaekeun          최초 생성
 *
 * </pre>
 * @since 2020/09/14
 */
public class CookieLocaleFilter implements Filter {

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		HttpServletRequest req = (HttpServletRequest) request;
		HttpServletResponse res = (HttpServletResponse) response;

		if (req.getParameter("language") != null) {
			Cookie cookie = new Cookie("lang", req.getParameter("language"));
			cookie.setPath("/");
			res.addCookie(cookie);
		}

		chain.doFilter(request, response);
	}

	@Override
	public void destroy() {}
}
