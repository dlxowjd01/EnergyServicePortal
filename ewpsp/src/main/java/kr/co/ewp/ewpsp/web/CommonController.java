/**
 * class name : UsageController
 * description : 사용자 현황 화면 controller
 * version : 1.0
 * author : 이우람
 */

package kr.co.ewp.ewpsp.web;

import kr.co.ewp.ewpsp.common.ExcelDownload;
import kr.co.ewp.ewpsp.common.util.CommonUtils;
import kr.co.ewp.ewpsp.service.DeviceMonitoringService;
import kr.co.ewp.ewpsp.service.UsageService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class CommonController {

    private static final Logger logger = LoggerFactory.getLogger(CommonController.class);

    @Resource(name = "usageService")
    private UsageService usageService;

    @Resource(name = "deviceMonitoringService")
    private DeviceMonitoringService deviceMonitoringService;

    @RequestMapping(value = "/excelDownload")
    public void excelDownload(@RequestParam Map<String, Object> param, Model model, HttpServletRequest request, HttpSession session, HttpServletResponse response) throws Exception {
        logger.debug("/excelDownload");
        logger.debug("param ::::: " + param.toString());

        String gbn = (String) param.get("gbn");
        String excelTitle = "";
        String colNm = "";

        List list = null;
        param.put("siteId", session.getAttribute("selViewSiteId"));
        if ("IOE".equals(gbn)) {
            list = deviceMonitoringService.getDeviceIOEList(param);
            excelTitle = "장치현황(IOE)_" + CommonUtils.convertDateFormat(new Date(), "yyyyMMddHHmmssSSS");
            colNm = "No.|Device Name|Device ID|Device Type|Status|Status Time";
        } else if ("PCS".equals(gbn)) {
            list = deviceMonitoringService.getDevicePCSList(param);
            excelTitle = "장치현황(PCS)_" + CommonUtils.convertDateFormat(new Date(), "yyyyMMddHHmmssSSS");
            colNm = "No.|Device Name|Device ID|Device Type|PCS Status|PCS Message|Status Time";
        } else if ("BMS".equals(gbn)) {
            list = deviceMonitoringService.getDeviceBMSList(param);
            excelTitle = "장치현황(BMS)_" + CommonUtils.convertDateFormat(new Date(), "yyyyMMddHHmmssSSS");
            colNm = "No|Device Name|Device ID|Device Type|BMS Status|BMS Message|Status Time";
        } else if ("PV".equals(gbn)) {
            list = deviceMonitoringService.getDevicePVList(param);
            excelTitle = "장치현황(PV)_" + CommonUtils.convertDateFormat(new Date(), "yyyyMMddHHmmssSSS");
            colNm = "No.|Device Name|Device ID|Device Type|PV Status|Temperature|PV Message|Status Time";
        }

        param.put("colNm", colNm);
        param.put("excelTitle", excelTitle);

        ExcelDownload ed = null;
        try {
            ed = new ExcelDownload(response, param);

            if(list != null && !list.isEmpty()) {
                for (int i = 0; i < list.size(); i++) {
                    Map<String, Object> excelMap = new HashMap<String, Object>();
                    excelMap = (Map<String, Object>) list.get(i);
                    ed.handleRow(excelMap);
                }

            }

        } catch (NullPointerException e) {
            logger.error("error1 is : " + e.toString());
        } catch (Exception e) {
            logger.error("error is : " + e.toString());
        } finally {
            if (ed != null) {
                ed.close();
            }
        }

    }

    @RequestMapping("/htmlToExcel")
    public String htmlToExcel(Model model, HttpServletRequest request) {
        logger.debug("/htmlToExcel");

        String excelHtml = request.getParameter("excelHtml");
        model.addAttribute("excelHtml", excelHtml);

        return "ewp/include/htmlToExcel";
    }

}
