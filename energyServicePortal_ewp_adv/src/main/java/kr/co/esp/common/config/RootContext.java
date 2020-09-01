package kr.co.esp.common.config;

import egovframework.rte.fdl.cmmn.trace.LeaveaTrace;
import egovframework.rte.fdl.cmmn.trace.handler.DefaultTraceHandler;
import egovframework.rte.fdl.cmmn.trace.handler.TraceHandler;
import egovframework.rte.fdl.cmmn.trace.manager.DefaultTraceHandleManager;
import egovframework.rte.fdl.cmmn.trace.manager.TraceHandlerService;
import kr.co.esp.common.service.EgovMessageSource;
import kr.co.esp.common.util.EgovWildcardReloadableResourceBundleMessageSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.FilterType;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;
import org.springframework.util.AntPathMatcher;

/**
 * RootContext 클래스
 * <Notice>
 * 	   스프링 공통 설정
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
@ComponentScan(
		basePackages = {"egovframework", "kr.co.esp"},
		includeFilters = {
				@ComponentScan.Filter(type = FilterType.ANNOTATION, classes = Service.class),
				@ComponentScan.Filter(type = FilterType.ANNOTATION, classes = Repository.class)
		},
		excludeFilters = {
				@ComponentScan.Filter(type = FilterType.ANNOTATION, classes = Controller.class)
		}
)
public class RootContext {

	/**
	 * 국제화 Message 설정
	 *
	 * @return
	 */
	@Bean
	public EgovWildcardReloadableResourceBundleMessageSource messageSource() {
		EgovWildcardReloadableResourceBundleMessageSource messageSource = new EgovWildcardReloadableResourceBundleMessageSource();
		messageSource.setEgovBasenames(new String[]{
				"classpath*:/kr/co/esp/message/com/**/*",
				"classpath:/kr/co/esp/egovProps/globals",
				"classpath:/kr/co/esp/message/esp/message-common"
		});
		messageSource.setCacheSeconds(60);

		return messageSource;
	}

	/**
	 *
	 *
	 * @param messageSource
	 * @return
	 */
	@Bean
	public EgovMessageSource egovMessageSource(EgovWildcardReloadableResourceBundleMessageSource messageSource) {
		EgovMessageSource egovMsgSrc = new EgovMessageSource();
		egovMsgSrc.setReloadableResourceBundleMessageSource(messageSource);
		return egovMsgSrc;
	}

	/**
	 *
	 *
	 * @param traceHandlerService
	 * @return
	 */
	@Bean
	public LeaveaTrace leaveaTrace(DefaultTraceHandleManager traceHandlerService) {
		LeaveaTrace leaveaTrace = new LeaveaTrace();
		leaveaTrace.setTraceHandlerServices(new TraceHandlerService[]{traceHandlerService});
		return leaveaTrace;
	}

	/**
	 *
	 *
	 * @param defaultTraceHandler
	 * @return
	 */
	@Bean
	public DefaultTraceHandleManager traceHandlerService(AntPathMatcher antPathMatcher, DefaultTraceHandler defaultTraceHandler) {
		DefaultTraceHandleManager defaultTraceHandleManager = new DefaultTraceHandleManager();
		defaultTraceHandleManager.setPatterns(new String[]{"0"});
		defaultTraceHandleManager.setHandlers(new TraceHandler[]{defaultTraceHandler});
		return defaultTraceHandleManager;
	}

	/**
	 *
	 *
	 * @return
	 */
	@Bean
	public AntPathMatcher antPathMatcher() { return new AntPathMatcher(); }

	/**
	 *
	 *
	 * @return
	 */
	@Bean
	public DefaultTraceHandler defaultTraceHandler() { return new DefaultTraceHandler(); }
}
