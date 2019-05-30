package kr.co.ewp.ewpsp.service;

import kr.co.ewp.ewpsp.common.energy.PeriodDataSetting;
import kr.co.ewp.ewpsp.dao.PVGenDao;
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


}
