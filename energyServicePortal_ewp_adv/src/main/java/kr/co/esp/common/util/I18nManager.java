package kr.co.esp.common.util;

import java.io.IOException;
import java.io.InputStream;
import java.io.Reader;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.util.Properties;

import java.nio.file.Path;
import java.nio.file.Paths;

import egovframework.com.cmm.EgovWebUtil;
import egovframework.com.cmm.service.Globals;
import kr.co.esp.common.service.EgovProperties;

public class I18nManager {
	static I18nManager instance;
	Properties enDict = new Properties();
	Properties koDict = new Properties();

	final static String FILE_SEPARATOR = System.getProperty("file.separator");
	
	static public I18nManager getInstance () {
		if (instance == null) return new I18nManager();
		else return instance;
	}
	
	public String tr(HttpServletRequest request, String key) {
		HttpSession session = request.getSession();
		String sessionLang = (String) session.getAttribute("sessionLang");
		
		String lang = request.getParameter("lang");
		if (lang == null || "".equals(lang)) {
			if (sessionLang == null || "".equals(sessionLang)) {
				lang = "ko";
			} 
			else {
				lang = sessionLang;
			}
		}

		if (lang == "ko") {
			return koDict.getProperty(key);
		}
		else {
			return enDict.getProperty(key);
		}
	}

	I18nManager () {
        try {
			FileInputStream enDictStream = new FileInputStream(EgovWebUtil.filePathBlackList(EgovProperties.RELATIVE_PATH_PREFIX + "message" + FILE_SEPARATOR + "com" + FILE_SEPARATOR + "message-common_en.properties"));			
            enDict.load(new BufferedInputStream(enDictStream));
            enDictStream.close();

            FileInputStream koDictStream = new FileInputStream(EgovWebUtil.filePathBlackList(EgovProperties.RELATIVE_PATH_PREFIX + "message" + FILE_SEPARATOR + "com" + FILE_SEPARATOR + "message-common_ko.properties"));
            koDict.load(new BufferedInputStream(koDictStream));
            koDictStream.close();

        } catch (IOException e) {
        	System.out.println("abcdef" + e);
            e.printStackTrace();
        }
	}
}
