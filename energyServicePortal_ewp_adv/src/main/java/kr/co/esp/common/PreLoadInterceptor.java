package kr.co.esp.common;

import egovframework.com.cmm.service.EgovProperties;
import kr.co.esp.common.util.UserUtil;
import kr.co.esp.system.service.CmpyGrpSiteMngService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.*;

public class PreLoadInterceptor extends HandlerInterceptorAdapter {

	@Value("${git.commit.id}")
	private String commitId;

	@Resource(name="cmpyGrpSiteMngService")
	private CmpyGrpSiteMngService cmpyGrpSiteMngService;
	
	// controller보다 먼저 수행
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		System.out.println("++++++++++++++++PreLoadInterceptor start++++++++++++++++");
		
		Map<String, Object> userInfo = UserUtil.getUserInfo(request);

		// 상단 사이트 목록 조회
		if (userInfo != null) {
			Integer userIdx = (Integer) userInfo.get("user_idx");
			Integer compIdx = (Integer) userInfo.get("comp_idx");
			Integer siteGrpIdx = (Integer) userInfo.get("site_grp_idx");
			String authType = (String) userInfo.get("auth_type");
			if (userIdx == null) {
				userIdx = -1; // userIdx가 빈값일 경우 검색이 안되게 한다.
			}

			Map<String, Object> param = new HashMap<String, Object>();
			// 권한이 없거나 시스템관리자가 아니면 사용자가 권한이 있는 목록만 검색한다.
			if (authType == null || (!"1".equals(authType) && !"2".equals(authType) && !"3".equals(authType))) {
				param.put("userIdx", userIdx);
			}
			if ("2".equals(authType)) {
				param.put("compIdx", compIdx);
			}
			if ("3".equals(authType)) {
				param.put("siteGrpIdx", siteGrpIdx);
			}

			List<Map<String, Object>> userGroupList = cmpyGrpSiteMngService.getUserGroupList(param);
			List<Map<String, Object>> userSiteList = cmpyGrpSiteMngService.getUserSiteList(param);
			request.setAttribute("userGroupList", userGroupList);
			request.setAttribute("userSiteList", userSiteList);
		}

		String siteId = (request.getParameter("siteId") != null && !"".equals(request.getParameter("siteId"))) ? request.getParameter("siteId") : (String) request.getSession().getAttribute("selViewSiteId");
		System.out.println("선택된 사이트id는   "+siteId);
		if (siteId != null) {
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("siteId", siteId);
			Map<String, Object> result = cmpyGrpSiteMngService.getSiteDetail(param);
			request.getSession().setAttribute("selViewSiteId", siteId);
			request.getSession().setAttribute("selViewSite", result);
			request.setAttribute("selViewSiteId", siteId);
			request.setAttribute("selViewSite", result);
		}

		// 군관리 메인은 세션의 사이트ID를 지운다.
		if (request.getRequestURI() != null && request.getRequestURI().startsWith("/main/gMain.do")) {
			request.getSession().removeAttribute("selViewSiteId");
			request.getSession().removeAttribute("selViewSite");
			request.removeAttribute("selViewSiteId");
			request.removeAttribute("selViewSite");
		}
		
		// 상단 시간 초기값 -- 서울로 세팅
		TimeZone timeZone = TimeZone.getTimeZone("Asia/Seoul");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		sdf.setTimeZone(timeZone);

		String gitVersion = EgovProperties.getGitProperty("git.commit.id.abbrev");
		request.setAttribute("nowTime", sdf.format(new Date()));
		request.setAttribute("gitVersion", gitVersion);
		return super.preHandle(request, response, handler);
	}
	
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		System.out.println("++++++++++++++++PreLoadInterceptor end++++++++++++++++");
		super.postHandle(request, response, handler, modelAndView);
	}
}
