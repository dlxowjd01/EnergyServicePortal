package kr.co.esp.common.util;

import org.apache.http.client.protocol.HttpClientContext;
import org.apache.http.conn.ssl.NoopHostnameVerifier;
import org.apache.http.conn.ssl.SSLConnectionSocketFactory;
import org.apache.http.conn.ssl.TrustStrategy;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.*;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import javax.net.ssl.SSLContext;
import java.net.URI;
import java.nio.charset.Charset;
import java.security.KeyManagementException;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;

public class HttpUtil {
	private static final Logger logger = LoggerFactory.getLogger(HttpUtil.class);

	public static RestTemplate getRestTemplate(final HttpClientContext context) {
		RestTemplate restOperations = null;
		try {
			// 2019.03.08 이우람 추가
			// 인증무시기능 start
			TrustStrategy acceptingTrustStrategy = new TrustStrategy() {
				public boolean isTrusted(X509Certificate[] chain, String authType) throws CertificateException {
					return true;
				}
			};
			SSLContext sslContext = org.apache.http.ssl.SSLContexts.custom().loadTrustMaterial(null, acceptingTrustStrategy).build();
			SSLConnectionSocketFactory csf = new SSLConnectionSocketFactory(sslContext, new NoopHostnameVerifier());
			CloseableHttpClient httpClient = HttpClients.custom().setSSLSocketFactory(csf).build();
			// 인증무시기능 end

			HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory();
			factory.setReadTimeout(60000); // milliseconds
			factory.setHttpClient(httpClient); // 2019.03.08 이우람 추가
			restOperations = new RestTemplate(factory);
//		restOperations.setRequestFactory(new HttpComponentsClientHttpRequestFactory() {
//		  @Override
//		  protected HttpContext createHttpContext(HttpMethod httpMethod, URI uri) {
//			if (context.getAttribute(HttpClientContext.COOKIE_STORE) == null) {
//			  context.setAttribute(HttpClientContext.COOKIE_STORE, new BasicCookieStore());
//			  Builder builder = RequestConfig.custom()
//				  // .setCookieSpec(CookieSpecs.IGNORE_COOKIES)
//				  // .setAuthenticationEnabled(false)
//				  .setRedirectsEnabled(false);
//			  context.setRequestConfig(builder.build());
//			}
//			return context;
//		  }
//		});
		} catch (KeyManagementException e) {
			e.printStackTrace();
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		} catch (KeyStoreException e) {
			e.printStackTrace();
		}

		return restOperations;
	}

	public static HttpHeaders getHeaders() {
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept-Encoding", "gzip, deflate, sdch");
		headers.set("Connection", "keep-alive");
		headers.set("Accept-Language", "ko-KR,ko;q=0.8,en-US;q=0.6,en;q=0.4");
		headers.set("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8");
		headers.set("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.115 Safari/537.36");
		return headers;
	}

	/**
	 * 보안문자 이미지 호출
	 *
	 * @param sessionId
	 * @return
	 */
	public static byte[] download(String url) {
		HttpClientContext context = HttpClientContext.create();
		RestTemplate restOperations = HttpUtil.getRestTemplate(context);
		HttpHeaders headers = HttpUtil.getHeaders();
		ResponseEntity<byte[]> exchange = restOperations.exchange(url, HttpMethod.GET, new HttpEntity<MultiValueMap<String, Object>>(headers), byte[].class);
		HttpStatus statusCode = exchange.getStatusCode();
		ValidateUtil.isTrue(statusCode == HttpStatus.OK, null, "status code:" + statusCode);
		return exchange.getBody();
	}

	/**
	 * POST 요청
	 *
	 * @param context
	 * @param twsid
	 * @param answer
	 * @return
	 */
	public static String post(String url, MultiValueMap<String, Object> parts, String charset) {
		logger.debug("url:{}, param:{}, charset:{}", new Object[]{url, parts, charset});
		HttpClientContext context = HttpClientContext.create();
		RestTemplate restOperations = HttpUtil.getRestTemplate(context);
		restOperations.getMessageConverters().add(0, new StringHttpMessageConverter(Charset.forName(charset)));
		HttpHeaders headers = HttpUtil.getHeaders();
		ResponseEntity<String> exchange = restOperations.exchange(url, HttpMethod.POST, new HttpEntity<MultiValueMap<String, Object>>(parts, headers), String.class);
		String body = exchange.getBody();
		HttpStatus statusCode = exchange.getStatusCode();
		if (statusCode != HttpStatus.OK) {
			logger.warn("%s - status : {}", url, statusCode);
		}

		return body;
	}

	public static String post(String url, HttpHeaders headers, String requestBody) {
		logger.debug("url:{},  body:{}", new Object[]{url, requestBody});
		HttpClientContext context = HttpClientContext.create();
		RestTemplate restOperations = HttpUtil.getRestTemplate(context);

		HttpEntity<String> entity = new HttpEntity<String>(requestBody, headers);
		ResponseEntity<String> exchange = restOperations.exchange(url, HttpMethod.POST, entity, String.class);
		String body = exchange.getBody();
		HttpStatus statusCode = exchange.getStatusCode();
		if (statusCode != HttpStatus.OK) {
			logger.warn("%s - status : {}", url, statusCode);
		}

		return body;
	}

	public static String post(String url, MultiValueMap<String, Object> parts) {
		return post(url, parts, "UTF-8");
	}

	public static String get(String url) {
		return get(url, HttpUtil.getHeaders());
	}

	public static String get(String url, HttpHeaders headers) {
		HttpClientContext context = HttpClientContext.create();
		RestTemplate restOperations = HttpUtil.getRestTemplate(context);
		restOperations.getMessageConverters().add(0, new StringHttpMessageConverter(Charset.forName("UTF-8")));
		ResponseEntity<String> exchange = restOperations.exchange(URI.create(url), HttpMethod.GET, new HttpEntity<Object>(headers), String.class);
		HttpStatus statusCode = exchange.getStatusCode();
		if (statusCode != HttpStatus.OK) {
			logger.warn("{} - status : {}", url, statusCode);
		}
		return exchange.getBody();
	}
}
