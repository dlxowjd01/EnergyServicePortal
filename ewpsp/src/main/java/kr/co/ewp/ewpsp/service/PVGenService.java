package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

public interface PVGenService {

	Map getPVGenRealList(HashMap param, HttpServletRequest request) throws Exception;

	Map getPVGenFutureList(HashMap param, HttpServletRequest request) throws Exception;

}
