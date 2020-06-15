package kr.co.ewp.ewpsp.service;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

public interface DERUsageService {

    Map getESSUsageList(HashMap param, HttpServletRequest request) throws Exception;

//	Map getPVUsageList(HashMap param) throws Exception;

}
