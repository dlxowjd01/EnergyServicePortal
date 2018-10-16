package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.Map;

public interface LoginService {

	public Map getUserDetail(HashMap param) throws Exception;

	public Map findUserId(HashMap param) throws Exception;

	public Map findUserPw(HashMap param) throws Exception;

	public Map checkUserId(HashMap param) throws Exception;

	public int insertUser(HashMap param) throws Exception;

	public int updateUser(HashMap param) throws Exception;

	public int deleteUser(HashMap param) throws Exception;
}
