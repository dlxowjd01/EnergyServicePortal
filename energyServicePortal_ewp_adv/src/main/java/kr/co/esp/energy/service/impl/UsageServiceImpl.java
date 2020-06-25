package kr.co.esp.energy.service.impl;

import java.sql.Timestamp;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import kr.co.esp.common.util.CommonUtils;
import kr.co.esp.energy.PeriodDataSetting;
import kr.co.esp.energy.service.UsageService;

/**
 * @Class Name : CmmLoginServiceImpl.java
 * @Description : CmmLoginServiceImpl Class
 * @Modification Information
 * @
 * @  수정일			수정자					 수정내용
 * @ -------------   ------------   -------------------------------
 * @ 2018.09.23	MINHA		  최초생성
 *
 * @author HKITS
 * @since 2018.09.23
 * @version 1.0
 * @see
 */
@Service("usageService")
public class UsageServiceImpl extends EgovAbstractServiceImpl implements UsageService {

	@Resource(name="usageMapper")
	private UsageMapper usageMapper;

	@Override
	public Map<String, Object> getUsageRealList(Map<String, Object> param, HttpServletRequest request)
			throws Exception {
		List<Map<String, Object>> list = usageMapper.getUsageRealList(param);
		Map<String, Object> resultMap = new HashMap<String, Object>();
		if (list == null || list.size() == 0) {
			resultMap.put("sheetList", null);
			resultMap.put("chartList", null);

			return resultMap;
		} else {
			resultMap = PeriodDataSetting.dataSetting(request, param, list, "std_timestamp", "usg_val", 1);
			return resultMap;
		}
	}

	@Override
	public Map<String, Object> getUsageFutureList(Map<String, Object> param, HttpServletRequest request)
			throws Exception {
		String start = (String) param.get("selTermFrom");
		String reTimestamp = start.substring(0, 4) + "-" + start.substring(4, 6) + "-" + start.substring(6, 8) + " " + start.substring(8, 10) + ":" + start.substring(10, 12) + ":" + start.substring(12, 14);
		Timestamp tp = Timestamp.valueOf(reTimestamp);
		Calendar cal = Calendar.getInstance();
		cal.setTimeInMillis(tp.getTime());
		cal.add(Calendar.HOUR, -1);
		String startDate = CommonUtils.convertDateFormat(cal.getTime(), "yyyyMMddHHmmss");
		param.put("selTermFrom", startDate);

		List<Map<String, Object>> list = usageMapper.getUsageFutureList(param);
		Map<String, Object> resultMap = new HashMap<String, Object>();
		if (list == null || list.size() == 0) {
			resultMap.put("sheetList", null);
			resultMap.put("chartList", null);

			return resultMap;
		} else {
			param.put("selTermFrom", start);
			resultMap = PeriodDataSetting.dataSetting(request, param, list, "std_timestamp", "pre_usg_val", 2);
			return resultMap;
		}
	}
	
}
