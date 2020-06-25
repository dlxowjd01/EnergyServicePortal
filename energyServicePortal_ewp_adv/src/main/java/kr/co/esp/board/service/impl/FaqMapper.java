package kr.co.esp.board.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("faqMapper")
public interface FaqMapper {

	List<Map<String, Object>> getFAQCateList();

	List<Map<String, Object>> getFAQList(Map<String, Object> param);

	Map<String, Object> getFAQCateDetail(Map<String, Object> param);

	Map<String, Object> getFAQDetail(Map<String, Object> param);

	int insertFAQCate(Map<String, Object> param);

	int insertFAQ(Map<String, Object> param);

	int updateFAQCate(Map<String, Object> param);

	int updateFAQ(Map<String, Object> param);

	Object getFAQListCnt(Map<String, Object> param);

	int deleteFAQ(Map<String, Object> param);

	int deleteFAQCate(Map<String, Object> param);

	
	//임시
	List<Map<String, Object>> getReferCateList();
	List<Map<String, Object>> getReferList(Map<String, Object> param);
	List<Map<String, Object>> getFileList(Map<String, Object> param);
	int insertRefer(Map<String, Object> param);
	int insertFileCnt(Map<String, Object> param);
	int insertReferCate(Map<String, Object> param);
	int getReferListCnt(Map<String, Object> param);
	int deleteRefer(Map<String, Object> param);
	int deleteFiles(Map<String, Object> param);
	int deleteReferCate(Map<String, Object> param);
	Map<String, Object> getReferCateDetail(Map<String, Object> param);
	int updateReferCate(Map<String, Object> param);
	Map<String, Object> getReferDetail(Map<String, Object> param);
	List<Map<String, Object>> getReferFiles(Map<String, Object> param);
	int updateRefer(Map<String, Object> param);
	Map<String, Object> getReferFileState(Map<String, Object> param);
	int deleteOneFile(Map<String, Object> param);
}
