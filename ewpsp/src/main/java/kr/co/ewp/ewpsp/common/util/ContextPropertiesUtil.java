package kr.co.ewp.ewpsp.common.util;

import org.springframework.core.io.FileSystemResourceLoader;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Component;

import java.io.InputStream;
import java.util.Properties;

@Component("prop")
public class ContextPropertiesUtil {
    private Properties propFile;

    public void setPropFile(String proFile) throws Exception {
        FileSystemResourceLoader fsrl = new FileSystemResourceLoader();
        Resource propResource = fsrl.getResource(proFile);
        InputStream is = propResource.getInputStream();
        propFile = new Properties();
        propFile.load(is);
    }

    public String get(String key) {
        if (propFile != null) {
            return propFile.getProperty(key);
        }

        return "";
    }

}
