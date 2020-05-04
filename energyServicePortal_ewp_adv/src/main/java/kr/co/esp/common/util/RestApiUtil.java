package kr.co.esp.common.util;

import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class RestApiUtil {
	private static final Logger logger = LoggerFactory.getLogger(RestApiUtil.class);

	/**
	 *
	 * @param strUrl
	 * @param json
	 * @return
	 */
	public static Map<String, Object> get(String strUrl, String json) {
		return post(strUrl, json, null);
	}

	public static Map<String, Object> get(String strUrl, String json, String token) {
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		try {
			URL url = new URL("http://iderms.enertalk.com:8443" + strUrl);
			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			con.setConnectTimeout(5000); //서버에 연결되는 Timeout 시간 설정
			con.setReadTimeout(5000); // InputStream 읽어 오는 Timeout 시간 설정
			con.setRequestMethod("GET");
			if(token != null && !"".equals(token)) {
				con.setRequestProperty("Authorization", "Bearer " + token);
			}

			con.setDoOutput(false);

			StringBuilder sb = new StringBuilder();
			if (con.getResponseCode() == HttpURLConnection.HTTP_OK) {
				BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
				String line;
				while ((line = br.readLine()) != null) {
					sb.append(line).append("\n");
				}
				br.close();

				ObjectMapper mapper = new ObjectMapper();
				if(sb.toString().startsWith("[")) {
					List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
					list = mapper.readValue(sb.toString(), new TypeReference<List<Map<String, Object>>>(){});
					rtnMap.put("data", list);
				} else {
					Map<String, Object> map = new HashMap<String, Object>();
					map = mapper.readValue(sb.toString(), new TypeReference<Map<String, Object>>(){});
					rtnMap.put("data", map);
				}

				rtnMap.put("code", con.getResponseCode());
				rtnMap.put("msg", con.getResponseMessage());
			} else {
				rtnMap.put("data", null);
				rtnMap.put("code", con.getResponseCode());
				rtnMap.put("msg", con.getResponseMessage());
			}
		} catch (Exception e) {
			System.err.println(e.toString());
			rtnMap.put("data", null);
			rtnMap.put("code", "");
			rtnMap.put("msg", e.toString());
		}

		return rtnMap;
	}


	/**
	 *
	 * @param strUrl
	 * @param jsonMessage
	 * @return
	 */
	public static Map<String, Object> post(String strUrl, String jsonMessage) {
		return post(strUrl, jsonMessage, null);
	}

	/**
	 * API POST 처리
	 *
	 * @param strUrl
	 * @param jsonMessage
	 * @return
	 */
	public static Map<String, Object> post(String strUrl, String jsonMessage, String token) {
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		try {
			URL url = new URL("http://iderms.enertalk.com:8443" + strUrl);
			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			con.setConnectTimeout(5000); //서버에 연결되는 Timeout 시간 설정
			con.setReadTimeout(5000); // InputStream 읽어 오는 Timeout 시간 설정
			con.setRequestMethod("POST");
			if(token != null && !"".equals(token)) {
				con.setRequestProperty("Authorization", "Bearer " + token);
			}

			//json으로 message를 전달하고자 할 때
			con.setRequestProperty("Content-Type", "application/json");
			con.setDoInput(true);
			con.setDoOutput(true); //POST 데이터를 OutputStream으로 넘겨 주겠다는 설정
			con.setUseCaches(false);
			con.setDefaultUseCaches(false);

			OutputStreamWriter wr = new OutputStreamWriter(con.getOutputStream());
			wr.write(jsonMessage); //json 형식의 message 전달
			wr.flush();

			StringBuilder sb = new StringBuilder();
			if (con.getResponseCode() == HttpURLConnection.HTTP_OK) {
				BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
				String line;
				while ((line = br.readLine()) != null) {
					sb.append(line).append("\n");
				}
				br.close();

				ObjectMapper mapper = new ObjectMapper();
				if(sb.toString().startsWith("[")) {
					List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
					list = mapper.readValue(sb.toString(), new TypeReference<List<Map<String, Object>>>(){});
					rtnMap.put("data", list);
				} else {
					Map<String, Object> map = new HashMap<String, Object>();
					map = mapper.readValue(sb.toString(), new TypeReference<Map<String, Object>>(){});
					rtnMap.put("data", map);
				}

				rtnMap.put("code", con.getResponseCode());
				rtnMap.put("msg", con.getResponseMessage());
			} else {
				rtnMap.put("data", null);
				rtnMap.put("code", con.getResponseCode());
				rtnMap.put("msg", con.getResponseMessage());
			}
		} catch (Exception e){
			System.err.println(e.toString());
			rtnMap.put("data", null);
			rtnMap.put("code", "");
			rtnMap.put("msg", e.toString());
		}

		return rtnMap;
	}
}
