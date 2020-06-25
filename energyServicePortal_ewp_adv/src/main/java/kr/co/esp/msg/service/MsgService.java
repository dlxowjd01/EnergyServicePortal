package kr.co.esp.msg.service;

import java.util.Map;

import org.springframework.stereotype.Service;

@Service
public interface MsgService {
	
	int sendSmsMessage(Map<String, Object> param) throws Exception;
	boolean sendMailMessage(Map<String, Object> param) throws Exception;

}
