package kr.co.ewp.ewpsp.service;

import kr.co.ewp.ewpsp.dao.WeatherDao;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;


@Service("WeatherService")
public class WeatherServiceImpl implements WeatherService{

    @Resource(name = "WeatherDao")
    private WeatherDao weatherDao;

    private static final Logger logger = LoggerFactory.getLogger(WeatherServiceImpl.class);

    public List getWeatherInfo(HashMap param, HttpServletRequest request) throws Exception {
        List list = weatherDao.getWeatherInfo(param);
        logger.debug("/getWeatherInfo + {}", list);
        if(list == null || list.isEmpty()){
            return null;
        } else {
            return list;
        }
    }

    public List getGeneratedHour(HashMap param, HttpServletRequest request) throws Exception {
        List list = weatherDao.getGeneratedHour(param);
        logger.debug("/getGeneratedHour + {}", list);
        if(list == null || list.isEmpty()){
            return null;
        }else {
            return list;
        }
    }
}
