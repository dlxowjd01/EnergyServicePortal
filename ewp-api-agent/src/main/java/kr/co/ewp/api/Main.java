package kr.co.ewp.api;

import java.util.Date;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.ApplicationArguments;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.stereotype.Component;

import com.google.common.collect.Maps;

import kr.co.ewp.api.controller.BillController;
import kr.co.ewp.api.controller.DeviceController;
import kr.co.ewp.api.controller.EnergyController;
import kr.co.ewp.api.controller.LogManageController;
import kr.co.ewp.api.util.DateUtil;
import kr.co.ewp.api.util.JsonUtil;
import kr.co.ewp.api.util.PrettyLog;

@Component
public class Main implements ApplicationListener<ContextRefreshedEvent> {
  private Logger logger = LoggerFactory.getLogger(Main.class);

  @Autowired
  private ApplicationArguments applicationArguments;
  @Autowired
  private EnergyController energyController;
  @Autowired
  private DeviceController deviceController;
  @Autowired
  private BillController billController;
  @Autowired
  private LogManageController logManageController;

  public enum OPTION {
    API_CODE, SITE_ID, DEVICE_ID, BEGIN_DATE, END_DATE;
  }

  @Override
  public void onApplicationEvent(ContextRefreshedEvent event) {
    PrettyLog prettyLog = new PrettyLog("EWP-API");
    try {
      Map<OPTION, String> option = Maps.newHashMap();
      for (OPTION opt : OPTION.values()) {
        if (applicationArguments.containsOption(opt.name())) {
          option.put(opt, applicationArguments.getOptionValues(opt.name()).get(0));
        }
      }
      prettyLog.append("OPTION", JsonUtil.toJson(option));

      String siteId = option.get(OPTION.SITE_ID);
      String deviceId = option.get(OPTION.DEVICE_ID);
      Date beginDate = null;
      Date endDate = null;
      String strBeginDate = option.get(OPTION.BEGIN_DATE);
      String strEndDate = option.get(OPTION.END_DATE);
      if (option.containsKey(OPTION.BEGIN_DATE) && strBeginDate.length() == 8) {
        beginDate = DateUtil.stringToDate(strBeginDate, "yyyyMMdd");
      }
      if (option.containsKey(OPTION.END_DATE) && strEndDate.length() == 8) {
        endDate = DateUtil.stringToDate(strEndDate + "235959", "yyyyMMddHHmmss");
      }

      if (option.containsKey(OPTION.API_CODE)) {
        switch (option.get(OPTION.API_CODE)) {
        case "ENERGY01":// 에너지모니터링 > 사용량 현황 > 사용량
          energyController.energy01(siteId, deviceId, beginDate, endDate, prettyLog);
          break;
        case "ENERGY02":// 에너지모니터링 > 사용량 현황 > 예측사용량
          energyController.energy02(siteId, deviceId, beginDate, endDate, prettyLog);
          break;
        case "ENERGY03":// 에너지모니터링 > 사용량 현황 > 무효전력
          energyController.energy03(siteId, deviceId, beginDate, endDate, prettyLog);
          break;
        case "ENERGY04":// 에너지모니터링 > 피크 전력 현황 > 피크
          energyController.energy04(siteId, beginDate, endDate, prettyLog);
          break;
        case "ENERGY05":// 에너지모니터링 > 피크 전력 현황 > 예측피크
          energyController.energy05(siteId, beginDate, endDate, prettyLog);
          break;
        case "ENERGY06":// 에너지모니터링 > ESS 충방전량 조회 > ESS충방전량
          energyController.energy06(siteId, deviceId, beginDate, endDate, prettyLog);
          break;
        case "ENERGY07":// 에너지모니터링 > ESS 충방전량 조회 > ESS충방전계획량
          energyController.energy07(siteId, deviceId, beginDate, endDate, prettyLog);
          break;
        case "ENERGY08":// 에너지모니터링 > PV 발전량 조회 > PV 발전량
          energyController.energy08(siteId, deviceId, beginDate, endDate, prettyLog);
          break;
        case "ENERGY09":// 에너지모니터링 > DR 실적조회 > DR 실적(감축이력)
          energyController.energy09(siteId, prettyLog);
          break;
        case "ENERGY10":// 에너지모니터링 > ESS/PV 사용량 구성 > ESS 사용량
          energyController.energy10(siteId, deviceId, beginDate, endDate, prettyLog);
          break;
        case "ENERGY11":// 에너지모니터링 > ESS/PV 사용량 구성 > PV 사용량
          energyController.energy11(siteId, deviceId, beginDate, endDate, prettyLog);
          break;
        case "DEVICE01":// 장치모니터링 > IOE 통신상태
          deviceController.device01(siteId, deviceId, prettyLog);
          break;
        case "DEVICE02":// 장치모니터링 > PCS 장치
          deviceController.device02(siteId, deviceId, prettyLog);
          break;
        case "DEVICE03":// 장치모니터링 > BMS 장치
          deviceController.device03(siteId, deviceId, prettyLog);
          break;
        case "DEVICE04":// 장치모니터링 > PV 장치
          deviceController.device04(siteId, deviceId, prettyLog);
          break;
        case "BILL01":// 요금/수익 > 한전요금조회 > 요금
          billController.bill01(siteId, beginDate, endDate, prettyLog);
          break;
        case "BILL03":// 요금/수익 > DR 수익 조회 > DR 수익
          billController.bill03(siteId, strBeginDate, strEndDate, prettyLog);
          break;
        case "BILL04":// 요금/수익 > PV 수익 조회> 발전수익
          billController.bill04(siteId, beginDate, endDate, prettyLog);
          break;
        case "LOG":// 로그파일 관리
        	logManageController.logManagement(prettyLog);
        	break;
        }
      }
    } finally {
      prettyLog.stop();
      logger.info(prettyLog.prettyPrint());
    }
  }
}