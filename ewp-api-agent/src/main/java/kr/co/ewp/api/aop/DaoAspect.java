package kr.co.ewp.api.aop;

import java.util.ArrayList;
import java.util.List;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.aop.framework.Advised;
import org.springframework.aop.support.AopUtils;
import org.springframework.util.StopWatch;

import kr.co.ewp.api.config.Constants;
import kr.co.ewp.api.util.JsonUtil;
import kr.co.ewp.api.util.PrettyLog;

@Aspect
public class DaoAspect {
  Logger logger = LoggerFactory.getLogger(DaoAspect.class);

  @Around("execution(* " + Constants.PACKAGE_BASE + ".dao..*.*(..))")
  public Object commonDao(ProceedingJoinPoint joinPoint) throws Throwable {
    StopWatch stopWatch = new StopWatch();
    stopWatch.start();

    String methodName = joinPoint.getSignature().getName();
    PrettyLog prettyLog = null;
    List<Object> args = new ArrayList<Object>();
    for (Object arg : joinPoint.getArgs()) {
      if ((arg instanceof PrettyLog) == false) {
        args.add(arg);
      } else {
        prettyLog = (PrettyLog) arg;
      }
    }
    if (prettyLog != null) {
      prettyLog.start(String.format("%s,%s,%s", "DAO", getTargetObject(joinPoint.getThis()), methodName));
      prettyLog.append("PARAM", JsonUtil.toJson(args));
    }
    Object retVal = null;
    try {
      retVal = joinPoint.proceed();
      return retVal;
    } catch (Exception e) {
      if (prettyLog != null) {
        prettyLog.append("EXCEPTION", e == null ? "null" : e.getMessage());
      }
      throw e;
    } finally {
      if (prettyLog != null) {
        if (logger.isDebugEnabled()) {
          prettyLog.append("RESPONSE", JsonUtil.toJson(retVal));
        }
        prettyLog.stop();
      }
    }
  }

  protected String getTargetObject(Object proxy) throws Exception {
    if (AopUtils.isJdkDynamicProxy(proxy)) {
      return (((Advised) proxy).getProxiedInterfaces())[0].getSimpleName();
    } else {
      return proxy.toString();
    }
  }
}
