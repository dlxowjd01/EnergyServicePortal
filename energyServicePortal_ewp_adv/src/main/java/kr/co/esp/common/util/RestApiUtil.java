package kr.co.esp.common.util;

import egovframework.com.cmm.service.EgovProperties;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.codehaus.jettison.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

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

@Component
public class RestApiUtil {
	private static final Logger logger = LoggerFactory.getLogger(RestApiUtil.class);

	private static final String apiHost = EgovProperties.getProperty("servletApiHost");
	private static final String apiHostTest = EgovProperties.getProperty("servletApiHostTest");

	/**
	 * GET
	 *
	 * @param strUrl
	 * @param mode
	 * @param parameters
	 * @return
	 */
	public static Map<String, Object> get(String strUrl, String mode, Map<String, Object> parameters) {
		if (mode != null && "test".equals(mode)) {
			return basicGet(strUrl, parameters, null);
		} else {
			return secureGet(strUrl, toStringParameter(parameters), null);
		}
	}

	/**
	 * GET
	 *
	 * @param strUrl
	 * @param mode
	 * @param parameters
	 * @param token
	 * @return
	 */
	public static Map<String, Object> get(String strUrl, String mode, Map<String, Object> parameters, String token) {
		if (mode != null && "test".equals(mode)) {
			return basicGet(strUrl, parameters, token);
		} else {
			return secureGet(strUrl, toStringParameter(parameters), token);
		}
	}

	public static Map<String, Object> basicGet(String strUrl, Map<String, Object> parameters, String token) {
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		try {
			URI uri = new URI(apiHostTest + strUrl);
			if (parameters != null) {
				uri = applyParameters(uri, parameters);
			}

			HttpURLConnection con = (HttpURLConnection) uri.toURL().openConnection();
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

	public static Map<String, Object> secureGet(String strUrl, String parameters, String token) {
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		try {
			TrustManager[] trustAllCerts = new TrustManager[] { new X509TrustManager() {
				public X509Certificate[] getAcceptedIssuers() { return null; }
				public void checkClientTrusted(X509Certificate[] certs, String authType) { }
				public void checkServerTrusted(X509Certificate[] certs, String authType) { }
			}};

			SSLContext sc = SSLContext.getInstance("SSL");
			sc.init(null, trustAllCerts, new SecureRandom());

			URL url = new URL(apiHost + strUrl);

			HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
			HttpsURLConnection con = (HttpsURLConnection) new URL("https://iderms-api.iderms.ai" + strUrl + parameters).openConnection();
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
			URL url = new URL(apiHostTest + strUrl);
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

	private static URI applyParameters(URI baseUri, Map<String, Object> urlParameters) {
		try {
			return new URI(baseUri.getScheme(), baseUri.getAuthority(), baseUri.getPath(), toStringParameter(urlParameters), null);
		} catch (URISyntaxException ex) {
			throw new RuntimeException(ex);
		}
	}

	private static String toStringParameter(Map<String, Object> urlParameters) {
		StringBuilder query = new StringBuilder();
		for (Map.Entry<String, Object> elem : urlParameters.entrySet()) {
			if (query.length() > 1) {
				query.append("&");
			}
			query.append(elem.getKey()).append("=").append(elem.getValue());
		}

		return query.toString();
	}
}
