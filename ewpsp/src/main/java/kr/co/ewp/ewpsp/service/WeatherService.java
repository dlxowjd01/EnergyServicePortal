package kr.co.ewp.ewpsp.service;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;

public interface WeatherService {
    List getWeatherIconMonthly(HashMap params, HttpServletRequest request) throws Exception;
}
