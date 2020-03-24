package kr.co.esp.system.service;

import java.util.List;
import java.util.Map;

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
public interface UserMngService {

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
	int updateCommonCode(Map<String, Object> param) throws Exception;
	int updateSymbol(Map<String, Object> param) throws Exception;
	int deleteCommonCode(List<Map<String, Object>> list) throws Exception;
	int deleteSymbol(List<Map<String, Object>> list) throws Exception;
	void updateCodeName(Map<String, Object> param) throws Exception;
	void updateSymbolName(Map<String, Object> param) throws Exception;
	Map<String, Object> selectCodeDetail(Map<String, Object> param) throws Exception;
	int saveCodeDetail(Map<String, Object> param) throws Exception;
	
}
