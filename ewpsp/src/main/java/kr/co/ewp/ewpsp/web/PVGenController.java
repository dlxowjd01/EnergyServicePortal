/**
 * class name : PVGenController
 * description : PV 발전량 조회 화면 controller
 * version : 1.0
 * author : 이우람
 */

package kr.co.ewp.ewpsp.web;

import kr.co.ewp.ewpsp.common.energy.PeriodDataSetting;
import kr.co.ewp.ewpsp.service.PVGenService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class PVGenController {

    private static final Logger logger = LoggerFactory.getLogger(PVGenController.class);

    @Resource(name = "pvGenService")
    private PVGenService pvGenService;

    @RequestMapping("/pvGen")
    public String main() {
        logger.debug("/pvGen");
        return "ewp/energy/pvGen";
    }

    @RequestMapping("/getPVGenRealList")
    public @ResponseBody
    Map<String, Object> getPVGenRealList(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
        logger.debug("/getPVGenRealList");
        logger.debug("param ::::: " + param.toString());

        param = PeriodDataSetting.setSearchTerm(param);

        Map list = pvGenService.getPVGenRealList(param, request);

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("sheetList", list.get("sheetList"));
        resultMap.put("chartList", list.get("chartList"));
        return resultMap;
    }

    @RequestMapping("/getPVGenFutureList")
    public @ResponseBody
    Map<String, Object> getPVGenFutureList(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
        logger.debug("/getPVGenFutureList");
        logger.debug("param ::::: " + param.toString());

        param = PeriodDataSetting.setSearchTerm(param);

        Map list = pvGenService.getPVGenFutureList(param, request);

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("sheetList", list.get("sheetList"));
        resultMap.put("chartList", list.get("chartList"));
        return resultMap;
    }

    @PostMapping("/getPVGenRealListForToday")
    public @ResponseBody
    Integer getPVGenRealListForToday(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
        logger.debug("/getPVGenRealListForToday");

        Integer result = pvGenService.getPVGenRealListForToday(param, request);

        logger.debug("/getPVGenRealListForToday::{}", result);
        return result;
    }

    @PostMapping("/getPVGenRealListForLastMonth")
    public @ResponseBody
    Integer getPVGenRealListForLastMonth(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
        logger.debug("/getPVGenRealListForLastMonth");

        Integer result = pvGenService.getPVGenRealListForLastMonth(param, request);

        logger.debug("/getPVGenRealListForLastMonth::{}", result);
        return result;
    }

    @PostMapping("/getPVGenRealListForThisMonth")
    public @ResponseBody
    Integer getPVGenRealListForThisMonth(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
        logger.debug("/getPVGenRealListForThisMonth");

        Integer result = pvGenService.getPVGenRealListForThisMonth(param, request);

        logger.debug("/getPVGenRealListForThisMonth::{}", result);
        return result;
    }

    @PostMapping("/getPVGenRealListForThisMonthDaily")
    public @ResponseBody
    List getPVGenRealListForThisMonthDaily(@RequestParam Map param, HttpServletRequest request) throws Exception {
        logger.debug("/getPVGenRealListForThisMonthDaily");
        HashMap params = new HashMap();
        params.put("siteId", param.get("siteId"));
        List result = pvGenService.getPVGenRealListForThisMonthDaily(params, request);
        logger.debug("/getPVGenRealListForThisMonthDaily:: {}", result);
        return result;
    }

    @PostMapping("/getPVGenRealListForLastYear")
    public @ResponseBody
    Integer getPVGenRealListForLastYear(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
        logger.debug("/getPVGenRealListForLastYear");

        Integer result = pvGenService.getPVGenRealListForLastYear(param, request);

        logger.debug("/getPVGenRealListForLastYear::{}", result);
        return result;
    }

    @PostMapping("/getPVGenRealListForThisYear")
    public @ResponseBody
    Integer getPVGenRealListForThisYear(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
        logger.debug("/getPVGenRealListForThisYear");

        Integer result = pvGenService.getPVGenRealListForThisYear(param, request);

        logger.debug("/getPVGenRealListForThisYear::{}", result);
        return result;
    }

    @PostMapping("/getPVGenRealListForThisYearMonthly")
    public @ResponseBody
    List getPVGenRealListForThisYearMonthly(@RequestParam Map param, HttpServletRequest request) throws Exception {
        logger.debug("/getPVGenRealListForThisYearMonthly");
        HashMap params = new HashMap();
        params.put("siteId", param.get("siteId"));
        List result = pvGenService.getPVGenRealListForThisYearMonthly(params, request);
        logger.debug("/getPVGenRealListForThisYearMonthly:: {}", result);
        return result;
    }

    @PostMapping("/getPVGenRealLatestListOfDevices")
    public @ResponseBody
    List getPVGenRealLatestListOfDevices(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
        logger.debug("/getPVGenRealLatestListOfDevices");
        List result = pvGenService.getPVGenRealLatestListOfDevices(param, request);
        logger.debug("/getPVGenRealLatestListOfDevices::{}", result);
        return result;
    }
}
