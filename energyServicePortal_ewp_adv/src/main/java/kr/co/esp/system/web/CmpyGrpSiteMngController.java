// package kr.co.esp.system.web;

// import java.io.File;
// import java.util.Arrays;
// import java.util.Date;
// import java.util.HashMap;
// import java.util.Iterator;
// import java.util.List;
// import java.util.Map;

// import javax.annotation.Resource;
// import javax.servlet.http.HttpServletRequest;
// import javax.servlet.http.HttpSession;

// import org.slf4j.Logger;
// import org.slf4j.LoggerFactory;
// import org.springframework.stereotype.Controller;
// import org.springframework.ui.Model;
// import org.springframework.web.bind.annotation.RequestMapping;
// import org.springframework.web.bind.annotation.RequestParam;
// import org.springframework.web.bind.annotation.ResponseBody;
// import org.springframework.web.multipart.MultipartFile;
// import org.springframework.web.multipart.MultipartHttpServletRequest;

// import egovframework.com.cmm.service.EgovProperties;
// import kr.co.esp.api.web.ApiController;
// import kr.co.esp.common.util.CommonUtils;
// import kr.co.esp.common.util.UserUtil;
// import kr.co.esp.system.service.CmpyGrpSiteMngService;

// @Controller
// public class CmpyGrpSiteMngController {

// 	private static final Logger logger = LoggerFactory.getLogger(CmpyGrpSiteMngController.class);

// 	@Resource(name="cmpyGrpSiteMngService")
// 	private CmpyGrpSiteMngService cmpyGrpSiteMngService;
	
// //	@Value("${globals.fileUpload.rootPath}")
// //    private String fileUploadRootPath;
// 	private String fileUploadRootPath = EgovProperties.getProperty("globals.fileUpload.rootPath");
	
// 	@RequestMapping(value = "/system/cmpyGrpSiteMng.do")
// 	public String cmpyGrpSiteMng(HttpServletRequest request, HttpSession session, Model model) {
// 		logger.debug("/system/cmpyGrpSiteMng.do");
// 		return "esp/system/cmpyGrpSiteMng";
// 	}

// 	/**
// 	 * 회사 목록 조회
// 	 *
// 	 * @param param
// 	 * @return
// 	 * @throws Exception
// 	 */
// 	@RequestMapping("/system/getCmpyList.json")
// 	public @ResponseBody Map<String, Object> getCmpyList(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
// 		logger.debug("/system/getCmpyList.json");
// 		logger.debug("     param ::::: " + param.toString());
		
// 		int selPageNum = Integer.parseInt((String) param.get("selPageNum"));
// 		int pageRowCnt = 5;
// 		int startNum = pageRowCnt * (selPageNum - 1);
		
// 		param.put("siteId", request.getSession().getAttribute("selViewSiteId"));
// 		param.put("startNum", startNum);
// 		param.put("pageRowCnt", pageRowCnt);
		
// 		List<Map<String,Object>> list = cmpyGrpSiteMngService.getCmpyList(param);
// 		int listCnt = cmpyGrpSiteMngService.getCmpyListCnt(param);
// 		int totalPageCnt = 0;
// 		if (listCnt > 0) {
// 			totalPageCnt = listCnt / pageRowCnt;
// 			if (listCnt % pageRowCnt > 0) {
// 				totalPageCnt++;
// 			}
// 		}
		
// 		Map<String, Object> pagingMap = new HashMap<String, Object>();
// 		pagingMap.put("pageRowCnt", pageRowCnt); // 한 페이지 당 보여줄 데이터 수
// 		pagingMap.put("selPageNum", selPageNum); // 선택한 페이지번호
// 		pagingMap.put("listCnt", listCnt); // 전체 데이터 수
// 		pagingMap.put("totalPageCnt", totalPageCnt); // 전체 페이지 수
		
// 		Map<String, Object> resultMap = new HashMap<String, Object>();
// 		resultMap.put("list", list);
// 		resultMap.put("pagingMap", pagingMap);
// 		return resultMap;
// 	}
	
// 	/**
// 	 * 그룹 목록 조회
// 	 *
// 	 * @param param
// 	 * @return
// 	 * @throws Exception
// 	 */
// 	@RequestMapping("/system/getGroupList.json")
// 	public @ResponseBody Map<String, Object> getGroupList(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
// 		logger.debug("/system/getGroupList.json");
// 		logger.debug("     param ::::: " + param.toString());
		
// 		Map<String, Object> userInfo = UserUtil.getUserInfo(request);
// 		String authType = (String) userInfo.get("auth_type");
// 		if ("1".equals(authType)) { // 포털관리자
			
// 		} else if ("2".equals(authType)) { // 고객사관리자
// 			param.put("compIdx", userInfo.get("comp_idx"));
// 		} else if ("3".equals(authType) || "4".equals(authType) || "5".equals(authType)) { // 그룹관리자 || 사이트관리자 || 사이트이용자
// 			param.put("siteGrpIdx", userInfo.get("site_grp_idx"));
// 		}
		
// 		int selPageNum = Integer.parseInt((String) param.get("selPageNum"));
// 		int pageRowCnt = 5;
// 		int startNum = pageRowCnt * (selPageNum - 1);
		
// 		param.put("startNum", startNum);
// 		param.put("pageRowCnt", pageRowCnt);
		
// 		List<Map<String,Object>> list = cmpyGrpSiteMngService.getGroupList(param);
// 		int listCnt = cmpyGrpSiteMngService.getGroupListCnt(param);
// 		int totalPageCnt = 0;
// 		if (listCnt > 0) {
// 			totalPageCnt = listCnt / pageRowCnt;
// 			if (listCnt % pageRowCnt > 0) {
// 				totalPageCnt++;
// 			}
// 		}
		
// 		Map<String, Object> pagingMap = new HashMap<String, Object>();
// 		pagingMap.put("pageRowCnt", pageRowCnt); // 한 페이지 당 보여줄 데이터 수
// 		pagingMap.put("selPageNum", selPageNum); // 선택한 페이지번호
// 		pagingMap.put("listCnt", listCnt); // 전체 데이터 수
// 		pagingMap.put("totalPageCnt", totalPageCnt); // 전체 페이지 수
		
// 		Map<String, Object> resultMap = new HashMap<String, Object>();
// 		resultMap.put("list", list);
// 		resultMap.put("pagingMap", pagingMap);
// 		return resultMap;
// 	}
	
// 	/**
// 	 * 사이트 목록 조회
// 	 *
// 	 * @param param
// 	 * @return
// 	 * @throws Exception
// 	 */
// 	@RequestMapping("/system/getSiteList.json")
// 	public @ResponseBody Map<String, Object> getSiteList(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
// 		logger.debug("/system/getSiteList.json");
// 		logger.debug("     param ::::: " + param.toString());
		
// 		Map<String, Object> userInfo = UserUtil.getUserInfo(request);
// 		String authType = (String) userInfo.get("auth_type");
// 		if ("1".equals(authType)) { // 포털관리자
			
// 		} else if ("2".equals(authType)) { // 고객사관리자
// 			param.put("compIdx", userInfo.get("comp_idx"));
// 		} else if ("3".equals(authType)) { // 그룹관리자
// 			param.put("siteGrpIdx", userInfo.get("site_grp_idx"));
// 		} else if ("4".equals(authType) || "5".equals(authType)) { // 사이트관리자 || 사이트이용자
// 			param.put("siteId", userInfo.get("site_id"));
// 		}
		
// 		int selPageNum = Integer.parseInt((String) param.get("selPageNum"));
// 		int pageRowCnt = 5;
// 		int startNum = pageRowCnt * (selPageNum - 1);
		
// 		param.put("startNum", startNum);
// 		param.put("pageRowCnt", pageRowCnt);
		
// 		List<Map<String,Object>> list = cmpyGrpSiteMngService.getSiteList(param);
// 		int listCnt = cmpyGrpSiteMngService.getSiteListCnt(param);
// 		int totalPageCnt = 0;
// 		if (listCnt > 0) {
// 			totalPageCnt = listCnt / pageRowCnt;
// 			if (listCnt % pageRowCnt > 0) {
// 				totalPageCnt++;
// 			}
// 		}
		
// 		Map<String, Object> pagingMap = new HashMap<String, Object>();
// 		pagingMap.put("pageRowCnt", pageRowCnt); // 한 페이지 당 보여줄 데이터 수
// 		pagingMap.put("selPageNum", selPageNum); // 선택한 페이지번호
// 		pagingMap.put("listCnt", listCnt); // 전체 데이터 수
// 		pagingMap.put("totalPageCnt", totalPageCnt); // 전체 페이지 수
		
// 		Map<String, Object> resultMap = new HashMap<String, Object>();
// 		resultMap.put("list", list);
// 		resultMap.put("pagingMap", pagingMap);
// 		return resultMap;
// 	}
	
// 	/**
// 	 * 회사 목록(팝업) 조회
// 	 *
// 	 * @param param
// 	 * @return
// 	 * @throws Exception
// 	 */
// 	@RequestMapping("/system/getCmpyPopupList.json")
// 	public @ResponseBody
// 	Map<String, Object> getCmpyPopupList(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
// 		logger.debug("/system/getCmpyPopupList.json");
// 		logger.debug("     param ::::: " + param.toString());
		
// 		Map<String, Object> userInfo = UserUtil.getUserInfo(request);
// 		String authType = (String) userInfo.get("auth_type");
// 		if ("1".equals(authType)) { // 포털관리자
			
// 		} else if ("2".equals(authType) || "3".equals(authType) || "4".equals(authType) || "5".equals(authType)) { // 고객사관리자 || 그룹관리자 || 사이트관리자 || 사이트이용자
// 			param.put("compIdx", userInfo.get("comp_idx"));
// //		} else if("4".equals(authType) || "5".equals(authType)) { // 사이트관리자 || 사이트이용자
// //			param.put("siteGrpIdx", userInfo.get("site_grp_idx"));
// 		}
		
// 		List<Map<String,Object>> list = cmpyGrpSiteMngService.getCmpyList(param);
		
// 		Map<String, Object> resultMap = new HashMap<String, Object>();
// 		resultMap.put("list", list);
// 		return resultMap;
// 	}
	
// 	/**
// 	 * 회사 내 그룹 목록(팝업) 조회
// 	 *
// 	 * @param param
// 	 * @return
// 	 * @throws Exception
// 	 */
// 	@RequestMapping("/system/getGroupPopupList.json")
// 	public @ResponseBody
// 	Map<String, Object> getGroupPopupList(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
// 		logger.debug("/system/getGroupPopupList.json");
// 		logger.debug("     param ::::: " + param.toString());
		
// 		String compIdx = (String) param.get("compIdx");
// 		if ("".equals(compIdx) || compIdx == null) {
// 			Map<String, Object> userInfo = UserUtil.getUserInfo(request);
// 			String authType = (String) userInfo.get("auth_type");
// 			if ("1".equals(authType)) { // 포털관리자
				
// 			} else if ("2".equals(authType) || "3".equals(authType)) { // 고객사관리자 || 그룹관리자
// 				param.put("compIdx", userInfo.get("comp_idx"));
// 			} else if ("4".equals(authType) || "5".equals(authType)) { // 사이트관리자 || 사이트이용자
// 				param.put("siteGrpIdx", userInfo.get("site_grp_idx"));
// 			}
// 		}
		
// 		List<Map<String,Object>> list = cmpyGrpSiteMngService.getGroupPopupList(param);
		
// 		Map<String, Object> resultMap = new HashMap<String, Object>();
// 		resultMap.put("list", list);
// 		return resultMap;
// 	}
	
// 	/**
// 	 * 사이트 목록(팝업) 조회
// 	 *
// 	 * @param param
// 	 * @return
// 	 * @throws Exception
// 	 */
// 	@RequestMapping("/system/getSitePopupList.json")
// 	public @ResponseBody
// 	Map<String, Object> getSitePopupList(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
// 		logger.debug("/system/getSitePopupList.json");
// 		logger.debug("     param ::::: " + param.toString());
		
// 		Map<String, Object> userInfo = UserUtil.getUserInfo(request);
// 		String authType = (String) userInfo.get("auth_type");
// 		if ("1".equals(authType)) { // 포털관리자
			
// 		} else if ("2".equals(authType)) { // 고객사관리자
// 			param.put("compIdx", userInfo.get("comp_idx"));
// 		} else if ("3".equals(authType)) { // 그룹관리자
// 			param.put("siteGrpIdx", userInfo.get("site_grp_idx"));
// 		} else if ("4".equals(authType) || ("5".equals(authType))) { // 사이트관리자 || 사이트이용자
// 			param.put("siteId", userInfo.get("site_id"));
// //		} else if("5".equals(authType)) { // 사이트이용자
// //			param.put("userIdx", userInfo.get("user_idx"));
// 		}
		
// 		List<Map<String,Object>> grpSiteList = cmpyGrpSiteMngService.getGrpSiteList(param);
// 		List<Map<String,Object>> allSiteList = cmpyGrpSiteMngService.getAllSiteList(param);
		
// 		Map<String, Object> resultMap = new HashMap<String, Object>();
// 		resultMap.put("grpSiteList", grpSiteList);
// 		resultMap.put("allSiteList", allSiteList);
// 		return resultMap;
// 	}
	
// 	/**
// 	 * 회사 한건 조회
// 	 *
// 	 * @param param
// 	 * @return
// 	 * @throws Exception
// 	 */
// 	@RequestMapping("/system/getCmpyDetail.json")
// 	public @ResponseBody
// 	Map<String, Object> getCmpyDetail(@RequestParam Map<String, Object> param) throws Exception {
// 		logger.debug("/system/getCmpyDetail.json");
// 		logger.debug("     param ::::: " + param.toString());
		
// 		Map<String, Object> result = cmpyGrpSiteMngService.getCmpyDetail(param);
// 		System.out.println("result.toString() : " + result.toString());
		
// 		Map<String, Object> resultMap = new HashMap<String, Object>();
// 		resultMap.put("detail", result);
// 		return resultMap;
// 	}
	
// 	/**
// 	 * 그룹 한건 조회
// 	 *
// 	 * @param param
// 	 * @return
// 	 * @throws Exception
// 	 */
// 	@RequestMapping("/system/getGroupDetail.json")
// 	public @ResponseBody
// 	Map<String, Object> getGroupDetail(@RequestParam Map<String, Object> param) throws Exception {
// 		logger.debug("/system/getGroupDetail.json");
// 		logger.debug("     param ::::: " + param.toString());
		
// 		Map<String, Object> result = cmpyGrpSiteMngService.getGroupDetail(param);
		
// 		Map<String, Object> resultMap = new HashMap<String, Object>();
// 		resultMap.put("detail", result);
// 		return resultMap;
// 	}
	
// 	/**
// 	 * 사이트 한건 조회
// 	 *
// 	 * @param param
// 	 * @return
// 	 * @throws Exception
// 	 */
// 	@RequestMapping("/system/getSiteDetail.json")
// 	public @ResponseBody
// 	Map<String, Object> getSiteDetail(@RequestParam Map<String, Object> param) throws Exception {
// 		logger.debug("/system/getSiteDetail.json");
// 		logger.debug("     param ::::: " + param.toString());
		
// 		Map<String, Object> result = cmpyGrpSiteMngService.getSiteDetail(param);
		
// 		Map<String, Object> resultMap = new HashMap<String, Object>();
// 		resultMap.put("detail", result);
// 		return resultMap;
// 	}

// 	/**
// 	 * 사이트그룹 내 사이트 추가/제거
// 	 *
// 	 * @param param
// 	 * @return
// 	 * @throws Exception
// 	 */
// 	@RequestMapping("/system/saveSiteInSiteGrp.json")
// 	public @ResponseBody
// 	Map<String, Object> saveSiteInSiteGrp(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
// 		logger.debug("/system/saveSiteInSiteGrp.json");
// 		logger.debug("     param ::::: " + param.toString());
		
// 		Map<String, Object> userInfo = UserUtil.getUserInfo(request);
		
// 		String selSiteGrpIdx = (String) param.get("selSiteGrpIdx1"); // 그룹 목록
// 		String nowSiteIds = (String) param.get("nowSiteIds"); // 기존 그룹내 사이트목록
// 		String newSiteIds = (String) param.get("newSiteIds"); // 변경할 그룹내 사이트목록
// 		String nowSiteIds_arr[] = null; // 기존 그룹내 사이트목록
// 		String newSiteIds_arr[] = null; // 변경할 그룹내 사이트목록
// 		if (nowSiteIds != null && !"".equals(nowSiteIds)) {
// 			nowSiteIds_arr = nowSiteIds.split(",");
// 		}
// 		if (newSiteIds != null && !"".equals(newSiteIds)) {
// 			newSiteIds_arr = newSiteIds.split(",");
// 		}
		
// 		// 기존목록과 변경목록이 동일한지 확인 -> 동일하면 변경사항 없음
// 		String changeYn = "Y";
// 		changeYn = (Arrays.equals(nowSiteIds_arr, newSiteIds_arr)) ? "N" : "Y";
		
// 		if ("Y".equals(changeYn)) {
// 			// 로직 : 기존목록과 변경된목록을 비교한다.
// 			// 기존에 존재하고 변경된 목록에 미존재 : 그룹에저 제외됨
// 			// 기존에도 존재하고 변경된 목록에도 존재 : 변동없음
// 			// 기존에 미존재하고 변경된 목록에 존재 : 그룹에 새로 추가됨
// 			// 기존목록이 있는데 변경된 목록이 null일 경우 : 그룹에서 전부 제외됨
// 			// 기존목록이 null인데 변경된 목록이 존재 : 빈 그룹에 새로 추가됨
// 			int addCnt = 0;
// 			int delCnt = 0;
// 			if (nowSiteIds_arr != null) {
// 				if (nowSiteIds_arr.length > 0) { // 기존목록의 데이터를 변동된목록에 존재하는지 확인
// 					for (int i = 0; i < nowSiteIds_arr.length; i++) {
// 						String str = nowSiteIds_arr[i];
// 						boolean res = false;
// 						if (newSiteIds_arr != null) res = Arrays.asList(newSiteIds_arr).contains(str);
// 						if (!res) { // 기존에 존재하고 변경된 목록에 미존재 : 그룹에저 제외됨
// 							Map<String, Object> dvMap = new HashMap<String, Object>();
// 							dvMap.put("siteId", str);
// 							dvMap.put("siteGrpIdx", 0);
// 							dvMap.put("modUid", userInfo.get("user_id"));
// 							int cnt = cmpyGrpSiteMngService.updateSite(dvMap);
// 							delCnt = delCnt + cnt;
// 						}
// 					}
// 				}
				
// 			} else {
// 				for (int i = 0; i < newSiteIds_arr.length; i++) {
// 					Map<String, Object> dvMap = new HashMap<String, Object>();
// 					dvMap.put("siteId", newSiteIds_arr[i]);
// 					dvMap.put("siteGrpIdx", selSiteGrpIdx);
// 					dvMap.put("modUid", userInfo.get("user_id"));
// 					int cnt = cmpyGrpSiteMngService.updateSite(dvMap);
// 					addCnt = addCnt + cnt;
// 				}
// 			}
			
// 			if (newSiteIds_arr != null) {
// 				if (newSiteIds_arr.length > 0) { // 변동된목록의 데이터를 기존목록에 존재하는지 확인
// 					for (int i = 0; i < newSiteIds_arr.length; i++) {
// 						String str = newSiteIds_arr[i];
// 						boolean res = false;
// 						if (nowSiteIds_arr != null) res = Arrays.asList(nowSiteIds_arr).contains(str);
// 						if (!res) { // 기존에 미존재하고 변경된 목록에 존재 : 그룹에 새로 추가됨
// 							Map<String, Object> dvMap = new HashMap<String, Object>();
// 							dvMap.put("siteId", str);
// 							dvMap.put("siteGrpIdx", selSiteGrpIdx);
// 							dvMap.put("modUid", userInfo.get("user_id"));
// 							int cnt = cmpyGrpSiteMngService.updateSite(dvMap);
// 							addCnt = addCnt + cnt;
// 						}
// 					}
// 				}
				
// 			} else {
// 				for (int i = 0; i < nowSiteIds_arr.length; i++) {
// 					Map<String, Object> dvMap = new HashMap<String, Object>();
// 					dvMap.put("siteId", nowSiteIds_arr[i]);
// 					dvMap.put("siteGrpIdx", 0);
// 					dvMap.put("modUid", userInfo.get("user_id"));
// 					int cnt = cmpyGrpSiteMngService.updateSite(dvMap);
// 					delCnt = delCnt + cnt;
// 				}
// 			}
			
			
// 		}
		
// 		Map<String, Object> resultMap = new HashMap<String, Object>();
// 		resultMap.put("resultCnt", 0);
// 		resultMap.put("changeYn", changeYn);
// 		return resultMap;
// 	}
	
// 	/**
// 	 * 회사 등록
// 	 *
// 	 * @param param
// 	 * @return
// 	 * @throws Exception
// 	 */
// 	@RequestMapping("/system/insertCmpy.json")
// 	public @ResponseBody
// 	Map<String, Object> insertCmpy(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
// 		logger.debug("/system/insertCmpy.json");
// 		logger.debug("     param ::::: " + param.toString());
		
// 		Map<String, Object> userInfo = UserUtil.getUserInfo(request);
// 		param.put("regUid", userInfo.get("user_id"));
// 		param.put("userIdx", userInfo.get("user_idx"));
		
// 		int resultCnt = cmpyGrpSiteMngService.insertCmpy(param);
		
// 		Map<String, Object> resultMap = new HashMap<String, Object>();
// 		resultMap.put("resultCnt", resultCnt);
// 		return resultMap;
// 	}
	
// 	/**
// 	 * 그룹 등록
// 	 *
// 	 * @param param
// 	 * @return
// 	 * @throws Exception
// 	 */
// 	@RequestMapping("/system/insertGroup.json")
// 	public @ResponseBody
// 	Map<String, Object> insertGroup(@RequestParam Map<String, Object> param, MultipartHttpServletRequest multipart, HttpSession session) throws Exception {
// 		logger.debug("/system/insertGroup.json");
// 		logger.debug("     param ::::: " + param.toString());
		
// 		Map<String, Object> resultMap = new HashMap<String, Object>();
		
// 		int cnt = cmpyGrpSiteMngService.getSiteGroupIdChk(param);
// 		if (cnt > 0) {
// 			resultMap.put("resultCode", 1);
// 			resultMap.put("resultMsg", "입력하신 그룹 ID가 존재합니다. \n다른 ID를 입력해주세요.");
// 			return resultMap;
// 		}
		
// 		Map<String, Object> userInfo = UserUtil.getUserInfo(multipart.getSession());
// 		param.put("regUid", userInfo.get("user_id"));
// 		param.put("userIdx1", userInfo.get("user_idx"));
		
// 		String siteGrpName = multipart.getParameter("siteGrpName");
// 		String siteGrpId = multipart.getParameter("siteGrpId");
// //		String siteGrpIdx = multipart.getParameter("siteGrpIdx");
// //		String userIdx = multipart.getParameter("userIdx");
// 		Integer userIdx = (userInfo.get("user_idx") == null) ? null : (Integer) userInfo.get("user_idx");
		
// 		String root = fileUploadRootPath;
// 		String seperator = File.separator;
// 		String path = seperator + "upload" + seperator;
		
// 		String fileName = "";
// 		String newFileName = ""; // 업로드 되는 파일명
		
// 		File dir = new File(root + path);
// 		if (!dir.exists() || !dir.isDirectory()) {
// 			dir.mkdirs();
// 		}
		
// 		Iterator<String> files = multipart.getFileNames();
// 		while (files.hasNext()) {
// 			String uploadFile = files.next();
			
// 			MultipartFile mFile = multipart.getFile(uploadFile);
// 			fileName = mFile.getOriginalFilename();
// 			newFileName = CommonUtils.getRandomText(10, 7) + "_" + CommonUtils.convertDateFormat(new Date(), "yyyyMMddHHmmssSSS") + "." + fileName.substring(fileName.lastIndexOf(".") + 1);
			
// 			if (!"".equals(fileName)) { // 업로드할 파일이 존재할 경우
// 				try {
// 					mFile.transferTo(new File(root + path + newFileName));
// 				} catch (NullPointerException e) {
// 					logger.error("error is : " + e.toString());
// 				} catch (Exception e) {
// 					//e.printStackTrace();
// 					logger.error("error is : " + e.toString());
// 				}
				
// 				param.put("siteGrpImgPath", path);
// 				param.put("siteGrpImgSname", newFileName);
// 				param.put("siteGrpImgRname", fileName);
// 			}
			
// 		}
// //		Map<String, Object><String, Object> m = CommonUtils.fileUpload(multipart, session);
		
// 		int resultCnt = cmpyGrpSiteMngService.insertGroup(param);
		
// 		resultMap.put("resultCnt", resultCnt);
// 		resultMap.put("resultMsg", "");
// 		resultMap.put("resultCode", 0);
// 		return resultMap;
// 	}
	
// 	/**
// 	 * 사이트 등록
// 	 *
// 	 * @param param
// 	 * @return
// 	 * @throws Exception
// 	 */
// 	@RequestMapping("/system/insertSite.json")
// 	public @ResponseBody
// 	Map<String, Object> insertSite(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
// 		logger.debug("/system/insertSite.json");
// 		logger.debug("     param ::::: " + param.toString());
		
// 		Map<String, Object> userInfo = UserUtil.getUserInfo(request);
// 		param.put("regUid", userInfo.get("user_id"));
// //		Integer userIdx = (userInfo.get("user_idx") == null) ? null : (Integer) userInfo.get("user_idx");
// 		param.put("userIdx2", userInfo.get("user_idx"));
		
// 		int resultCnt = cmpyGrpSiteMngService.insertSite(param);
		
// 		Map<String, Object> resultMap = new HashMap<String, Object>();
// 		resultMap.put("resultCnt", resultCnt);
// 		return resultMap;
// 	}

// 	/**
// 	 * 회사 수정
// 	 *
// 	 * @param param
// 	 * @return
// 	 * @throws Exception
// 	 */
// 	@RequestMapping("/system/updateCmpy.json")
// 	public @ResponseBody
// 	Map<String, Object> updateCmpy(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
// 		logger.debug("/system/updateCmpy.json");
// 		logger.debug("     param ::::: " + param.toString());
		
// 		Map<String, Object> userInfo = UserUtil.getUserInfo(request);
// 		param.put("modUid", userInfo.get("user_id"));
		
// 		int resultCnt = cmpyGrpSiteMngService.updateCmpy(param);
		
// 		Map<String, Object> resultMap = new HashMap<String, Object>();
// 		resultMap.put("resultCnt", resultCnt);
// 		return resultMap;
// 	}

// 	/**
// 	 * 그룹 수정
// 	 *
// 	 * @param param
// 	 * @return
// 	 * @throws Exception
// 	 */
// 	@RequestMapping("/system/updateGroup.json")
// 	public @ResponseBody
// 	Map<String, Object> updateGroup(@RequestParam Map<String, Object> param, MultipartHttpServletRequest multipart, HttpSession session) throws Exception {
// 		logger.debug("/system/updateGroup.json");
// 		logger.debug("     param ::::: " + param.toString());
		
// 		Map<String, Object> userInfo = UserUtil.getUserInfo(multipart.getSession());
// 		param.put("modUid", userInfo.get("user_id"));
		
// 		String siteGrpName = multipart.getParameter("siteGrpName");
// 		String siteGrpId = multipart.getParameter("siteGrpId");
// //		String siteGrpIdx = multipart.getParameter("siteGrpIdx");
// 		String userIdx = multipart.getParameter("userIdx");
// 		String fileChangeYn = multipart.getParameter("fileChangeYn");
		
// 		if ("Y".equals(fileChangeYn)) {
// 			String root = fileUploadRootPath;
// 			String seperator = File.separator;
// 			String path = seperator + "upload" + seperator;
			
// 			String fileName = "";
// 			String newFileName = ""; // 업로드 되는 파일명
			
// 			File dir = new File(root + path);
// 			if (!dir.exists() || !dir.isDirectory()) {
// 				dir.mkdirs();
// 			}
			
// 			Iterator<String> files = multipart.getFileNames();
// 			while (files.hasNext()) {
// 				String uploadFile = files.next();
				
// 				MultipartFile mFile = multipart.getFile(uploadFile);
// 				fileName = mFile.getOriginalFilename();
// 				newFileName = CommonUtils.getRandomText(10, 7) + "_" + CommonUtils.convertDateFormat(new Date(), "yyyyMMddHHmmssSSS") + "." + fileName.substring(fileName.lastIndexOf(".") + 1);
				
// 				if (!"".equals(fileName)) { // 업로드할 파일이 존재할 경우
					
// 					Map<String, Object> result = cmpyGrpSiteMngService.getGroupDetail(param);
// 					String past_path = (String) result.get("site_grp_img_path");
// 					String past_saveName = (String) result.get("site_grp_img_sname");
					
// 					if (!"".equals(path)) {
// 						CommonUtils.deleteFile(root + past_path, past_saveName); // 그룹이미지 파일 삭제
// 					}
					
// 					mFile.transferTo(new File(root + path + newFileName));
// 					param.put("siteGrpImgPath", path);
// 					param.put("siteGrpImgSname", newFileName);
// 					param.put("siteGrpImgRname", fileName);
// 				}
				
// 			}
// //			Map<String, Object><String, Object> m = CommonUtils.fileUpload(multipart, session);
			
// 		}
		
// 		param.put("compIdx", param.get("selCompIdx1"));
// 		int resultCnt = cmpyGrpSiteMngService.updateGroup(param);
		
// 		Map<String, Object> resultMap = new HashMap<String, Object>();
// 		resultMap.put("resultCnt", resultCnt);
// 		return resultMap;
// 	}
	
// 	/**
// 	 * 사이트 수정
// 	 *
// 	 * @param param
// 	 * @return
// 	 * @throws Exception
// 	 */
// 	@RequestMapping("/system/updateSite.json")
// 	public @ResponseBody
// 	Map<String, Object> updateSite(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
// 		logger.debug("/system/updateSite.json");
// 		logger.debug("     param ::::: " + param.toString());
		
// 		Map<String, Object> userInfo = UserUtil.getUserInfo(request);
// 		param.put("modUid", userInfo.get("user_id"));
// 		param.put("siteGrpIdx", param.get("selSiteGrpIdx2"));
// 		param.put("compIdx", param.get("selCompIdx2"));
		
// 		int resultCnt = cmpyGrpSiteMngService.updateSite(param);
		
// 		Map<String, Object> resultMap = new HashMap<String, Object>();
// 		resultMap.put("resultCnt", resultCnt);
// 		return resultMap;
// 	}
	
// 	/**
// 	 * 그룹 삭제
// 	 *
// 	 * @param param
// 	 * @return
// 	 * @throws Exception
// 	 */
// 	@RequestMapping("/system/deleteGroup.json")
// 	public @ResponseBody
// 	Map<String, Object> deleteGroup(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
// 		logger.debug("/system/deleteGroup.json");
// 		logger.debug("     param ::::: " + param.toString());
		
// 		Map<String, Object> userInfo = UserUtil.getUserInfo(request);
// 		param.put("modUid", userInfo.get("user_id"));
		
// //		Map result = cmpyGrpSiteMngService.getGroupDetail(param);
// //		String path = (String) result.get("site_grp_img_path");
// //		String saveName = (String) result.get("site_grp_img_sname");
		
// 		int resultCnt = cmpyGrpSiteMngService.deleteGroup(param);
// //		if(resultCnt > 0 && !"".equals(path)) {
// //			String root = "d:\\fileUploadTest\\test";
// //			CommonUtils.deleteFile(root+path, saveName); // 그룹이미지 파일 삭제 
// //		}
		
// 		Map<String, Object> resultMap = new HashMap<String, Object>();
// 		resultMap.put("resultCnt", resultCnt);
// 		return resultMap;
// 	}
	
// 	/**
// 	 * 회사 삭제
// 	 *
// 	 * @param param
// 	 * @return
// 	 * @throws Exception
// 	 */
// 	@RequestMapping("/system/deleteCmpy.json")
// 	public @ResponseBody
// 	Map<String, Object> deleteCmpy(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
// 		logger.debug("/system/deleteCmpy.json");
// 		logger.debug("     param ::::: " + param.toString());
		
// 		Map<String, Object> userInfo = UserUtil.getUserInfo(request);
// 		param.put("modUid", userInfo.get("user_id"));
		
// 		int resultCnt = cmpyGrpSiteMngService.deleteCmpy(param);
		
// 		Map<String, Object> resultMap = new HashMap<String, Object>();
// 		resultMap.put("resultCnt", resultCnt);
// 		return resultMap;
// 	}
	
// 	/**
// 	 * 사이트 삭제
// 	 *
// 	 * @param param
// 	 * @return
// 	 * @throws Exception
// 	 */
// 	@RequestMapping("/system/deleteSite.json")
// 	public @ResponseBody
// 	Map<String, Object> deleteSite(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
// 		logger.debug("/system/deleteSite.json");
// 		logger.debug("     param ::::: " + param.toString());
		
// 		Map<String, Object> userInfo = UserUtil.getUserInfo(request);
// 		param.put("modUid", userInfo.get("user_id"));
		
// 		int resultCnt = cmpyGrpSiteMngService.deleteSite(param);
		
// 		Map<String, Object> resultMap = new HashMap<String, Object>();
// 		resultMap.put("resultCnt", resultCnt);
// 		return resultMap;
// 	}
	
	
// }
