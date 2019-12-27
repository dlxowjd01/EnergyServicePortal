package kr.co.ewp.ewpsp.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;

@Repository("SMPDao")
public class SMPDao {

    @Autowired
    private SqlSessionTemplate sqlSession;

    private static final Logger logger = LoggerFactory.getLogger(SMPDao.class);

    public List getFixedSMPMarketPrice(HashMap param){

        List resultList = sqlSession.selectList("SMPDao.getFixedSMPMarketPrice", param);

        logger.debug("/getFixedSMPMarketPriceDao + {}", resultList);

        return resultList;
    }
}
