package kr.co.ewp.ewpsp.service;

import kr.co.ewp.ewpsp.common.energy.PeriodDataSetting;
import kr.co.ewp.ewpsp.dao.DERUsageDao;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("derUsageService")
public class DERUsageServiceImpl implements DERUsageService {

    @Resource(name = "derUsageDao")
    private DERUsageDao derUsageDao;

    public Map getESSUsageList(HashMap param, HttpServletRequest request) throws Exception {
        List list = derUsageDao.getESSUsageList(param);
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

}
