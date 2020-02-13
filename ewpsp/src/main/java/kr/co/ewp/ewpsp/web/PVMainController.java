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
import kr.co.ewp.ewpsp.dao.SMPDao;
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

    @Resource(name = "RECService")
    private RECService RECService;

    @Resource(name = "WeatherService")
    private WeatherService weatherService;

    @Autowired
    private AlarmService alarmService;

    @GetMapping("/pvMain")
    public String pvMain(@RequestParam Map param, HttpSession session, Model model) {
        logger.debug("/pvMain + {}", param.get("siteId"));
        return "ewp/main/pvMain";
    }

    @GetMapping("/pvMain_nodata")
    public String pvMain_nodata(@RequestParam Map param, HttpSession session, Model model) {
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

    @PostMapping("/getCurrentRECMarketPrice")
    public @ResponseBody
    Map getCurrentRECMarketPrice(HttpServletRequest request) throws Exception {
        logger.debug("/getCurrentRECMarketPrice");

        HashMap param = new HashMap();

        param.put("market_id", "KPX_REC");

        Map result = RECService.getCurrentRECMarketPrice(param, request);

        logger.debug("/getCurrentRECMarketPriceListResult::+{}", result);

        return result;
    }

    @PostMapping("/getSiteRECIssued")
    public @ResponseBody
    Map getSiteRECIssued(@RequestParam Map param, HttpServletRequest request) throws Exception {
        logger.debug("/getSiteRECIssued");

        HashMap params = new HashMap();

        params.put("site_id", param.get("siteId"));

        Map result = RECService.getSiteRECIssued(params, request);

        logger.debug("/getSiteRECIssuedListResult::+{}", result);

        return result;
    }

    @PostMapping("/getSiteRECBook")
    public @ResponseBody
    Map getSiteRECBook(@RequestParam Map param, HttpServletRequest request) throws Exception {
        logger.debug("/getSiteRECBook");

        HashMap params = new HashMap();

        params.put("site_id", param.get("siteId"));

        Map result = RECService.getSiteRECBook(params, request);

        logger.debug("/getSiteRECBookListResult::+{}", result);

        return result;
    }

    @PostMapping("/getIssuedRECInThisMonth")
    public @ResponseBody
    Integer getIssuedRECInThisMonth(@RequestParam Map param, HttpServletRequest request) throws Exception {
        logger.debug("/getIssuedRECInThisMonth");
        HashMap params = new HashMap();
        params.put("site_id", param.get("siteId"));
        Integer result = RECService.getIssuedRECInThisMonth(params, request);
        logger.debug("/getIssuedRECInThisMonthResult:: {}", result);
        return result;
    }

    @PostMapping("/getSoldRECInThisDay")
    public @ResponseBody
    List getSoldRECInThisDay(@RequestParam Map param, HttpServletRequest request) throws Exception {
        logger.debug("/getSoldRECInThisDay");
        HashMap params = new HashMap();
        params.put("site_id", param.get("siteId"));
        List result = RECService.getSoldRECInThisDay(params, request);
        logger.debug("/getSoldRECInThisDayResult:: {}", result);
        return result;
    }

    @PostMapping("/getSoldRECInThisMonth")
    public @ResponseBody
    List getSoldRECInThisMonth(@RequestParam Map param, HttpServletRequest request) throws Exception {
        logger.debug("/getSoldRECInThisMonth");
        HashMap params = new HashMap();
        params.put("site_id", param.get("siteId"));
        List result = RECService.getSoldRECInThisMonth(params, request);
        logger.debug("/getSoldRECInThisMonthResult:: {}", result);
        return result;
    }

    @PostMapping("/getSoldRECInLastMonth")
    public @ResponseBody
    List getSoldRECInLastMonth(@RequestParam Map param, HttpServletRequest request) throws Exception {
        logger.debug("/getSoldRECInLastMonth");
        HashMap params = new HashMap();
        params.put("site_id", param.get("siteId"));
        List result = RECService.getSoldRECInLastMonth(params, request);
        logger.debug("/getSoldRECInLastMonthResult:: {}", result);
        return result;
    }

    @PostMapping("/getSoldRECInThisYear")
    public @ResponseBody
    List getSoldRECInThisYear(@RequestParam Map param, HttpServletRequest request) throws Exception {
        logger.debug("/getSoldRECInThisYear");
        HashMap params = new HashMap();
        params.put("site_id", param.get("siteId"));
        List result = RECService.getSoldRECInThisYear(params, request);
        logger.debug("/getSoldRECInThisYearResult:: {}", result);
        return result;
    }

    @PostMapping("/getSoldRECInLastYear")
    public @ResponseBody
    List getSoldRECInLastYear(@RequestParam Map param, HttpServletRequest request) throws Exception {
        logger.debug("/getSoldRECInLastYear");
        HashMap params = new HashMap();
        params.put("site_id", param.get("siteId"));
        List result = RECService.getSoldRECInLastYear(params, request);
        logger.debug("/getSoldRECInLastYearResult:: {}", result);
        return result;
    }

    @PostMapping("/getSoldRECInThisYearMonthly")
    public @ResponseBody
    List getSoldRECInThisYearMonthly(@RequestParam Map param, HttpServletRequest request) throws Exception {
        logger.debug("/getSoldRECInThisYearMonthly");
        HashMap params = new HashMap();
        params.put("site_id", param.get("siteId"));
        List result = RECService.getSoldRECInThisYearMonthly(params, request);
        logger.debug("/getSoldRECInThisYearMonthlyResult:: {}", result);
        return result;
    }

    @PostMapping("/getTradingVolumeByDay")
    public @ResponseBody
    List getTradingVolumeByDay(@RequestParam Map param, HttpServletRequest request) throws Exception {
        logger.debug("/getTradingVolumeByDay");
        HashMap params = new HashMap();
        params.put("site_id", param.get("siteId"));
        List result = RECService.getTradingVolumeByDay(params, request);
        logger.debug("/getTradingVolumeByDayResult:: {}", result);
        return result;
    }

    @PostMapping("/getTransactionPriceByDay")
    public @ResponseBody
    List getTransactionPriceByDay(@RequestParam Map param, HttpServletRequest request) throws Exception {
        logger.debug("/getTransactionPriceByDay");
        HashMap params = new HashMap();
        params.put("site_id", param.get("siteId"));
        List result = RECService.getTransactionPriceByDay(params, request);
        logger.debug("/getTransactionPriceByDayResult:: {}", result);
        return result;
    }

    @RequestMapping("/getPVAlarmList")
    public @ResponseBody
    Map<String, Object> getPVAlarmList(@RequestParam HashMap param) throws Exception {
        logger.debug("/getPVAlarmList");
        logger.debug("param ::::: " + param.toString());

        param = PeriodDataSetting.setSearchTerm(param);

        Map result = controlService.getDeviceAlarmCnt(param); // 장치별 알람건수
        Map result2 = controlService.getSiteMainAlarmCnt(param); // 장치타입별 알람건수
        List alarmList = alarmService.getMainAlarmList(param); // 최근 알람 목록 조회(3건)

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("detail", result);
        resultMap.put("detail2", result2);
        resultMap.put("alarmList", alarmList);
        return resultMap;
    }

    @PostMapping("/getWeatherIconMonthly")
    public @ResponseBody
    List getWeatherIconMonthly(@RequestParam Map param, HttpServletRequest request) throws Exception {
        logger.debug("/getWeatherIconMonthly");
        HashMap params = new HashMap();
        params.put("site_id", param.get("siteId"));
        List result = weatherService.getWeatherIconMonthly(params, request);
        logger.debug("/getWeatherIconMonthly:: + {}", result);
        return result;
    }

    @PostMapping("/getSoldSMPForToday")
    public @ResponseBody
    Integer getSoldSMPForToday(@RequestParam Map param, HttpServletRequest request) throws Exception {
        logger.debug("/getSoldSMPForToday");
        HashMap params = new HashMap();
        params.put("site_id", param.get("siteId"));
        Integer result = SMPService.getSoldSMPForToday(params, request);
        logger.debug("/getSoldSMPForToday:: + {}", result);
        return result;
    }

}
