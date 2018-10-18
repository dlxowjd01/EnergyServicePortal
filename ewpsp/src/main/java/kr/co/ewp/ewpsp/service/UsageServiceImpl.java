package kr.co.ewp.ewpsp.service;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.co.ewp.ewpsp.common.energy.CommonEnergyFn;
import kr.co.ewp.ewpsp.common.energy.PeriodDataSetting;
import kr.co.ewp.ewpsp.dao.UsageDao;

@Service("usageService")
public class UsageServiceImpl implements UsageService {

	@Resource(name="usageDao")
	private UsageDao usageDao;

	public Map getUsageRealList(HashMap param) throws Exception {
		List list = usageDao.getUsageRealList(param);
		Map<String, Object> resultMap = new HashMap<String, Object>();
		if(list == null || list.size() == 0) {
			return resultMap;
		} else {
			resultMap = PeriodDataSetting.dataSetting(param, list, "std_timestamp", "usg_val", 1);
			return resultMap;
		}
	}

	public Map getUsageFutureList(HashMap param) throws Exception {
		List list = usageDao.getUsageFutureList(param);
		Map<String, Object> resultMap = new HashMap<String, Object>();
		if(list == null || list.size() == 0) {
			return resultMap;
		} else {
			resultMap = PeriodDataSetting.dataSetting(param, list, "std_timestamp", "pre_usg_val", 2);
			return resultMap;
		}
	}
	
	
}
