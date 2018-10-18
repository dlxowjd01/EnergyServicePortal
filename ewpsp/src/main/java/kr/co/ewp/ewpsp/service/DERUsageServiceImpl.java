package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.co.ewp.ewpsp.common.energy.CommonEnergyFn;
import kr.co.ewp.ewpsp.common.energy.PeriodDataSetting;
import kr.co.ewp.ewpsp.dao.DERUsageDao;

@Service("derUsageService")
public class DERUsageServiceImpl implements DERUsageService {

	@Resource(name="derUsageDao")
	private DERUsageDao derUsageDao;

	public Map getESSUsageList(HashMap param) throws Exception {
		List list = derUsageDao.getESSUsageList(param);
		Map<String, Object> resultMap = new HashMap<String, Object>();
		if(list == null || list.size() == 0) {
			return resultMap;
		} else {
			resultMap = PeriodDataSetting.dataSetting(param, list, "std_date", "usg_val", 1);
			return resultMap;
		}
	}

//	public Map getPVUsageList(HashMap param) throws Exception {
//		List list = derUsageDao.getPVUsageList(param);
//		Map<String, Object> resultMap = new HashMap<String, Object>();
//		if(list == null || list.size() == 0) {
//			return resultMap;
//		} else {
//			resultMap = PeriodDataSetting.dataSetting(param, list, "std_timestamp", "usg_val", 1);
//			return resultMap;
//		}
//	}
	
	
	
}
