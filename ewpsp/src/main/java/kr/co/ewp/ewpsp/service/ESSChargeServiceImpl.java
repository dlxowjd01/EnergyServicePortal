package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.co.ewp.ewpsp.common.energy.CommonEnergyFn;
import kr.co.ewp.ewpsp.dao.ESSChargeDao;

@Service("essChargeService")
public class ESSChargeServiceImpl implements ESSChargeService {

	@Resource(name="essChargeDao")
	private ESSChargeDao essChargeDao;

	public Map getESSChargeSum(HashMap param) throws Exception {
		param.put("substringIdx", "dd");
		Map todaySum = essChargeDao.getESSChargeSum(param);
		param.put("substringIdx", "MM");
		Map monthSum = essChargeDao.getESSChargeSum(param);
		param.put("substringIdx", "yyyy");
		Map yearSum = essChargeDao.getESSChargeSum(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("todaySum", todaySum);
		resultMap.put("monthSum", monthSum);
		resultMap.put("yearSum", yearSum);
		
		return resultMap;
		
	}

	public Map getESSChargeRealList(HashMap param) throws Exception {
		List list = essChargeDao.getESSChargeRealList(param);
		Map<String, Object> resultMap = new HashMap<String, Object>();
		if(list == null || list.size() == 0) {
			resultMap.put("chgList", null);
			resultMap.put("dischgList", null);
			
			return resultMap;
		} else {
			List chgList = CommonEnergyFn.periodSet(param, list, "std_timestamp", "chg_val", 1);
			List dischgList = CommonEnergyFn.periodSet(param, list, "std_timestamp", "dischg_val", 1);
			
			resultMap.put("chgList", chgList);
			resultMap.put("dischgList", dischgList);
			
			return resultMap;
		}
	}

	public Map getESSChargeFutureList(HashMap param) throws Exception {
		List list = essChargeDao.getESSChargeFutureList(param);
		Map<String, Object> resultMap = new HashMap<String, Object>();
		if(list == null || list.size() == 0) {
			resultMap.put("chgList", null);
			resultMap.put("dischgList", null);
			
			return resultMap;
		} else {
			List chgList = CommonEnergyFn.periodSet(param, list, "std_timestamp", "chg_val", 2);
			List dischgList = CommonEnergyFn.periodSet(param, list, "std_timestamp", "dischg_val", 2);
			
			resultMap.put("chgList", chgList);
			resultMap.put("dischgList", dischgList);
			
			return resultMap;
		}
	}
	
	
	
}
