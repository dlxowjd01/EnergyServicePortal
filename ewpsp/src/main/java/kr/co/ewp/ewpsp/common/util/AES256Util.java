package kr.co.ewp.ewpsp.common.util;

import java.io.UnsupportedEncodingException;
import java.security.Key;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.binary.Base64;

@Deprecated
public class AES256Util {

	private String iv;
	private Key keySpec;

	// 초기화
	public AES256Util(String key) throws UnsupportedEncodingException {
		if (key == null || key.length() < 16) {
			return;
		}

		this.iv = key.substring(0, 16);

		byte[] keyBytes = new byte[16];
		byte[] b = key.getBytes("UTF-8");
		int len = b.length;
		if (len > keyBytes.length) {
			len = keyBytes.length;
		}
		System.arraycopy(b, 0, keyBytes, 0, len);
		SecretKeySpec keySpec = new SecretKeySpec(keyBytes, "AES");

		this.keySpec = keySpec;
	}

	// 암호화
	public String aesEncode(String str) {
		if (str == null) {
			return "";
		}

		String encStr = str;

		try {
			Cipher c = Cipher.getInstance("AES/CBC/PKCS5Padding");
			c.init(Cipher.ENCRYPT_MODE, keySpec, new IvParameterSpec(iv.getBytes()));

			byte[] encrypted = c.doFinal(str.getBytes("UTF-8"));
			encStr = new String(Base64.encodeBase64(encrypted));
		} catch (Exception e) {
			e.printStackTrace();
		}

		return encStr;
	}

	// 복호화
	public String aesDecode(String str) {
		if (str == null) {
			return "";
		}

		String decStr = str;

		try {
			Cipher c = Cipher.getInstance("AES/CBC/PKCS5Padding");
			c.init(Cipher.DECRYPT_MODE, keySpec, new IvParameterSpec(iv.getBytes("UTF-8")));

			byte[] byteStr = Base64.decodeBase64(str.getBytes());
			decStr = new String(c.doFinal(byteStr),"UTF-8");
		} catch (Exception e) {
			e.printStackTrace();
		}

		return decStr;
	}
}
