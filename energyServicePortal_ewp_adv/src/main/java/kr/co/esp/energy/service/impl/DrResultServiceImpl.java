package kr.co.esp.energy.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import kr.co.esp.energy.service.DrResultService;

/**
 * @Class Name : CmmLoginServiceImpl.java
 * @Description : CmmLoginServiceImpl Class
 * @Modification Information
 * @
 * @  수정일			수정자					 수정내용
 * @ -------------   ------------   -------------------------------
 * @ 2018.09.23	MINHA		  최초생성
 *
 * @author HKITS
 * @since 2018.09.23
 * @version 1.0
 * @see
 */
@Service("drResultService")
public class DrResultServiceImpl extends EgovAbstractServiceImpl implements DrResultService {

	@Resource(name="drResultMapper")
	private DrResultMapper drResultMapper;

	@Override
	public List<Map<String, Object>> getDRResultList(Map<String, Object> param) throws Exception {
		return drResultMapper.getDRResultList(param);
	}

	@Override
	public Map<String, Object> getCbl(Map<String, Object> param) throws Exception {
		return drResultMapper.getCbl(param);
	}
	
}
