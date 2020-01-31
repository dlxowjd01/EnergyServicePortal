package kr.co.ewp.ewpsp.service;

import kr.co.ewp.ewpsp.common.energy.PeriodDataSetting;
import kr.co.ewp.ewpsp.dao.PVGenDao;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("pvGenService")
public class PVGenServiceImpl implements PVGenService {

    @Resource(name = "pvGenDao")
    private PVGenDao pvGenDao;

    private static final Logger logger = LoggerFactory.getLogger(PVGenServiceImpl.class);

    public Map getPVGenRealList(HashMap param, HttpServletRequest request) throws Exception {
        List list = pvGenDao.getPVGenRealList(param);
        Map<String, Object> resultMap = new HashMap<String, Object>();
        if (list == null || list.size() == 0) {
            resultMap.put("sheetList", null);
            resultMap.put("chartList", null);

            return resultMap;
        } else {
            resultMap = PeriodDataSetting.dataSetting(request, param, list, "std_date", "gen_val", 1);
            return resultMap;
        }
    }

    public Map getPVGenFutureList(HashMap param, HttpServletRequest request) throws Exception {
        List list = pvGenDao.getPVGenFutureList(param);
        Map<String, Object> resultMap = new HashMap<String, Object>();
        if (list == null || list.size() == 0) {
            resultMap.put("sheetList", null);
            resultMap.put("chartList", null);

            return resultMap;
        } else {
            resultMap = PeriodDataSetting.dataSetting(request, param, list, "std_date", "gen_val", 1);
            return resultMap;
        }
    }

    public Integer getPVGenRealListForToday(HashMap param, HttpServletRequest request) throws Exception {
        Integer result = pvGenDao.getPVGenRealListForToday(param);
        logger.debug("/getPVGenRealListForTodayServiceImpl + {}", result);
        if (result == null) {
            return 0;
        } else {
            return result;
        }
    }

    public Integer getPVGenRealListForLastMonth(HashMap param, HttpServletRequest request) throws Exception {
        Integer result = pvGenDao.getPVGenRealListForLastMonth(param);
        logger.debug("/getPVGenRealListForLastMonthServiceImpl + {}", result);
        if (result == null) {
            return 0;
        } else {
            return result;
        }
    }

    public Integer getPVGenRealListForThisMonth(HashMap param, HttpServletRequest request) throws Exception {
        Integer result = pvGenDao.getPVGenRealListForThisMonth(param);
        logger.debug("/getPVGenRealListForThisMonthServiceImpl + {}", result);
        if (result == null) {
            return 0;
        } else {
            return result;
        }
    }

    public List getPVGenRealListForThisMonthDaily(HashMap param, HttpServletRequest request) throws Exception {
        List list = pvGenDao.getPVGenRealListForThisMonthDaily(param);
        logger.debug("/getPVGenRealListForThisMonthDailyServiceImpl + {}", list);
        if (list == null || list.isEmpty()) {
            return null;
        } else {
            return list;
        }
    }

    public Integer getPVGenRealListForLastYear(HashMap param, HttpServletRequest request) throws Exception {
        Integer result = pvGenDao.getPVGenRealListForLastYear(param);
        logger.debug("/getPVGenRealListForLastYearServiceImpl + {}", result);
        if (result == null) {
            return 0;
        } else {
            return result;
        }
    }

    public Integer getPVGenRealListForThisYear(HashMap param, HttpServletRequest request) throws Exception {
        Integer result = pvGenDao.getPVGenRealListForThisYear(param);
        logger.debug("/getPVGenRealListForThisYearServiceImpl + {}", result);
        if (result == null) {
            return 0;
        } else {
            return result;
        }
    }

    public List getPVGenRealListForThisYearMonthly(HashMap param, HttpServletRequest request) throws Exception {
        List list = pvGenDao.getPVGenRealListForThisYearMonthly(param);
        logger.debug("/getPVGenRealListForThisYearMonthlyServiceImpl::{}", list);
        if (list == null || list.isEmpty()) {
            return null;
        } else {
            return list;
        }
    }

    public List getPVGenRealLatestListOfDevices(HashMap param, HttpServletRequest request) throws Exception {
        List list = pvGenDao.getPVGenRealLatestListOfDevices(param);
        if (list == null || list.isEmpty()) {
            return null;
        } else {
            return list;
        }
    }


}
