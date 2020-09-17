package kr.co.esp.common.config;

import kr.co.esp.common.service.impl.CustomAuthenticationProvider;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

/**
 * SecurityConfig 클래스
 * <Notice>
 * 	   스프링 시큐리티 설정
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
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {

	@Autowired
	CustomAuthenticationProvider authProvider;

	@Override
	public void configure(WebSecurity web) {
		web.ignoring().antMatchers("/css/**",
												"/font/**",
												"/fonts/**",
												"/img/**",
												"/img@2x/**",
												"/img@3x/**",
												"/img@4x/**",
												"/js/**",
												"/resources/**");
		web.ignoring().regexMatchers("\\A/WEB-INF/jsp/.*\\Z");
	}

	@Override
	protected void configure(HttpSecurity http) throws Exception {
		http.csrf().disable();
		http.formLogin()
			.loginPage("/login.do").permitAll()
			.loginProcessingUrl("/loginUser.do")
			.failureUrl("/loginFailure.do")
			.defaultSuccessUrl("/loginSuccess.do", true)
			.usernameParameter("login_id")
			.passwordParameter("password")
			.and()
			.logout()
			.logoutRequestMatcher(new AntPathRequestMatcher("/logout.do"))
			.logoutSuccessUrl("/login.do").permitAll()
			.deleteCookies("JSESSIONID")
			.invalidateHttpSession(true);

		super.configure(http); // 모든 url 막고있음
	}

	@Override
	protected void configure(AuthenticationManagerBuilder auth) throws Exception {
		auth.authenticationProvider(authProvider);
	}
}