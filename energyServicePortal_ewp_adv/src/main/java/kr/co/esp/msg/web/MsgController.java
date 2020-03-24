package kr.co.esp.msg.web;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.esp.msg.service.MsgService;

@Controller
public class MsgController {
	@Resource(name="msgService")
	private MsgService msgService;
	
	private static final Logger logger = LoggerFactory.getLogger(MsgController.class);
	
	
	@RequestMapping("/sendSms.json")
	public @ResponseBody Map<String, Object> sendSms(@RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/sendSms.json");
		logger.debug("param : {}", param);

		int resultCnt = msgService.sendSmsMessage(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", resultCnt);
		return resultMap;
	}	
	
	@RequestMapping("/sendMail.json")
	public @ResponseBody Map<String, Object> sendMail(@RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/sendMail.json");
		logger.debug("param : {}", param);

		boolean bResult = msgService.sendMailMessage(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultVal", bResult);
		return resultMap;
	}		

}
