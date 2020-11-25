package kr.co.esp.common.service.impl;

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
		boolean secure = request.isSecure();
		String oid = "encored";

		try  {
			Map<String, Object> oidMap = loginService.selectOid(request.getServerName());
			if (oidMap != null && !oidMap.isEmpty()) {
				oid = (String) oidMap.get("oid");
			}
		} catch (Exception e) {
			oid = "encored";
		}

		try {
			JSONObject obj = new JSONObject();
			obj.put("oid", oid);
			obj.put("login_id", name);
			obj.put("password", password);

			Map<String, Object> userInfoMap = loginService.selectAuthLogin(secure, obj);
			if (userInfoMap != null && !userInfoMap.isEmpty()) {
				session.setAttribute(UserUtil.USER_SESSION_ID, userInfoMap);

				return new UsernamePasswordAuthenticationToken(secure, password, new ArrayList<>());
			} else {
				return null;
			}
		} catch (JSONException e) {
			return null;
		} catch (Exception e) {
			return null;
		}
	}

	@Override
	public boolean supports(Class<?> authentication) {
		return true;
	}
}
