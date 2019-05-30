package kr.co.ewp.ewpsp.web;

import org.springframework.context.MessageSource;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;

import java.util.Locale;

public class EgovMessageSource extends ReloadableResourceBundleMessageSource implements MessageSource {

    private ReloadableResourceBundleMessageSource reloadableResourceBundleMessageSource;

    /**
     * getReloadableResourceBundleMessageSource()
     *
     * @return ReloadableResourceBundleMessageSource
     */
    public ReloadableResourceBundleMessageSource getReloadableResourceBundleMessageSource() {
        return reloadableResourceBundleMessageSource;
    }

    /**
     * getReloadableResourceBundleMessageSource()
     *
     * @param reloadableResourceBundleMessageSource - resource MessageSource
     * @return ReloadableResourceBundleMessageSource
     */
    public void setReloadableResourceBundleMessageSource(ReloadableResourceBundleMessageSource reloadableResourceBundleMessageSource) {
        this.reloadableResourceBundleMessageSource = reloadableResourceBundleMessageSource;
    }

    /**
     * 정의된 메세지 조회
     *
     * @param code - 메세지 코드
     * @return String
     */
    public String getMessage(String code) {
        return getReloadableResourceBundleMessageSource().getMessage(code, null, Locale.getDefault());
    }

    /**
     * 정의된 메세지 조회
     *
     * @param code - 메세지 코드
     * @return String
     * @parma lo - locale
     */
    public String getMessage(String code, Locale lo) {
        return getReloadableResourceBundleMessageSource().getMessage(code, null, lo);
    }

}
