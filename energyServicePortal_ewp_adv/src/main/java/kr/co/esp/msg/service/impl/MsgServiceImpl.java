package kr.co.esp.msg.service.impl;

import java.nio.charset.Charset;
import java.util.Map;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.Message;
import javax.mail.Multipart;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.internet.MimeUtility;

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

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import kr.co.esp.msg.service.MsgService;
import kr.co.esp.sms.service.SmsService;
import kr.co.esp.sms.service.impl.SmsServiceImpl;


@Service("msgService")
public class MsgServiceImpl extends EgovAbstractServiceImpl implements  MsgService {
	
	private static final Logger logger = LoggerFactory.getLogger(SmsServiceImpl.class);	
	
	private static final int port= 465;
	private String host = "smtp.naver.com";
	private String user = "eberly";
	private String tail = "@naver.com";
	private String password = "11111111";
	
	
	public int sendSmsMessage(Map<String, Object> param) throws Exception {
		RestTemplate restTemplate = new RestTemplate();
		String url = "https://mkt.tason.com/open/auto_message_sender.jsp";

		restTemplate.getMessageConverters().add(0, new StringHttpMessageConverter(Charset.forName("EUC-KR")));

		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(new MediaType(MediaType.APPLICATION_FORM_URLENCODED, Charset.forName("EUC-KR")));

		MultiValueMap<String, String> body = new LinkedMultiValueMap<String, String>();
		body.add("enc_type", "EUC-KR");
		//TODO:!!! 맞는 템플릿으로 바꿔주세요. !!!
		body.add("mail_code", "S0848");	// !!! 바꿔주세요. !!!
		body.add("user_id", "encoredtech");
		body.add("auth_key", "0BA3TU-VCWRG1-KNI6U2-6ON5U7");
		body.add("mem_id", "JOIN_" + System.currentTimeMillis());
		body.add("mem_name", "김상수");
		body.add("mem_phone", (String) param.get("sms_number"));
		String smsMsgStr = "[신재생에너지 서비스 포털] " + (String) param.get("sms_text") + "												   ";
		//body.add("M1", (String) param.get("sms_text"));
		body.add("M1", smsMsgStr);
		logger.debug("request body: {}", body);

		HttpEntity entity = new HttpEntity(body, headers);
		String responseBody = restTemplate.postForObject(url, entity, String.class);
		logger.debug("response body: {}", responseBody);
		return Integer.parseInt(responseBody.trim());
	}

	public String getHost() {
		return host;
	}
	
	public void setHost(String host) {
		this.host = host;
	}
	
	public String getUser() {
		return user;
	}
	
	public void setUser(String user) {
		this.user = user;
	}
	
	public String getTail() {
		return tail;
	}
	
	public void setTail(String tail) {
		this.tail = tail;
	}
	
	public String getPassword() {
		return password;
	}
	
	public void setPassword(String password) {
		this.password = password;
	}
	
	private Properties props = System.getProperties();
	
	private boolean setEnv(){
		props.put("mail.smtp.host", host);  
		props.put("mail.smtp.port", port);  
		props.put("mail.smtp.auth", "true");  
		props.put("mail.smtp.ssl.enable", "true");  
		props.put("mail.smtp.ssl.trust", host);  
		return true;
	}
	
	public boolean sendMail(String receiver,String title, String text) throws Exception{
		setEnv();
		Message msg = sendingHead();
		sendingBody(msg, receiver, title, text);
		
		msg.setText(text);
        Transport.send(msg);	
        
		return true;
	}

	public boolean sendMail(String receiver,String title, String text, String filePath, String fileName) throws Exception{
		
		setEnv();
		Message msg = sendingHead();
		sendingBody(msg, receiver, title, text);
		
		if(filePath != null && filePath.length() > 0){  
	        Multipart multipart = new MimeMultipart();
	        MimeBodyPart textBodyPart = new MimeBodyPart();
	        textBodyPart.setText(text,"UTF-8");
	        MimeBodyPart attachmentBodyPart= new MimeBodyPart();
	        DataSource source = new FileDataSource(filePath); 
	        attachmentBodyPart.setDataHandler(new DataHandler(source));
	        attachmentBodyPart.setFileName(MimeUtility.encodeText(fileName, "UTF-8", null));
	        multipart.addBodyPart(textBodyPart);
	        multipart.addBodyPart(attachmentBodyPart);
	        msg.setContent(multipart);			
		}	
		Transport.send(msg);
		
        return true;
	}
	
	private Message sendingHead(){
		Session session = Session.getDefaultInstance(props, new javax.mail.Authenticator() {
			String un = user;
			String pw = password;
			protected javax.mail.PasswordAuthentication getPasswordAuthentication() {
				return new javax.mail.PasswordAuthentication(un, pw);
			}
		});
		session.setDebug(true);  
		Message msg = new MimeMessage(session); 
		return msg;
	}

	private void sendingBody(Message msg, String receiver, String title, String text) throws Exception{
		msg.setFrom(new InternetAddress(user + tail));  
		msg.setRecipient(Message.RecipientType.TO, new InternetAddress(receiver));  
		msg.setSubject(title);  
	}	
	
	public boolean sendMailMessage(Map<String, Object> param) throws Exception {

		setEnv();
		Message msg = sendingHead();
		
		sendingBody(msg, (String) param.get("email_address"), (String) param.get("email_title"), (String) param.get("email_text"));
		
		msg.setText((String) param.get("email_text"));
        Transport.send(msg);
        
		return true;		
	}		
	
	

}
