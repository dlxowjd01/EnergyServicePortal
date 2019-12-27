/**
 * class name : PvMainController
 * description : PV메인 화면 controller
 * version : 1.0
 * author : 한유덕
 */

package kr.co.ewp.ewpsp.web;

import kr.co.ewp.ewpsp.common.energy.PeriodDataSetting;
import kr.co.ewp.ewpsp.common.util.CommonUtils;
import kr.co.ewp.ewpsp.common.util.EnertalkApiUtil;
import kr.co.ewp.ewpsp.common.util.PMGrowApiUtil;
import kr.co.ewp.ewpsp.common.util.PMGrowApiUtilBefore;
import kr.co.ewp.ewpsp.model.*;
import kr.co.ewp.ewpsp.service.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
public class PVMainController {

    private static final Logger logger = LoggerFactory.getLogger(PVMainController.class);

    @Resource(name = "controlService")
    private ControlService controlService;

    @Resource(name = "essChargeService")
    private ESSChargeService essChargeService;

    @Resource(name = "essRevenueService")
    private ESSRevenueService essRevenueService;

    @Resource(name = "pvRevenueService")
    private PVRevenueService pvRevenueService;

    @Resource(name = "drRevenueService")
    private DRRevenueService drRevenueService;

    @Resource(name = "deviceMonitoringService")
    private DeviceMonitoringService deviceMonitoringService;

    @Resource(name = "SMPService")
    private SMPService SMPService;

    @Autowired
    private AlarmService alarmService;

    @GetMapping("/pvMain")
    public String pvMain(@RequestParam HashMap param, HttpSession session, Model model) {
        logger.debug("/pvMain + {}", param.get("siteId"));
        return "ewp/main/pvMain";
    }

    @GetMapping("/pvMain_nodata")
    public String pvMain_nodata(@RequestParam HashMap param, HttpSession session, Model model) {
        logger.debug("/pvMain_nodata + {}", param.get("siteId"));
        return "ewp/main/pvMain_nodata";
    }

    @PostMapping("/getFixedSMPMarketPrice")
    public @ResponseBody
    Map[] getFixedSMPMarketPrice(HttpServletRequest request) throws Exception {
        logger.debug("/getFixedSMPMarketPriceList");

        HashMap mainland = new HashMap();
        HashMap jeju = new HashMap();

        mainland.put("market_id", "KPX_SMP");
        jeju.put("market_id", "KPX_SMP_JEJU");

        Map mainlandList = SMPService.getFixedSMPMarketPrice(mainland, request);
        Map jejuList = SMPService.getFixedSMPMarketPrice(jeju, request);

        Map[] result = new Map[]{mainlandList, jejuList};

        logger.debug("/getFixedSMPMarketPriceListResult::+{}", (Object) result);
        return result;
    }


}
