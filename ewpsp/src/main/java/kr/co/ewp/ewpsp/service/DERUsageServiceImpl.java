package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;

import kr.co.ewp.ewpsp.common.energy.PeriodDataSetting;
import kr.co.ewp.ewpsp.dao.DERUsageDao;

@Service("derUsageService")
public class DERUsageServiceImpl implements DERUsageService {

	@Resource(name="derUsageDao")
	private DERUsageDao derUsageDao;

	public Map getESSUsageList(HashMap param, HttpServletRequest request) throws Exception {
		List list = derUsageDao.getESSUsageList(param);
		Map<String, Object> resultMap = new HashMap<String, Object>();
		if(list == null || list.size() == 0) {
			resultMap.put("sheetList", null);
			resultMap.put("chartList", null);
			
			return resultMap;
		} else {
			resultMap = PeriodDataSetting.dataSetting(request, param, list, "std_date", "usg_val", 1);
			return resultMap;
		}
	}
	
}
