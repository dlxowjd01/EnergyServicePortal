package egovframework.com.cmm.service.impl;

import kr.co.esp.common.util.UserUtil;
import kr.co.esp.login.service.LoginService;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.Map;

@Component
public class CustomAuthenticationProvider implements AuthenticationProvider {

	@Autowired
	LoginService loginService;

	@Override
	public Authentication authenticate(Authentication authentication) throws AuthenticationException {
		String name = authentication.getName();
		String password = authentication.getCredentials().toString();

		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		HttpSession session = request.getSession();
		String oid = "encroed", mode = "test";

		try  {
			Map<String, Object> oidMap = loginService.selectOid(request.getServerName());
			if (oidMap != null && !oidMap.isEmpty()) {
				oid = (String) oidMap.get("oid");
				mode = (String) oidMap.get("mode");
			}
		} catch (Exception e) {
			e.printStackTrace();
			oid = "encroed";
			mode = "test";
		}

		try {
			JSONObject obj = new JSONObject();
			obj.put("oid", oid);
			obj.put("login_id", name);
			obj.put("password", password);

			Map<String, Object> userInfoMap = loginService.selectAuthLogin(mode, obj);
			if (userInfoMap != null && !userInfoMap.isEmpty()) {
				session.setAttribute(UserUtil.USER_SESSION_ID, userInfoMap);
				session.setAttribute("mode", mode); //운영 / 스테이징 구분

				return new UsernamePasswordAuthenticationToken(name, password, new ArrayList<>());
			} else {
				return null;
			}
		} catch (JSONException e) {
			e.printStackTrace();
			return null;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	@Override
	public boolean supports(Class<?> authentication) {
		return true;
	}
}
