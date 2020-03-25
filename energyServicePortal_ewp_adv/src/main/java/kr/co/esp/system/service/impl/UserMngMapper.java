package kr.co.esp.system.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("userMngMapper")
public interface UserMngMapper {

	List<Map<String, Object>> getUserList(Map<String, Object> param) throws Exception;

	
	int getUserListCnt(Map<String, Object> param) throws Exception;
	
	Map<String, Object> getUserDetail(Map<String, Object> param) throws Exception;
	
	Map<String, Object> getLastUserDetail(Map<String, Object> param) throws Exception;
	
	Map<String, Object> getUserIdDetail(Map<String, Object> param) throws Exception;
	
	int updateUser(Map<String, Object> param) throws Exception;
	
	int updateUserAuth(Map<String, Object> param) throws Exception;
	
	int deleteUser(Map<String, Object> param) throws Exception;

	//임시영역
	List<Map<String, Object>> getCmmnCodeList(Map<String, Object> param) throws Exception;
	int getCmmnCodeListCnt(Map<String, Object> param) throws Exception;
	List<Map<String, Object>> getSymbolList(Map<String, Object> param) throws Exception;
	int insertCommonCode(Map<String, Object> param) throws Exception;
	int insertSymbol(List<Map<String, Object>> list) throws Exception;	
	int deleteCommonCode(List<Map<String, Object>> list) throws Exception;
	int deleteSymbol(List<Map<String, Object>> list) throws Exception;
	int updateCommonCode(Map<String, Object> param) throws Exception;
	int updateSymbol(Map<String, Object> param) throws Exception;
	void updateSymbolName(Map<String, Object> param) throws Exception;
	void updateCodeName(Map<String, Object> param) throws Exception;
	Map<String, Object> selectCodeDetail(Map<String, Object> param) throws Exception;
	int saveCodeDetail(Map<String, Object> param) throws Exception;
}
