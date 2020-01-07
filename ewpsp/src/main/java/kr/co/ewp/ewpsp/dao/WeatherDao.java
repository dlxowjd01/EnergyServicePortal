package kr.co.ewp.ewpsp.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;

@Repository("WeatherDao")
public class WeatherDao {

    @Autowired
    private SqlSessionTemplate sqlSession;

    private static final Logger logger = LoggerFactory.getLogger(WeatherDao.class);

    public List getWeatherInfo(HashMap param){
        List resultList = sqlSession.selectList("WeatherDao.getWeatherInfo", param);
        logger.debug("/getWeatherInfoDao + {}", resultList);
        return resultList;
    }

    public List getGeneratedHour(HashMap param){
        List resultList = sqlSession.selectList("WeatherDao.getGeneratedHour", param);
        logger.debug("/getGeneratedHourDao + {}", resultList);
        return resultList;
    }
}
