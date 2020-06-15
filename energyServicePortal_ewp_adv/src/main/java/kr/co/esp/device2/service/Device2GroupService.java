package kr.co.esp.device2.service;

import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Service;


@Service
public interface Device2GroupService {
	List<Map<String, Object>> getDevice2GroupInfo(Map<String, Object> param) throws Exception;
	
	List<Map<String, Object>> getDevice2Info(Map<String, Object> param) throws Exception;
	
	int getDevice2Chk(Map<String, Object> param) throws Exception;
	
	int insertDevice2(Map<String, Object> param) throws Exception;
}
