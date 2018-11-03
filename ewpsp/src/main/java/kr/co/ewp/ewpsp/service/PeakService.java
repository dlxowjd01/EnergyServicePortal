package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

public interface PeakService {

	Map getPeakRealList(HashMap param, HttpServletRequest request) throws Exception;

}
