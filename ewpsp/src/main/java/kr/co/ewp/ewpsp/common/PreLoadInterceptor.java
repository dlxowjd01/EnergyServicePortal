package kr.co.ewp.ewpsp.common;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import kr.co.ewp.ewpsp.common.util.UserUtil;
import kr.co.ewp.ewpsp.service.CmpyGrpSiteMngService;

public class PreLoadInterceptor extends HandlerInterceptorAdapter {

	private static final Logger logger = LoggerFactory.getLogger(PreLoadInterceptor.class);
	
	@Resource(name="cmpyGrpSiteMngService")
	CmpyGrpSiteMngService cmpyGrpSiteMngService;

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		logger.debug("++++++++++++++++PreLoadInterceptor++++++++++++++++");
		Map userInfo = UserUtil.getUserInfo(request);
//		logger.debug("userInfo:{}", userInfo);

		// 상단 사이트 목록 조회
		if(userInfo != null) {
			Integer userIdx = (Integer)userInfo.get("user_idx");
			Integer compIdx = (Integer)userInfo.get("comp_idx");
			Integer siteGrpIdx = (Integer)userInfo.get("site_grp_idx");
			String authType = (String)userInfo.get("auth_type");
			if (userIdx == null) {
				userIdx = -1; // userIdx가 빈값일 경우 검색이 안되게 한다.
			}

			HashMap param = new HashMap<String, Object>();
			// 권한이 없거나 시스템관리자가 아니면 사용자가 권한이 있는 목록만 검색한다.
			if (authType == null || (!authType.equals("1") && !authType.equals("2") && !authType.equals("3"))) {
				param.put("userIdx", userIdx);
			}
			if(authType.equals("2")) {
				param.put("compIdx", compIdx);
			}
			if(authType.equals("3")) {
				param.put("siteGrpIdx", siteGrpIdx);
			}

			List userGroupList = cmpyGrpSiteMngService.getUserGroupList(param);
			List userSiteList = cmpyGrpSiteMngService.getUserSiteList(param);
			request.setAttribute("userGroupList", userGroupList);
			request.setAttribute("userSiteList", userSiteList);
			logger.debug("userGroupList:{}", userGroupList);
		}
		
		String siteId = (request.getParameter("siteId") != null && !"".equals(request.getParameter("siteId"))) ? request.getParameter("siteId") : (String) request.getSession().getAttribute("selViewSiteId");
		if(siteId != null) {
			HashMap param = new HashMap<String, Object>();
			param.put("siteId", siteId);
			Map result = cmpyGrpSiteMngService.getSiteDetail(param);
			request.getSession().setAttribute("selViewSiteId", siteId);
			request.getSession().setAttribute("selViewSite", result);
			request.setAttribute("selViewSiteId", siteId);
			request.setAttribute("selViewSite", result);
		}

		// 군관리 메인은 세션의 사이트ID를 지운다.
		if (request.getRequestURI() != null && request.getRequestURI().startsWith("/main")) {
			request.getSession().removeAttribute("selViewSiteId");
			request.getSession().removeAttribute("selViewSite");
			request.removeAttribute("selViewSiteId");
			request.removeAttribute("selViewSite");
		}

		// 상단 시간 초기값
		request.setAttribute("nowTime", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));

		return super.preHandle(request, response, handler);
	}
}
