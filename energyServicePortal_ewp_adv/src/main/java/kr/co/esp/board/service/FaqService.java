package kr.co.esp.board.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;

/**
 * @Class Name : CmmLoginService.java
 * @Description : CmmLoginService
 * @Modification Information
 * @
 * @  수정일            수정자                     수정내용
 * @ -------------   ------------   -------------------------------
 * @ 2018.09.23    MINHA          최초생성
 *
 * @author HKITS
 * @since 2018.09.23
 * @version 1.0
 * @see
 */
@Service
public interface FaqService {

	List<Map<String, Object>> getFAQCateList() throws Exception;

	List<Map<String, Object>> getFAQList(Map<String, Object> param) throws Exception;

	Map<String, Object> getFAQCateDetail(Map<String, Object> param) throws Exception;

	Map<String, Object> getFAQDetail(Map<String, Object> param) throws Exception;

	int insertFAQCate(Map<String, Object> param) throws Exception;

	int insertFAQ(Map<String, Object> param) throws Exception;

	int updateFAQCate(Map<String, Object> param) throws Exception;

	int updateFAQ(Map<String, Object> param) throws Exception;

	Object getFAQListCnt(Map<String, Object> param) throws Exception;

	int deleteFAQ(Map<String, Object> param) throws Exception;

	int deleteFAQCate(Map<String, Object> param) throws Exception;
	
	
	//임시
	List<Map<String, Object>> getReferCateList() throws Exception;
	List<Map<String, Object>> getReferList(Map<String, Object> param) throws Exception;
	List<Map<String, Object>> getFileList(Map<String, Object> param) throws Exception;
	int insertRefer(Map<String, Object> param) throws Exception;
	int insertFileCnt(Map<String, Object> param) throws Exception;
	int insertReferCate(Map<String, Object> param) throws Exception;
	int getReferListCnt(Map<String, Object> param) throws Exception;
	int deleteRefer(Map<String, Object> param) throws Exception;
	int deleteFiles(Map<String, Object> param) throws Exception;
	int deleteReferCate(Map<String, Object> param) throws Exception;
	Map<String, Object> getReferCateDetail(Map<String, Object> param) throws Exception;
	int updateReferCate(Map<String, Object> param) throws Exception;
	Map<String, Object> getReferDetail(Map<String, Object> param) throws Exception;
	List<Map<String, Object>> getReferFiles(Map<String, Object> param) throws Exception;
	int updateRefer(Map<String, Object> param) throws Exception;
	Map<String, Object> getReferFileState(Map<String, Object> param) throws Exception;
	int deleteOneFile(Map<String, Object> param) throws Exception;
}
