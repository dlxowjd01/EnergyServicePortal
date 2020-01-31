package kr.co.ewp.ewpsp.service;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface SMPService {
    Map getFixedSMPMarketPrice(HashMap param, HttpServletRequest request) throws Exception;
}
