package kr.co.ewp.api.util;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class SystemProperties {
  private static SystemProperties systemProperties = new SystemProperties();
  private static Logger logger = LoggerFactory.getLogger(SystemProperties.class);

  private Properties properties = null;

  public static String getProperty(String key) {
    String property = systemProperties.properties.getProperty(key);
    if (property == null)
      throw new RuntimeException(key + " can not found.");
    return property;
  }

  public static String getProperty(String key, String defaultValue) {
    String property = systemProperties.properties.getProperty(key);
    if (property == null)
      return defaultValue;
    return property;
  }

  public SystemProperties() {
    properties = new Properties();
    InputStream is = null;
    try {
      String systemConfigFilePath = System.getProperty("system.config");
      if (systemConfigFilePath == null) {
        is = SystemProperties.class.getResourceAsStream("/system.properties");
      } else {
        is = new FileInputStream(systemConfigFilePath);
      }
      properties.load(is);
    } catch (IOException e) {
      logger.error(e.getMessage(), e);
    } finally{
    	try {
    		if(is != null){
    			is.close();
    		}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			logger.error(e.getMessage(), e);
		}
    }
  }

  public Properties getProperties() {
    return properties;
  }

  public void setProperties(Properties properties) {
    this.properties = properties;
  }
}
