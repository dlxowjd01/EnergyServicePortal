package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.co.ewp.ewpsp.dao.LoginDao;

@Service("loginService")
public class LoginServiceImpl implements LoginService {

	@Resource(name="loginDao")
	private LoginDao loginDao;

	public Map getUserDetail(HashMap param) throws Exception {
		return loginDao.getUserDetail(param);
	}

	public int insertUser(HashMap param) throws Exception {
		return loginDao.insertUser(param);
	}
}
