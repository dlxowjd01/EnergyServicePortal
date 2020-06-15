package kr.co.esp.energy.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

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
public interface EssChargeService {

	Map<String, Object> getESSChargeRealList(Map<String, Object> param, HttpServletRequest request) throws Exception;

	Map<String, Object> getESSChargeFutureList(Map<String, Object> param, HttpServletRequest request) throws Exception;
	
	Map<String, Object> getESSChargeSum(Map<String, Object> param) throws Exception;
	
}
