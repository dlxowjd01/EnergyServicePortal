/**
 * class name : UsageController
 * description : 사용자 현황 화면 controller
 * version : 1.0
 * author : 이우람
 */

package kr.co.ewp.ewpsp.web;

import kr.co.ewp.ewpsp.common.energy.PeriodDataSetting;
import kr.co.ewp.ewpsp.service.UsageService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

@Controller
public class UsageController {

    private static final Logger logger = LoggerFactory.getLogger(UsageController.class);

    @Resource(name = "usageService")
    private UsageService usageService;

    @RequestMapping("/usage")
    public String usage(Model model) {
        logger.debug("/usage");

        return "ewp/energy/usage";
    }

    @RequestMapping("/getUsageRealList")
    public @ResponseBody
    Map<String, Object> getUsageRealList(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
        logger.debug("/getUsageRealList");
        logger.debug("     param ::::: " + param.toString());

        param = PeriodDataSetting.setSearchTerm(param);

        Map result = usageService.getUsageRealList(param, request);

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("sheetList", result.get("sheetList"));
        resultMap.put("chartList", result.get("chartList"));
        return resultMap;
    }

    @RequestMapping("/getUsageFutureList")
    public @ResponseBody
    Map<String, Object> getUsageFutureList(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
        logger.debug("/getUsageFutureList");
        logger.debug("param ::::: " + param.toString());

        param = PeriodDataSetting.setSearchTerm(param);

        Map result = usageService.getUsageFutureList(param, request);

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("sheetList", result.get("sheetList"));
        resultMap.put("chartList", result.get("chartList"));
        return resultMap;
    }

}
