package kr.co.ewp.api.aop;

import java.util.ArrayList;
import java.util.List;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;

import kr.co.ewp.api.config.Constants;
import kr.co.ewp.api.exception.MsgException;
import kr.co.ewp.api.util.JsonUtil;
import kr.co.ewp.api.util.PrettyLog;

@Aspect
public class ServiceAspect {
  Logger logger = LoggerFactory.getLogger(ServiceAspect.class);

  @Around("execution(* " + Constants.PACKAGE_BASE + ".service..*.*(..)) ")
  public Object commonService(ProceedingJoinPoint joinPoint) throws Throwable {
    String methodName = joinPoint.getSignature().getName();
    PrettyLog prettyLog = null;
    List<Object> args = new ArrayList<Object>();
    for (Object arg : joinPoint.getArgs()) {
      if (arg instanceof PageRequest) {
        args.add(arg.toString());
      } else if ((arg instanceof PrettyLog) == false) {
        args.add(arg);
      } else {
        prettyLog = (PrettyLog) arg;
      }
    }
    Object retVal = null;
    try {
      if (prettyLog != null) {
        prettyLog
            .start(String.format("%s,%s,%s", "SERVICE", joinPoint.getTarget().getClass().getSimpleName(), methodName));
        prettyLog.append("PARAM", JsonUtil.toJson(args));
      }
      retVal = joinPoint.proceed();
      return retVal;
    } catch (NullPointerException e) {
    	  logger.error("error is : "+e.toString());
    	  throw e;
    } catch (Exception e) {
      // 2017.09.29 보안수정 RH.Jung PMD-AvoidCatchingGenericException
      // } catch (MsgException e) {
      if (prettyLog != null) {
        String msg = "Null";

        if (e != null) {
          msg = e.getMessage();
          if (e instanceof MsgException) {
            String customCause = ((MsgException) e).getCustomCause();
            if (customCause != null) {
              msg += "(" + customCause + ")";
            }
          }
        }
        prettyLog.append("EXCEPTION", msg);
      }
      throw e;
    } finally {
      if (prettyLog != null) {
        if (logger.isDebugEnabled()) {
          if (retVal instanceof PageImpl) {
            prettyLog.append("RESPONSE", ((PageImpl<?>) retVal).toString());
          } else {
            prettyLog.append("RESPONSE", JsonUtil.toJson(retVal));
          }
        }
        prettyLog.stop();
      }
    }
  }
}
