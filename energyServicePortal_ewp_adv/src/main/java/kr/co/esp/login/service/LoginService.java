package kr.co.esp.login.service;

import org.codehaus.jettison.json.JSONObject;

import java.util.Map;

public interface LoginService {

	Map<String, Object> selectOid(String serverName) throws Exception;

	Map<String, Object> selectAuthLogin(boolean secure, JSONObject obj) throws Exception;

	Map<String, Object> selectTwoFactorAuthLogin(boolean secure, JSONObject obj) throws Exception;

}
