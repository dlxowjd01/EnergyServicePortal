/**
 * class name : SetupController
 * description : 설정 메뉴 controller
 * version : 1.0
 * author : 이우람
 */

package kr.co.ewp.ewpsp.web;

import java.io.File;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import kr.co.ewp.ewpsp.common.util.CommonUtils;
import kr.co.ewp.ewpsp.common.util.ContextPropertiesUtil;
import kr.co.ewp.ewpsp.service.CmpyGrpSiteMngService;

@Controller
public class CmpyGrpSiteMngController {

	private static final Logger logger = LoggerFactory.getLogger(CmpyGrpSiteMngController.class);
	
	@Resource(name="cmpyGrpSiteMngService")
	private CmpyGrpSiteMngService cmpyGrpSiteMngService;
	
//	@Resource(name="prop")
//	private ContextPropertiesUtil properties;
	@Value("${globals.fileUpload.rootPath}")
	private String fileUploadRootPath;;
	
	
	@RequestMapping("/cmpyGrpSiteMng")
	public String cmpyGrpSiteMng(Model model) {
		logger.debug("/cmpyGrpSiteMng");
		
		return "ewp/setup/cmpyGrpSiteMng";
	}
	
	/**
	 * 회사 목록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getCmpyList")
	public @ResponseBody Map<String, Object> getCmpyList(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
		logger.debug("/getCmpyList");
		logger.debug("param ::::: "+param.toString());

		int selPageNum = Integer.parseInt((String) param.get("selPageNum"));
		int pageRowCnt = 5;
		int startNum = pageRowCnt*(selPageNum-1);
		
		param.put("siteId", request.getSession().getAttribute("selViewSiteId"));
		param.put("startNum", startNum);
		param.put("pageRowCnt", pageRowCnt);
		
		List list = cmpyGrpSiteMngService.getCmpyList(param);
		int listCnt = cmpyGrpSiteMngService.getCmpyListCnt(param);
		int totalPageCnt = 0;
		if(listCnt > 0) {
			totalPageCnt = listCnt / pageRowCnt;
			if(listCnt % pageRowCnt > 0) {
				totalPageCnt++;
			}
		}
		
		Map<String, Object> pagingMap = new HashMap<String, Object>();
		pagingMap.put("pageRowCnt", pageRowCnt); // 한 페이지 당 보여줄 데이터 수
		pagingMap.put("selPageNum", selPageNum); // 선택한 페이지번호
		pagingMap.put("listCnt", listCnt); // 전체 데이터 수
		pagingMap.put("totalPageCnt", totalPageCnt); // 전체 페이지 수
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		resultMap.put("pagingMap", pagingMap);
		return resultMap;
	}
	
	/**
	 * 그룹 목록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getGroupList")
	public @ResponseBody Map<String, Object> getGroupList(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
		logger.debug("/getGroupList");
		logger.debug("param ::::: "+param.toString());

		int selPageNum = Integer.parseInt((String) param.get("selPageNum"));
		int pageRowCnt = 5;
		int startNum = pageRowCnt*(selPageNum-1);
		
		param.put("siteId", request.getSession().getAttribute("selViewSiteId"));
		param.put("startNum", startNum);
		param.put("pageRowCnt", pageRowCnt);
		
		List list = cmpyGrpSiteMngService.getGroupList(param);
		int listCnt = cmpyGrpSiteMngService.getGroupListCnt(param);
		int totalPageCnt = 0;
		if(listCnt > 0) {
			totalPageCnt = listCnt / pageRowCnt;
			if(listCnt % pageRowCnt > 0) {
				totalPageCnt++;
			}
		}
		
		Map<String, Object> pagingMap = new HashMap<String, Object>();
		pagingMap.put("pageRowCnt", pageRowCnt); // 한 페이지 당 보여줄 데이터 수
		pagingMap.put("selPageNum", selPageNum); // 선택한 페이지번호
		pagingMap.put("listCnt", listCnt); // 전체 데이터 수
		pagingMap.put("totalPageCnt", totalPageCnt); // 전체 페이지 수
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		resultMap.put("pagingMap", pagingMap);
		return resultMap;
	}
	
	/**
	 * 사이트 목록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getSiteList")
	public @ResponseBody Map<String, Object> getSiteList(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
		logger.debug("/getSiteList");
		logger.debug("param ::::: "+param.toString());

		int selPageNum = Integer.parseInt((String) param.get("selPageNum"));
		int pageRowCnt = 5;
		int startNum = pageRowCnt*(selPageNum-1);
		
		param.put("siteId", request.getSession().getAttribute("selViewSiteId"));
		param.put("startNum", startNum);
		param.put("pageRowCnt", pageRowCnt);
		
		List list = cmpyGrpSiteMngService.getSiteList(param);
		int listCnt = cmpyGrpSiteMngService.getSiteListCnt(param);
		int totalPageCnt = 0;
		if(listCnt > 0) {
			totalPageCnt = listCnt / pageRowCnt;
			if(listCnt % pageRowCnt > 0) {
				totalPageCnt++;
			}
		}
		
		Map<String, Object> pagingMap = new HashMap<String, Object>();
		pagingMap.put("pageRowCnt", pageRowCnt); // 한 페이지 당 보여줄 데이터 수
		pagingMap.put("selPageNum", selPageNum); // 선택한 페이지번호
		pagingMap.put("listCnt", listCnt); // 전체 데이터 수
		pagingMap.put("totalPageCnt", totalPageCnt); // 전체 페이지 수
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		resultMap.put("pagingMap", pagingMap);
		return resultMap;
	}

	/**
	 * 회사 목록(팝업) 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getCmpyPopupList")
	public @ResponseBody Map<String, Object> getCmpyPopupList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getCmpyPopupList");
		logger.debug("param ::::: "+param.toString());
		
//		List list = cmpyGrpSiteMngService.getGroupPopupList(param);
		List list = cmpyGrpSiteMngService.getCmpyList(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		return resultMap;
	}
	
	/**
	 * 회사 내 그룹 목록(팝업) 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getGroupPopupList")
	public @ResponseBody Map<String, Object> getGroupPopupList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getGroupPopupList");
		logger.debug("param ::::: "+param.toString());
		
		List list = cmpyGrpSiteMngService.getGroupPopupList(param);
//		List list = cmpyGrpSiteMngService.getGroupList(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		return resultMap;
	}

	/**
	 * 사이트 목록(팝업) 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getSitePopupList")
	public @ResponseBody Map<String, Object> getSitePopupList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getSitePopupList");
		logger.debug("param ::::: "+param.toString());
		
		param.put("userIdx", "1");
		
		List grpSiteList = cmpyGrpSiteMngService.getGrpSiteList(param);
		List allSiteList = cmpyGrpSiteMngService.getAllSiteList(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("grpSiteList", grpSiteList);
		resultMap.put("allSiteList", allSiteList);
		return resultMap;
	}

	/**
	 * 회사 한건 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getCmpyDetail")
	public @ResponseBody Map<String, Object> getCmpyDetail(@RequestParam HashMap param) throws Exception {
		logger.debug("/getCmpyDetail");
		logger.debug("param ::::: "+param.toString());
		
		Map result = cmpyGrpSiteMngService.getCmpyDetail(param);
		logger.debug("result.toString() : "+result.toString());
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("detail", result);
		return resultMap;
	}
	
	/**
	 * 그룹 한건 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getGroupDetail")
	public @ResponseBody Map<String, Object> getGroupDetail(@RequestParam HashMap param) throws Exception {
		logger.debug("/getGroupDetail");
		logger.debug("param ::::: "+param.toString());
		
		Map result = cmpyGrpSiteMngService.getGroupDetail(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("detail", result);
		return resultMap;
	}

	/**
	 * 사이트 한건 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getSiteDetail")
	public @ResponseBody Map<String, Object> getSiteDetail(@RequestParam HashMap param) throws Exception {
		logger.debug("/getSiteDetail");
		logger.debug("param ::::: "+param.toString());
		
		Map result = cmpyGrpSiteMngService.getSiteDetail(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("detail", result);
		return resultMap;
	}

	/**
	 * 사이트그룹 내 사이트 추가/제거
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/saveSiteInSiteGrp")
	public @ResponseBody Map<String, Object> saveSiteInSiteGrp(@RequestParam HashMap param) throws Exception {
		logger.debug("/saveSiteInSiteGrp");
		logger.debug("param ::::: "+param.toString());
		
		String selSiteGrpIdx = (String) param.get("selSiteGrpIdx"); // 그룹 목록
		String nowSiteIds = (String) param.get("nowSiteIds"); // 기존 그룹내 사이트목록
		String newSiteIds = (String) param.get("newSiteIds"); // 변경할 그룹내 사이트목록
		String nowSiteIds_arr[] = null; // 기존 그룹내 사이트목록
		String newSiteIds_arr[] = null; // 변경할 그룹내 사이트목록 
		if(nowSiteIds != null && !"".equals(nowSiteIds)) {
			nowSiteIds_arr = nowSiteIds.split(",");
		}
		if(newSiteIds != null && !"".equals(newSiteIds)) {
			newSiteIds_arr = newSiteIds.split(",");
		}
		
		// 기존목록과 변경목록이 동일한지 확인 -> 동일하면 변경사항 없음
		String changeYn = "Y";
		changeYn = ( Arrays.equals(nowSiteIds_arr, newSiteIds_arr) ) ? "N" : "Y"; 
		
		if("Y".equals(changeYn)) {
			// 로직 : 기존목록과 변경된목록을 비교한다.
			// 기존에 존재하고 변경된 목록에 미존재 : 그룹에저 제외됨
			// 기존에도 존재하고 변경된 목록에도 존재 : 변동없음
			// 기존에 미존재하고 변경된 목록에 존재 : 그룹에 새로 추가됨
			// 기존목록이 있는데 변경된 목록이 null일 경우 : 그룹에서 전부 제외됨
			// 기존목록이 null인데 변경된 목록이 존재 : 빈 그룹에 새로 추가됨
			int addCnt = 0;
			int delCnt = 0;
			if(nowSiteIds_arr != null) {
				if(nowSiteIds_arr.length > 0) { // 기존목록의 데이터를 변동된목록에 존재하는지 확인
					for (int i = 0; i < nowSiteIds_arr.length; i++) {
						String str = nowSiteIds_arr[i];
						boolean res = false;
						if(newSiteIds_arr != null) res = Arrays.asList(newSiteIds_arr).contains(str);
						if(!res) { // 기존에 존재하고 변경된 목록에 미존재 : 그룹에저 제외됨
							HashMap dvMap = new HashMap<String, Object>();
							dvMap.put("siteId", str);
							dvMap.put("siteGrpIdx", 0);
							dvMap.put("modUid", "tttt");
							int cnt = cmpyGrpSiteMngService.updateSite(dvMap);
							delCnt = delCnt + cnt;
						}
					}
				}
				
			} else {
				for (int i = 0; i < newSiteIds_arr.length; i++) {
					HashMap dvMap = new HashMap<String, Object>();
					dvMap.put("siteId", newSiteIds_arr[i]);
					dvMap.put("siteGrpIdx", selSiteGrpIdx);
					dvMap.put("modUid", "tttt");
					int cnt = cmpyGrpSiteMngService.updateSite(dvMap);
					addCnt = addCnt + cnt;
				}
			}
			
			if(newSiteIds_arr != null) {
				if(newSiteIds_arr.length > 0) { // 변동된목록의 데이터를 기존목록에 존재하는지 확인
					for (int i = 0; i < newSiteIds_arr.length; i++) {
						String str = newSiteIds_arr[i];
						boolean res = false;
						if(nowSiteIds_arr != null) res = Arrays.asList(nowSiteIds_arr).contains(str);
						if(!res) { // 기존에 미존재하고 변경된 목록에 존재 : 그룹에 새로 추가됨
							HashMap dvMap = new HashMap<String, Object>();
							dvMap.put("siteId", str);
							dvMap.put("siteGrpIdx", selSiteGrpIdx);
							dvMap.put("modUid", "tttt");
							int cnt = cmpyGrpSiteMngService.updateSite(dvMap);
							addCnt = addCnt + cnt;
						}
					}
				}
				
			} else {
				for (int i = 0; i < nowSiteIds_arr.length; i++) {
					HashMap dvMap = new HashMap<String, Object>();
					dvMap.put("siteId", nowSiteIds_arr[i]);
					dvMap.put("siteGrpIdx", 0);
					dvMap.put("modUid", "tttt");
					int cnt = cmpyGrpSiteMngService.updateSite(dvMap);
					delCnt = delCnt + cnt;
				}
			}
			
			
		}
		
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", 0);
		resultMap.put("changeYn", changeYn);
		return resultMap;
	}
	
	/**
	 * 회사 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/insertCmpy")
	public @ResponseBody Map<String, Object> insertCmpy(@RequestParam HashMap param) throws Exception {
		logger.debug("/insertCmpy");
		logger.debug("param ::::: "+param.toString());
		
		param.put("userIdx", "1");
		
		int resultCnt = cmpyGrpSiteMngService.insertCmpy(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", resultCnt);
		return resultMap;
	}
	
	/**
	 * 그룹 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/insertGroup")
	public @ResponseBody Map<String, Object> insertGroup(@RequestParam HashMap param, MultipartHttpServletRequest multipart, HttpSession session) throws Exception {
		logger.debug("/insertGroup");
		logger.debug("param ::::: "+param.toString());
		
		String siteGrpName = multipart.getParameter("siteGrpName");
		String siteGrpId = multipart.getParameter("siteGrpId");
//		String siteGrpIdx = multipart.getParameter("siteGrpIdx");
		String userIdx = multipart.getParameter("userIdx");
		
		String root = fileUploadRootPath;
		String path = "/upload/";
		
		String fileName = "";
		String newFileName = ""; // 업로드 되는 파일명
		
		File dir = new File(root+path);
		if(!dir.exists() ||!dir.isDirectory()){
			dir.mkdirs();
		}
		
		Iterator<String> files = multipart.getFileNames();
		while(files.hasNext()){
			String uploadFile = files.next();
			
			MultipartFile mFile = multipart.getFile(uploadFile);
			fileName = mFile.getOriginalFilename();
			newFileName = CommonUtils.getRandomText(10, 7) + "_" + CommonUtils.convertDateFormat(new Date(), "yyyyMMddHHmmssSSS")+"."+fileName.substring(fileName.lastIndexOf(".")+1);
			
			if(!"".equals(fileName)) { // 업로드할 파일이 존재할 경우
				try {
					mFile.transferTo(new File(root+path+newFileName));
				} catch (Exception e) {
					e.printStackTrace();
				}
				
				param.put("siteGrpImgPath", path);
				param.put("siteGrpImgSname", newFileName);
				param.put("siteGrpImgRname", fileName);
			}
			System.out.println("aaaaa     13");
		}
//		HashMap<String, Object> m = CommonUtils.fileUpload(multipart, session);
		
		int resultCnt = cmpyGrpSiteMngService.insertGroup(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", resultCnt);
		return resultMap;
	}
	
	/**
	 * 사이트 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/insertSite")
	public @ResponseBody Map<String, Object> insertSite(@RequestParam HashMap param) throws Exception {
		logger.debug("/insertSite");
		logger.debug("param ::::: "+param.toString());
		
		int resultCnt = cmpyGrpSiteMngService.insertSite(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", resultCnt);
		return resultMap;
	}
	
	/**
	 * 회사 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/updateCmpy")
	public @ResponseBody Map<String, Object> updateCmpy(@RequestParam HashMap param) throws Exception {
		logger.debug("/updateCmpy");
		logger.debug("param ::::: "+param.toString());
		
		int resultCnt = cmpyGrpSiteMngService.updateCmpy(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", resultCnt);
		return resultMap;
	}
	
	/**
	 * 그룹 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/updateGroup")
	public @ResponseBody Map<String, Object> updateGroup(@RequestParam HashMap param, MultipartHttpServletRequest multipart, HttpSession session) throws Exception {
		logger.debug("/updateGroup");
		logger.debug("param ::::: "+param.toString());
		
		String siteGrpName = multipart.getParameter("siteGrpName");
		String siteGrpId = multipart.getParameter("siteGrpId");
//		String siteGrpIdx = multipart.getParameter("siteGrpIdx");
		String userIdx = multipart.getParameter("userIdx");
		String fileChangeYn = multipart.getParameter("fileChangeYn");
		
		if("Y".equals(fileChangeYn)) {
			String root = fileUploadRootPath;
			String path = "/upload/";
			
			String fileName = "";
			String newFileName = ""; // 업로드 되는 파일명
			
			File dir = new File(root+path);
			if(!dir.exists() ||!dir.isDirectory()){
				dir.mkdirs();
			}
			
			Iterator<String> files = multipart.getFileNames();
			while(files.hasNext()){
				String uploadFile = files.next();
				
				MultipartFile mFile = multipart.getFile(uploadFile);
				fileName = mFile.getOriginalFilename();
				newFileName = CommonUtils.getRandomText(10, 7) + "_" + CommonUtils.convertDateFormat(new Date(), "yyyyMMddHHmmssSSS")+"."+fileName.substring(fileName.lastIndexOf(".")+1);
				
				if(!"".equals(fileName)) { // 업로드할 파일이 존재할 경우
					System.out.println(root+path+newFileName);
					
					Map result = cmpyGrpSiteMngService.getGroupDetail(param);
					String past_path = (String) result.get("site_grp_img_path");
					String past_saveName = (String) result.get("site_grp_img_sname");
					
					if(!"".equals(path)) {
						CommonUtils.deleteFile(root+past_path, past_saveName); // 그룹이미지 파일 삭제 
					}
					
					mFile.transferTo(new File(root+path+newFileName));
					param.put("siteGrpImgPath", path);
					param.put("siteGrpImgSname", newFileName);
					param.put("siteGrpImgRname", fileName);
				}
				
			}
//			HashMap<String, Object> m = CommonUtils.fileUpload(multipart, session);
			
		}
		
		int resultCnt = cmpyGrpSiteMngService.updateGroup(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", resultCnt);
		return resultMap;
	}
	
	/**
	 * 사이트 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/updateSite")
	public @ResponseBody Map<String, Object> updateSite(@RequestParam HashMap param) throws Exception {
		logger.debug("/updateSite");
		logger.debug("param ::::: "+param.toString());
		
		int resultCnt = cmpyGrpSiteMngService.updateSite(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", resultCnt);
		return resultMap;
	}
	
	/**
	 * 그룹 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/deleteGroup")
	public @ResponseBody Map<String, Object> deleteGroup(@RequestParam HashMap param) throws Exception {
		logger.debug("/deleteGroup");
		logger.debug("param ::::: "+param.toString());
		
//		Map result = cmpyGrpSiteMngService.getGroupDetail(param);
//		String path = (String) result.get("site_grp_img_path");
//		String saveName = (String) result.get("site_grp_img_sname");
		
		int resultCnt = cmpyGrpSiteMngService.deleteGroup(param);
//		if(resultCnt > 0 && !"".equals(path)) {
//			String root = "d:\\fileUploadTest\\test";
//			CommonUtils.deleteFile(root+path, saveName); // 그룹이미지 파일 삭제 
//		}
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", resultCnt);
		return resultMap;
	}
	
	/**
	 * 회사 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/deleteCmpy")
	public @ResponseBody Map<String, Object> deleteCmpy(@RequestParam HashMap param) throws Exception {
		logger.debug("/deleteCmpy");
		logger.debug("param ::::: "+param.toString());
		
		int resultCnt = cmpyGrpSiteMngService.deleteCmpy(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", resultCnt);
		return resultMap;
	}
	
	/**
	 * 사이트 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/deleteSite")
	public @ResponseBody Map<String, Object> deleteSite(@RequestParam HashMap param) throws Exception {
		logger.debug("/deleteSite");
		logger.debug("param ::::: "+param.toString());
		
		int resultCnt = cmpyGrpSiteMngService.deleteSite(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", resultCnt);
		return resultMap;
	}
	
}
