package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.ewp.ewpsp.dao.KepcoMngSetDao;

@Service("kepcoMngSetService")
public class KepcoMngSetServiceImpl implements KepcoMngSetService {

	@Resource(name="kepcoMngSetDao")
	private KepcoMngSetDao kepcoMngSetDao;

	public Map getSiteSetDetail(HashMap param) throws Exception {
		return kepcoMngSetDao.getSiteSetDetail(param);
	}

	public List getPlanType(HashMap param) throws Exception {
		return kepcoMngSetDao.getPlanType(param);
	}
	
	public Map getPlanTypeVal(HashMap param) throws Exception {
		return kepcoMngSetDao.getPlanTypeVal(param);
	}
	
	@Transactional
	public int updateSiteSet(HashMap param) throws Exception {
		if(param.get("essBattery") != null) param.put("essBattery", ( Float.parseFloat((String)param.get("essBattery")) )*1000); // ess배터리 kWh -> Wh
		if(param.get("essPcs") != null) param.put("essPcs", ( Float.parseFloat((String)param.get("essPcs")) )*1000); // ess PCS kW -> W
		if(param.get("contractPower") != null) param.put("contractPower", ( Float.parseFloat((String)param.get("contractPower")) )*1000); // 계약전력 kWh -> Wh
		if(param.get("chargePower") != null) param.put("chargePower", ( Float.parseFloat((String)param.get("chargePower")) )*1000); // 요금적용전력 kWh -> Wh
		if(param.get("reduceAmt") != null) param.put("reduceAmt", ( Float.parseFloat((String)param.get("reduceAmt")) )*1000); // 감축용량 kW -> W
		return kepcoMngSetDao.updateSiteSet(param);
	}
	
}
