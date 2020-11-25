package kr.co.esp.login.service.impl;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import kr.co.esp.common.service.EgovProperties;
import kr.co.esp.common.util.RestApiUtil;
import kr.co.esp.login.service.LoginService;
import org.codehaus.jettison.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service("loginService")
public class LoginServiceImpl extends EgovAbstractServiceImpl implements LoginService {
	private static final Logger LOGGER = LoggerFactory.getLogger(LoginServiceImpl.class);

	@Resource(name="restApiUtil")
	RestApiUtil restApiUtil;

	private static final String defualtOid = EgovProperties.getProperty("default.oid");
	private static final String fixedOid = EgovProperties.getProperty("fixed.oid");

	/**
	 * 도메인 기준으로 OID와 MODE 세팅
	 *
	 * oid - 조직 아이디
	 * mode - 서버 테스트 mode
	 *
	 * @param serverName
	 * @return Map
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> selectOid(String serverName) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		try {
			if (fixedOid != null && !"".equals(fixedOid)) {
				rtnMap.put("oid", fixedOid);
				rtnMap.put("mode", "");
			} else {
				if (serverName != null && !"".equals(serverName) && !"localhost".equals(serverName)) {
					Pattern p = Pattern.compile("^(.*?)(?=\\.)");
					Matcher m = p.matcher(serverName);
					String targetHost = "";
					while (m.find()) {
						targetHost = m.group();
					}

					if (targetHost.contains("-")) {
						rtnMap.put("oid", targetHost.split("-")[0]);
					} else {
						if (targetHost.matches("^[0-9]")) {
							rtnMap.put("oid", defualtOid);
						} else {
							rtnMap.put("oid", targetHost);
						}
					}
				} else {
					rtnMap.put("oid", defualtOid);
				}
			}
		} catch (Exception e) {
			LOGGER.error("LoginService - selectOid - Exception : " + e.getMessage());
			rtnMap.put("oid", defualtOid);
		}
		return rtnMap;
	}

	/**
	 * API로 로그인 처리를 진행한다.
	 *
	 * @param secure
	 * @param obj
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> selectAuthLogin(boolean secure, JSONObject obj) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		try {
			Map<String, Object> tokenMap = restApiUtil.post("/auth/login", secure, obj.toString()); //토큰 발급
			if (200 == (int) tokenMap.get("code")) {
				rtnMap.putAll((Map<String, Object>) tokenMap.get("data"));

				Map<String, Object> meMap = RestApiUtil.get("/auth/me", secure,null, (String) rtnMap.get("token"));
				if(200 == (int) meMap.get("code")) {
					rtnMap.putAll((Map<String, Object>) meMap.get("data"));
				}
			}
		} catch (Exception e) {
			LOGGER.error("LoginService - selectAuthLogin - Exception : " + e.getMessage());
		}
		return rtnMap;
	}

	/**
	 * API로 로그인 처리를 진행한다.
	 *
	 * @param secure
	 * @param obj
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> selectTwoFactorAuthLogin(boolean secure, JSONObject obj) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		try {
			Map<String, Object> tokenMap = restApiUtil.post("/auth/login/2fa", secure, obj.toString()); //토큰 발급
			if (200 == (int) tokenMap.get("code")) {
				rtnMap.putAll((Map<String, Object>) tokenMap.get("data"));

				Map<String, Object> meMap = RestApiUtil.get("/auth/me", secure,null, (String) rtnMap.get("token"));
				if(200 == (int) meMap.get("code")) {
					rtnMap.putAll((Map<String, Object>) meMap.get("data"));
				}
			}
		} catch (Exception e) {
			LOGGER.error("LoginService - selectAuthLogin - Exception : " + e.getMessage());
		}
		return rtnMap;
	}
}
