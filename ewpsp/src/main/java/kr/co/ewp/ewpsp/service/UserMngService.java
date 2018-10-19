package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface UserMngService {
	
	List getUserList(HashMap param) throws Exception;

	int getUserListCnt(HashMap param) throws Exception;

	Map getUserDetail(HashMap param) throws Exception;
	
	Map getLastUserDetail(HashMap param) throws Exception;
	
	int insertUser(HashMap param) throws Exception;
	
	int updateUser(HashMap param) throws Exception;
	
	int deleteUser(HashMap param) throws Exception;

}
