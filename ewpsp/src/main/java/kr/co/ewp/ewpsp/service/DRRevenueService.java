package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.Map;

public interface DRRevenueService {

    Map getDRRevenueList(HashMap param) throws Exception;

    Map getDRRevenueTexList(HashMap param) throws Exception;

    Map getDRRevenueChartList(HashMap param) throws Exception;

}
