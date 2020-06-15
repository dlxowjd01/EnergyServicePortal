package kr.co.ewp.ewpsp.web;

import kr.co.ewp.ewpsp.common.util.PMGrowApiUtil;
import kr.co.ewp.ewpsp.common.util.PMGrowApiUtilBefore;
import kr.co.ewp.ewpsp.model.*;
import kr.co.ewp.ewpsp.service.DeviceMonitoringService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
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
public class DeviceMonitoringController {

    private static final Logger logger = LoggerFactory.getLogger(DeviceMonitoringController.class);

    @Resource(name = "deviceMonitoringService")
    private DeviceMonitoringService deviceMonitoringService;

    @RequestMapping("/deviceMonitoring")
    public String main(Model model, HttpServletRequest request) {
        logger.debug("/deviceMonitoring " + request.getParameter("deviceGbn"));

        model.addAttribute("deviceGbn", request.getParameter("deviceGbn"));

        return "ewp/device/deviceMonitoring";
    }

    @RequestMapping("/getDeviceIOEList")
    public @ResponseBody
    Map<String, Object> getDeviceIOEList(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
        logger.debug("/getDeviceIOEList");
        logger.debug("param ::::: " + param.toString());

        int selPageNum = Integer.parseInt((String) param.get("selPageNum"));
        int pageRowCnt = 5;
        int startNum = pageRowCnt * (selPageNum - 1);

        param.put("siteId", request.getSession().getAttribute("selViewSiteId"));
        param.put("startNum", startNum);
        param.put("pageRowCnt", pageRowCnt);

        List list = deviceMonitoringService.getDeviceIOEList(param);
        int listCnt = deviceMonitoringService.getDeviceIOEListCnt(param);
        int totalPageCnt = 0;
        if (listCnt > 0) {
            totalPageCnt = listCnt / pageRowCnt;
            if (listCnt % pageRowCnt > 0) {
                totalPageCnt++;
            }
        }

        Map<String, Object> pagingMap = new HashMap<String, Object>();
        pagingMap.put("pageRowCnt", pageRowCnt); // 한 페이지 당 보여줄 데이터 수
        pagingMap.put("selPageNum", selPageNum); // 선택한 페이지번호
        pagingMap.put("listCnt", listCnt); // 전체 데이터 수
        pagingMap.put("totalPageCnt", totalPageCnt); // 전체 페이지 수

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("list", list);
        resultMap.put("pagingMap", pagingMap);
        return resultMap;
    }

    @RequestMapping("/getDeviceIOEDetail")
    public @ResponseBody
    Map<String, Object> getDeviceIOEDetail(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
        logger.debug("/getDeviceIOEDetail");
        logger.debug("param ::::: " + param.toString());

        String deviceType = (String) param.get("deviceType");
        Map<String, Object> result = new HashMap<String, Object>();
        if(!"9".equals(deviceType)) {
            result = deviceMonitoringService.getDeviceIOEDetail(param);
            ApiController api = new ApiController();
            UsageRealtimeModel usageRealtime = api.getDeviceRealTime((String) param.get("deviceId"));
            Long voltage = (usageRealtime == null || usageRealtime.getVoltage() == null) ? -1 : usageRealtime.getVoltage();
            result.put("voltage", (voltage < 0 || voltage > 1000000000) ? null : voltage/ 1000);
            result.put("activePower", (usageRealtime == null) ? null : usageRealtime.getActivePower()/ (1000 * 1000));
            result.put("energy", (usageRealtime == null) ? null : (usageRealtime.getPositiveEnergy() + usageRealtime.getNegativeEnergy())/ (1000 * 1000));
            result.put("energyReactive", (usageRealtime == null) ? null : (usageRealtime.getPositiveEnergyReactive() + usageRealtime.getNegativeEnergyReactive())/ (1000 * 1000));
        } else {
        	result = deviceMonitoringService.getDeviceAMIDetail(param);
        	Map siteDetail = (Map) request.getSession().getAttribute("selViewSite");
            String host = (String) siteDetail.get("local_ems_addr");
            String apiVer = (String) siteDetail.get("local_ems_api_ver");
            AmiEquipmentModel amiModel = null;
            if ("1.1".equals(apiVer)) { // 기존
                amiModel = PMGrowApiUtilBefore.getAmiEquipmentList(host, (String) param.get("deviceId"));
            } else {
                amiModel = PMGrowApiUtil.getAmiEquipmentList(host, (String) param.get("deviceId"));
            }
            Float volR = amiModel.getVoltageR();
            Float volS = amiModel.getVoltageS();
            Float volT = amiModel.getVoltageT();
            Float curR = amiModel.getCurrentR();
            Float curS = amiModel.getCurrentS();
            Float curT = amiModel.getCurrentT();
            Float aapR = amiModel.getAccumActivePowerR();
            Float aapS = amiModel.getAccumActivePowerS();
            Float aapT = amiModel.getAccumActivePowerT();
            result.put("voltage", (amiModel == null) ? null : (Math.abs(volR-volS)+Math.abs(volS-volT)+Math.abs(volR-volT))/3);
            result.put("activePower", (amiModel == null || (amiModel != null && curR==null && curS==null && curT==null)) ? null : 1.732*((((curR==null)?0:curR)+((curS==null)?0:curS)+((curT==null)?0:curT))*380));
            result.put("energy", (amiModel == null || (amiModel != null && aapR==null && aapS==null && aapT==null)) ? null : (((aapR==null)?0:aapR)+((aapS==null)?0:aapS)+((aapT==null)?0:aapT))/1000);
            Float rctvPwrLagging = null;
            Float rctvPwrLeading = null;
            Float arpLaggingR = amiModel.getAccumReactivePowerLaggingR();
            Float arpLaggingS = amiModel.getAccumReactivePowerLaggingS();
            Float arpLaggingT = amiModel.getAccumReactivePowerLaggingT();
            Float arpLeadingR = amiModel.getAccumReactivePowerLeadingR();
            Float arpLeadingS = amiModel.getAccumReactivePowerLeadingS();
            Float arpLeadingT = amiModel.getAccumReactivePowerLeadingT();
            
            if(!(arpLaggingR == null && arpLaggingS == null && arpLaggingT == null)) {
                rctvPwrLagging = ((arpLaggingR == null) ? 0 : arpLaggingR)+((arpLaggingS == null) ? 0 : arpLaggingS)+((arpLaggingT == null) ? 0 : arpLaggingT);
            }
            if(!(arpLeadingR == null && arpLeadingS == null && arpLeadingT == null)) {
                rctvPwrLeading = ((arpLeadingR == null) ? 0 : arpLeadingR)+((arpLeadingS == null) ? 0 : arpLeadingS)+((arpLeadingT == null) ? 0 : arpLeadingT);
            }
            Float energyReactive = (rctvPwrLagging != null) ? rctvPwrLagging : rctvPwrLeading;
            result.put("energyReactive", (energyReactive == null) ? null : energyReactive/1000);
        }

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("detail", result);
        System.out.println("최종 : "+resultMap);
        return resultMap;
    }

    @RequestMapping("/getDevicePCSList")
    public @ResponseBody
    Map<String, Object> getDevicePCSList(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
        logger.debug("/getDevicePCSList");
        logger.debug("param ::::: " + param.toString());

        int selPageNum = Integer.parseInt((String) param.get("selPageNum"));
        int pageRowCnt = 5;
        int startNum = pageRowCnt * (selPageNum - 1);

        param.put("siteId", request.getSession().getAttribute("selViewSiteId"));
        param.put("startNum", startNum);
        param.put("pageRowCnt", pageRowCnt);

        List list = deviceMonitoringService.getDevicePCSList(param);
        int listCnt = deviceMonitoringService.getDevicePCSListCnt(param);
        int totalPageCnt = 0;
        if (listCnt > 0) {
            totalPageCnt = listCnt / pageRowCnt;
            if (listCnt % pageRowCnt > 0) {
                totalPageCnt++;
            }
        }

        Map<String, Object> pagingMap = new HashMap<String, Object>();
        pagingMap.put("pageRowCnt", pageRowCnt); // 한 페이지 당 보여줄 데이터 수
        pagingMap.put("selPageNum", selPageNum); // 선택한 페이지번호
        pagingMap.put("listCnt", listCnt); // 전체 데이터 수
        pagingMap.put("totalPageCnt", totalPageCnt); // 전체 페이지 수

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("list", list);
        resultMap.put("pagingMap", pagingMap);
        return resultMap;
    }

    @RequestMapping("/getDevicePCSDetail")
    public @ResponseBody
    Map<String, Object> getDevicePCSDetail(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
        logger.debug("/getDevicePCSDetail");
        logger.debug("param ::::: " + param.toString());

        Map<String, Object> result = deviceMonitoringService.getDevicePCSDetail(param);
        Map siteDetail = (Map) request.getSession().getAttribute("selViewSite");
        String host = (String) siteDetail.get("local_ems_addr");
        String apiVer = (String) siteDetail.get("local_ems_api_ver");
        if ("1.1".equals(apiVer)) { // 기존
            PcsEquipmentModelBefore pcsDetail = PMGrowApiUtilBefore.getPcsEquipmentList(host, (String) param.get("deviceId"));
            System.out.println("             pcs결과  " + pcsDetail);
            if (pcsDetail != null) {
//                for (PcsEquipmentModelBefore pcsDetail : pcsDetailList) {
                    if (pcsDetail == null) {
                        result.put("pcsStatus", null);
                        result.put("pcsStatusNm", null);
                        result.put("alarmMsg", null);
                    } else {
                        String statusNm = "";
                        if (pcsDetail.getPcsStatus() == 0) {
                            statusNm = "OFF";
                        } else if (pcsDetail.getPcsStatus() == 1) {
                            statusNm = "ON";
                        } else if (pcsDetail.getPcsStatus() == 2) {
                            statusNm = "Fault";
                        } else if (pcsDetail.getPcsStatus() == 3) {
                            statusNm = "Warning";
                        }
                        result.put("pcsStatus", pcsDetail.getPcsStatus());
                        result.put("pcsStatusNm", statusNm);
                        result.put("alarmMsg", pcsDetail.getAlarmMsg());
                    }
                    result.put("acVoltage", (pcsDetail == null || pcsDetail.getAcVoltage() == null) ? -1 : pcsDetail.getAcVoltage());
                    result.put("acPower", (pcsDetail == null || pcsDetail.getAcPower() == null) ? -1 : Math.ceil((pcsDetail.getAcPower()/1000f)*10)/10);
                    result.put("acFreq", (pcsDetail == null || pcsDetail.getAcFreq() == null) ? -1 : pcsDetail.getAcFreq());
                    result.put("acCurrent", (pcsDetail == null || pcsDetail.getAcCurrent() == null) ? -1 : pcsDetail.getAcCurrent());
                    result.put("acPf", (pcsDetail == null || pcsDetail.getAcPf() == null) ? -1 : pcsDetail.getAcPf());
                    result.put("acSetPower", (pcsDetail == null || pcsDetail.getAcSetPower() == null) ? -1 : Math.ceil((pcsDetail.getAcSetPower()/1000f)*10)/10);
                    result.put("dcVoltage", (pcsDetail == null || pcsDetail.getDcVoltage() == null) ? -1 : pcsDetail.getDcVoltage());
                    result.put("dcPower", (pcsDetail == null || pcsDetail.getDcPower() == null) ? -1 : Math.ceil((pcsDetail.getDcPower()/1000f)*10)/10);
                    result.put("dcCurrent", (pcsDetail == null || pcsDetail.getDcCurrent() == null) ? -1 : pcsDetail.getDcCurrent());
                    result.put("pcsStatus", (pcsDetail == null) ? -1 : pcsDetail.getPcsStatus());
                    if (pcsDetail == null) {
                        result.put("pcsCommand", -1);
                    } else {
                        if (pcsDetail.getPcsCommand() == 0) {
                            result.put("pcsCommand", "Stop");
                        } else {
                            result.put("pcsCommand", "Run");
                        }
                    }
                    result.put("todayCEnergy", (pcsDetail == null) ? -1 : Math.ceil((pcsDetail.getTodayCEnergy()/1000f)*10)/10);
                    result.put("todayDEnergy", (pcsDetail == null) ? -1 : Math.ceil((pcsDetail.getTodayDEnergy()/1000f)*10)/10);
//                }
            } else {
                result.put("pcsStatus", null);
                result.put("pcsStatusNm", null);
                result.put("alarmMsg", null);
                result.put("acVoltage", -1);
                result.put("acPower", -1);
                result.put("acFreq", -1);
                result.put("acCurrent", -1);
                result.put("acPf", -1);
                result.put("acSetPower", -1);
                result.put("dcVoltage", -1);
                result.put("dcPower", -1);
                result.put("dcCurrent", -1);
                result.put("pcsStatus", -1);
                result.put("pcsCommand", -1);
                result.put("todayCEnergy", -1);
                result.put("todayDEnergy", -1);
            }
        } else {
            PcsEquipmentModel pcsDetail = PMGrowApiUtil.getPcsEquipmentList(host, (String) param.get("deviceId"));
            if (pcsDetail != null) {
                String statusNm = "";
                if (pcsDetail.getPcsStatus() == 0) {
                    statusNm = "OFF";
                } else if (pcsDetail.getPcsStatus() == 1) {
                    statusNm = "ON";
                } else if (pcsDetail.getPcsStatus() == 2) {
                    statusNm = "Fault";
                } else if (pcsDetail.getPcsStatus() == 3) {
                    statusNm = "Warning";
                }
                result.put("pcsStatus", pcsDetail.getPcsStatus());
                result.put("pcsStatusNm", statusNm);
                result.put("alarmMsg", pcsDetail.getAlarmMsg());

            } else {
                result.put("pcsStatus", null);
                result.put("pcsStatusNm", null);
                result.put("alarmMsg", null);
            }
            result.put("acVoltage", (pcsDetail == null) ? -1 : pcsDetail.getAcVoltage());
            result.put("acPower", (pcsDetail == null) ? -1 : Math.ceil((pcsDetail.getAcPower()/1000f)*10)/10);
            result.put("acFreq", (pcsDetail == null) ? -1 : pcsDetail.getAcFreq());
            result.put("acCurrent", (pcsDetail == null) ? -1 : pcsDetail.getAcCurrent());
            result.put("acPf", (pcsDetail == null) ? -1 : pcsDetail.getAcPf());
            result.put("acSetPower", (pcsDetail == null) ? -1 : Math.ceil((pcsDetail.getAcSetPower()/1000f)*10)/10);
            result.put("dcVoltage", (pcsDetail == null) ? -1 : pcsDetail.getDcVoltage());
            result.put("dcPower", (pcsDetail == null) ? -1 : Math.ceil((pcsDetail.getDcPower()/1000f)*10)/10);
            result.put("dcCurrent", (pcsDetail == null) ? -1 : pcsDetail.getDcCurrent());
            result.put("pcsStatus", (pcsDetail == null) ? -1 : pcsDetail.getPcsStatus());
            if (pcsDetail == null) {
                result.put("pcsCommand", -1);
            } else {
                if (pcsDetail.getPcsCommand() == 0) {
                    result.put("pcsCommand", "Stop");
                } else {
                    result.put("pcsCommand", "Run");
                }
            }
            result.put("todayCEnergy", (pcsDetail == null) ? -1 : Math.ceil((pcsDetail.getTodayCEnergy()/1000f)*10)/10);
            result.put("todayDEnergy", (pcsDetail == null) ? -1 : Math.ceil((pcsDetail.getTodayDEnergy()/1000f)*10)/10);
        }

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("detail", result);
        return resultMap;
    }

    @RequestMapping("/getDeviceBMSList")
    public @ResponseBody
    Map<String, Object> getDeviceBMSList(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
        logger.debug("/getDeviceBMSList");
        logger.debug("param ::::: " + param.toString());

        int selPageNum = Integer.parseInt((String) param.get("selPageNum"));
        int pageRowCnt = 5;
        int startNum = pageRowCnt * (selPageNum - 1);

        param.put("siteId", request.getSession().getAttribute("selViewSiteId"));
        param.put("startNum", startNum);
        param.put("pageRowCnt", pageRowCnt);

        List list = deviceMonitoringService.getDeviceBMSList(param);
        int listCnt = deviceMonitoringService.getDeviceBMSListCnt(param);
        int totalPageCnt = 0;
        if (listCnt > 0) {
            totalPageCnt = listCnt / pageRowCnt;
            if (listCnt % pageRowCnt > 0) {
                totalPageCnt++;
            }
        }

        Map<String, Object> pagingMap = new HashMap<String, Object>();
        pagingMap.put("pageRowCnt", pageRowCnt); // 한 페이지 당 보여줄 데이터 수
        pagingMap.put("selPageNum", selPageNum); // 선택한 페이지번호
        pagingMap.put("listCnt", listCnt); // 전체 데이터 수
        pagingMap.put("totalPageCnt", totalPageCnt); // 전체 페이지 수

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("list", list);
        resultMap.put("pagingMap", pagingMap);
        return resultMap;
    }

    @RequestMapping("/getDeviceBMSDetail")
    public @ResponseBody
    Map<String, Object> getDeviceBMSDetail(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
        logger.debug("/getDeviceBMSDetail");
        logger.debug("param ::::: " + param.toString());

        Map<String, Object> result = deviceMonitoringService.getDeviceBMSDetail(param);
        Map siteDetail = (Map) request.getSession().getAttribute("selViewSite");
        String host = (String) siteDetail.get("local_ems_addr");
        String apiVer = (String) siteDetail.get("local_ems_api_ver");
        if ("1.1".equals(apiVer)) { // 기존
            BmsEquipmentModelBefore bmsDetail = PMGrowApiUtilBefore.getBmsEquipmentList(host, (String) param.get("deviceId"));
            System.out.println("             bms결과  " + bmsDetail);
            if (bmsDetail != null) {
//                for (BmsEquipmentModelBefore bmsDetail : bmsDetailList) {
                    if (bmsDetail == null) {
                        result.put("bmsStatus", null);
                        result.put("bmsStatusNm", null);
                        result.put("alarmMsg", null);
                    } else {
                        String statusNm = "";
                        if (!"".equals(bmsDetail.getSysMode()) && bmsDetail.getSysMode() != null) {
                            if (bmsDetail.getSysMode() == 0) {
                                statusNm = "Idle";
                            } else if (bmsDetail.getSysMode() == 1) {
                                statusNm = "Charge";
                            } else if (bmsDetail.getSysMode() == 2) {
                                statusNm = "Discharge";
                            } else if (bmsDetail.getSysMode() == 3) {
                                statusNm = "MainS/W on/off";
                            } else if (bmsDetail.getSysMode() == 4) {
                                statusNm = "Off-line";
                            } else if (bmsDetail.getSysMode() == 5) {
                                statusNm = "Ready";
                            }
                        }
                        result.put("bmsStatus", bmsDetail.getSysMode());
                        result.put("bmsStatusNm", statusNm);
                        result.put("alarmMsg", ""/*bmsDetail.getAlarmMsg()*/);
                    }
                    result.put("sysSoc", (bmsDetail == null || bmsDetail.getSysSoc() == null) ? -1 : bmsDetail.getSysSoc());
                    result.put("sysSoh", (bmsDetail == null || bmsDetail.getSysSoh() == null) ? -1 : bmsDetail.getSysSoh());
                    result.put("currSoc", (bmsDetail == null || bmsDetail.getCurrSoc() == null) ? -1 : Math.ceil((bmsDetail.getCurrSoc()/1000f)*10)/10);
                    result.put("sysVoltage", (bmsDetail == null || bmsDetail.getSysVoltage() == null) ? -1 : bmsDetail.getSysVoltage());
                    result.put("sysCurrent", (bmsDetail == null || bmsDetail.getSysCurrent() == null) ? -1 : bmsDetail.getSysCurrent());
                    result.put("dod", (bmsDetail == null || bmsDetail.getDod() == null) ? -1 : bmsDetail.getDod());
//                }
            } else {
                result.put("bmsStatus", null);
                result.put("bmsStatusNm", null);
                result.put("alarmMsg", null);
                result.put("sysSoc", -1);
                result.put("sysSoh", -1);
                result.put("currSoc", -1);
                result.put("sysVoltage", -1);
                result.put("sysCurrent", -1);
                result.put("dod", -1);
            }
        } else {
            BmsEquipmentModel bmsDetail = PMGrowApiUtil.getBmsEquipmentList(host, (String) param.get("deviceId"));
            System.out.println("bmsDetail api 결과  " + bmsDetail.toString());
            if (bmsDetail != null) {
                String statusNm = "";
                if (bmsDetail.getSysMode() == 0) {
                    statusNm = "Idle";
                } else if (bmsDetail.getSysMode() == 1) {
                    statusNm = "Charge";
                } else if (bmsDetail.getSysMode() == 2) {
                    statusNm = "Discharge";
                } else if (bmsDetail.getSysMode() == 3) {
                    statusNm = "MainS/W on/off";
                } else if (bmsDetail.getSysMode() == 4) {
                    statusNm = "Off-line";
                } else if (bmsDetail.getSysMode() == 5) {
                    statusNm = "Ready";
                }
                result.put("bmsStatus", bmsDetail.getSysMode());
                result.put("bmsStatusNm", statusNm);
                result.put("alarmMsg", bmsDetail.getAlarmMsg());

            } else {
                result.put("bmsStatus", null);
                result.put("bmsStatusNm", null);
                result.put("alarmMsg", null);
            }
            result.put("sysSoc", (bmsDetail == null) ? -1 : bmsDetail.getSysSoc());
            result.put("sysSoh", (bmsDetail == null) ? -1 : bmsDetail.getSysSoh());
            result.put("currSoc", (bmsDetail == null) ? -1 : Math.ceil((bmsDetail.getCurrSoc()/1000f)*10)/10);
            result.put("sysVoltage", (bmsDetail == null) ? -1 : bmsDetail.getSysVoltage());
            result.put("sysCurrent", (bmsDetail == null) ? -1 : bmsDetail.getSysCurrent());
            result.put("dod", (bmsDetail == null) ? -1 : bmsDetail.getDod());
        }

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("detail", result);
        return resultMap;
    }

    @PostMapping("/getDevicePVList")
    public @ResponseBody
    Map<String, Object> getDevicePVList(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
        logger.debug("/getDevicePVList {}", param);

        int selPageNum = Integer.parseInt((String) param.get("selPageNum"));
        int pageRowCnt = 5;
        int startNum = pageRowCnt * (selPageNum - 1);

        param.put("siteId", request.getSession().getAttribute("selViewSiteId"));
        param.put("startNum", startNum);
        param.put("pageRowCnt", pageRowCnt);

        List list = deviceMonitoringService.getDevicePVList(param);
        int listCnt = deviceMonitoringService.getDevicePVListCnt(param);
        int totalPageCnt = 0;
        if (listCnt > 0) {
            totalPageCnt = listCnt / pageRowCnt;
            if (listCnt % pageRowCnt > 0) {
                totalPageCnt++;
            }
        }

        Map<String, Object> pagingMap = new HashMap<String, Object>();
        pagingMap.put("pageRowCnt", pageRowCnt); // 한 페이지 당 보여줄 데이터 수
        pagingMap.put("selPageNum", selPageNum); // 선택한 페이지번호
        pagingMap.put("listCnt", listCnt); // 전체 데이터 수
        pagingMap.put("totalPageCnt", totalPageCnt); // 전체 페이지 수

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("list", list);
        resultMap.put("pagingMap", pagingMap);
        return resultMap;
    }

    @RequestMapping("/getDevicePVDetail")
    public @ResponseBody
    Map<String, Object> getDevicePVDetail(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
        logger.debug("/getDevicePVDetail");
        logger.debug("param ::::: " + param.toString());

        Map<String, Object> result = deviceMonitoringService.getDevicePVDetail(param);
        Map siteDetail = (Map) request.getSession().getAttribute("selViewSite");
        String host = (String) siteDetail.get("local_ems_addr");
        String apiVer = (String) siteDetail.get("local_ems_api_ver");
        if ("1.1".equals(apiVer)) { // 기존
            PvEquipmentModelBefore pvDetail = PMGrowApiUtilBefore.getPvEquipmentList(host, (String) param.get("deviceId"));
            if (pvDetail != null) {
                if (pvDetail == null) {
                    result.put("pvStatus", null);
                    result.put("pvStatusNm", null);
                    result.put("alarmMsg", null);
                    result.put("temperature", -1);
                    result.put("totalPower", -1);
                    result.put("todayPower", -1);
                } else {
                    String statusNm = "";
                    if (pvDetail.getStatus() == null) {
                        result.put("pvStatus", 1);
                        result.put("pvStatusNm", "Run");
                        result.put("alarmMsg", "");
                    } else {
                        if (pvDetail.getStatus() == 0) {
                            statusNm = "Stop";
                        } else if (pvDetail.getStatus() == 1) {
                            statusNm = "Run";
                        } else if (pvDetail.getStatus() == 2) {
                            statusNm = "Fault";
                        } else if (pvDetail.getStatus() == 3) {
                            statusNm = "Warning";
                        }
                        result.put("pvStatus", pvDetail.getStatus());
                        result.put("pvStatusNm", statusNm);
                        result.put("alarmMsg", pvDetail.getAlarmMsg());

                    }
                    result.put("temperature", (pvDetail.getTemperature() == null) ? -1 : pvDetail.getTemperature());
                    result.put("totalPower", (pvDetail.getTotalGenPower() == null) ? -1 : Math.ceil((pvDetail.getTotalGenPower()/1000f)*10)/10);
                    result.put("todayPower", (pvDetail.getTodayGenPower() == null) ? -1 : Math.ceil((pvDetail.getTodayGenPower()/1000f)*10)/10);
                }
            } else {
                result.put("pvStatus", null);
                result.put("pvStatusNm", null);
                result.put("alarmMsg", null);
                result.put("temperature", -1);
                result.put("totalPower", -1);
                result.put("todayPower", -1);

            }
        } else {
            PvEquipmentModel pvDetail = PMGrowApiUtil.getPvEquipmentList(host, (String) param.get("deviceId"));
            if (pvDetail != null) {
                String statusNm = "";
                if (pvDetail.getStatus() == 0) {
                    statusNm = "Stop";
                } else if (pvDetail.getStatus() == 1) {
                    statusNm = "Run";
                } else if (pvDetail.getStatus() == 2) {
                    statusNm = "Fault";
                } else if (pvDetail.getStatus() == 3) {
                    statusNm = "Warning";
                }
                result.put("pvStatus", pvDetail.getStatus());
                result.put("pvStatusNm", statusNm);
                result.put("alarmMsg", pvDetail.getAlarmMsg());

            } else {
                result.put("pvStatus", null);
                result.put("pvStatusNm", null);
                result.put("alarmMsg", null);
            }
            result.put("temperature", (pvDetail == null) ? -1 : pvDetail.getTemperature());
            result.put("totalPower", (pvDetail == null) ? -1 : Math.ceil((pvDetail.getTotalGenPower()/1000f)*10)/10);
            result.put("todayPower", (pvDetail == null) ? -1 : Math.ceil((pvDetail.getTodayGenPower()/1000f)*10)/10);
        }

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("detail", result);
        return resultMap;
    }

}
