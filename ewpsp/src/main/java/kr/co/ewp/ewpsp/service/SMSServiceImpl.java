package kr.co.ewp.ewpsp.service;

import kr.co.ewp.ewpsp.dao.ControlDao;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import javax.annotation.Resource;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("smsService")
public class SMSServiceImpl implements SMSService {

    private static final Logger logger = LoggerFactory.getLogger(SMSServiceImpl.class);

    @Resource(name = "controlDao")
    private ControlDao controlDao;

    /**
     * 메시지 ===>>>
     * ${map_4}에서 ${map_5} 알람이 발생
     * 장치 : ${map_6}
     * 시간 : ${map_7}
     * 메시지 : ${map_8}
     * <p>
     * site_name
     * alarm_type
     * device_name
     * std_date
     * alarm_msg
     *
     * @param type
     * @param msg
     * @return
     */
    public void sendAlarmMessage(String siteId, String deviceId, String deviceName, String alarmTime, String alarmType, String alarmMsg) throws Exception {

        HashMap param = new HashMap();
        param.put("siteId", siteId);
        List<Map> userList = controlDao.getSmsUserList(param);

        RestTemplate restTemplate = new RestTemplate();
        String url = "https://mkt.tason.com/open/auto_message_sender.jsp";

        restTemplate.getMessageConverters().add(0, new StringHttpMessageConverter(Charset.forName("EUC-KR")));

        HttpHeaders headers = new HttpHeaders();
//		headers.setContentType(new MediaType(MediaType.TEXT_HTML, Charset.forName("UTF-8")));
        headers.setContentType(new MediaType(MediaType.APPLICATION_FORM_URLENCODED, Charset.forName("EUC-KR")));

        for (Map userMap : userList) {
            String mobile = (String) userMap.get("mobile");

            if (mobile == null) {
                logger.debug("{} phone number is null.", userMap.get("user_name"));
                continue;
            }

            MultiValueMap<String, String> body = new LinkedMultiValueMap<String, String>();
            body.add("enc_type", "EUC-KR");
            body.add("mail_code", "S0848");
            body.add("user_id", "encoredtech");
            body.add("auth_key", "0BA3TU-VCWRG1-KNI6U2-6ON5U7");
            body.add("mem_id", userMap.get("sms_user_idx") + "_" + System.currentTimeMillis());
            body.add("mem_name", (String) userMap.get("user_name"));
            body.add("mem_phone", mobile);
            body.add("M1", (String) userMap.get("site_name"));
//			body.add("M1", siteId);
//			body.add("M2", deviceName);
            body.add("M2", alarmType.equals("1") ? "비상" : "주의");
            body.add("M3", deviceName);
            body.add("M4", alarmTime.substring(0, 4) + "-" + alarmTime.substring(4, 6) + "-" + alarmTime.substring(6, 8) + " "
                    + alarmTime.substring(8, 10) + ":" + alarmTime.substring(10, 12));
            body.add("M5", alarmMsg);
            logger.debug("request body: {}", body);

            HttpEntity entity = new HttpEntity(body, headers);
            String responseBody = restTemplate.postForObject(url, entity, String.class);
            logger.debug("response body: {}", responseBody);
        }
    }

    /**
     * 인증번호 전송
     */
    public int sendAuthCodeMessage(HashMap param) throws Exception {

        RestTemplate restTemplate = new RestTemplate();
        String url = "https://mkt.tason.com/open/auto_message_sender.jsp";

        restTemplate.getMessageConverters().add(0, new StringHttpMessageConverter(Charset.forName("EUC-KR")));

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(new MediaType(MediaType.APPLICATION_FORM_URLENCODED, Charset.forName("EUC-KR")));

        MultiValueMap<String, String> body = new LinkedMultiValueMap<String, String>();
        body.add("enc_type", "EUC-KR");
        //TODO:!!! 맞는 템플릿으로 바꿔주세요. !!!
        body.add("mail_code", "S0848");    // !!! 바꿔주세요. !!!
        body.add("user_id", "encoredtech");
        body.add("auth_key", "0BA3TU-VCWRG1-KNI6U2-6ON5U7");
        body.add("mem_id", "JOIN_" + System.currentTimeMillis());
        body.add("mem_name", (String) param.get("psnName"));
        body.add("mem_phone", (String) param.get("psnMobile"));
        String smsMsgStr = "[신재생에너지 서비스 포털] 본인확인을 위한 인증번호[" + (String) param.get("authCode") + "]를 입력해 주세요.                                                   ";
        body.add("M1", smsMsgStr);
        logger.debug("request body: {}", body);

        HttpEntity entity = new HttpEntity(body, headers);
        String responseBody = restTemplate.postForObject(url, entity, String.class);
        logger.debug("response body: {}", responseBody);
        return Integer.parseInt(responseBody.trim());
    }

    /**
     * 비밀번호 sms
     */
    public int sendFindPassMessage(HashMap param) throws Exception {

        RestTemplate restTemplate = new RestTemplate();
        String url = "https://mkt.tason.com/open/auto_message_sender.jsp";

        restTemplate.getMessageConverters().add(0, new StringHttpMessageConverter(Charset.forName("EUC-KR")));

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(new MediaType(MediaType.APPLICATION_FORM_URLENCODED, Charset.forName("EUC-KR")));

        MultiValueMap<String, String> body = new LinkedMultiValueMap<String, String>();
        body.add("enc_type", "EUC-KR");
        //TODO:!!! 맞는 템플릿으로 바꿔주세요. !!!
        body.add("mail_code", "S0848");    // !!! 바꿔주세요. !!!
        body.add("user_id", "encoredtech");
        body.add("auth_key", "0BA3TU-VCWRG1-KNI6U2-6ON5U7");
        body.add("mem_id", "FIND_PW_" + System.currentTimeMillis());
        body.add("mem_name", (String) param.get("psnName"));
        body.add("mem_phone", (String) param.get("psnMobile"));
        String smsMsgStr = "[신재생에너지 서비스 포털] " + (String) param.get("userId") + "의 임시 비밀번호는 " + (String) param.get("userPw") + " 입니다.                                                   ";
        body.add("M1", smsMsgStr);
        logger.debug("request body: {}", body);

        HttpEntity entity = new HttpEntity(body, headers);
        String responseBody = restTemplate.postForObject(url, entity, String.class);
        logger.debug("response body: {}", responseBody);
        return Integer.parseInt(responseBody.trim());
    }
}
