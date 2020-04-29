package kr.co.esp.dashboard.web;

import java.util.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import kr.co.esp.common.util.DateUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.ibm.icu.text.SimpleDateFormat;

import kr.co.esp.alarm.service.AlarmService;
import kr.co.esp.billRevenue.service.DrRevenueService;
import kr.co.esp.billRevenue.service.EssRevenueService;
import kr.co.esp.billRevenue.service.PvRevenueService;
import kr.co.esp.device.service.DeviceMonitoringService;
import kr.co.esp.energy.service.EssChargeService;

@Controller
public class DashboardController {

	private static final Logger logger = LoggerFactory.getLogger(DashboardController.class);

	@Resource(name="essChargeService")
	private EssChargeService essChargeService;

	@Resource(name="essRevenueService")
	private EssRevenueService essRevenueService;

	@Resource(name="pvRevenueService")
	private PvRevenueService pvRevenueService;

	@Resource(name="drRevenueService")
	private DrRevenueService drRevenueService;

	@Resource(name="deviceMonitoringService")
	private DeviceMonitoringService deviceMonitoringService;

	@Resource(name="alarmService")
	private AlarmService alarmService;

	@RequestMapping(value = "/main/siteMain.do")
	public String siteMain(HttpServletRequest request, HttpSession session, Model model) {
		logger.debug("/main/siteMain.do");
		return "esp/main/siteMain";
	}

	@RequestMapping(value = "/main/gMain.do")
	public String gMain(HttpServletRequest request, HttpSession session, Model model) {
		System.out.println("/main/gMain.do");
		return "esp/main/gMain";
	}

	@RequestMapping(value = "/dashboard/dmain.do")
	public String groupDashboard(HttpServletRequest request, HttpSession session, Model model) {
		System.out.println("/dashboard/dmain.do");
		String linkSiteName = request.getParameter("linkSiteName");
		model.addAttribute("siteName", linkSiteName);
		return "esp/dashboard/dmain";
	}

	@RequestMapping(value = "/dashboard/emain.do")
	public String emain(HttpServletRequest request, HttpSession session, Model model) {
		System.out.println("/dashboard/emain.do");
		String linkSiteName = request.getParameter("linkSiteName");
		model.addAttribute("siteName", linkSiteName);
		return "esp/dashboard/emain";
	}

	@RequestMapping(value = "/dashboard/gmain.do")
	public String gmain(HttpServletRequest request, HttpSession session, Model model) {
		System.out.println("/dashboard/gmain.do");
		return "esp/dashboard/gmain";
	}

	@RequestMapping(value = "/dashboard/jmain.do")
	public String jmain(HttpServletRequest request, HttpSession session, Model model) {
		System.out.println("/dashboard/jmain.do");
		return "esp/dashboard/jmain";
	}

	@RequestMapping(value = "/dashboard/smain.do")
	public String smain(HttpServletRequest request, HttpSession session, Model model) {
		String linkSiteName = request.getParameter("linkSiteName");

		if (request.getParameter("sid") == null || "".equals(request.getParameter("sid"))) {
			model.addAttribute("sid", "0c7c90c6-9505-4f77-b42d-500c2879c689"); //sid가 없을경우 하드코딩한 값으로 세팅한다.
		} else {
			model.addAttribute("sid", request.getParameter("sid")); //siteId를 받아서 다시 보낸다.
			if("0c7c90c6-9505-4f77-b42d-500c2879c689".equals(request.getParameter("sid"))) {
				linkSiteName = "혜원솔라 02";
			} else {
				linkSiteName = "혜원솔라 01";
			}
		}

		model.addAttribute("siteName", linkSiteName);

		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
		Date toDate = DateUtil.getDate();
		DateUtil.truncateHms(toDate);
		Date endDate = DateUtil.getAfterDays(toDate, 1);
		DateUtil.truncateHms(endDate);

		model.addAttribute("startTime", sdf.format(toDate));
		model.addAttribute("endTime", sdf.format(endDate));
		model.addAttribute("startDate", DateUtil.getMonthFirstDate("yyyyMMdd") + "000000");
		model.addAttribute("endDate", sdf.format(endDate));

		Date startWeek = DateUtil.getFirstDateOfWeek(toDate);
		DateUtil.truncateHms(startWeek);
		Date endWeek = DateUtil.getAfterDays(toDate, 7);
		DateUtil.truncateHms(endWeek);
		model.addAttribute("startWeek", sdf.format(startWeek));
		model.addAttribute("endWeek", sdf.format(endWeek));

		TimeZone timeZone = TimeZone.getTimeZone("GMT+09:00");
		Calendar startDate = Calendar.getInstance(timeZone, Locale.KOREAN);
		int nowYear = startDate.get(Calendar.YEAR);

		startDate.set(nowYear, 0, 1, 0, 0, 0);

		model.addAttribute("startMonth", DateUtil.dateToString(startDate, "yyyyMMddHHmmss"));
		model.addAttribute("endMonth", DateUtil.getCurMonthLastDate("yyyyMMdd") + "000000");

		startDate.set(nowYear-1, 0, 1, 0, 0, 0);

		Calendar endDateC = Calendar.getInstance(timeZone, Locale.KOREAN);
		endDateC.set(nowYear-1, endDateC.get(Calendar.MONTH), 1, 0, 0, 0);
		model.addAttribute("beforeStartMonth", DateUtil.dateToString(startDate, "yyyyMMddHHmmss"));
		model.addAttribute("beforeEndMonth", DateUtil.dateToString(endDateC, "yyyyMMddHHmmss"));


		Calendar c = Calendar.getInstance(timeZone, Locale.KOREAN); /* TODO : 테스트 일자조정 c.set(Calendar.DATE, 2); */
		int nowMonth = c.get(Calendar.MONTH);
		int nowWeek = c.get(Calendar.DAY_OF_WEEK);
		int nowDay = c.get(Calendar.DAY_OF_MONTH);

		c.set(Calendar.DATE, 1);
		int weekDay = c.get(Calendar.DAY_OF_WEEK) - 1;
		int lastDay = c.getActualMaximum(Calendar.DAY_OF_MONTH);
		c.set(Calendar.DAY_OF_MONTH, lastDay);
		int weeks = c.get(Calendar.WEEK_OF_MONTH);

		int[] calArr = new int[(weeks * 7)];
		int day = 1;
		for (int i = 0; i < calArr.length; i++) {
			if(i < weekDay) calArr[i] = 0;
			else if(i >= weekDay+lastDay) calArr[i] = 0;
			else calArr[i] = day++;
		}

		List<int[]> calList = new ArrayList<int[]>();
		for (int i = 1; i <= weeks; i++) {
			calList.add(Arrays.copyOfRange(calArr, (i-1)*7, i*7));
		}

		model.addAttribute("calList", calList);
		model.addAttribute("nowMonth", nowMonth+1);
		model.addAttribute("nowWeek", (nowWeek > 1 ? nowWeek -1 : 7)); //sun~sat > mon~sun
		model.addAttribute("nowDay", nowDay);

		return "esp/dashboard/smain";
	}

}
