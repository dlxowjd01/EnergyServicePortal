package kr.co.ewp.ewpsp.common;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import kr.co.ewp.ewpsp.common.util.CommonUtils;
import kr.co.ewp.ewpsp.service.CmpyGrpSiteMngService;

public class PreLoadInterceptor extends HandlerInterceptorAdapter {

	private static final Logger logger = LoggerFactory.getLogger(PreLoadInterceptor.class);
	
	@Resource(name="cmpyGrpSiteMngService")
	CmpyGrpSiteMngService cmpyGrpSiteMngService;

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

		HttpSession session = request.getSession();
		Map userInfo = new HashMap<String, Object>();
		userInfo = (Map) session.getAttribute("userInfo");
//		logger.debug("userInfo:{}", userInfo);

		if(userInfo != null && CommonUtils.isNotEmpty(userInfo.get("user_idx"))) {

			HashMap param = new HashMap<String, Object>();
			param.put("userIdx", userInfo.get("user_idx"));

			List userSiteList = cmpyGrpSiteMngService.getUserSiteList(param);
			request.setAttribute("userSiteList", userSiteList);
			logger.debug("userSiteList:{}", userSiteList);
		}

		return super.preHandle(request, response, handler);
	}
}
