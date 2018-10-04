package kr.co.ewp.ewpsp.common.util;

import java.io.File;
import java.lang.reflect.Array;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Random;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import kr.co.ewp.ewpsp.web.UsageController;

public class CommonUtils {

	private static final Logger logger = LoggerFactory.getLogger(CommonUtils.class);
	
	/**
	* Object type 변수가 비어있는지 체크
	* 
	* @param obj 
	* @return Boolean : true / false
	*/
	public static Boolean isEmpty(Object obj) {
		if (obj instanceof String) return obj == null || "".equals(obj.toString().trim());
		else if (obj instanceof List) return obj == null || ((List<?>) obj).isEmpty();
		else if (obj instanceof Map) return obj == null || ((Map<?, ?>) obj).isEmpty();
		else if (obj instanceof Object[]) return obj == null || Array.getLength(obj) == 0;
		else return obj == null;
	}
 
	/**
	* Object type 변수가 비어있지 않은지 체크
	* 
	* @param obj
	* @return Boolean : true / false
	*/
	public static Boolean isNotEmpty(Object obj) {
		return !isEmpty(obj);
	}
	
	/**
	 * 파일 업로드
	 * @param multiRequest
	 * @return
	 */
//	public static List<HashMap<String, Object>> fileUpload(MultipartHttpServletRequest multiRequest, HttpSession session) {
//		logger.debug("function fileUpload");
//		List fileInfoList = new ArrayList<HashMap<String, Object>>();
//		
//		Map<String, MultipartFile> files = multiRequest.getFileMap();
//		Iterator<Entry<String, MultipartFile>> itr = files.entrySet().iterator();
//
//		MultipartFile file;
//		
//		if (!files.isEmpty()) {
//			while (itr.hasNext()) {
//				Entry<String, MultipartFile> entry = itr.next();
//				file = entry.getValue();
//				HashMap<String, String> fileInfo = null;
//				try {
//					fileInfo = CommonUtils.parseFileInf(file, session);
//				} catch (Exception e) {
//					e.printStackTrace();
//				}
//				
//				if(fileInfo != null){
//					fileInfoList.add(fileInfo);
//				}
//			}
//		}
//		
//		return fileInfoList;
//	}
//	
//	public static HashMap<String, String> parseFileInf(MultipartFile file, HttpSession session) throws Exception {
//		if (isEmpty(file)) {
//			return null;
//		}
//		
//		String orginFileName = file.getOriginalFilename();
//		String storePath = "/ewpsp/imgTest/";
//		String savePath = filePathBlackList(storePath);
//		File saveFolder = new File(savePath);
//		String saveOriginPath = filePathBlackList(storePath+"/originals/");
//		File saveOriginFolder = new File(saveOriginPath);
//
//		if (!saveFolder.exists() || saveFolder.isFile()) {
//			saveFolder.mkdirs();
//		}
//		if (!saveOriginFolder.exists() || saveOriginFolder.isFile()) {
//			saveOriginFolder.mkdirs();
//		}
//		
//		int index = orginFileName.lastIndexOf(".");
//		// String fileName = orginFileName.substring(0, index);
//		String fileExt = orginFileName.substring(index + 1);
//		String newName = getRandomText(10, 7) + "_" + CommonUtils.convertDateFormat(new Date(), "yyyyMMddHHmmssSSS") + "." + fileExt;
//		String newOriName = getRandomText(10, 7) + "_" + CommonUtils.convertDateFormat(new Date(), "yyyyMMddHHmmssSSS") + "." + fileExt;
//		long size = file.getSize();
//		String originFilePath = saveOriginPath + newOriName; // 원본파일 저장할 폴더
//		String filePath = savePath + "/" + newName; // 변환된 파일 저장할 폴더
//		
//		file.transferTo(new File(filePath));
//		
//		File f = new File(filePath);
//		// 파일 존재 여부 판단
//		if (f.isFile()) {
//		  logger.debug(filePath + " OK 파일 있습니다.");
//		}
//		else {
//			logger.debug(filePath + " 그런 파일 없습니다.");
//		}
//		
//		HashMap<String, String> map = new HashMap<String, String>();
//		map.put("savePath", savePath);
//		map.put("rName", orginFileName);
//		map.put("sName", newName);
//		map.put("fileSize", String.valueOf(size));
//		map.put("fileExt", fileExt);
//		logger.debug("file map : "+map.toString());
//		return map;
//	}
	
	private static String filePathBlackList(String value) {
		String returnValue = value;
		if (returnValue == null || returnValue.trim().equals("")) {
			return "";
		}

		returnValue = returnValue.replaceAll("\\.\\./", ""); // ../
		returnValue = returnValue.replaceAll("\\.\\.\\\\", ""); // ..\

		return returnValue;
	}
	
	/**
	 * Date Type의 데이터를 포맷팅 하여 반환
	 * @param input
	 * @param format
	 * @return
	 * @throws Exception
	 */
	public static String convertDateFormat(Date input, String format) throws Exception{
		SimpleDateFormat dateFormat = new SimpleDateFormat(format);
		return dateFormat.format(input);
	}

	/**
	 * 알파뱃 난수
	 * 입력받은 수 만큼 렌덤 문자를 만들어 반환한다.
	 * @param textSize
	 * @param rmSeed
	 * @return
	 */

	public static String getRandomText(int textSize , Integer rmSeed){
		Random random = new Random(System.currentTimeMillis());
		if(CommonUtils.isEmpty(rmSeed) || rmSeed <= 0){
			rmSeed = random.nextInt(10);
		}
		String rmText = "";
		int rmNum = 0;
		char ch = 'a';
		for (int i = 0; i < textSize; i++) {
			random.setSeed(System.currentTimeMillis() * rmSeed * i + rmSeed + i);
			rmNum = random.nextInt(10);
			ch += rmNum;
			rmText = rmText + ch ;
			ch = 'a';
		}
		return rmText;
	}

}
