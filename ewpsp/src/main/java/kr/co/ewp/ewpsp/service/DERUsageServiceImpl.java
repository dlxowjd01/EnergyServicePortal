package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.co.ewp.ewpsp.common.energy.CommonEnergyFn;
import kr.co.ewp.ewpsp.dao.DERUsageDao;

@Service("derUsageService")
public class DERUsageServiceImpl implements DERUsageService {

	@Resource(name="derUsageDao")
	private DERUsageDao derUsageDao;

	public List getESSUsageList(HashMap param) throws Exception {
		List list = derUsageDao.getESSUsageList(param);
		if(list == null || list.size() == 0) {
			return list;
		} else {
			List resultList = CommonEnergyFn.periodSet(param, list, "std_date", "usg_val", 1);
			return resultList;
		}
	}

	public List getPVUsageList(HashMap param) throws Exception {
		List list = derUsageDao.getPVUsageList(param);
		if(list == null || list.size() == 0) {
			return list;
		} else {
			List resultList = CommonEnergyFn.periodSet(param, list, "std_timestamp", "usg_val", 1);
			return resultList;
		}
	}
	
	
	
}
