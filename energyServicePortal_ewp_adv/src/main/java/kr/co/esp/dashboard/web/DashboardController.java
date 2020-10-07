package kr.co.esp.dashboard.web;

import kr.co.esp.common.service.EgovProperties;
import kr.co.esp.common.util.UserUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
public class DashboardController {
	private static final Logger logger = LoggerFactory.getLogger(DashboardController.class);

	@RequestMapping(value = "/dashboard/gmain.do")
	public String gmain(HttpServletRequest request, HttpSession session, Model model) {
		String dashboardMap = (String) EgovProperties.getProperty("dashboard.map"); // TEST 서버 여부

		String defaultOid = EgovProperties.getProperty("default.oid");
		if ("testkpx".equals(defaultOid)) {
			model.addAttribute("secondYAxis", false);
		} else {
			model.addAttribute("secondYAxis", true);
		}

		model.addAttribute("dashboardMap", dashboardMap);
		return "esp/dashboard/gmain";
	}

	@RequestMapping(value = "/dashboard/jmain.do")
	public String jmain(HttpServletRequest request, HttpSession session, Model model) {
		return "esp/dashboard/jmain";
	}

	@RequestMapping(value = "/dashboard/smain.do")
	public String smain(HttpServletRequest request, HttpSession session, Model model) {
		Map<String, Object> userInfo = UserUtil.getUserInfo(session);

		// range
		TimeZone timeZone = TimeZone.getTimeZone("Asia/Seoul");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
		sdf.setTimeZone(timeZone);
		
		Calendar rangeCal = Calendar.getInstance(timeZone);

		int nowYear = rangeCal.get(Calendar.YEAR);
		int nowMonth = rangeCal.get(Calendar.MONTH);
		int nowWeek = rangeCal.get(Calendar.DAY_OF_WEEK);
		int nowDay = rangeCal.get(Calendar.DAY_OF_MONTH);

		Calendar startDate = Calendar.getInstance(timeZone, Locale.KOREAN);
		Calendar endDate = Calendar.getInstance(timeZone, Locale.KOREAN);
		Calendar beforeDate = Calendar.getInstance(timeZone, Locale.KOREAN);

		//2020.04.12 000000 ~ 2020.04.12 000000
		startDate.set(nowYear, nowMonth, nowDay, 0, 0, 0);
		endDate.set(nowYear, nowMonth, nowDay, 0, 0, 0);
		beforeDate.set(nowYear, nowMonth, nowDay, 0, 0, 0);
		endDate.add(Calendar.DATE, 1);
		beforeDate.add(Calendar.DATE, -1);

		model.addAttribute("startTime", sdf.format(startDate.getTime()));
		model.addAttribute("endTime", sdf.format(endDate.getTime()));
		model.addAttribute("beforeTime", sdf.format(beforeDate.getTime()));

		//e.g. 2020.03.30 000000 ~ 2020.04.05 000000 (today 2020.04.02)
		startDate.set(nowYear, nowMonth, nowDay, 0, 0, 0);
		if( startDate.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY) startDate.add(Calendar.DATE, -7);
		startDate.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
		endDate.set(nowYear, nowMonth, nowDay, 0, 0, 0);
		if( endDate.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY)  endDate.add(Calendar.DATE, -7);
		endDate.add(Calendar.DATE, 7);
		endDate.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
		endDate.add(Calendar.DATE, 1);
		model.addAttribute("startWeek", sdf.format(startDate.getTime()));
		model.addAttribute("endWeek", sdf.format(endDate.getTime()));

		//e.g. 2020.04.01 000000 ~ 2020.04.30 000000
		startDate.set(nowYear, nowMonth, 1, 0, 0, 0);
		endDate.set(nowYear, nowMonth, startDate.getActualMaximum(Calendar.DATE), 0, 0, 0);
		endDate.add(Calendar.DATE, 1);
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
		Calendar c = Calendar.getInstance(timeZone, Locale.KOREAN);
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
