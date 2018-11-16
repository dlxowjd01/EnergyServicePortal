package kr.co.ewp.api.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import kr.co.ewp.api.aop.ControllerAspect;
import kr.co.ewp.api.aop.DaoAspect;
import kr.co.ewp.api.aop.ServiceAspect;

@Configuration
public class AopConfig {

  @Bean
  public ControllerAspect controllerAspect() {
    return new ControllerAspect();
  }

  @Bean
  public DaoAspect daoAspect() {
    return new DaoAspect();
  }

  @Bean
  public ServiceAspect serviceAspect() {
    return new ServiceAspect();
  }
}
