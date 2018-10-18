package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.co.ewp.ewpsp.common.energy.CommonEnergyFn;
import kr.co.ewp.ewpsp.common.energy.PeriodDataSetting;
import kr.co.ewp.ewpsp.dao.PVGenDao;

@Service("pvGenService")
public class PVGenServiceImpl implements PVGenService {

	@Resource(name="pvGenDao")
	private PVGenDao pvGenDao;

	public Map getPVGenRealList(HashMap param) throws Exception {
		List list = pvGenDao.getPVGenRealList(param);
		Map<String, Object> resultMap = new HashMap<String, Object>();
		if(list == null || list.size() == 0) {
			return resultMap;
		} else {
			resultMap = PeriodDataSetting.dataSetting(param, list, "std_date", "gen_val", 1);
			return resultMap;
		}
	}

	public Map getPVGenFutureList(HashMap param) throws Exception {
		List list = pvGenDao.getPVGenFutureList(param);
		Map<String, Object> resultMap = new HashMap<String, Object>();
		if(list == null || list.size() == 0) {
			return resultMap;
		} else {
			resultMap = PeriodDataSetting.dataSetting(param, list, "std_date", "gen_val", 1);
			return resultMap;
		}
	}
	
	
	
}
