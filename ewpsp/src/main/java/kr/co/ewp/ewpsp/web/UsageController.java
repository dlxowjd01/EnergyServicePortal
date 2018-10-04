/**
 * class name : UsageController
 * description : 사용자 현황 화면 controller
 * version : 1.0
 * author : 이우람
 */

package kr.co.ewp.ewpsp.web;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.ewp.ewpsp.common.ExcelDownload;
import kr.co.ewp.ewpsp.service.UsageService;

@Controller
public class UsageController {
	
	private static final Logger logger = LoggerFactory.getLogger(UsageController.class);
	
	@Resource(name="usageService")
	private UsageService usageService;

	@RequestMapping("/usage")
	public String usage(Model model) {
		logger.debug("/usage");
		
//		List list = usageService.usageList();
//		model.addAttribute("list", list);
		
		return "ewp/energy/usage";
	}
	
	@RequestMapping("/getUsageRealList")
	public @ResponseBody Map<String, Object> getUsageRealList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getUsageRealList");
		logger.debug("param ::::: "+param.toString());
		
		List list = usageService.getUsageRealList(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		return resultMap;
	}
	
	@RequestMapping("/getUsageFutureList")
	public @ResponseBody Map<String, Object> getUsageFutureList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getUsageFutureList");
		logger.debug("param ::::: "+param.toString());
		
		List list = usageService.getUsageFutureList(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		return resultMap;
	}

	@RequestMapping(value = "/excelDownload")
    public void excelDownload(@RequestParam HashMap param, Model model, HttpServletRequest request, HttpSession session, HttpServletResponse response) throws Exception {
		logger.debug("/excelDownload");
		logger.debug("param ::::: "+param.toString());

//		String queryId = "usage.getUsageRealList";
		String excel_title = "사용량 조회_"+System.currentTimeMillis();
//		param.put("queryId", queryId);
		param.put("excel_title", excel_title);
		
		List list = usageService.getUsageRealList(param);
		
		String res = "";
		
		ExcelDownload ed = null;
		try {
			ed = new ExcelDownload(response, param);
			
			if(list != null && list.size() > 0) {
				for (int i = 0; i < list.size(); i++) {
					Map<String, Object> excelMap = new HashMap<String, Object>();
					excelMap = (Map<String, Object>) list.get(i);
					ed.handleRow(excelMap);
				}
				
			}
			res = res+",1";
		} catch (Exception e) {
			e.printStackTrace();
			res = res+",2";
		} finally {
			res = res+",3";
			if(ed != null) {
				ed.close();
				res = res+",4";
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
