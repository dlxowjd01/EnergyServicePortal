package kr.co.ewp.ewpsp.service;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface RECService {
    Map getCurrentRECMarketPrice(HashMap param, HttpServletRequest request) throws Exception;

    Map getSiteRECIssued(HashMap param, HttpServletRequest request) throws Exception;

    Map getSiteRECBook(HashMap param, HttpServletRequest request) throws Exception;

    Integer getIssuedRECInThisMonth(HashMap param, HttpServletRequest request) throws Exception;

    List getSoldRECInThisMonth(HashMap param, HttpServletRequest request) throws Exception;

    List getSoldRECInThisDay(HashMap param, HttpServletRequest request) throws Exception;

    List getSoldRECInLastMonth(HashMap param, HttpServletRequest request) throws Exception;

    List getSoldRECInThisYear(HashMap param, HttpServletRequest request) throws Exception;

    List getSoldRECInLastYear(HashMap param, HttpServletRequest request) throws Exception;

    List getSoldRECInThisYearMonthly(HashMap param, HttpServletRequest request) throws Exception;

    List getTradingVolumeByDay(HashMap param, HttpServletRequest request) throws Exception;

    List getTransactionPriceByDay(HashMap param, HttpServletRequest request) throws Exception;
}
