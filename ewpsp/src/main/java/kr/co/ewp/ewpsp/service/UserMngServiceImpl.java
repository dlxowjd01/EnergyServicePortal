package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.ewp.ewpsp.dao.UserMngDao;

@Service("userMngService")
public class UserMngServiceImpl implements UserMngService {

	@Resource(name="userMngDao")
	private UserMngDao userMngDao;

	@Transactional
	public List getUserList(Map<String, Object> param) throws Exception {
		return userMngDao.getUserList(param);
	}

	public int getUserListCnt(Map<String, Object> param) throws Exception {
		return userMngDao.getUserListCnt(param);
	}

	public Map getUserDetail(Map<String, Object> param) throws Exception {
		return userMngDao.getUserDetail(param);
	}

	public Map getLastUserDetail(Map<String, Object> param) throws Exception {
		return userMngDao.getLastUserDetail(param);
	}

	@Transactional
	public int insertUser(Map<String, Object> param) throws Exception {
		return userMngDao.insertUser(param);
	}

	@Transactional
	public int updateUser(Map<String, Object> param) throws Exception {
		return userMngDao.updateUser(param);
	}
	
	@Transactional
	public int deleteUser(Map<String, Object> param) throws Exception {
		return userMngDao.deleteUser(param);
	}

	@Transactional
	public int updateUserAuth(Map<String, Object> param) throws Exception {
		return userMngDao.updateUserAuth(param);
	}
	
}
