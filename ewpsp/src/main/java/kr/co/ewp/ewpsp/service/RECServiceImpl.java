package kr.co.ewp.ewpsp.service;

import kr.co.ewp.ewpsp.dao.RECDao;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("RECService")
public class RECServiceImpl implements RECService {

    @Resource(name = "RECDao")
    private RECDao RECDao;

    private static final Logger logger = LoggerFactory.getLogger(RECServiceImpl.class);

    public Map getCurrentRECMarketPrice(HashMap param, HttpServletRequest request) throws Exception {
        List list = RECDao.getCurrentRECMarketPrice(param);

        logger.debug("/getCurrentRECMarketPriceServiceImpl + {}", list);

        Map resultMap = new HashMap();

        if (list == null || list.isEmpty()) {
            resultMap.put(param.get("market_id"), null);
            return resultMap;
        } else {
            resultMap.put(param.get("market_id"), list);
            return resultMap;
        }
    }

    public Map getSiteRECIssued(HashMap param, HttpServletRequest request) throws Exception {
        List list = RECDao.getSiteRECIssued(param);
        logger.debug("/getSiteIssuedServiceImpl + {}", list);
        Map resultMap = new HashMap();
        if (list == null || list.isEmpty()) {
            resultMap.put(param.get("site_id"), null);
            return resultMap;
        } else {
            resultMap.put(param.get("site_id"), list);
            return resultMap;
        }
    }

    public Map getSiteRECBook(HashMap param, HttpServletRequest request) throws Exception {
        List list = RECDao.getSiteRECBook(param);
        logger.debug("/getSiteRECBookServiceImpl + {}", list);
        Map resultMap = new HashMap();
        if (list == null || list.isEmpty()) {
            resultMap.put(param.get("site_id"), null);
            return resultMap;
        } else {
            resultMap.put(param.get("site_id"), list);
            return resultMap;
        }
    }

    public Integer getIssuedRECInThisMonth(HashMap param, HttpServletRequest request) throws Exception {
        Integer result = RECDao.getIssuedRECInThisMonth(param);
        logger.debug("/getIssuedRECInThisMonthServiceImpl + {}", result);
        if (result == null) {
            result = 0;
        }
        return result;
    }

    public List getSoldRECInThisDay(HashMap param, HttpServletRequest request) throws Exception {
        List list = RECDao.getSoldRECInThisDay(param);
        logger.debug("getSoldRECInThisDayServiceImpl + {}", list);
        if(list == null || list.isEmpty()){
            return null;
        }else {
            return list;
        }
    }

    public List getSoldRECInThisMonth(HashMap param, HttpServletRequest request) throws Exception {
        List list = RECDao.getSoldRECInThisMonth(param);
        logger.debug("/getSoldRECInThisMonthServiceImpl + {}", list);
        if(list == null || list.isEmpty()){
            return null;
        }else {
            return list;
        }
    }

    public List getSoldRECInLastMonth(HashMap param, HttpServletRequest request) throws Exception {
        List list = RECDao.getSoldRECInLastMonth(param);
        logger.debug("/getSoldRECInLastMonthServiceImpl + {}", list);
        if(list == null || list.isEmpty()){
            return null;
        }else {
            return list;
        }
    }

    public List getSoldRECInThisYear(HashMap param, HttpServletRequest request) throws Exception {
        List list = RECDao.getSoldRECInThisYear(param);
        logger.debug("/getSoldRECInThisYearServiceImpl + {}", list);
        if(list == null || list.isEmpty()){
            return null;
        }else {
            return list;
        }
    }

    public List getSoldRECInLastYear(HashMap param, HttpServletRequest request) throws Exception {
        List list = RECDao.getSoldRECInLastYear(param);
        logger.debug("/getSoldRECInLastYearServiceImpl + {}", list);
        if(list == null || list.isEmpty()){
            return null;
        }else {
            return list;
        }
    }

    public List getSoldRECInThisYearMonthly(HashMap param, HttpServletRequest request) throws Exception {
        List list = RECDao.getSoldRECInThisYearMonthly(param);
        logger.debug("/getSoldRECInThisYearMonthlyServiceImpl:: {}", list);
        if(list == null || list.isEmpty()){
            return null;
        }else {
            return list;
        }
    }

    public List getTradingVolumeByDay(HashMap param, HttpServletRequest request) throws Exception {
        List list = RECDao.getTradingVolumeByDay(param);
        logger.debug("/getTradingVolumeByDayServiceImpl + {}", list);
        if(list == null || list.isEmpty()){
            return null;
        }else {
            return list;
        }
    }

    public List getTransactionPriceByDay(HashMap param, HttpServletRequest request) throws Exception {
        List list = RECDao.getTransactionPriceByDay(param);
        logger.debug("/getTransactionPriceByDayServiceImpl + {}", list);
        if(list == null || list.isEmpty()){
            return null;
        }else {
            return list;
        }
    }

}
