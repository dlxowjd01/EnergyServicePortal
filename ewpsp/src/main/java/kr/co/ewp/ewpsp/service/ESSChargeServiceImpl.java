package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.co.ewp.ewpsp.common.energy.CommonEnergyFn;
import kr.co.ewp.ewpsp.dao.ESSChargeDao;

@Service("essChargeService")
public class ESSChargeServiceImpl implements ESSChargeService {

	@Resource(name="essChargeDao")
	private ESSChargeDao essChargeDao;

	public List getESSChargeRealList(HashMap param) throws Exception {
		List list = essChargeDao.getESSChargeRealList(param);
		if(list == null || list.size() == 0) {
			return list;
		} else {
			List resultList = CommonEnergyFn.periodSet(param, list, "std_timestamp", "charge_val", 1);
			return resultList;
		}
	}

	public List getESSChargeFutureList(HashMap param) throws Exception {
		List list = essChargeDao.getESSChargeFutureList(param);
		if(list == null || list.size() == 0) {
			return list;
		} else {
			List resultList = CommonEnergyFn.periodSet(param, list, "std_timestamp", "pre_charge_val", 2);
			return resultList;
		}
	}
	
	
	
}
