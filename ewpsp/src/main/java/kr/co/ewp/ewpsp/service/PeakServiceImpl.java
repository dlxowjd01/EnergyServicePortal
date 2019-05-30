package kr.co.ewp.ewpsp.service;

import kr.co.ewp.ewpsp.common.energy.PeriodDataSetting;
import kr.co.ewp.ewpsp.dao.PeakDao;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("peakService")
public class PeakServiceImpl implements PeakService {

    @Resource(name = "peakDao")
    private PeakDao peakDao;

    public Map getPeakRealList(HashMap param, HttpServletRequest request) throws Exception {
        List list = peakDao.getPeakRealList(param);
        Map<String, Object> resultMap = new HashMap<String, Object>();
        if (list == null || list.size() == 0) {
            resultMap.put("sheetList", null);
            resultMap.put("chartList", null);

            return resultMap;
        } else {
            request.setAttribute("energyGbn", "peak");
            resultMap = PeriodDataSetting.dataSetting(request, param, list, "std_timestamp", "peak_val", 1);
            return resultMap;
        }
    }

}
