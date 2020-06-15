package kr.co.esp.energy.service;

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
public interface DrResultService {

	List<Map<String, Object>> getDRResultList(Map<String, Object> param) throws Exception;

	Map<String, Object> getCbl(Map<String, Object> param) throws Exception;
	
}
