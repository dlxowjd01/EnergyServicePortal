package kr.co.esp.dashboard.web;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

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
		System.out.println("/dashboard/smain.do");
		String linkSiteName = request.getParameter("linkSiteName");
		model.addAttribute("siteName", linkSiteName);

		// range
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");

		Calendar rangeCal = Calendar.getInstance(); /* TODO : 테스트용 일자조정  rangeCal.set(Calendar.DATE, 2); */
		int nowYear = rangeCal.get(Calendar.YEAR);
		int nowMonth = rangeCal.get(Calendar.MONTH);
		int nowWeek = rangeCal.get(Calendar.DAY_OF_WEEK);
		int nowDay = rangeCal.get(Calendar.DAY_OF_MONTH);

		Calendar startDate = Calendar.getInstance(); /* TODO : 테스트 일자조정  startDate.set(Calendar.DATE, 2); */
		Calendar endDate = Calendar.getInstance(); /* TODO : 테스트 일자조정  endDate.set(Calendar.DATE, 2); */

		//2020.04.12 000000 ~ 2020.04.12 000000
		startDate.set(nowYear, nowMonth, nowDay, 0, 0, 0);
		endDate.set(nowYear, nowMonth, nowDay, 0, 0, 0);
		endDate.add(Calendar.DATE, 1); //FIXME e.g. 2020.04.12 000000 ~ 2020.04.13 000000 일단위 데이터
		model.addAttribute("startTime", sdf.format(startDate.getTime()));
		model.addAttribute("endTime", sdf.format(endDate.getTime()));

		//e.g. 2020.03.30 000000 ~ 2020.04.05 000000 (today 2020.04.02)
		startDate.set(nowYear, nowMonth, nowDay, 0, 0, 0);
		if( startDate.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY) startDate.add(Calendar.DATE, -7);
		startDate.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
		endDate.set(nowYear, nowMonth, nowDay, 0, 0, 0);
		if( endDate.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY)  endDate.add(Calendar.DATE, -7);
		endDate.add(Calendar.DATE, 7);
		endDate.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
		endDate.add(Calendar.DATE, 1); //FIXME e.g. 2020.03.30 000000 ~ 2020.04.06 000000 일단위 데이터
		model.addAttribute("startWeek", sdf.format(startDate.getTime()));
		model.addAttribute("endWeek", sdf.format(endDate.getTime()));

		//e.g. 2020.04.01 000000 ~ 2020.04.30 000000
		startDate.set(nowYear, nowMonth, 1, 0, 0, 0);
		endDate.set(nowYear, nowMonth, startDate.getActualMaximum(Calendar.DATE), 0, 0, 0);
		endDate.add(Calendar.DATE, 1); //FIXME e.g. 2020.04.01 000000 ~ 2020.05.01 000000 일단위 데이터
		model.addAttribute("startDate", sdf.format(startDate.getTime()));
		model.addAttribute("endDate", sdf.format(endDate.getTime()));

		//e.g. 2020.01.01 000000 ~ 2020.12.31 000000
		startDate.set(nowYear, 0, 1, 0, 0, 0);
		endDate.set(nowYear, nowMonth, startDate.getActualMaximum(Calendar.DATE), 0, 0, 0);
		model.addAttribute("startMonth", sdf.format(startDate.getTime()));
		model.addAttribute("endMonth", sdf.format(endDate.getTime()));

		//e.g. 2019.01.01 000000 ~ 2019.12.31 000000
		startDate.set(nowYear-1, 0, 1, 0, 0, 0);
		endDate.set(nowYear-1, nowMonth, startDate.getActualMaximum(Calendar.DATE), 0, 0, 0);
		model.addAttribute("beforeStartMonth", sdf.format(startDate.getTime()));
		model.addAttribute("beforeEndMonth", sdf.format(endDate.getTime()));

		// display calendar
		Calendar c = Calendar.getInstance(); /* TODO : 테스트 일자조정 c.set(Calendar.DATE, 2); */
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
