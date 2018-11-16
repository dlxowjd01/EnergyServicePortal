package kr.co.ewp.api.config;

import kr.co.ewp.api.util.SystemProperties;

public class Constants {
  public static final String PACKAGE_BASE = "kr.co.ewp.api";
  public static final String ENERTALK_API_AUTH = SystemProperties.getProperty("ENERTALK_API_AUTH");
  public static final String PRETTY_LOGGER_NAME = "PRETTYL_LOG";
  public static final String CONTEXT_PATH = "";
  public static final String ENCORED_API_URL = SystemProperties.getProperty("ENCORED_API_URL");
  public static final String ENERTALK_API_URL = SystemProperties.getProperty("ENERTALK_API_URL");
}
