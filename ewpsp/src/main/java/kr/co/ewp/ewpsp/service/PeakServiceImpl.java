package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.co.ewp.ewpsp.common.energy.PeriodDataSetting;
import kr.co.ewp.ewpsp.dao.PeakDao;

@Service("peakService")
public class PeakServiceImpl implements PeakService {

	@Resource(name="peakDao")
	private PeakDao peakDao;

	public Map getPeakRealList(HashMap param) throws Exception {
		List list = peakDao.getPeakRealList(param);
		Map<String, Object> resultMap = new HashMap<String, Object>();
		if(list == null || list.size() == 0) {
			return resultMap;
		} else {
			resultMap = PeriodDataSetting.dataSetting(param, list, "std_timestamp", "peak_val", 1);
			return resultMap;
		}
	}
	
}
