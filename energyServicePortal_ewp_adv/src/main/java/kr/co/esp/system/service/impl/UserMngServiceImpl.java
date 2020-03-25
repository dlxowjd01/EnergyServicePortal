package kr.co.esp.system.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import kr.co.esp.system.service.UserMngService;

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
@Service("userMngService")
public class UserMngServiceImpl extends EgovAbstractServiceImpl implements UserMngService {

	@Resource(name="userMngMapper")
	private UserMngMapper userMngMapper;
	
	@Override
	public List<Map<String, Object>> getUserList(Map<String, Object> param) throws Exception {
		return userMngMapper.getUserList(param);
	}	
	@Override
	public int getUserListCnt(Map<String, Object> param) throws Exception {
		return userMngMapper.getUserListCnt(param);
	}
	
	@Override
	public Map<String, Object> getUserDetail(Map<String, Object> param) throws Exception {
		return userMngMapper.getUserDetail(param);
	}
	
	@Override
	public Map<String, Object> getLastUserDetail(Map<String, Object> param) throws Exception {
		return userMngMapper.getLastUserDetail(param);
	}
	
	@Override
	public Map<String, Object> getUserIdDetail(Map<String, Object> param) throws Exception {
		return userMngMapper.getUserIdDetail(param);
	}
	
	@Override
	public int updateUser(Map<String, Object> param) throws Exception {
		return userMngMapper.updateUser(param);
	}
	
	@Override
	public int updateUserAuth(Map<String, Object> param) throws Exception {
		return userMngMapper.updateUserAuth(param);
	}
	
	@Override
	public int deleteUser(Map<String, Object> param) throws Exception {
		return userMngMapper.deleteUser(param);
	}
	
	//임시영역
	@Override
	public List<Map<String, Object>> getCmmnCodeList(Map<String, Object> param) throws Exception {
		return userMngMapper.getCmmnCodeList(param);
	}
	@Override
	public int getCmmnCodeListCnt(Map<String, Object> param) throws Exception {
		return userMngMapper.getCmmnCodeListCnt(param);
	}
	@Override
	public List<Map<String, Object>> getSymbolList(Map<String, Object> param) throws Exception {
		return userMngMapper.getSymbolList(param);
	}
	@Override
	public int insertCommonCode(Map<String, Object> param) throws Exception {
		return userMngMapper.insertCommonCode(param);
	}
	@Override
	public int insertSymbol(List<Map<String, Object>> list) throws Exception {
		return userMngMapper.insertSymbol(list);
	}
	@Override
	public int updateCommonCode(Map<String, Object> param) throws Exception {
		return userMngMapper.updateCommonCode(param);
	}
	@Override
	public int updateSymbol(Map<String, Object> param) throws Exception {
		return userMngMapper.updateSymbol(param);
	}
	@Override
	public int deleteCommonCode(List<Map<String, Object>> list) throws Exception {
		return userMngMapper.deleteCommonCode(list);
	}
	@Override
	public int deleteSymbol(List<Map<String, Object>> list) throws Exception {
		return userMngMapper.deleteSymbol(list);
	}
	@Override
	public void updateCodeName(Map<String, Object> param) throws Exception {
		userMngMapper.updateCodeName(param);
	}
	@Override
	public void updateSymbolName(Map<String, Object> param) throws Exception {
		userMngMapper.updateSymbolName(param);
	}
	@Override
	public Map<String, Object> selectCodeDetail(Map<String, Object> param) throws Exception {
		return userMngMapper.selectCodeDetail(param);
	}
	@Override
	public int saveCodeDetail(Map<String, Object> param) throws Exception {
		return userMngMapper.saveCodeDetail(param);
	}
}
