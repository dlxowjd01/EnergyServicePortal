package kr.co.esp.system.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

/**
 * @Class Name : CmmLoginService.java
 * @Description : CmmLoginService
 * @Modification Information
 * @
 * @  수정일            수정자                     수정내용
 * @ -------------   ------------   -------------------------------
 * @ 2018.09.23    MINHA          최초생성
 *
 * @author HKITS
 * @since 2018.09.23
 * @version 1.0
 * @see
 */
@Service
public interface KepcoMngService {

	Map<String, Object> getSiteSetDetail(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> getPlanType(Map<String, Object> param) throws Exception;

	Map<String, Object> getPlanTypeVal(Map<String, Object> param) throws Exception;

	int updateSiteSet(Map<String, Object> param) throws Exception;
	
}
