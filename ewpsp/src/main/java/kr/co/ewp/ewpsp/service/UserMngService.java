package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface UserMngService {
	
	List getUserList(Map<String, Object> param) throws Exception;

	int getUserListCnt(Map<String, Object> param) throws Exception;

	Map getUserDetail(Map<String, Object> param) throws Exception;
	
	Map getLastUserDetail(Map<String, Object> param) throws Exception;
	
	int insertUser(Map<String, Object> param) throws Exception;
	
	int updateUser(Map<String, Object> param) throws Exception;
	
	int deleteUser(Map<String, Object> param) throws Exception;

	int updateUserAuth(Map<String, Object> param) throws Exception;
}
