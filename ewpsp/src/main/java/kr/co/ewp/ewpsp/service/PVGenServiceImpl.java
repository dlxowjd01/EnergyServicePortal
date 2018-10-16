package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.co.ewp.ewpsp.common.energy.CommonEnergyFn;
import kr.co.ewp.ewpsp.common.energy.PeriodDataSetting;
import kr.co.ewp.ewpsp.dao.PVGenDao;

@Service("pvGenService")
public class PVGenServiceImpl implements PVGenService {

	@Resource(name="pvGenDao")
	private PVGenDao pvGenDao;

	public List getPVGenRealList(HashMap param) throws Exception {
		List list = pvGenDao.getPVGenRealList(param);
		if(list == null || list.size() == 0) {
			return list;
		} else {
			List resultList = PeriodDataSetting.dataSetting(param, list, "std_date", "gen_val", 1);
			return resultList;
		}
	}

	public List getPVGenFutureList(HashMap param) throws Exception {
		List list = pvGenDao.getPVGenFutureList(param);
		if(list == null || list.size() == 0) {
			return list;
		} else {
			List resultList = PeriodDataSetting.dataSetting(param, list, "std_date", "gen_val", 1);
			return resultList;
		}
	}
	
	
	
}
