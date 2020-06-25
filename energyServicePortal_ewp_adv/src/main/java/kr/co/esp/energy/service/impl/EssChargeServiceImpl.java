package kr.co.esp.energy.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import kr.co.esp.energy.PeriodDataSetting;
import kr.co.esp.energy.service.EssChargeService;

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
@Service("essChargeService")
public class EssChargeServiceImpl extends EgovAbstractServiceImpl implements EssChargeService {

	@Resource(name="essChargeMapper")
	private EssChargeMapper essChargeMapper;

	@Override
	public Map<String, Object> getESSChargeRealList(Map<String, Object> param, HttpServletRequest request)
			throws Exception {
		List<Map<String, Object>> list = essChargeMapper.getESSChargeRealList(param);
			Map<String, Object> resultMap = new HashMap<String, Object>();
			if (list == null || list.size() == 0) {
				Map<String, Object> chgMap = new HashMap<String, Object>();
				chgMap.put("sheetList", null);
				chgMap.put("chartList", null);
				Map<String, Object> dischgMap = new HashMap<String, Object>();
				dischgMap.put("sheetList", null);
				dischgMap.put("chartList", null);

				resultMap.put("chgMap", chgMap);
				resultMap.put("dischgMap", dischgMap);

				return resultMap;
			} else {
				Map<String, Object> chgMap = new HashMap<String, Object>();
				Map<String, Object> dischgMap = new HashMap<String, Object>();
				chgMap = PeriodDataSetting.dataSetting(request, param, list, "std_timestamp", "chg_val", 1);
				dischgMap = PeriodDataSetting.dataSetting(request, param, list, "std_timestamp", "dischg_val", 1);

				resultMap.put("chgMap", chgMap);
				resultMap.put("dischgMap", dischgMap);

				return resultMap;
			}
	}

	@Override
	public Map<String, Object> getESSChargeFutureList(Map<String, Object> param, HttpServletRequest request)
			throws Exception {
		List<Map<String, Object>> list = essChargeMapper.getESSChargeFutureList(param);
		Map<String, Object> resultMap = new HashMap<String, Object>();
		if (list == null || list.size() == 0) {
			Map<String, Object> chgMap = new HashMap<String, Object>();
			chgMap.put("sheetList", null);
			chgMap.put("chartList", null);
			Map<String, Object> dischgMap = new HashMap<String, Object>();
			dischgMap.put("sheetList", null);
			dischgMap.put("chartList", null);

			resultMap.put("chgMap", chgMap);
			resultMap.put("dischgMap", dischgMap);

			return resultMap;
		} else {
			Map<String, Object> chgMap = new HashMap<String, Object>();
			Map<String, Object> dischgMap = new HashMap<String, Object>();
			chgMap = PeriodDataSetting.dataSetting(request, param, list, "std_timestamp", "chg_val", 1);
			dischgMap = PeriodDataSetting.dataSetting(request, param, list, "std_timestamp", "dischg_val", 1);

			resultMap.put("chgMap", chgMap);
			resultMap.put("dischgMap", dischgMap);

			return resultMap;
		}
	}

	@Override
	public Map<String, Object> getESSChargeSum(Map<String, Object> param) throws Exception {
		param.put("substringIdx", "dd");
		Map<String, Object> todaySum = essChargeMapper.getESSChargeSum(param);
		param.put("substringIdx", "MM");
		Map<String, Object> monthSum = essChargeMapper.getESSChargeSum(param);
		param.put("substringIdx", "yyyy");
		Map<String, Object> yearSum = essChargeMapper.getESSChargeSum(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("todaySum", todaySum);
		resultMap.put("monthSum", monthSum);
		resultMap.put("yearSum", yearSum);

		return resultMap;
	}
	
}
