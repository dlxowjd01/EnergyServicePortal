package kr.co.esp.energy.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import kr.co.esp.energy.PeriodDataSetting;
import kr.co.esp.energy.service.DerUsageService;

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
@Service("derUsageService")
public class DerUsageServiceImpl extends EgovAbstractServiceImpl implements DerUsageService {

	@Resource(name="derUsageMapper")
	private DerUsageMapper derUsageMapper;

	@Override
	public Map<String, Object> getESSUsageList(Map<String, Object> param, HttpServletRequest request) throws Exception {
		List<Map<String, Object>> list = derUsageMapper.getESSUsageList(param);
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
	
}
