package kr.co.esp.login.service.impl;

import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("cmmLoginMapper")
public interface LoginMapper {

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
