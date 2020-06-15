package kr.co.ewp.ewpsp.service;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

public interface PVRevenueService {

    Map getPVRevenueList(HashMap param, HttpServletRequest request) throws Exception;

}
