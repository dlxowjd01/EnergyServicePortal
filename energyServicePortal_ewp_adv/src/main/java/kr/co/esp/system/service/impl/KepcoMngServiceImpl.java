package kr.co.esp.system.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import kr.co.esp.system.service.KepcoMngService;

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
@Service("kepcoMngService")
public class KepcoMngServiceImpl extends EgovAbstractServiceImpl implements KepcoMngService {

	@Resource(name="kepcoMngMapper")
	private KepcoMngMapper kepcoMngMapper;
	
	@Override
	public Map<String, Object> getSiteSetDetail(Map<String, Object> param) throws Exception {
		return kepcoMngMapper.getSiteSetDetail(param);
	}
	
	@Override
	public List<Map<String, Object>> getPlanType(Map<String, Object> param) throws Exception {
		return kepcoMngMapper.getPlanType(param);
	}
	
	@Override
	public Map<String, Object> getPlanTypeVal(Map<String, Object> param) throws Exception {
		return kepcoMngMapper.getPlanTypeVal(param);
	}
	
	@Override
	public int updateSiteSet(Map<String, Object> param) throws Exception {
		if (param.get("essBattery") != null)
			param.put("essBattery", (Float.parseFloat((String) param.get("essBattery"))) * 1000); // ess배터리 kWh -> Wh
		if (param.get("essPcs") != null)
			param.put("essPcs", (Float.parseFloat((String) param.get("essPcs"))) * 1000); // ess PCS kW -> W
		if (param.get("contractPower") != null)
			param.put("contractPower", (Float.parseFloat((String) param.get("contractPower"))) * 1000); // 계약전력 kWh -> Wh
		if (param.get("chargePower") != null)
			param.put("chargePower", (Float.parseFloat((String) param.get("chargePower"))) * 1000); // 요금적용전력 kWh -> Wh
		if (param.get("reduceAmt") != null)
			param.put("reduceAmt", (Float.parseFloat((String) param.get("reduceAmt"))) * 1000); // 감축용량 kW -> W
		return kepcoMngMapper.updateSiteSet(param);
	}
	
}
