package kr.co.ewp.ewpsp.service;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

public interface PeakService {

    Map getPeakRealList(HashMap param, HttpServletRequest request) throws Exception;

}
