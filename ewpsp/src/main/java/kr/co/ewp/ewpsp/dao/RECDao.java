package kr.co.ewp.ewpsp.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository("RECDao")
public class RECDao {

    @Autowired
    private SqlSessionTemplate sqlSession;

    private static final Logger logger = LoggerFactory.getLogger(RECDao.class);

    public List getCurrentRECMarketPrice(HashMap param) {
        List resultList = sqlSession.selectList("RECDao.getCurrentRECMarketPrice", param);
        logger.debug("/getCurrentRECMarketPriceDao + {}", resultList);
        return resultList;
    }

    public List getSiteRECIssued(HashMap param) {
        List resultList = sqlSession.selectList("RECDao.getSiteRECIssued", param);
        logger.debug("/getSiteRECIssuedDao + {}", resultList);
        return resultList;
    }

    public List getSiteRECBook(HashMap param) {
        List resultList = sqlSession.selectList("RECDao.getSiteRECBook", param);
        logger.debug("/getSiteRECBookDao + {}", resultList);
        return resultList;
    }

    public Integer getIssuedRECInThisMonth(HashMap param){
        Integer result = sqlSession.selectOne("RECDao.getIssuedRECInThisMonth", param);
        logger.debug("/getIssuedRECInThisMonthDao + {}", result);
        return result;
    }

    public List getSoldRECInThisDay(HashMap param){
        List result = sqlSession.selectList("RECDao.getSoldRECInThisDay", param);
        logger.debug("/getSoldRECInThisDayDao + {}", result);
        return result;
    }

    public List getSoldRECInThisMonth(HashMap param){
        List resultList = sqlSession.selectList("RECDao.getSoldRECInThisMonth", param);
        logger.debug("/getSoldRECInThisMonth + {}", resultList);
        return resultList;
    }

    public List getSoldRECInLastMonth(HashMap param){
        List resultList = sqlSession.selectList("RECDao.getSoldRECInLastMonth", param);
        logger.debug("/getSoldRECInLastMonth + {}", resultList);
        return resultList;
    }

    public List getSoldRECInThisYear(HashMap param){
        List resultList = sqlSession.selectList("RECDao.getSoldRECInThisYear", param);
        logger.debug("/getSoldRECInThisYear + {}", resultList);
        return resultList;
    }

    public List getSoldRECInLastYear(HashMap param){
        List resultList = sqlSession.selectList("RECDao.getSoldRECInLastYear", param);
        logger.debug("/getSoldRECInLastYear + {}", resultList);
        return resultList;
    }

    public List getSoldRECInThisYearMonthly(HashMap param){
        List resultList = sqlSession.selectList("RECDao.getSoldRECInThisYearMonthly", param);
        logger.debug("/getSoldRECInThisYearMonthlyDao:: {}", resultList);
        return resultList;
    }

    public List getTradingVolumeByDay(HashMap param){
        List resultList = sqlSession.selectList("RECDao.getTradingVolumeByDay", param);
        logger.debug("/getTradingVolumeByDay + {}", resultList);
        return resultList;
    }

    public List getTransactionPriceByDay(HashMap param){
        List resultList = sqlSession.selectList("RECDao.getTransactionPriceByDay", param);
        logger.debug("/getTransactionPriceByDay + {}", resultList);
        return resultList;
    }
}
