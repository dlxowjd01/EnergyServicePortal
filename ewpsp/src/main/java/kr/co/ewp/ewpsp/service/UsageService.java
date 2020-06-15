package kr.co.ewp.ewpsp.service;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

public interface UsageService {

    Map getUsageRealList(HashMap param, HttpServletRequest request) throws Exception;

    Map getUsageFutureList(HashMap param, HttpServletRequest request) throws Exception;

}
