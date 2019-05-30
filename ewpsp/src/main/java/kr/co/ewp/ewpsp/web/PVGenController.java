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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
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
}
