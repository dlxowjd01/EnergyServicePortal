package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.co.ewp.ewpsp.common.energy.CommonEnergyFn;
import kr.co.ewp.ewpsp.dao.PeakDao;

@Service("peakService")
public class PeakServiceImpl implements PeakService {

	@Resource(name="peakDao")
	private PeakDao peakDao;

	public List getPeakRealList(HashMap param) throws Exception {
		List list = peakDao.getPeakRealList(param);
		if(list == null || list.size() == 0) {
			return list;
		} else {
			List resultList = CommonEnergyFn.periodSet(param, list, "std_timestamp", "peak_val", 1);
			return resultList;
		}
	}

	public List getContractPowerList(HashMap param) throws Exception {
		List list = peakDao.getContractPowerList(param);
		if(list == null || list.size() == 0) {
			return list;
		} else {
			List resultList = CommonEnergyFn.periodSet(param, list, "std_timestamp", "peak_val", 1);
			return resultList;
		}
	}
	
	public List getChargePowerList(HashMap param) throws Exception {
		List list = peakDao.getChargePowerList(param);
		if(list == null || list.size() == 0) {
			return list;
		} else {
			List resultList = CommonEnergyFn.periodSet(param, list, "std_timestamp", "peak_val", 1);
			return resultList;
		}
	}
	
	
	
}
