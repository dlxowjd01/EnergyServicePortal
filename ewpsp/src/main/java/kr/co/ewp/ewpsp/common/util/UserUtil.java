package kr.co.ewp.ewpsp.common.util;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.codec.DecoderException;
import org.apache.commons.codec.EncoderException;
import org.apache.commons.codec.net.URLCodec;

public class UserUtil {

	public final static String USER_SESSION_ID = "userInfo";

	public static Map getUserInfo(HttpSession session) {
		Map userInfo = (Map)session.getAttribute(UserUtil.USER_SESSION_ID);
		return userInfo;
	}

	public static Map getUserInfo(HttpServletRequest request) {
		return UserUtil.getUserInfo(request.getSession());
	}

//	@Deprecated()
//	public static String encAES256(String userPw) throws UnsupportedEncodingException, EncoderException {
//
//		String key = "aes256-ewpsp-key";
//		AES256Util aes256 = new AES256Util(key);
//		URLCodec codec = new URLCodec();
//
//		return codec.encode(aes256.aesEncode(userPw));
//	}
//
//	@Deprecatedr
//	public static String decAES256(String userPw) throws UnsupportedEncodingException, DecoderException {
//
//		String key = "aes256-ewpsp-key";
//		AES256Util aes256 = new AES256Util(key);
//		URLCodec codec = new URLCodec();
//
//		return aes256.aesDecode(codec.decode(userPw));
//	}

	public static String encSHA256(String userPw) throws NoSuchAlgorithmException {

		MessageDigest md = MessageDigest.getInstance("SHA-256"); 
		md.update(userPw.getBytes()); 

		byte byteData[] = md.digest();
		StringBuffer sb = new StringBuffer(); 

		for(int i = 0 ; i < byteData.length ; i++){
			sb.append(Integer.toString((byteData[i] & 0xff) + 0x100, 16).substring(1));
		}

		return sb.toString();
	}
}
