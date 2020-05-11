package kr.co.esp.common;

import egovframework.com.cmm.service.EgovProperties;
import kr.co.esp.common.util.UserUtil;
import kr.co.esp.system.service.CmpyGrpSiteMngService;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.*;

public class PreLoadInterceptor extends HandlerInterceptorAdapter {

	@Resource(name = "cmpyGrpSiteMngService")
	private CmpyGrpSiteMngService cmpyGrpSiteMngService;

	// controller보다 먼저 수행
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		System.out.println("++++++++++++++++PreLoadInterceptor start++++++++++++++++");

		HttpSession session = request.getSession();
		Map<String, Object> userInfo = UserUtil.getUserInfo(request);

		if(userInfo != null) {
			String[] systemLoc = request.getParameterValues("systemLoc");
			String[] systemType = request.getParameterValues("systemType");
			String systemValue = request.getParameter("systemValue");
			List<Map<String, Object>> siteList = (List<Map<String, Object>>) userInfo.get("siteList");
			List<Map<String, Object>> refineList = new ArrayList<Map<String, Object>>();

			if(systemValue != null && "system".equals(systemValue)) {
				session.setAttribute("systemLoc", systemLoc);
				session.setAttribute("systemTp", systemType);
			}

			if(systemLoc != null || systemType != null) {
				for(Map<String, Object> siteMap: siteList) {
					String siteLocation = (String) siteMap.get("location");
					int siteResourceType = (int) siteMap.get("resource_type");
					String siteId = (String) siteMap.get("sid");

					if(systemLoc != null) {
						for(String loc : systemLoc) {
							if(loc.startsWith(siteLocation)) {
								if(refineList.size() > 0) {
									for(Map<String, Object> refine : refineList) {
										String sid = (String) refine.get("sid");
										if(!sid.equals(siteId)) {
											refineList.add(siteMap);
											break;
										}
									}
								} else {
									refineList.add(siteMap);
								}
							}
						}
					}

					if(systemType != null) {
						for(String type : systemType) {
							if(type.equals(String.valueOf(siteResourceType))) {
								if(refineList.size() > 0) {
									for(Map<String, Object> refine : refineList) {
										String sid = (String) refine.get("sid");
										if(!sid.equals(siteId)) {
											refineList.add(siteMap);
											break;
										}
									}
								} else {
									refineList.add(siteMap);
								}
							}
						}
					}
				}
			} else {
				systemLoc = (String[]) session.getAttribute("systemLoc");
				systemType = (String[]) session.getAttribute("systemTp");

				if(systemLoc != null || systemType != null) {
					for(Map<String, Object> siteMap: siteList) {
						String siteLocation = (String) siteMap.get("location");
						int siteResourceType = (int) siteMap.get("resource_type");
						String siteId = (String) siteMap.get("sid");

						if(systemLoc != null) {
							for(String loc : systemLoc) {
								if(loc.startsWith(siteLocation))  {
									if(refineList.size() > 0) {
										for(Map<String, Object> refine : refineList) {
											String sid = (String) refine.get("sid");
											if(!sid.equals(siteId)) {
												refineList.add(siteMap);
												break;
											}
										}
									} else {
										refineList.add(siteMap);
									}
								}
							}
						}

						if(systemType != null) {
							for(String type : systemType) {
								if(type.equals(String.valueOf(siteResourceType))) {
									if(refineList.size() > 0) {
										for(Map<String, Object> refine : refineList) {
											String sid = (String) refine.get("sid");
											if(!sid.equals(siteId)) {
												refineList.add(siteMap);
												break;
											}
										}
									} else {
										refineList.add(siteMap);
									}
								}
							}
						}
					}
				} else {
					refineList = siteList;
				}
			}

			JSONArray jsonArray = new JSONArray();

			for(Map<String, Object> siteMap : refineList) {
				jsonArray.put(new JSONObject(siteMap));
			}

			request.setAttribute("siteList", jsonArray); //사이트 리스트 세팅

			String[] locationArray = {"서울특별시", "부산광역시", "대구광역시", "인천광역시", "광주광역시", "울산광역시", "경기도", "강원도", "충청북도", "충청남도", "전라북도", "전라남도", "경상북도", "경상남도", "제주도"};
			String[] type = {"수요", "태양광", "풍력", "소수력"};
			request.setAttribute("systemLocation", locationArray);
			request.setAttribute("systemType", type);
		} else {
			response.sendRedirect("/login.do");
			return false;
		}

		return super.preHandle(request, response, handler);
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView mav) throws Exception {
		System.out.println("++++++++++++++++PreLoadInterceptor end++++++++++++++++");


		// 상단 시간 초기값 -- 서울로 세팅
		TimeZone timeZone = TimeZone.getTimeZone("Asia/Seoul");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		sdf.setTimeZone(timeZone);

		String gitVersion = EgovProperties.getGitProperty("git.commit.id.abbrev");
		mav.addObject("nowTime", sdf.format(new Date()));
		mav.addObject("gitVersion", gitVersion);
		super.postHandle(request, response, handler, mav);
	}
}