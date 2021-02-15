package kr.co.esp.common.interceptor;

import kr.co.esp.common.service.EgovProperties;
import kr.co.esp.common.util.I18nManager;
import kr.co.esp.common.util.UserUtil;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.json.JsonObject;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.PrintWriter;
import java.util.*;

import static kr.co.esp.common.util.RestApiUtil.get;

public class PreLoadInterceptor extends HandlerInterceptorAdapter {

	// controller보다 먼저 수행
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		HttpSession session = request.getSession();
		Map<String, Object> groupMap = new HashMap<String, Object>();
		List<Map<String, Object>> refineList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> siteOriginList = new ArrayList<Map<String, Object>>();
		Map<String, Object> userInfo = UserUtil.getUserInfo(request);
		JSONArray jsonArray = new JSONArray();

		if (userInfo != null && (userInfo.get("token") != null && !"".equals(userInfo.get("token")))) {
			String token = (String) userInfo.get("token");
			String mode = (String) session.getAttribute("mode");

			String oid = (String) userInfo.get("oid");
			int role = (int) userInfo.get("role");
			int task = (int) userInfo.get("task");
			String requestUri = request.getRequestURI();

			//Menu조회
			Map<String,Object> parameters = new HashMap<String, Object>();
			parameters.put("types", "menu");
			Map<String, Object> menuProperties = get("/config/view/properties2", mode, parameters, token); //그룹화되어있는 사이트 리스트 정보
			if (200 == (int) menuProperties.get("code")) {
				Map<String, Object> menuMap = (Map<String, Object>) menuProperties.get("data");
				Map<String, Object> menuList = (Map<String, Object>) menuMap.get("menu");

				if (menuList != null && !menuList.isEmpty()) {
					int dupHrefCount = 0;
					for (Map.Entry<String, Object> elem : menuList.entrySet()) {
						Map<String, Object> mapDetail = (Map<String, Object>) elem.getValue();
						String href = mapDetail.get("href") != null ? (String) mapDetail.get("href") : "";

						if (requestUri.equals("/" + href)) {
							dupHrefCount++;
						} else {
							continue;
						}
					}

					for (Map.Entry<String, Object> elem : menuList.entrySet()) {
						Map<String, Object> mapDetail = (Map<String, Object>) elem.getValue();
						String menuCode = (String) mapDetail.get("code");
						String href = mapDetail.get("href") != null ? (String) mapDetail.get("href") : "";
						Map<String, Object> name = (Map<String, Object>) mapDetail.get("name");

						if (requestUri.equals("/" + href)) {
							if (dupHrefCount == 1 || (dupHrefCount > 1 && ((oid.equals("testkpx") && menuCode.contains("kpx")) || (!oid.equals("testkpx") && !menuCode.contains("kpx"))))) {
								Map<String, Object> access = (Map<String, Object>) mapDetail.get("access");
								if(!access.isEmpty()) {
									if (access.containsKey("deny")) {
										Map<String, Object> denyMap = (Map<String, Object>) access.get("deny");

										for (Map.Entry<String, Object> denyTemp : denyMap.entrySet()) {
											List denyArray = (List) denyTemp.getValue();
											if ((int) userInfo.get("role") != 1) {
												if ("role".equals(denyTemp.getKey())) {
													boolean contains = containsValue(denyArray, String.valueOf(role));
													if (contains) {
														if ("/dashboard/gmain.do".equals(requestUri)) {
															response.sendRedirect("/spc/transactionCalendar.do");
															return false;
														} else {
															response.sendError(HttpServletResponse.SC_FORBIDDEN);
															return false;
														}
													}
												} else if ("task".equals(denyTemp.getKey())) {
													boolean contains = containsValue(denyArray, String.valueOf(task));
													if (contains) {
														if ("/dashboard/gmain.do".equals(requestUri)) {
															response.sendRedirect("/spc/transactionCalendar.do");
															return false;
														} else {
															response.sendError(HttpServletResponse.SC_FORBIDDEN);
															return false;
														}
													}
												}
											}

											if ("oid".equals(denyTemp.getKey())) {
												boolean contains = containsValue(denyArray, oid);
												if (contains) {
													if ("/dashboard/gmain.do".equals(requestUri)) {
														response.sendRedirect("/spc/transactionCalendar.do");
														return false;
													} else {
														response.sendError(HttpServletResponse.SC_FORBIDDEN);
														return false;
													}
												}
											}
										}
									}

									if (access.containsKey("allow")) {
										Map<String, Object> allowMap = (Map<String, Object>) access.get("allow");
										for (Map.Entry<String, Object> allowTemp : allowMap.entrySet()) {
											List allowArray = (List) allowTemp.getValue();
											if ((int) userInfo.get("role") != 1) {
												if ("role".equals(allowTemp.getKey())) {
													boolean contains = containsValue(allowArray, String.valueOf(role));
													if (!contains) {
														if ("/dashboard/gmain.do".equals(requestUri)) {
															response.sendRedirect("/spc/transactionCalendar.do");
															return false;
														} else {
															response.sendError(HttpServletResponse.SC_FORBIDDEN);
															return false;
														}
													}
												} else if ("task".equals(allowTemp.getKey())) {
													boolean contains = containsValue(allowArray, String.valueOf(task));
													if (!contains) {
														if ("/dashboard/gmain.do".equals(requestUri)) {
															response.sendRedirect("/spc/transactionCalendar.do");
															return false;
														} else {
															response.sendError(HttpServletResponse.SC_FORBIDDEN);
															return false;
														}
													}
												}
											}

											if ("oid".equals(allowTemp.getKey())) {
												boolean contains = containsValue(allowArray, oid);
												if (!contains) {
													if ("/dashboard/gmain.do".equals(requestUri)) {
														response.sendRedirect("/spc/transactionCalendar.do");
														return false;
													} else {
														response.sendError(HttpServletResponse.SC_FORBIDDEN);
														return false;
													}
												}
											}
										}
									}
								} else {
									continue;
								}
							}

							Cookie[] cookie = request.getCookies();
							for (Cookie ck : cookie) {
								if ("lang".equals(ck.getName())) {
									if ("EN".equals(ck.getValue())) {
										request.setAttribute("menuName", name.get("en"));
									} else {
										request.setAttribute("menuName", name.get("kr"));
									}
								}
							}
						}
					}
					request.setAttribute("menuList", menuList);
				}
			}
			//Menu조회

			//아래 소스 postHandler로 이동해야됨.
			String[] divisionLocation = request.getParameterValues("divisionLocation");
			String[] divisionResourceType = request.getParameterValues("divisionResourceType");
			String divisionProc = request.getParameter("divisionProc");

			parameters.clear();
			parameters.put("includeDevices", "true");
			parameters.put("addCapacity", "true");
			Map<String, Object> siteMap = get("/auth/me/sites", mode, parameters, token); //사이트 리스트 정보
			if (200 == (int) siteMap.get("code")) {
				siteOriginList = (List<Map<String, Object>>) siteMap.get("data");
				request.setAttribute("siteHeaderList", siteOriginList); //사이트 리스트 세팅
			} else {
				session.invalidate();
				response.setContentType("text/html; charset=UTF-8");
				PrintWriter out = response.getWriter();
				out.println("<script type=\"text/javascript\">alert('토큰이 만료되었습니다. 로그인페이지로 이동합니다.'); location.href='/login.do';</script>");
				out.flush();

				return false;
			}

			parameters.clear();
			parameters.put("includeSites", "true");
			parameters.put("includeDevices", "false");
			parameters.put("addCapacity", "true");

			Map<String, Object> userSiteGroupSearch = get("/auth/me/groups", mode, parameters, token); //그룹화되어있는 사이트 리스트 정보
			if (200 == (int) userSiteGroupSearch.get("code")) {
				groupMap = (Map<String, Object>) userSiteGroupSearch.get("data");
				request.setAttribute("tag_group", groupMap.get("tag_group")); //태그그룹 별
				request.setAttribute("vpp_group", groupMap.get("vpp_group")); //중개거래그룹 별
				request.setAttribute("dr_group", groupMap.get("dr_group")); //DR그룹 별
			} else {
				request.setAttribute("tag_group", null); //태그그룹 별
				request.setAttribute("vpp_group", null); //중개거래그룹 별
				request.setAttribute("dr_group", null); //DR그룹 별
			}


			//구분에서 사이트리스트 정제하는 부분
			if (divisionProc != null && !"".equals(divisionProc)) {
				session.removeAttribute("divisionLocation");
				session.removeAttribute("divisionResourceType");
				session.removeAttribute("sgid");
				session.removeAttribute("vgid");

				if ("init".equals(divisionProc)) { //초기화
					jsonArray = new JSONArray();
					for (Map<String, Object> refineMap : siteOriginList) {
						refineMap.remove("devices");
						jsonArray.put(jsonParser(refineMap));
					}

					request.setAttribute("siteList", jsonArray); //사이트 리스트 세팅
					request.setAttribute("siteName", "전체"); //사이트 리스트 세팅
				} else if ("group".equals(divisionProc)) { //그룹대시보드
					String siteName = "";
					String sgid = request.getParameter("sgid");
					if (groupMap != null && !groupMap.isEmpty()) {
						for (Map<String, Object> tagGroup : (List<Map<String, Object>>) groupMap.get("tag_group")) {
							if (sgid.equals(tagGroup.get("sgid"))) {
								siteName = (String) tagGroup.get("name");
								refineList = (List<Map<String, Object>>) tagGroup.get("sites");
								break;
							} else {
								continue;
							}
						}
					}

					if (refineList != null && refineList.size() > 0) {
						jsonArray = new JSONArray();
						for (Map<String, Object> refineMap : refineList) {
							jsonArray.put(jsonParser(refineMap));
						}
					}

					request.setAttribute("sgid", sgid);
					request.setAttribute("siteName", siteName);
					request.setAttribute("siteList", jsonArray); //사이트 리스트 세팅

					session.setAttribute("sgid", sgid);
				} else if ("vpp".equals(divisionProc)) { //
					String siteName = "";
					String vgid = request.getParameter("vgid");
					if (groupMap != null && !groupMap.isEmpty()) {
						for (Map<String, Object> tagGroup : (List<Map<String, Object>>) groupMap.get("vpp_group")) {
							if (vgid.equals(tagGroup.get("vgid"))) {
								siteName = (String) tagGroup.get("name");
								refineList = (List<Map<String, Object>>) tagGroup.get("sites");
								break;
							} else {
								continue;
							}
						}
					}

					if (refineList != null && refineList.size() > 0) {
						jsonArray = new JSONArray();
						for (Map<String, Object> refineMap : refineList) {
							jsonArray.put(jsonParser(refineMap));
						}
					}

					request.setAttribute("vgid", vgid);
					request.setAttribute("siteName", siteName);
					request.setAttribute("siteList", jsonArray); //사이트 리스트 세팅

					session.setAttribute("vgid", vgid);
				} else if ("site".equals(divisionProc)) {
					String siteName = "";
					String sid = request.getParameter("sid");
					for (Map<String, Object> site : siteOriginList) {
						if (sid.equals(site.get("sid"))) {
							siteName = (String) site.get("name");
							jsonArray = new JSONArray();
							jsonArray.put(jsonParser(site));
							break;
						} else {
							continue;
						}
					}

					request.setAttribute("sid", sid);
					request.setAttribute("siteName", siteName);
					request.setAttribute("siteList", jsonArray); //사이트 리스트 세팅
				} else {
					refineList = makeSiteList(siteOriginList, groupMap, session, divisionLocation, divisionResourceType, divisionProc);

					jsonArray = new JSONArray();
					for (Map<String, Object> refineMap : refineList) {
						jsonArray.put(jsonParser(refineMap));
					}

					//그룹 대시보드는 처음 진입시 들어오는 화면이라 파라미터가 없을경우는 사용자가 볼수있는 모든 사이트가 대상이다.
					request.setAttribute("sgid", "");
					request.setAttribute("siteList", jsonArray); //사이트 리스트 세팅
					request.setAttribute("siteName", I18nManager.getInstance().tr(request, "gdash.entire")); //사이트 리스트 세팅
				}
			} else {
				String sgid = (String) session.getAttribute("sgid");
				String vgid = (String) session.getAttribute("vgid");
				String sid = request.getParameter("sid");

				if (sid != null && !"".equals(sid) && "/dashboard/smain.do".equals(request.getRequestURI())) {
					String siteName = "";
					for (Map<String, Object> site : siteOriginList) {
						if (sid.equals(site.get("sid"))) {
							siteName = (String) site.get("name");
							jsonArray = new JSONArray();
							jsonArray.put(jsonParser(site));
							break;
						} else {
							continue;
						}
					}

					request.setAttribute("sid", sid);
					request.setAttribute("siteName", siteName);
					request.setAttribute("siteList", jsonArray); //사이트 리스트 세팅
				} else {
					if (sgid != null && !"".equals(sgid)) {
						String siteName = "";
						if (groupMap != null && !groupMap.isEmpty()) {
							for (Map<String, Object> tagGroup : (List<Map<String, Object>>) groupMap.get("tag_group")) {
								if (sgid.equals(tagGroup.get("sgid"))) {
									siteName = (String) tagGroup.get("name");
									refineList = (List<Map<String, Object>>) tagGroup.get("sites");
									break;
								} else {
									continue;
								}
							}
						}

						if (refineList != null && refineList.size() > 0) {
							jsonArray = new JSONArray();
							for (Map<String, Object> refineMap : refineList) {
								jsonArray.put(jsonParser(refineMap));
							}
						}

						request.setAttribute("sgid", sgid);
						request.setAttribute("siteName", siteName);
						request.setAttribute("siteList", jsonArray); //사이트 리스트 세팅

						session.setAttribute("sgid", sgid);
					} else if (vgid != null && !"".equals(vgid)) {
						String siteName = "";
						if (groupMap != null && !groupMap.isEmpty()) {
							for (Map<String, Object> tagGroup : (List<Map<String, Object>>) groupMap.get("vpp_group")) {
								if (vgid.equals(tagGroup.get("vgid"))) {
									siteName = (String) tagGroup.get("name");
									refineList = (List<Map<String, Object>>) tagGroup.get("sites");
									break;
								} else {
									continue;
								}
							}
						}

						if (refineList != null && refineList.size() > 0) {
							jsonArray = new JSONArray();
							for (Map<String, Object> refineMap : refineList) {
								jsonArray.put(jsonParser(refineMap));
							}
						}

						request.setAttribute("vgid", vgid);
						request.setAttribute("siteName", siteName);
						request.setAttribute("siteList", jsonArray); //사이트 리스트 세팅

						session.setAttribute("vgid", vgid);
					} else {
						divisionLocation = (String[]) session.getAttribute("divisionLocation");
						divisionResourceType = (String[]) session.getAttribute("divisionResourceType");

						refineList = makeSiteList(siteOriginList, groupMap, session, divisionLocation, divisionResourceType, divisionProc);

						jsonArray = new JSONArray();
						for (Map<String, Object> refineMap : refineList) {
							jsonArray.put(jsonParser(refineMap));
						}

						//그룹 대시보드는 처음 진입시 들어오는 화면이라 파라미터가 없을경우는 사용자가 볼수있는 모든 사이트가 대상이다.
						request.setAttribute("sgid", "");
						request.setAttribute("siteList", jsonArray); //사이트 리스트 세팅
						request.setAttribute("siteName", I18nManager.getInstance().tr(request, "gdash.entire"));
					}
				}
			}
			parameters.clear();
			parameters.put("types", "resource,location");
			Map<String, Object> typeProperties = get("/config/view/properties2", mode, parameters, token); //그룹화되어있는 사이트 리스트 정보
			if (200 == (int) typeProperties.get("code")) {
				Map<String, Object> typeMap = (Map<String, Object>) typeProperties.get("data");

				JSONArray jsonSiteList = (JSONArray) request.getAttribute("siteList");

				for (int i = 0; i < jsonSiteList.length(); i++) {
					JSONObject site = (JSONObject) jsonSiteList.get(i);
					String location = (String) site.get("location");
					int resourceType = (Integer) site.get("resource_type");

					LinkedHashMap<String, Object> locationMap = (LinkedHashMap<String, Object>) typeMap.get("location");
					for (Map.Entry<String, Object> country : locationMap.entrySet()) {
						LinkedHashMap<String, Object> countryValue = (LinkedHashMap<String, Object>) country.getValue();
						LinkedHashMap<String, Object> countryMap = (LinkedHashMap<String, Object>) countryValue.get("locations");

						for (Map.Entry<String, Object> state : countryMap.entrySet()) {
							LinkedHashMap<String, Object> stateValue = (LinkedHashMap<String, Object>) state.getValue();
							String locationCode = (String) stateValue.get("code");

							if (locationCode.equals(location)) {
								stateValue.put("display", true);
								countryValue.put("display", true);
							}
						}
					}

					LinkedHashMap<String, Object> resourceMap = (LinkedHashMap<String, Object>) typeMap.get("resource");
					for (Map.Entry<String, Object> resource : resourceMap.entrySet()) {
						LinkedHashMap<String, Object> resourceValue = (LinkedHashMap<String, Object>) resource.getValue();
						int resourceCode = Integer.parseInt((String) resourceValue.get("code"));
						if (resourceCode == resourceType) {
							resourceValue.put("display", true);
						}
					}
				}

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
		HttpSession session = request.getSession();

		String gitVersion = EgovProperties.getGitProperty("git.commit.id.abbrev");
		String certApiHost = EgovProperties.getProperty("certApiHost"); //인증서 HOST
		String activateSPC = EgovProperties.getProperty("activateSPC"); //activateSPC True/False
		String mode = (String) session.getAttribute("mode"); // TEST 서버 여부

		String apiHost;//API HOST
		if (mode != null && "test".equals(mode)) {
			apiHost = EgovProperties.getProperty("jsApiHost");
		} else {
			apiHost = EgovProperties.getProperty("jsApiHostSecure");
		}
		mav.addObject("apiHost", apiHost);

		mav.addObject("certApiHost", certApiHost); //WebRa 서버 주소
		mav.addObject("activateSPC", activateSPC); //activateSPC
		mav.addObject("gitVersion", gitVersion);

		super.postHandle(request, response, handler, mav);
	}

	/**
	 * 배열안에 값이 특정값이 포함되어있는지 비교
	 *
	 * @param array
	 * @param target
	 * @return
	 */
	public boolean containsValue(List array, Object target) {
		boolean contains = array.contains(target);
		return contains;
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
	public List<Map<String, Object>> makeSiteList(List<Map<String, Object>> siteOriginList, Map<String, Object> userSiteGroupSearch, HttpSession session, String[] divisionLocation, String[] divisionResourceType, String divisionProc) {
		List<Map<String, Object>> siteLocationList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> siteResourceList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> refineList = new ArrayList<Map<String, Object>>();

		if (divisionProc != null && "change".equals(divisionProc)) {
			session.setAttribute("divisionLocation", divisionLocation);
			session.setAttribute("divisionResourceType", divisionResourceType);
		}

		divisionLocation = (String[]) session.getAttribute("divisionLocation");
		divisionResourceType = (String[]) session.getAttribute("divisionResourceType");

		if ((divisionLocation != null && !"".equals(divisionLocation)) || (divisionResourceType != null && !"".equals(divisionResourceType))) {
			if (userSiteGroupSearch != null && !userSiteGroupSearch.isEmpty()) {
				refineSiteList(divisionLocation, siteLocationList, (List<Map<String, Object>>) userSiteGroupSearch.get("location_group"), "location");
				refineSiteList(divisionResourceType, siteResourceList, (List<Map<String, Object>>) userSiteGroupSearch.get("resource_group"), "resource_type");
			}

			if ((divisionLocation != null && divisionLocation.length > 0) && (divisionResourceType != null && divisionResourceType.length > 0)) {
				refineList = intersection(siteLocationList, siteResourceList);
			} else {
				if (siteLocationList.size() > 0) {
					refineList = siteLocationList;
				}

				if (siteResourceList.size() > 0) {
					refineList = siteResourceList;
				}
			}
		} else {
			refineList = siteOriginList;
		}

		if (refineList.size() > 0) {
			for (int i = 0; i < refineList.size(); i++) {
//				if (refineList.get(i).get("devices") == null) {
//					refineList.get(i).put("hasDevices", false);
//				} else {
//					refineList.get(i).put("hasDevices", true);
//				}
				refineList.get(i).remove("devices");
			}
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
	private void refineSiteList(String[] system, List<Map<String, Object>> rtnSiteList, List<Map<String, Object>> grp, String type) {
		if (system != null && system.length > 0 && grp != null && !grp.isEmpty()) {
			for (Map<String, Object> tmpMap : grp) {
				String keyCode = (String) tmpMap.get(type);
				if (Arrays.asList(system).contains(keyCode)) {
					rtnSiteList.addAll((List<Map<String, Object>>) tmpMap.get("sites"));
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

	/**
	 *
	 *
	 * @param target
	 * @return
	 */
	public JSONObject jsonParser(Map<String, Object> target) {
		JSONObject jo = new JSONObject(target);

		for (Map.Entry<String, Object> elem : target.entrySet()) {
			if (elem.getValue() instanceof ArrayList) {
				JSONArray ja = new JSONArray();
				List<Map<String, Object>> objectArr = (List<Map<String, Object>>) elem.getValue();
				for (Map<String, Object> el : objectArr) {
					ja.put(jsonParser(el));
				}

				try {
					jo.put(elem.getKey(), ja);
				} catch (JSONException e) {
					jo.remove(elem.getKey());
				}
			} else if (elem.getValue() instanceof HashMap) {
				try {
					jo.put(elem.getKey(), jsonParser((Map<String, Object>) elem.getValue()));
				} catch (JSONException e) {
					jo.remove(elem.getKey());
				}
			} else if (elem.getValue() instanceof String) {
				String dataValue = (String) elem.getValue();
				if ("description".equals(elem.getKey())) {
					jo.remove(elem.getKey());
				} else {
					if (dataValue.startsWith("{") && dataValue.endsWith("}")) {
						try {
							jo.put(elem.getKey(), new JSONObject((String) elem.getValue()));
						} catch (JSONException e) {
							jo.remove(elem.getKey());
						}
					} else if (dataValue.contains(System.getProperty("line.separator"))){
						try {
							jo.put(elem.getKey(), new JSONObject(((String) elem.getValue()).replaceAll(System.getProperty("line.separator"), "")));
						} catch (JSONException e) {
							jo.remove(elem.getKey());
						}
					}
				}
			}
		}
		return jo;
	}
}