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

	public Map findUserId(HashMap param) throws Exception {
		return loginDao.findUserId(param);
	}

	public Map findUserPw(HashMap param) throws Exception {
		return loginDao.findUserPw(param);
	}

	public Map checkUserId(HashMap param) throws Exception {
		return loginDao.checkUserId(param);
	}

	public int insertUser(HashMap param) throws Exception {
		return loginDao.insertUser(param);
	}

	public int updateUser(HashMap param) throws Exception {
		return loginDao.updateUser(param);
	}

	public int updateUserPw(HashMap param) throws Exception {
		return loginDao.updateUserPw(param);
	}

	public int deleteUser(HashMap param) throws Exception {
		return loginDao.deleteUser(param);
	}
}
