package kr.co.esp.login.service.impl;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import kr.co.esp.login.service.LoginService;

/**
 * @Class Name : CmmLoginServiceImpl.java
 * @Description : CmmLoginServiceImpl Class
 * @Modification Information
 * @
 * @  수정일            수정자                     수정내용
 * @ -------------   ------------   -------------------------------
 * @ 2018.09.23    MINHA          최초생성
 *
 * @author HKITS
 * @since 2018.09.23
 * @version 1.0
 * @see
 */
@Service("cmmLoginService")
public class LoginServiceImpl extends EgovAbstractServiceImpl implements LoginService {

	@Resource(name="cmmLoginMapper")
	private LoginMapper cmmLoginMapper;
	
	@Override
	public Map<String, Object> getUserDetail(Map<String, Object> param) throws Exception {
		return cmmLoginMapper.getUserDetail(param);
	}
	
	@Override
	public Map<String, Object> getUserDetailPlain(Map<String, Object> param) throws Exception {
		return cmmLoginMapper.getUserDetailPlain(param);
	}
	
	@Override
	public Map<String, Object> findUserId(Map<String, Object> param) throws Exception {
		return cmmLoginMapper.findUserId(param);
	}
	
	@Override
	public Map<String, Object> findUserPw(Map<String, Object> param) throws Exception {
		return cmmLoginMapper.findUserPw(param);
	}
	
	@Override
	public Map<String, Object> checkUserId(Map<String, Object> param) throws Exception {
		return cmmLoginMapper.checkUserId(param);
	}
	
	@Override
	public int insertUser(Map<String, Object> param) throws Exception {
		return cmmLoginMapper.insertUser(param);
	}
	
	@Override
	public int updateUser(Map<String, Object> param) throws Exception {
		return cmmLoginMapper.updateUser(param);
	}
	
	@Override
	public int updateUserPw(Map<String, Object> param) throws Exception {
		return cmmLoginMapper.updateUserPw(param);
	}
	
	@Override
	public int deleteUser(Map<String, Object> param) throws Exception {
		return cmmLoginMapper.deleteUser(param);
	}
	
}
