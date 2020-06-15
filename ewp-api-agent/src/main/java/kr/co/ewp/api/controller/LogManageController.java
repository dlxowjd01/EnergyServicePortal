package kr.co.ewp.api.controller;

import java.io.File;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import org.springframework.stereotype.Component;

import kr.co.ewp.api.util.PrettyLog;

@Component
public class LogManageController {
	
	public void logManagement(PrettyLog prettyLog) {
		prettyLog.title("로그파일 관리");
		Date today = new Date();
		
		String realPath = "";
		if(LogManageController.class.getResource("") != null){
			realPath = LogManageController.class.getResource("").getPath();
		}
		prettyLog.append("realPath  ", realPath);
		String path[] = realPath.split("ewpsp_batch");
		String _realPath = path[0].replace("file:", "")+"ewpsp_batch"+File.separator+"logs";
		prettyLog.append("_realPath  ", _realPath);
		
		File dirFile = new File(_realPath);
		File [] fileList = dirFile.listFiles();
		String substringTxt = "ewp-api.";
		int deleteCnt = 0;
		if(fileList != null){
			
			for(File tempFile : fileList) {
				if(tempFile.isFile()) {
					String tempFileName = tempFile.getName();
					prettyLog.append("FileName=", tempFileName);
					
					int extIdx = tempFileName.lastIndexOf(".");
					String _tempFileName = tempFileName.substring(0, extIdx);
					String __tempFileName = _tempFileName.replaceAll(substringTxt, "");
					
					int logDate_yyyy = Integer.parseInt(__tempFileName.substring(0, 4));
					int logDate_MM = Integer.parseInt(__tempFileName.substring(4, 6));
					int logDate_dd = Integer.parseInt(__tempFileName.substring(6, 8));
					
					Calendar cal = Calendar.getInstance();
					cal.set(logDate_yyyy, logDate_MM-1, logDate_dd);
					cal.set(Calendar.MILLISECOND, 0);
					Date logDate = cal.getTime();
					
					long calDate = today.getTime()-logDate.getTime();
					long calDateDays = calDate / ( 24*60*60*1000 ); 
					
					if(calDateDays > 7) {
						tempFile.delete();
						prettyLog.append(tempFileName, " : The file was deleted from the server after the storage period.");
						deleteCnt++;
					}
					
				}
			}
		}

		prettyLog.append("---------------------------------------------------", "");
		if(fileList !=null){
			
			for(File tempFile : fileList) {
				if(tempFile.isFile()) {
					String tempFileName = tempFile.getName();
					prettyLog.append("final FileName=", tempFileName);
					
				}
			}
		}
		
		prettyLog.append("DELETE_CNT", deleteCnt);
	}
}
