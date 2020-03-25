package kr.co.esp.login.service;

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
public interface LoginService {

	Map<String, Object> getUserDetail(Map<String, Object> param) throws Exception;
	
	Map<String, Object> getUserDetailPlain(Map<String, Object> param) throws Exception;
	
	Map<String, Object> findUserId(Map<String, Object> param) throws Exception;
	
	Map<String, Object> findUserPw(Map<String, Object> param) throws Exception;
	
	Map<String, Object> checkUserId(Map<String, Object> param) throws Exception;
	
	int insertUser(Map<String, Object> param) throws Exception;
	
	int updateUser(Map<String, Object> param) throws Exception;
	
	int updateUserPw(Map<String, Object> param) throws Exception;
	
	int deleteUser(Map<String, Object> param) throws Exception;
	
}
