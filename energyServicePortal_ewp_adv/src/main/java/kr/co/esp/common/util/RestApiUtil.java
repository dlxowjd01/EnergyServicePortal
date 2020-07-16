package kr.co.esp.common.util;

import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import java.io.*;
import java.net.*;
import java.security.SecureRandom;
import java.security.cert.X509Certificate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class RestApiUtil {
	private static final Logger logger = LoggerFactory.getLogger(RestApiUtil.class);

	/**
	 * @param strUrl
	 * @param parameters
	 * @return
	 */
	public static Map<String, Object> get(String strUrl, String mode, Map<String, String> parameters) {
		return get(strUrl, mode, parameters, null);
	}

	public static Map<String, Object> get(String strUrl, String mode, Map<String, String> parameters, String token) {
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		try {
			TrustManager[] trustAllCerts = new TrustManager[] { new X509TrustManager() {
				public X509Certificate[] getAcceptedIssuers() { return null; }
				public void checkClientTrusted(X509Certificate[] certs, String authType) { }
				public void checkServerTrusted(X509Certificate[] certs, String authType) { }
			}};

			SSLContext sc = SSLContext.getInstance("SSL");
			sc.init(null, trustAllCerts, new SecureRandom());

<<<<<<< HEAD
			TrustManager[] trustAllCerts = new TrustManager[] { new X509TrustManager() {
				public X509Certificate[] getAcceptedIssuers() { return null; }
				public void checkClientTrusted(X509Certificate[] certs, String authType) { }
				public void checkServerTrusted(X509Certificate[] certs, String authType) { }
			}};

			SSLContext sc = SSLContext.getInstance("SSL");
			sc.init(null, trustAllCerts, new SecureRandom());

=======
>>>>>>> 4560ef863b891137a5a43156a7d1bd39a6d32917
			HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
			HttpsURLConnection con = (HttpsURLConnection) new URL("https://iderms-api.iderms.ai" + strUrl).openConnection();
			con.setConnectTimeout(5000); //서버에 연결되는 Timeout 시간 설정
			con.setReadTimeout(5000); // InputStream 읽어 오는 Timeout 시간 설정
			con.setRequestMethod("GET");
			con.setRequestProperty("Content-Type", "application/json");
			con.setRequestProperty("Cache-Control", "no-cache");
			if (token != null && !"".equals(token)) {
				con.setRequestProperty("Authorization", "Bearer " + token);
			}

			StringBuilder sb = new StringBuilder();
			if (con.getResponseCode() == HttpURLConnection.HTTP_OK) {
				BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
				String line;
				while ((line = br.readLine()) != null) {
					sb.append(line).append("\n");
				}
				br.close();

				ObjectMapper mapper = new ObjectMapper();
				if (sb.toString().startsWith("[")) {
					List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
					list = mapper.readValue(sb.toString(), new TypeReference<List<Map<String, Object>>>() {
					});
					rtnMap.put("data", list);
				} else {
					Map<String, Object> map = new HashMap<String, Object>();
					map = mapper.readValue(sb.toString(), new TypeReference<Map<String, Object>>() {
					});
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
	 * @param strUrl
	 * @param jsonMessage
	 * @return
	 */
	public static Map<String, Object> post(String strUrl, String mode, String jsonMessage) {
		return post(strUrl, mode, jsonMessage, null);
	}

	/**
	 * API POST 처리
	 *
	 * @param strUrl
	 * @param jsonMessage
	 * @return
	 */
	public static Map<String, Object> post(String strUrl, String mode, String jsonMessage, String token) {
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		try {
			String postUrl = "https://iderms-api.iderms.ai";
//			if (mode != null && "test".equals(mode)) {
//				postUrl = "http://iderms.enertalk-test.com:8443";
//			}
			URL url = new URL(postUrl + strUrl);
			HttpsURLConnection con = (HttpsURLConnection) url.openConnection();
			con.setConnectTimeout(5000); //서버에 연결되는 Timeout 시간 설정
			con.setReadTimeout(5000); // InputStream 읽어 오는 Timeout 시간 설정
			con.setRequestMethod("POST");
			if (token != null && !"".equals(token)) {
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
				if (sb.toString().startsWith("[")) {
					List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
					list = mapper.readValue(sb.toString(), new TypeReference<List<Map<String, Object>>>() {
					});
					rtnMap.put("data", list);
				} else {
					Map<String, Object> map = new HashMap<String, Object>();
					map = mapper.readValue(sb.toString(), new TypeReference<Map<String, Object>>() {
					});
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

	private static URI applyParameters(URI baseUri, Map<String, String> urlParameters) {
		StringBuilder query = new StringBuilder();

		for (Map.Entry<String, String> elem : urlParameters.entrySet()) {
			if (query.length() > 1) {
				query.append("&");
			}
			query.append(elem.getKey()).append("=").append(elem.getValue());
		}

		try {
			return new URI(baseUri.getScheme(), baseUri.getAuthority(), baseUri.getPath(), query.toString(), null);
		} catch (URISyntaxException ex) {
			throw new RuntimeException(ex);
		}
	}
}
