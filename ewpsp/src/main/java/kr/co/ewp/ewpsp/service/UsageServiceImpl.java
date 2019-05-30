package kr.co.ewp.ewpsp.service;

import kr.co.ewp.ewpsp.common.energy.PeriodDataSetting;
import kr.co.ewp.ewpsp.common.util.CommonUtils;
import kr.co.ewp.ewpsp.dao.UsageDao;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.sql.Timestamp;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("usageService")
public class UsageServiceImpl implements UsageService {

    @Resource(name = "usageDao")
    private UsageDao usageDao;

    public Map getUsageRealList(HashMap param, HttpServletRequest request) throws Exception {
        List list = usageDao.getUsageRealList(param);
        Map<String, Object> resultMap = new HashMap<String, Object>();
        if (list == null || list.size() == 0) {
            resultMap.put("sheetList", null);
            resultMap.put("chartList", null);

            return resultMap;
        } else {
            resultMap = PeriodDataSetting.dataSetting(request, param, list, "std_timestamp", "usg_val", 1);
            return resultMap;
        }
    }

    public Map getUsageFutureList(HashMap param, HttpServletRequest request) throws Exception {
        String start = (String) param.get("selTermFrom");
        String reTimestamp = start.substring(0, 4) + "-" + start.substring(4, 6) + "-" + start.substring(6, 8) + " " + start.substring(8, 10) + ":" + start.substring(10, 12) + ":" + start.substring(12, 14);
        Timestamp tp = Timestamp.valueOf(reTimestamp);
        Calendar cal = Calendar.getInstance();
        cal.setTimeInMillis(tp.getTime());
        cal.add(Calendar.HOUR, -1);
        String startDate = CommonUtils.convertDateFormat(cal.getTime(), "yyyyMMddHHmmss");
        param.put("selTermFrom", startDate);

        List list = usageDao.getUsageFutureList(param);
        Map<String, Object> resultMap = new HashMap<String, Object>();
        if (list == null || list.size() == 0) {
            resultMap.put("sheetList", null);
            resultMap.put("chartList", null);

            return resultMap;
        } else {
            param.put("selTermFrom", start);
            resultMap = PeriodDataSetting.dataSetting(request, param, list, "std_timestamp", "pre_usg_val", 2);
            return resultMap;
        }
    }


}
