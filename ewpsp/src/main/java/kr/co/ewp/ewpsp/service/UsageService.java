package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

public interface UsageService {

	Map getUsageRealList(HashMap param, HttpServletRequest request) throws Exception;

	Map getUsageFutureList(HashMap param, HttpServletRequest request) throws Exception;

}
