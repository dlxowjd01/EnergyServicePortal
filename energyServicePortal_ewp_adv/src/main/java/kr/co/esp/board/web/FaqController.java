package kr.co.esp.board.web;

import java.io.File;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import kr.co.esp.board.service.FaqService;
import kr.co.esp.common.util.CommonUtils;
import kr.co.esp.common.util.UserUtil;

@Controller
public class FaqController {

	private static final Logger logger = LoggerFactory.getLogger(FaqController.class);
	
	@Resource(name="faqService")
	private FaqService faqService;
	
	@RequestMapping(value = "/board/faq.do")
	public String login(Model model) throws Exception {
		System.out.println("/board/faq.do");
		List<Map<String, Object>> cateList = faqService.getFAQCateList();
        model.addAttribute("faqCateList", cateList);
		return "esp/board/faq";
	}

	/**
	 * FAQ 카테고리 목록 조회
	 *
	 * @return
	 * @author greatman
	 */
	@RequestMapping("/board/getFAQCateList.json")
	public @ResponseBody Map<String, Object> getFAQCateList() throws Exception {
		logger.debug("/board/getFAQCateList.json");

		List<Map<String, Object>> list = faqService.getFAQCateList();

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		return resultMap;
	}

	/**
	 * FAQ 목록 조회
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 * @author greatman
	 */
	@RequestMapping("/board/getFAQList.json")
	public @ResponseBody Map<String, Object> getFAQList(@RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/board/getFAQList.json");
		logger.debug("param : {}", param);

		List<Map<String, Object>> list = faqService.getFAQList(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		return resultMap;
	}

	/**
	 * FAQ 카테고리 한건 조회
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 * @author greatman
	 */
	@RequestMapping("/board/getFAQCateDetail.json")
	public @ResponseBody Map<String, Object> getFAQCateDetail(@RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/board/getFAQCateDetail.json");
		logger.debug("param : {}", param);

		Map<String, Object> result = faqService.getFAQCateDetail(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("detail", result);
		return resultMap;
	}

	/**
	 * FAQ 한건 조회
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 * @author greatman
	 */
	@RequestMapping("/board/getFAQDetail.json")
	public @ResponseBody Map<String, Object> getFAQDetail(@RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/board/getFAQDetail.json");
		logger.debug("param : {}", param);

		Map<String, Object> result = faqService.getFAQDetail(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("detail", result);
		return resultMap;
	}

	/**
	 * FAQ 카테고리 등록
	 *
	 * @param session
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/board/insertFAQCate.json")
	public @ResponseBody Map<String, Object> insertFAQCate(HttpSession session, @RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/board/insertFAQCate.json");
		logger.debug("param : {}", param);

		Map<String, Object> userInfo = UserUtil.getUserInfo(session);
		if (userInfo != null) {
			param.put("regUid", userInfo.get("user_id"));
		}

		int resultCnt = faqService.insertFAQCate(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", resultCnt);
		return resultMap;
	}

	/**
	 * FAQ 등록
	 *
	 * @param session
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/board/insertFAQ.json")
	public @ResponseBody Map<String, Object> insertFAQ(HttpSession session, @RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/board/insertFAQ.json");
		logger.debug("param : {}", param);

		Map<String, Object> userInfo = UserUtil.getUserInfo(session);
		if (userInfo != null) {
			param.put("regUid", userInfo.get("user_id"));
		}

		int resultCnt = faqService.insertFAQ(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", resultCnt);
		return resultMap;
	}

	/**
	 * FAQ 카테고리 수정
	 *
	 * @param session
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/board/updateFAQCate.json")
	public @ResponseBody Map<String, Object> updateFAQCate(HttpSession session, @RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/board/updateFAQCate.json");
		logger.debug("param : {}", param);

		Map<String, Object> userInfo = UserUtil.getUserInfo(session);
		if (userInfo != null) {
			param.put("modUid", userInfo.get("user_id"));
		}

		int resultCnt = faqService.updateFAQCate(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", resultCnt);
		return resultMap;
	}

	/**
	 * FAQ 수정
	 *
	 * @param session
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/board/updateFAQ.json")
	public @ResponseBody Map<String, Object> updateFAQ(HttpSession session, @RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/board/updateFAQ.json");
		logger.debug("param : {}", param);

		Map<String, Object> userInfo = UserUtil.getUserInfo(session);
		if (userInfo != null) {
			param.put("modUid", userInfo.get("user_id"));
		}

		int resultCnt = faqService.updateFAQ(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", resultCnt);
		return resultMap;
	}

	/**
	 * FAQ 카테고리 내 게시물 존재 유무 체크
	 *
	 * @param session
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/board/getFAQListCnt.json")
	public @ResponseBody Map<String, Object> getFAQListCnt(HttpSession session, @RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/board/getFAQListCnt.json");
		logger.debug("param : {}", param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", faqService.getFAQListCnt(param));

		return resultMap;
	}

	/**
	 * FAQ 카테고리 삭제
	 *
	 * @param session
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/board/deleteFAQCate.json")
	public @ResponseBody Map<String, Object> deleteFAQCate(HttpSession session, @RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/board/deleteFAQCate.json");
		logger.debug("param : {}", param);

		Map<String, Object> userInfo = UserUtil.getUserInfo(session);
		if (userInfo != null) {
			param.put("modUid", userInfo.get("user_id"));
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		param.put("cateIdx", param.get("faqCateIdx"));
		List<Map<String, Object>> list = faqService.getFAQList(param);
		if(!list.isEmpty()) {
			for (int i=0; i<list.size(); i++) {
				Map<String, Object> faqMap = new HashMap<String, Object>();
				faqMap.put("faqIdx", ((Map<String, Object>)list.get(i)).get("faq_idx"));
				faqMap.put("modUid", userInfo.get("user_id"));

				faqService.deleteFAQ(faqMap);
			}
		}

		int resultCnt = faqService.deleteFAQCate(param);
		resultMap.put("resultCnt", resultCnt);

		return resultMap;
	}

	/**
	 * FAQ 삭제
	 *
	 * @param session
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/board/deleteFAQ.json")
	public @ResponseBody Map<String, Object> deleteFAQ(HttpSession session, @RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/board/deleteFAQ.json");
		logger.debug("param : {}", param);

		Map<String, Object> userInfo = UserUtil.getUserInfo(session);
		if (userInfo != null) {
			param.put("modUid", userInfo.get("user_id"));
		}

		int resultCnt = faqService.deleteFAQ(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", resultCnt);
		return resultMap;
	}
	
	//임시
	@RequestMapping(value = "/board/refer.do")
	public String goRefer(Model model) throws Exception {
		System.out.println("/board/refer.do");
		List<Map<String, Object>> list = faqService.getReferCateList();
        model.addAttribute("referCateList", list);
		return "esp/board/refer";
	}
	@RequestMapping("/board/getReferList.json")
	public @ResponseBody Map<String, Object> getReferList(@RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/board/getReferList.json");
		logger.debug("param : {}", param);

		List<Map<String, Object>> list = faqService.getReferList(param);

		for(Map<String, Object> m : list) {
			String tempIdx = (m.get("attach_idx") == null)?"":String.valueOf(m.get("attach_idx"));
			if(!"".equals(tempIdx)) {
				param.put("attach_idx", tempIdx);
				List<Map<String, Object>> fileList = faqService.getFileList(param);
				m.put("files", fileList);
			}
		}
		 
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		return resultMap;
	}
	@RequestMapping("/board/getReferCateList.json")
	public @ResponseBody Map<String, Object> getReferCateList(@RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/board/getFAQList.json");
		logger.debug("param : {}", param);

		List<Map<String, Object>> list = faqService.getReferCateList();

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		return resultMap;
	}
	@RequestMapping("/board/insertRefer.json")
	public @ResponseBody Map<String, Object> insertRefer(@RequestParam Map<String, Object> param, MultipartHttpServletRequest multipart, HttpSession session, HttpServletRequest request) throws Exception {
		logger.debug("/board/insertRefer.json");
		logger.debug("param : {}", param);
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String resultMsg = "";
		SimpleDateFormat format1 = new SimpleDateFormat ( "yyyyMMddHHmmss");
		String attach_time = format1.format(System.currentTimeMillis());
		param.put("attachIdx", attach_time);
		Map<String, Object> userInfo = UserUtil.getUserInfo(session);
		if (userInfo != null) {
			param.put("regUid", userInfo.get("user_id"));
		}
		int resultCnt = faqService.insertRefer(param);
		if(resultCnt > 0) {
			String root = "\\eGovFrameDev-3.8.0-64bit\\workspace\\energyServicePortal_svn\\src\\main\\webapp\\resources"; //임시 경로
			String seperator = File.separator;
			String path = seperator +"img" +seperator + "upload" + seperator;
			String fileName = "";
			String newFileName = ""; // 업로드 되는 파일명
			int fileSize = 0;
			int fCnt = 1;
			
			List<MultipartFile> fileList = multipart.getFiles("referFiles");
			int totalSize = 0;
			for(MultipartFile m : fileList) { //전체용량 체크
				totalSize += (int) m.getSize();
			}
			if (totalSize > 20000000) {
				resultMap.put("resultCnt", 0);
				resultMap.put("resultMsg", "전체 파일용량(20MB)을 초과하였습니다.");
				return resultMap;
			} else {
				for(MultipartFile m : fileList) {
					fileName = m.getOriginalFilename();
					newFileName = CommonUtils.getRandomText(10, 7) + "_" + CommonUtils.convertDateFormat(new Date(), "yyyyMMddHHmmssSSS") + "." + fileName.substring(fileName.lastIndexOf(".") + 1);
					if(m != null) {
						File dir = new File(root+ path);
						if (!dir.exists() || !dir.isDirectory()) {
							dir.mkdirs();
						}
						if (!"".equals(fileName)) { // 업로드할 파일이 존재할 경우
							try {
								m.transferTo(new File(root + path + newFileName)); //파일 저장
								
								param.put("file_path", path.replaceAll("\\\\", "/"));
								param.put("file_origin_name", fileName);
								param.put("file_save_name", newFileName);
								param.put("attachIdxNo", fCnt);
								param.put("fileSize", fileSize);
								
								faqService.insertFileCnt(param);
								fCnt++;
								
							} catch (NullPointerException e) {
								logger.error("error is : " + e.toString());
								resultMap.put("resultMsg", "저장에 실패하였습니다. \\n 관리자에게 문의하세요");
							} catch (Exception e) {
								//e.printStackTrace();
								logger.error("error is : " + e.toString());
								resultMap.put("resultMsg", "저장에 실패하였습니다. \\n 관리자에게 문의하세요");
							}
						}
					}
				}
			}
		}
		
		resultMap.put("resultCnt", resultCnt);
		return resultMap;
	}
	@RequestMapping("/board/downloadFile.do")
	public void downloadFile(@RequestParam Map<String, Object> param, HttpServletRequest req, HttpServletResponse res) throws Exception {
		String save_file_name = (String)param.get("saveName");
		String origin_file_name = (String)param.get("originName");
		
		String root = "\\eGovFrameDev-3.8.0-64bit\\workspace\\energyServicePortal_svn\\src\\main\\webapp\\resources"; //임시 경로
		String seperator = File.separator;
		String path = seperator +"img" +seperator + "upload" + seperator;
		
		File file = new File(root + path + save_file_name);
		
		try {
			DownloadView fileDown = new DownloadView(); 
			fileDown.filDown(req, res, root + path, save_file_name, origin_file_name);
		} catch( Exception e) {
			e.printStackTrace();
			logger.error(e.toString());
		}
	}
	@RequestMapping("/board/insertReferCate.json")
	public @ResponseBody Map<String, Object> insertReferCate(HttpSession session, @RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/board/insertReferCate.json");
		logger.debug("param : {}", param);
		
		Map<String, Object> userInfo = UserUtil.getUserInfo(session);
		if (userInfo != null) {
			param.put("regUid", userInfo.get("user_id"));
		}
		
		int resultCnt = faqService.insertReferCate(param); // 여기서부터 시작
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", resultCnt);
		return resultMap;
	}
	@RequestMapping("/board/getReferListCnt.json")
	public @ResponseBody Map<String, Object> getReferListCnt(HttpSession session, @RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/board/getReferListCnt.json");
		logger.debug("param : {}", param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", faqService.getFAQListCnt(param));
		resultMap.put("resultCnt", faqService.getReferListCnt(param));
		
		return resultMap;
	}
	@RequestMapping("/board/deleteReferCate.json")
	public @ResponseBody Map<String, Object> deleteReferCate(HttpSession session, @RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/board/deleteReferCate.json");
		logger.debug("param : {}", param);
		
		Map<String, Object> userInfo = UserUtil.getUserInfo(session);
		if (userInfo != null) {
			param.put("modUid", userInfo.get("user_id"));
		}
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		param.put("cateIdx", param.get("referCateIdx"));
		List<Map<String, Object>> list = faqService.getReferList(param);
		if(!list.isEmpty()) {
			for (int i=0; i<list.size(); i++) {
				Map<String, Object> referMap = new HashMap<String, Object>();
				referMap.put("rfnc_idx", ((Map<String, Object>)list.get(i)).get("rfnc_idx"));
				referMap.put("modUid", userInfo.get("user_id"));
				
				int delReferCnt = faqService.deleteRefer(referMap);
				if(delReferCnt > 0) {
					faqService.deleteFiles(referMap);
				}
			}
		}
		
		int resultCnt = faqService.deleteReferCate(param);
		resultMap.put("resultCnt", resultCnt);
		
		return resultMap;
	}
	@RequestMapping("/board/getReferCateDetail.json")
	public @ResponseBody Map<String, Object> getReferCateDetail(@RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/board/getReferCateDetail.json");
		logger.debug("param : {}", param);
		
		Map<String, Object> result = faqService.getReferCateDetail(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("detail", result);
		return resultMap;
	}
	@RequestMapping("/board/updateReferCate.json")
	public @ResponseBody Map<String, Object> updateReferCate(HttpSession session, @RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/board/updateReferCate.json");
		logger.debug("param : {}", param);
		
		Map<String, Object> userInfo = UserUtil.getUserInfo(session);
		if (userInfo != null) {
			param.put("modUid", userInfo.get("user_id"));
		}
		
		int resultCnt = faqService.updateReferCate(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", resultCnt);
		return resultMap;
	}
	@RequestMapping("/board/getReferDetail.json")
	public @ResponseBody Map<String, Object> getReferDetail(@RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/board/getReferDetail.json");
		logger.debug("param : {}", param);
		
		Map<String, Object> referDetail = faqService.getReferDetail(param);
		
		param.put("attachIdx", referDetail.get("attach_idx"));
		List<Map<String, Object>> referFiles = faqService.getReferFiles(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("detail", referDetail);
		resultMap.put("files", referFiles);
		return resultMap;
	}
	@RequestMapping("/board/updateRefer.json")          
	public @ResponseBody Map<String, Object> updateRefer(@RequestParam Map<String, Object> param, MultipartHttpServletRequest multipart, HttpSession session, HttpServletRequest request) throws Exception {
		logger.debug("/board/updateRefer.json");
		logger.debug("param : {}", param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> userInfo = UserUtil.getUserInfo(session);
		if (userInfo != null) {
			param.put("modUid", userInfo.get("user_id"));
		}
		//insert
		String root = "\\eGovFrameDev-3.8.0-64bit\\workspace\\energyServicePortal_svn\\src\\main\\webapp\\resources"; //임시 경로
		String seperator = File.separator;
		String path = seperator +"img" +seperator + "upload" + seperator;
		
		List<Map<String, Object>> delList = new ArrayList<Map<String, Object>>();
		//delete
		for( Map.Entry<String, Object> elem : param.entrySet()){ //delete 항목 추출
			if(elem.getKey().toString().startsWith("del")) {
				
				Map<String,Object> tempMap = new HashMap<String, Object>();
				String delDataArr[] = ((String)elem.getValue()).split(",");
				String file_path = (delDataArr[0] != null)?delDataArr[0]:"";
				String file_save_name = (delDataArr[1] != null)?delDataArr[1]:"";
				String attachIdxNo = (delDataArr[2] != null)?delDataArr[2]:"";
				
				tempMap.put("file_path", file_path);
				tempMap.put("file_save_name", file_save_name);
				tempMap.put("attachIdxNo", attachIdxNo);
				
				delList.add(tempMap);
			}
		}
		
		for(Map<String, Object> m : delList) { //추출된 항목 delete
		
			param.put("attachIdxNo", (String)m.get("attachIdxNo")); //delIdxNo 존재 시 해당 row만 삭제
			int delCnt = faqService.deleteOneFile(param); //1. DB delete
			
			if(delCnt > 0) {

				File file = new File(root + (String)m.get("file_path") + (String)m.get("file_save_name"));
				if( file.exists() ){ //파일존재여부확인
		    		if(file.isDirectory()){ //파일이 디렉토리인지 확인
		    			//디렉토리일 경우 처리
		    			File[] files = file.listFiles();
		    			for( int i=0; i<files.length; i++){
		    				if( files[i].delete() ){
		    					logger.debug(files[i].getName()+" 삭제성공");
		    				}else{
		    					logger.debug(files[i].getName()+" 삭제실패");
		    				}
		    			}
		    		} 
		    		if(file.delete()){  //2. file delete
		    			logger.debug(file.getName() + " 삭제성공");
		    		}else{
		    			logger.debug(file.getName() + " 삭제실패");
		    		}
		    	}else{
		    		logger.debug("파일이 존재하지 않습니다.");
		    	}
			}
		}
		//update
		Map<String, Object> fileState = faqService.getReferFileState(param);
		int attachIdxNo = ((Long) fileState.get("attach_idx_no")).intValue();
		int tot_size = ((BigDecimal) fileState.get("tot_size")).intValue();
		
		int resultCnt = faqService.updateRefer(param);
		if(resultCnt > 0) {
			String fileName = "";
			String newFileName = ""; // 업로드 되는 파일명
			
			List<MultipartFile> fileList = multipart.getFiles("referFiles");
			
			for(MultipartFile m : fileList) { //전체용량 체크
				tot_size += (int) m.getSize();
			}
			if (tot_size > 20000000) { //전체 용량 초과 시 리턴
				
				resultMap.put("resultCnt", 0);
				resultMap.put("resultMsg", "전체 파일용량(20MB)을 초과하였습니다.");
				return resultMap;
				
			} else {
				for(MultipartFile m : fileList) {
					fileName = m.getOriginalFilename();
					System.out.println(fileName);
					newFileName = CommonUtils.getRandomText(10, 7) + "_" + CommonUtils.convertDateFormat(new Date(), "yyyyMMddHHmmssSSS") + "." + fileName.substring(fileName.lastIndexOf(".") + 1);
					if(m != null) {
						File dir = new File(root+ path);
						if (!dir.exists() || !dir.isDirectory()) {
							dir.mkdirs();
						}
						
						if (!"".equals(fileName)) { // 업로드할 파일이 존재할 경우
							try {
								m.transferTo(new File(root + path + newFileName)); //1. 파일 insert
								
								param.put("file_path", path.replaceAll("\\\\", "/"));
								param.put("file_origin_name", fileName);
								param.put("file_save_name", newFileName);
								param.put("attachIdxNo", attachIdxNo);
								
								faqService.insertFileCnt(param); //2. DB insert
								attachIdxNo++; //file 인덱스 증가
							} catch (NullPointerException e) {
								logger.error("error is : " + e.toString());
							} catch (Exception e) {
								//e.printStackTrace();
								logger.error("error is : " + e.toString());
							}
						}
					}
				}
			}
		}
		
		resultMap.put("resultCnt", resultCnt);
		return resultMap;
	}
	@RequestMapping("/board/deleteRefer.json")
	public @ResponseBody Map<String, Object> deleteRefer(HttpSession session, @RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/board/deleteRefer.json");
		logger.debug("param : {}", param);
		
		Map<String, Object> userInfo = UserUtil.getUserInfo(session);
		if (userInfo != null) {
			param.put("modUid", userInfo.get("user_id"));
		}
		
		int resultCnt = faqService.deleteRefer(param);
		if (resultCnt > 0) {
			faqService.deleteFiles(param);
		}
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", resultCnt);
		return resultMap;
	}
	
	
}
