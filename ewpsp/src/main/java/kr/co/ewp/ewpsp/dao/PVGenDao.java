package kr.co.ewp.ewpsp.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;

@Repository("pvGenDao")
public class PVGenDao {

    @Autowired
    private SqlSessionTemplate sqlSession;

    public List getPVGenRealList(HashMap param) {
        List resultList = sqlSession.selectList("pvGenDao.getPVGenRealList", param);
        return resultList;
    }

    public List getPVGenFutureList(HashMap param) {
        List resultList = sqlSession.selectList("pvGenDao.getPVGenFutureList", param);
        return resultList;
    }

    public Integer getPVGenRealListForToday(HashMap param) {
        Integer result = sqlSession.selectOne("pvGenDao.getPVGenRealListForToday", param);
        return result;
    }

    public Integer getPVGenRealListForLastMonth(HashMap param) {
        Integer result = sqlSession.selectOne("pvGenDao.getPVGenRealListForLastMonth", param);
        return result;
    }

    public Integer getPVGenRealListForThisMonth(HashMap param) {
        Integer result = sqlSession.selectOne("pvGenDao.getPVGenRealListForThisMonth", param);
        return result;
    }

    public List getPVGenRealListForThisMonthDaily(HashMap param) {
        List result = sqlSession.selectList("pvGenDao.getPVGenRealListForThisMonthDaily", param);
        return result;
    }

    public Integer getPVGenRealListForLastYear(HashMap param) {
        Integer result = sqlSession.selectOne("pvGenDao.getPVGenRealListForLastYear", param);
        return result;
    }

    public Integer getPVGenRealListForThisYear(HashMap param) {
        Integer result = sqlSession.selectOne("pvGenDao.getPVGenRealListForThisYear", param);
        return result;
    }

    public List getPVGenRealListForThisYearMonthly(HashMap param) {
        List result = sqlSession.selectList("pvGenDao.getPVGenRealListForThisYearMonthly", param);
        return result;
    }

    public List getPVGenRealLatestListOfDevices(HashMap param) {
        List resultList = sqlSession.selectList("pvGenDao.getPVGenRealLatestListOfDevices", param);
        return resultList;
    }

}
