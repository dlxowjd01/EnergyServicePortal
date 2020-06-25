package kr.co.esp.system.web;

import java.io.File;
import java.util.ArrayList;
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
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.com.cmm.service.EgovProperties;
import kr.co.esp.common.util.CommonUtils;
import kr.co.esp.common.util.UserUtil;
import kr.co.esp.system.service.UserMngService;

@Controller
public class UserMngController {

	private static final Logger logger = LoggerFactory.getLogger(UserMngController.class);
	
	private String fileUploadRootPath = EgovProperties.getProperty("globals.fileUpload.rootPath");
	
	@Resource(name="userMngService")
	private UserMngService userMngService;
	
	@RequestMapping(value = "/system/userMng.do")
	public String userMng(HttpServletRequest request, HttpSession session, Model model) {
		logger.debug("/system/userMng.do");
		return "esp/system/userMng";
	}
	
	/**
	 * 사용자 목록 조회
	 * @param param
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/system/getUserList.json")
	public ResponseEntity<Map<String, Object>> getUserList(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/system/getUserList.json");
		logger.debug("     param ::::: " + param.toString());
		
		Map<String, Object> userInfo = UserUtil.getUserInfo(request);
		String authType = (String)userInfo.get("auth_type");
		if("2".equals(authType)) { // 고객사관리자
			param.put("compIdx", userInfo.get("comp_idx"));
		} else if("3".equals(authType)) { // 그룹관리자
			param.put("siteGrpIdx", userInfo.get("site_grp_idx"));
		} else if("4".equals(authType)) { // 사이트관리자
			param.put("siteId", userInfo.get("site_id"));
		} else if("5".equals(authType)) { // 사이트이용자
			param.put("userIdx", userInfo.get("user_idx"));
		}

		int selPageNum = Integer.parseInt((String) param.get("selPageNum"));
		int pageRowCnt = 5;
		int startNum = pageRowCnt*(selPageNum-1);
		
		param.put("startNum", startNum);
		param.put("pageRowCnt", pageRowCnt);
		
		List<Map<String, Object>> list = userMngService.getUserList(param);
		int listCnt = userMngService.getUserListCnt(param);
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
		return new ResponseEntity<>(resultMap, HttpStatus.OK);
	}
	
	/**
	 * 사용자 한건 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/system/getUserDetail.json")
	public ResponseEntity<Map<String, Object>> getUserDetail(@RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/system/getUserDetail.json");
		logger.debug("     param ::::: " + param.toString());
		
		Map<String, Object> result = userMngService.getUserDetail(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("detail", result);
		return new ResponseEntity<>(resultMap, HttpStatus.OK);
	}
	
	/**
	 * 마지막에 추가한 사용자 한건 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/system/getLastUserDetail.json")
	public ResponseEntity<Map<String, Object>> getLastUserDetail(@RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/system/getLastUserDetail.json");
		logger.debug("     param ::::: " + param.toString());
		
		Map<String, Object> result = userMngService.getLastUserDetail(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("detail", result);
		return new ResponseEntity<>(resultMap, HttpStatus.OK);
	}
	
	/**
	 * 사용자 등록
	 * @param param
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/system/insertUser.json")
	public ResponseEntity<Map<String, Object>> insertUser(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/system/insertUser.json");
		logger.debug("     param ::::: " + param.toString());
		
		//  정확하게는 사용자 권한 추가
		// 회원가입이 되어있는 사용자id에만 권한을 추가한다.
		int resultCnt = 0;
		Map<String, Object> userIdMap = userMngService.getUserIdDetail(param);
		if(userIdMap != null) {
			Map<String, Object> userInfo = UserUtil.getUserInfo(request);
			param.put("modUid", userInfo.get("user_id"));
			param.put("userIdx", userIdMap.get("user_idx"));
			
			resultCnt = userMngService.updateUser(param);
		}
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", resultCnt);
		return new ResponseEntity<>(resultMap, HttpStatus.OK);
	}
	
	/**
	 * 사용자 수정
	 * @param param
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/system/updateUser.json")
	public ResponseEntity<Map<String, Object>> updateUser(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/system/updateUser.json");
		logger.debug("     param ::::: " + param.toString());
		
		Map<String, Object> userInfo = UserUtil.getUserInfo(request);
		param.put("modUid", userInfo.get("user_id"));
		
		int resultCnt = userMngService.updateUser(param);
		int resultAuthCnt = userMngService.updateUserAuth(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", resultCnt);
		resultMap.put("resultAuthCnt", resultAuthCnt);
		return new ResponseEntity<>(resultMap, HttpStatus.OK);
	}
	
	/**
	 * 사용자 삭제
	 * @param param
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/system/deleteUser.json")
	public ResponseEntity<Map<String, Object>> deleteUser(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/system/deleteUser.json");
		logger.debug("     param ::::: " + param.toString());
		
		Map<String, Object> userInfo = UserUtil.getUserInfo(request);
		param.put("modUid", userInfo.get("user_id"));
		
		int resultCnt = userMngService.deleteUser(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", resultCnt);
		return new ResponseEntity<>(resultMap, HttpStatus.OK);
	}
	
	/////////////////////////임시영역//////////////////////////////
	//페이지 이동
	@RequestMapping(value = "/system/cmmnCdMng.do")
	public String cmmnCdMng(HttpServletRequest request, HttpSession session, Model model) {
		logger.debug("/system/cmmnCdMng.do");
		return "esp/system/cmmnCdMng";
	}
	//공통코드 조회
	@RequestMapping("/system/getCmmnCodeList.json")
	public ResponseEntity<Map<String, Object>> getCmmnCodeList(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/system/getCmmnCodeList.json");
		logger.debug("     param ::::: " + param.toString());
		
		Map<String, Object> userInfo = UserUtil.getUserInfo(request);

		int selPageNum = 0;
		int pageRowCnt = 0;
		int startNum = 0; 
		
		if(null != param.get("selPageNum")) { //페이지번호가 null일 때는 팝업에서 호출된 것
			selPageNum = Integer.parseInt((String) param.get("selPageNum"));
			pageRowCnt = 5;
			startNum = pageRowCnt*(selPageNum-1);
			param.put("startNum", startNum);
			param.put("pageRowCnt", pageRowCnt);
		}
		
		List<Map<String, Object>> cmmnCodeList = userMngService.getCmmnCodeList(param);
		int listCnt = userMngService.getCmmnCodeListCnt(param);
		Map<String, Object> pagingMap = new HashMap<String, Object>();
		if(null != param.get("selPageNum")) {
			
			int totalPageCnt = 0;
			if(listCnt > 0) {
				totalPageCnt = listCnt / pageRowCnt;
				if(listCnt % pageRowCnt > 0) {
					totalPageCnt++;
				}
			}
			pagingMap.put("pageRowCnt", pageRowCnt); // 한 페이지 당 보여줄 데이터 수
			pagingMap.put("selPageNum", selPageNum); // 선택한 페이지번호
			pagingMap.put("listCnt", listCnt); // 전체 데이터 수
			pagingMap.put("totalPageCnt", totalPageCnt); // 전체 페이지 수
		}
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", cmmnCodeList);
		resultMap.put("pagingMap", pagingMap);
		return new ResponseEntity<>(resultMap, HttpStatus.OK);
	}
	//공통코드 생성, 수정, 삭제
	@RequestMapping("/system/saveCommonCode.json")
	public ResponseEntity<Map<String, Object>> saveCommonCode(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/system/saveCommonCode.json");
		logger.debug("     param ::::: " + param.toString());
		List<Map<String, Object>> updateList = new ArrayList<>();  //update
		List<Map<String, Object>> insertList = new ArrayList<>();  //insert
		List<Map<String, Object>> deleteList = new ArrayList<>();  //delete
		
		Map<String, Object> userInfo = UserUtil.getUserInfo(request);
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		int insertCnt = 0;
		int updateCnt = 0;
		int deleteCnt = 0;
		
		for( Map.Entry<String, Object> elem : param.entrySet() ){
			Map<String, Object> temp = new HashMap<String, Object>();
			
			if(elem.getKey().toString().startsWith("U")) {
				String dataArr[] = ((String)elem.getValue()).split(",");
				temp.put("up_code_id", (dataArr[0]!=null)?dataArr[0]:"");
				temp.put("code_id", (dataArr[1]!=null)?dataArr[1]:"");
				temp.put("code_name", (dataArr[2]!=null)?dataArr[2]:"");
				temp.put("ex_code_id", (dataArr[3]!=null)?dataArr[3]:"");  //이전 code_id
				temp.put("modUid", userInfo.get("user_id"));
				updateList.add(temp);
				
			} else if(elem.getKey().toString().startsWith("I")) {
				String dataArr[] = ((String)elem.getValue()).split(",");
				temp.put("up_code_id", (dataArr[0]!=null)?dataArr[0]:"");
				temp.put("code_id", (dataArr[1]!=null)?dataArr[1]:"");
				temp.put("code_name", (dataArr[2]!=null)?dataArr[2]:"");
				temp.put("up_code_name", (dataArr[3]!=null)?dataArr[3]:"");  // 쓰이지 않음
				temp.put("regUid", userInfo.get("user_id"));
				insertList.add(temp);
				
			} else if(elem.getKey().toString().startsWith("D")) { // delete
				String dataArr[] = ((String)elem.getValue()).split(",");
				temp.put("up_code_id", (dataArr[0]!=null)?dataArr[0]:"");
				temp.put("code_id", (dataArr[1]!=null)?dataArr[1]:"");
				deleteList.add(temp);
			}
		}
		//update
		if (updateList.size() > 0) {
			for (Map<String, Object> m : updateList) {
				updateCnt += userMngService.updateCommonCode(m);
			}
		}
		//insert
		if (insertList.size() > 0) {
			for (Map<String, Object> m : insertList) {
				insertCnt = userMngService.insertCommonCode(m);
			}
		}
		//delete
		if (deleteList.size() > 0) {
			deleteCnt = userMngService.deleteCommonCode(deleteList);
		}

		resultMap.put("insertCnt", insertCnt);
		resultMap.put("updateCnt", updateCnt);
		resultMap.put("deleteCnt", deleteCnt);
		resultMap.put("resultMsg", "success");
		resultMap.put("resultCode", 0);
		return  new ResponseEntity<>(resultMap, HttpStatus.OK);
	}
	
	// 심볼 리스트 조회
	@RequestMapping("/system/getSymbolList.json")
	public ResponseEntity<Map<String, Object>> getSymbolList(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/system/getSymbolList.json");
		logger.debug("     param ::::: " + param.toString());
		
		int selPageNum = 0;
		int pageRowCnt = 0;
		int startNum = 0; 

		if(null != param.get("selPageNum")) { //페이지번호가 null이면 팝업에서 호출된 것
			selPageNum = Integer.parseInt((String) param.get("selPageNum"));
			pageRowCnt = 5;
			startNum = pageRowCnt*(selPageNum-1);
			param.put("startNum", startNum);
			param.put("pageRowCnt", pageRowCnt);
		}
		
		List<Map<String, Object>> symbolList = userMngService.getSymbolList(param);
		
		Map<String, Object> pagingMap = new HashMap<String, Object>();
		if(null != param.get("selPageNum")) {
			int listCnt = 0;
			if(symbolList.size() > 0) {
				listCnt = (int)(long) ((symbolList.get(0).get("listCnt") != null)?symbolList.get(0).get("listCnt"):0);
			}
			int totalPageCnt = 0;
			if(listCnt > 0) {
				totalPageCnt = listCnt / pageRowCnt;
				if(listCnt % pageRowCnt > 0) {
					totalPageCnt++;
				}
			}
			pagingMap.put("pageRowCnt", pageRowCnt); // 한 페이지 당 보여줄 데이터 수
			pagingMap.put("selPageNum", selPageNum); // 선택한 페이지번호
			pagingMap.put("listCnt", listCnt); // 전체 데이터 수
			pagingMap.put("totalPageCnt", totalPageCnt); // 전체 페이지 수
		}
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", symbolList);
		resultMap.put("imgRoot", ".."); //임시 root
		resultMap.put("pagingMap", pagingMap);
		return new ResponseEntity<>(resultMap, HttpStatus.OK);
	}
	
	// 심볼 생성, 수정, 삭제
	@RequestMapping("/system/saveSymbol.json")
	@ResponseBody
	public Map<String, Object> saveSymbol(@RequestParam Map<String, Object> param, MultipartHttpServletRequest multipart, HttpSession session, HttpServletRequest request) throws Exception {
		logger.debug("/system/saveSymbol.json");
		logger.debug("     param ::::: " + param.toString());
		List<Map<String, Object>> updateList = new ArrayList<>();  //update
		List<Map<String, Object>> insertList = new ArrayList<>();  //insert
		List<Map<String, Object>> deleteList = new ArrayList<>();  //delete
		
		Map<String, Object> userInfo = UserUtil.getUserInfo(request);
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		int insertCnt = 0;
		int updateCnt = 0;
		int deleteCnt = 0;
		
		for( Map.Entry<String, Object> elem : param.entrySet() ){
			Map<String, Object> temp = new HashMap<String, Object>();
			
			if(elem.getKey().toString().startsWith("U")) {
				String dataArr[] = ((String)elem.getValue()).split(",");
				temp.put("img_idx", (dataArr[0]!=null)?dataArr[0]:"");
				temp.put("img_origin_name", (dataArr[1]!=null)?dataArr[1]:"");
				temp.put("img_type", (dataArr[2]!=null)?dataArr[2]:"");
				temp.put("img_desc", (dataArr[3]!=null)?dataArr[3]:"");
				temp.put("img_file", (dataArr[4]!=null)?dataArr[4]:"");
				updateList.add(temp);
			} else if(elem.getKey().toString().startsWith("I")) {
				String dataArr[] = ((String)elem.getValue()).split(",");
//				temp.put("img_idx", (dataArr[0]!=null)?dataArr[0]:"");
				temp.put("img_origin_name", (dataArr[1]!=null)?dataArr[1]:"");
				temp.put("img_type", (dataArr[2]!=null)?dataArr[2]:"");
				temp.put("img_desc", (dataArr[3]!=null)?dataArr[3]:"");
				temp.put("img_file", (dataArr[4]!=null)?dataArr[4]:"");
				insertList.add(temp);
			} else if(elem.getKey().toString().startsWith("D")) { // delete
				temp.put("img_idx",(String)elem.getValue());
				deleteList.add(temp);
			}
		}
		
		String root = "\\eGovFrameDev-3.8.0-64bit\\workspace\\energyServicePortal_svn\\src\\main\\webapp\\resources"; //임시 경로
		String seperator = File.separator;
		String path = seperator +"img" +seperator + "upload" + seperator;
		String fileName = "";
		String newFileName = ""; // 업로드 되는 파일명
		//insert
		if (insertList.size() > 0) {
			
			List<Map<String, Object>> insertParamList = new ArrayList<>();  //insert
			
			for (Map<String, Object> m : insertList) {
				String img_type = (String)m.get("img_type"); //심볼타입을 가져오는 것.아직 db에 저장할 위치 불분명
				String img_desc = (String)m.get("img_desc");
				String img_origin_name = (String)m.get("img_origin_name");
				String uploadFile = (String)m.get("img_file");
				m.clear();
				
				MultipartFile mFile = multipart.getFile(uploadFile);
				
				if(mFile != null) {
					
					File dir = new File(root + path);
					if (!dir.exists() || !dir.isDirectory()) {
						dir.mkdirs();
					}
					fileName = mFile.getOriginalFilename();
					newFileName = CommonUtils.getRandomText(10, 7) + "_" + CommonUtils.convertDateFormat(new Date(), "yyyyMMddHHmmssSSS") + "." + fileName.substring(fileName.lastIndexOf(".") + 1);
					
					if (!"".equals(fileName)) { // 업로드할 파일이 존재할 경우
						try {
							mFile.transferTo(new File(root + path + newFileName));
						} catch (NullPointerException e) {
							logger.error("error is : " + e.toString());
						} catch (Exception e) {
							//e.printStackTrace();
							logger.error("error is : " + e.toString());
						}
					}
				}
				m.put("img_path", path.replaceAll("\\\\", "/"));
				m.put("img_origin_name", img_origin_name);   // 원래 파일이름
				m.put("img_save_name", newFileName);  //실제 저장 파일이름
				m.put("img_desc", img_desc);  //실제 저장 파일이름
				m.put("regUid", userInfo.get("user_id"));
				
				insertParamList.add(m);
			}
			
			insertCnt = userMngService.insertSymbol(insertParamList);
		}
		//insert
		//update
		if (updateList.size() > 0) {
			
			for (Map<String, Object> m : updateList) {
				String img_idx = (String)m.get("img_idx");
				String img_type = (String)m.get("img_type"); //심볼타입을 가져오는 것.아직 db에 저장할 위치 불분명
				String img_desc = (String)m.get("img_desc");
				String img_origin_name = (String)m.get("img_origin_name");
				String uploadFile = (String)m.get("img_file");
				m.clear();
				MultipartFile mFile = multipart.getFile(uploadFile);
				
				if(null != mFile) {
					
					File dir = new File(root + path);
					if (!dir.exists() || !dir.isDirectory()) {
						dir.mkdirs();
					}
					fileName = mFile.getOriginalFilename();
					newFileName = CommonUtils.getRandomText(10, 7) + "_" + CommonUtils.convertDateFormat(new Date(), "yyyyMMddHHmmssSSS") + "." + fileName.substring(fileName.lastIndexOf(".") + 1);
					
					if (!"".equals(fileName)) { // 업로드할 파일이 존재할 경우
						try {
							mFile.transferTo(new File(root + path + newFileName));
						} catch (NullPointerException e) {
							logger.error("error is : " + e.toString());
						} catch (Exception e) {
							//e.printStackTrace();
							logger.error("error is : " + e.toString());
						}
					}
					m.put("img_path", path.replaceAll("\\\\", "/"));
					m.put("img_save_name", newFileName);  //실제 저장 파일이름
				} else {
					m.put("img_path", null);
					m.put("img_save_name", null);  //실제 저장 파일이름
				}
				m.put("img_idx", img_idx);
				m.put("img_origin_name", img_origin_name);   // 원래 파일이름
				m.put("img_desc", img_desc);  //실제 저장 파일이름
				m.put("modUid", userInfo.get("user_id"));
				
				updateCnt += userMngService.updateSymbol(m);
			}
		}
		//update
		//delete
		if (deleteList.size() > 0) {
			deleteCnt += userMngService.deleteSymbol(deleteList);
		}
		//delete
		resultMap.put("insertCnt", insertCnt);
		resultMap.put("updateCnt", updateCnt);
		resultMap.put("deleteCnt", deleteCnt);
		resultMap.put("resultMsg", "success");
		resultMap.put("resultCode", 0);
		return resultMap;
	}
	
	// 코드 상세 가져오기
	@RequestMapping("/system/selectCodeDetail.json")
	public ResponseEntity<Map<String, Object>> selectCodeDetail(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/system/selectCodeDetail.json");

		Map<String, Object> detailMap = userMngService.selectCodeDetail(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("data", detailMap);
		return new ResponseEntity<>(resultMap, HttpStatus.OK);
	}
	// 코드 상세 가져오기
	@RequestMapping("/system/saveCodeDetail.json")
	public ResponseEntity<Map<String, Object>> saveCodeDetail(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/system/saveCodeDetail.json");
		Map<String, Object> userInfo = UserUtil.getUserInfo(request);
		param.put("modUid", userInfo.get("user_id"));
		int saveCnt = userMngService.saveCodeDetail(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultMsg", "success");
		resultMap.put("saveCnt", saveCnt);
		resultMap.put("resultCode", 0);
		return new ResponseEntity<>(resultMap, HttpStatus.OK);
	}
	// 이름만 수정ㅡㅡ > 한 row 수정하는 기능으로
	@RequestMapping("/system/updateSymbolName.json")
	public ResponseEntity<Map<String, Object>> updateSymbolName(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/system/updateSymbolName.json");
		Map<String, Object> userInfo = UserUtil.getUserInfo(request);
		param.put("modUid", userInfo.get("user_id"));
		
		for( Map.Entry<String, Object> elem : param.entrySet() ){
			Map<String, Object> temp = new HashMap<String, Object>();
			temp.put("img_idx", elem.getKey().toString());
			temp.put("img_origin_name", elem.getValue().toString());
			userMngService.updateSymbolName(temp);
		}
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		return new ResponseEntity<>(resultMap, HttpStatus.OK);
	}
	
	/////////////////////////임시영역//////////////////////////////
}
