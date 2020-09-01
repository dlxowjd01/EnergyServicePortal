package kr.co.esp.common.config;

import kr.co.esp.common.interceptor.LocaleInterceptor;
import kr.co.esp.common.interceptor.PreLoadInterceptor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.FilterType;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartResolver;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;
import org.springframework.web.servlet.ViewResolver;
import org.springframework.web.servlet.config.annotation.*;
import org.springframework.web.servlet.handler.SimpleMappingExceptionResolver;
import org.springframework.web.servlet.i18n.LocaleChangeInterceptor;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;
import org.springframework.web.servlet.mvc.multiaction.NoSuchRequestHandlingMethodException;
import org.springframework.web.servlet.resource.GzipResourceResolver;
import org.springframework.web.servlet.resource.PathResourceResolver;
import org.springframework.web.servlet.view.JstlView;
import org.springframework.web.servlet.view.UrlBasedViewResolver;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

import java.util.Properties;

/**
 * ServletContext 클래스
 * <Notice>
 * 	   DispatcherServlet 설정 파일
 * <Disclaimer>
 *		N/A
 *
 * @author 정재근
 * @since 2020.08.24
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일        수정자           수정내용
 *  -------      -------------  ----------------------
 *   2020.06.24  정재근           최초 생성
 * </pre>
 */
@Configuration
@EnableWebMvc
@ComponentScan(
		basePackages = {"egovframework", "kr.co.esp"},
		includeFilters = {
				@ComponentScan.Filter(type = FilterType.ANNOTATION, classes = Controller.class)
		},
		excludeFilters = {
				@ComponentScan.Filter(type = FilterType.ANNOTATION, classes = Service.class),
				@ComponentScan.Filter(type = FilterType.ANNOTATION, classes = Repository.class)
		}
)
public class ServletContext extends WebMvcConfigurerAdapter {

	@Override
	public void configureDefaultServletHandling (DefaultServletHandlerConfigurer configurer) {
		configurer.enable();
	}

	/**
	 * 루트 Mapping
	 *
	 * @param registry
	 */
	@Override
	public void addViewControllers(ViewControllerRegistry registry) {
		registry.addViewController("/").setViewName("index");
	}

	/**
	 * Interceptor 설정
	 *
	 * @param registry
	 */
	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		//공통 처리 Interceptor
		registry.addInterceptor(new PreLoadInterceptor())
				.addPathPatterns("/*/*.do")
				.addPathPatterns("/*/*.do?**");

		//언어 설정 Interceptor
		registry.addInterceptor(new LocaleInterceptor())
				.addPathPatterns("/*/*.do")
				.addPathPatterns("/*/*.do?**")
				.addPathPatterns("/*.do")
				.addPathPatterns("/*.do?**")
				.addPathPatterns("/login.do")
				.addPathPatterns("/loginUser.do");
	}

	/**
	 * 지역 언어 설정
	 *
	 * @return sessionLocaleResolver
	 */
	@Bean
	public SessionLocaleResolver localeResolver() {
		SessionLocaleResolver sessionLocaleResolver = new SessionLocaleResolver();
		return sessionLocaleResolver;
	}

	/**
	 * 지역 언어 설정 Interceptor
	 *
	 * @param lang
	 * @return localeChangeInterceptor
	 */
	@Bean
	public LocaleChangeInterceptor localeChangeInterceptor() {
		LocaleChangeInterceptor localeChangeInterceptor = new LocaleChangeInterceptor();
		localeChangeInterceptor.setParamName("lang");
		return localeChangeInterceptor;
	}

	/**
	 * Serving of Resources 설정
	 *
	 * @param registry
	 */
	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		registry.addResourceHandler("/css/**").addResourceLocations("/resources/css/")
				.setCachePeriod(3600).resourceChain(true)
				.addResolver(new GzipResourceResolver())
				.addResolver(new PathResourceResolver());
		registry.addResourceHandler("/font/**").addResourceLocations("/resources/font/")
				.setCachePeriod(3600).resourceChain(true)
				.addResolver(new GzipResourceResolver())
				.addResolver(new PathResourceResolver());
		registry.addResourceHandler("/fonts/**").addResourceLocations("/resources/fonts/")
				.setCachePeriod(3600).resourceChain(true)
				.addResolver(new GzipResourceResolver())
				.addResolver(new PathResourceResolver());
		registry.addResourceHandler("/img/**").addResourceLocations("/resources/img/")
				.setCachePeriod(3600).resourceChain(true)
				.addResolver(new GzipResourceResolver())
				.addResolver(new PathResourceResolver());
		registry.addResourceHandler("/js/**").addResourceLocations("/resources/js/")
				.setCachePeriod(3600).resourceChain(true)
				.addResolver(new GzipResourceResolver())
				.addResolver(new PathResourceResolver());
		registry.addResourceHandler("/favicon.ico").addResourceLocations("/resources/favicon.ico")
				.setCachePeriod(3600).resourceChain(true)
				.addResolver(new GzipResourceResolver())
				.addResolver(new PathResourceResolver());
		registry.addResourceHandler("/resources/**").addResourceLocations("/resources/")
				.setCachePeriod(3600).resourceChain(true)
				.addResolver(new GzipResourceResolver())
				.addResolver(new PathResourceResolver());
		registry.addResourceHandler("/*.jsp").addResourceLocations("/WEB-INF/jsp/");
	}

	/**
	 * Exception 정의 설정
	 *
	 * @return SimpleMappingExceptionResolver
	 */
	@Bean
	public SimpleMappingExceptionResolver simpleMappingExceptionResolver() {
		SimpleMappingExceptionResolver smer = new SimpleMappingExceptionResolver();

		smer.setDefaultErrorView("/esp/404");
		smer.setDefaultStatusCode(200);
		smer.setExceptionAttribute("exception");

		Properties mappings = new Properties();
		mappings.setProperty("egovframework.rte.fdl.cmmn.exception.EgovBizException", "eegovframework/com/cmm/error/egovBizException");
		mappings.setProperty("org.springframework.web.HttpSessionRequiredException", "egovframework/com/uat/uia/EgovLoginUsr");
		mappings.setProperty("egovframework.com.cmm.exception.EgovXssException", "egovframework/com/cmm/error/EgovXssException");
		mappings.setProperty("NoSuchRequestHandlingMethodException", "/esp/404");

		Properties statusCodes = new Properties();
		statusCodes.setProperty("common/error/securityError", "403");
		statusCodes.setProperty("common/error/businessError", "200");
		statusCodes.setProperty("common/error/ajaxError", "200");

		return smer;
	}

	/**
	 * ViewResolver 설정
	 *
	 * @return
	 */
	@Bean
	public ViewResolver viewResolver() {
		UrlBasedViewResolver resolver = new UrlBasedViewResolver();
		resolver.setViewClass(JstlView.class);
		resolver.setPrefix("/WEB-INF/jsp/");
		resolver.setOrder(1);
		resolver.setSuffix(".jsp");
		return resolver;
	}

	/**
	 * Jackson2JsonView 세팅
	 *
	 * @return MappingJackson2JsonView
	 */
	@Bean
	MappingJackson2JsonView jsonView() {
		return new MappingJackson2JsonView();
	}

	/**
	 * MultipartResolver 세팅
	 *
	 * @return CommonsMultipartResolver
	 */
	@Bean
	public MultipartResolver multipartResolver() {
		CommonsMultipartResolver resolver = new CommonsMultipartResolver();
		resolver.setMaxInMemorySize(100000000);
		resolver.setMaxUploadSize(600000000);
		return resolver;
	}
}
