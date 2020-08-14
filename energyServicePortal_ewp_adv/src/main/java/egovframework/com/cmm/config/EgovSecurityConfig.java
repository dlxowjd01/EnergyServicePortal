package egovframework.com.cmm.config;

import egovframework.com.cmm.service.EgovUserDetailsService;
import egovframework.com.cmm.service.impl.CustomAuthenticationProvider;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

@Configuration
@EnableWebSecurity
public class EgovSecurityConfig extends WebSecurityConfigurerAdapter {

	@Autowired
	private CustomAuthenticationProvider authProvider;

	@Override
	public void configure(WebSecurity web) throws Exception {
		web.ignoring().antMatchers("/css/**");
		web.ignoring().antMatchers("/font/**");
		web.ignoring().antMatchers("/fonts/**");
		web.ignoring().antMatchers("/img/**");
		web.ignoring().antMatchers("/img@2x/**");
		web.ignoring().antMatchers("/img@3x/**");
		web.ignoring().antMatchers("/img@4x/**");
		web.ignoring().antMatchers("/js/**");
		web.ignoring().antMatchers("/resources/**");
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
				.passwordParameter("password");

		http.logout()
				.logoutRequestMatcher(new AntPathRequestMatcher("/logout.do"))
				.logoutSuccessUrl("/login.do")
				.deleteCookies("JSESSIONID")
				.invalidateHttpSession(true);

		super.configure(http); // 모든 url 막고있음
	}

	@Override
	protected void configure(AuthenticationManagerBuilder auth) throws Exception {
		auth.authenticationProvider(authProvider);
	}
}