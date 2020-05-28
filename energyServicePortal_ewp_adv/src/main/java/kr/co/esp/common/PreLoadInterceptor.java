package kr.co.esp.common;

import egovframework.com.cmm.service.EgovProperties;
import kr.co.esp.common.util.RestApiUtil;
import kr.co.esp.common.util.StringUtil;
import kr.co.esp.common.util.UserUtil;
import kr.co.esp.system.service.CmpyGrpSiteMngService;
import org.apache.commons.lang.StringUtils;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.security.access.method.P;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.annotation.Resource;
import javax.json.Json;
import javax.json.JsonObject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.*;

import static kr.co.esp.common.util.RestApiUtil.*;

public class PreLoadInterceptor extends HandlerInterceptorAdapter {

	@Resource(name = "cmpyGrpSiteMngService")
	private CmpyGrpSiteMngService cmpyGrpSiteMngService;

	// controller보다 먼저 수행
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		System.out.println("++++++++++++++++PreLoadInterceptor start++++++++++++++++");

		HttpSession session = request.getSession();
		Map<String, Object> groupMap = new HashMap<String, Object>();
		List<Map<String, Object>> refineList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> siteOriginList = new ArrayList<Map<String, Object>>();
		Map<String, Object> userInfo = UserUtil.getUserInfo(request);
		JSONArray jsonArray = new JSONArray();

		if(userInfo != null) {
			String token = (String) userInfo.get("token");

			String[] systemLoc = request.getParameterValues("systemLoc");
			String[] systemType = request.getParameterValues("systemType");
			String systemValue = request.getParameter("systemValue");

			Map<String, Object> siteMap = get("/auth/me/sites", null, token); //사이트 리스트 정보
			if(200 == (int) siteMap.get("code")) {
				siteOriginList = (List<Map<String, Object>>) siteMap.get("data");
				request.setAttribute("siteHeaderList", siteOriginList); //사이트 리스트 세팅
			} else {
				request.setAttribute("siteHeaderList", null); //사이트 리스트 세팅
			}

			Map<String, String> parameters = new HashMap<String, String>();
			parameters.put("includeSites", "true");

			Map<String, Object> userSiteGroupSearch = get("/auth/me/groups", parameters, token); //그룹화되어있는 사이트 리스트 정보
			if(200 == (int) userSiteGroupSearch.get("code")) {
				groupMap = (Map<String, Object>) userSiteGroupSearch.get("data");

				request.setAttribute("tag_group", groupMap.get("tag_group")); //태그그룹 별
				request.setAttribute("vpp_group", groupMap.get("vpp_group")); //중개거래그룹 별
				request.setAttribute("dr_group", groupMap.get("dr_group")); //DR그룹 별
				request.setAttribute("location_group", groupMap.get("location_group")); //지역그룹 별
				request.setAttribute("resource_group", groupMap.get("resource_group")); //설비 별
			} else {
				request.setAttribute("tag_group", null); //태그그룹 별
				request.setAttribute("vpp_group", null); //중개거래그룹 별
				request.setAttribute("dr_group", null); //DR그룹 별
				request.setAttribute("location_group", null); //지역그룹 별
				request.setAttribute("resource_group", null); //설비 별
			}

			if("/dashboard/gmain.do".equals(request.getRequestURI())) {
				List<Map<String, Object>> selectList = new ArrayList<Map<String, Object>>();
				if(systemValue != null && "system".equals(systemValue)) {
					selectList = makeSiteList(siteOriginList, groupMap, session, systemLoc, systemType, systemValue);
				} else {
					session.removeAttribute("systemLoc");
					session.removeAttribute("systemTp");

					refineList = siteOriginList;
				}

				if(request.getParameter("sgid") != null && !"".equals(request.getParameter("sgid"))) {
					String siteName = "";
					if(groupMap != null && !groupMap.isEmpty()) {
						for(Map<String, Object> tagGroup: (List<Map<String, Object>>) groupMap.get("tag_group")) {
							if(request.getParameter("sgid").equals(tagGroup.get("sgid"))) {
								siteName = (String) tagGroup.get("name");
								refineList = (List<Map<String, Object>>) tagGroup.get("sites");
								break;
							} else {
								continue;
							}
						}
					}

					request.setAttribute("sgid", request.getParameter("sgid"));
					request.setAttribute("siteName", siteName);
				} else {
					//그룹 대시보드는 처음 진입시 들어오는 화면이라 파라미터가 없을경우는 사용자가 볼수있는 모든 사이트가 대상이다.
					request.setAttribute("sgid", "");
					request.setAttribute("siteName", "전체");
				}

				if(systemValue != null && "system".equals(systemValue)) {
					refineList = intersection(refineList, selectList);
				} else {
					refineList = siteOriginList;
				}

				for(Map<String, Object> refineMap : refineList) {
					jsonArray.put(new JSONObject(refineMap));
				}

				request.setAttribute("siteList", jsonArray); //사이트 리스트 세팅

			} else if("/dashboard/jmain.do".equals(request.getRequestURI())) {
				if(request.getParameter("vgid") != null && !"".equals(request.getParameter("vgid"))) {
					String siteName = "";
					if (groupMap != null && !groupMap.isEmpty()) {
						for (Map<String, Object> tagGroup : (List<Map<String, Object>>) groupMap.get("vpp_group")) {
							if (request.getParameter("vgid").equals(tagGroup.get("vgid"))) {
								siteName = (String) tagGroup.get("name");
								refineList = (List<Map<String, Object>>) tagGroup.get("sites");
								break;
							} else {
								continue;
							}
						}
					}

					if(refineList.size() > 0) {
						for (Map<String, Object> tmpMap : refineList) {
							jsonArray.put(new JSONObject(tmpMap));
						}
					}
					request.setAttribute("vgid", request.getParameter("vgid"));
					request.setAttribute("siteName", siteName);
					request.setAttribute("siteList", jsonArray); //사이트 리스트 세팅
				} else {
					throw new Exception();
				}
			} else if("/dashboard/smain.do".equals(request.getRequestURI())) {
				if(request.getParameter("sid") != null && !"".equals(request.getParameter("sid"))) {
					if (siteOriginList != null && siteOriginList.size() > 0) {
						String siteName = "";
						String timeZone = "Asia/Seoul";
						for(Map<String, Object> tmpMap: siteOriginList) {
							if(request.getParameter("sid").equals(tmpMap.get("sid"))) {
								siteName = (String) tmpMap.get("name");
								timeZone = (String) tmpMap.get("tx");
								break;
							} else {
								continue;
							}
						}

						request.setAttribute("sid", request.getParameter("sid"));
						request.setAttribute("siteName", siteName);
						request.setAttribute("timeZone", timeZone);
					}
				} else {
					throw new Exception();
				}
			} else {
				refineList = makeSiteList(siteOriginList, groupMap, session, systemLoc, systemType, systemValue);

				for(Map<String, Object> refineMap : refineList) {
					jsonArray.put(new JSONObject(refineMap));
				}

				request.setAttribute("siteList", jsonArray); //사이트 리스트 세팅
			}

			parameters.clear();
			parameters.put("types", "resource,location");
			Map<String, Object> typeProperties = get("/config/view/properties", parameters, token); //그룹화되어있는 사이트 리스트 정보
			if(200 == (int) typeProperties.get("code")) {
				Map<String, Object> typeMap = (Map<String, Object>) typeProperties.get("data");

				request.setAttribute("resource", typeMap.get("resource"));
				request.setAttribute("location", typeMap.get("location"));
			} else {
				request.setAttribute("resource", null);
				request.setAttribute("location", null);
			}
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

	/**
	 * 현재 페이지에서 사용할 사이트 리스트를 생성한다.
	 *
	 * @param userSiteGroupSearch
	 * @param session
	 * @param systemLoc
	 * @param systemType
	 * @param systemValue
	 * @return
	 */
	public List<Map<String, Object>> makeSiteList(List<Map<String, Object>> siteOriginList, Map<String, Object> userSiteGroupSearch, HttpSession session, String[] systemLoc, String[] systemType, String systemValue) {
		List<Map<String, Object>> siteLocationList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> siteResourceList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> refineList = new ArrayList<Map<String, Object>>();

		if(systemValue != null && "system".equals(systemValue)) {
			session.setAttribute("systemLoc", systemLoc);
			session.setAttribute("systemTp", systemType);
		}

		systemLoc = (String[]) session.getAttribute("systemLoc");
		systemType = (String[]) session.getAttribute("systemTp");

		if((systemLoc != null && !"".equals(systemLoc)) || (systemType != null && !"".equals(systemType))) {
			if(userSiteGroupSearch != null && !userSiteGroupSearch.isEmpty()) {
				refineSiteList(systemLoc, siteLocationList, (List<Map<String, Object>>) userSiteGroupSearch.get("location_group"));
				refineSiteList(systemType, siteResourceList, (List<Map<String, Object>>) userSiteGroupSearch.get("resource_group"));
			}

			if((systemLoc != null && systemLoc.length > 0) && (systemType != null && systemType.length > 0)) {
				refineList = intersection(siteLocationList, siteResourceList);
			} else {
				if(siteLocationList.size() > 0) {
					refineList = siteLocationList;
				}

				if(siteResourceList.size() > 0) {
					refineList = siteResourceList;
				}
			}
		} else {
			refineList = siteOriginList;
		}

		return refineList;
	}

	/**
	 * 선택된 지역 및 유형을 각각 리스트화 한다.
	 *
	 * @param system
	 * @param rtnSiteList
	 * @param grp
	 */
	private void refineSiteList(String[] system, List<Map<String, Object>> rtnSiteList, List<Map<String, Object>> grp) {
		if(system != null && system.length > 0 && grp != null && !grp.isEmpty()) {
			for(Map<String, Object> locMap: grp) {
				String location = (String) locMap.get("location");
				if(Arrays.asList(system).contains(location)) {
					rtnSiteList.addAll((List<Map<String, Object>>) locMap.get("sites"));
				}
			}
		}
	}

	/**
	 * 두 리스트를 비교하여 교집합을 찾는다.
	 *
	 * @param list1
	 * @param list2
	 * @param <T>
	 * @return
	 */
	public <T> List<T> intersection(List<T> list1, List<T> list2) {
		List<T> list = new ArrayList<T>();

		for (T t : list1) {
			if (list2.contains(t)) {
				list.add(t);
			}
		}

		return list;
	}
}