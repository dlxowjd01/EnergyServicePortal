package kr.co.ewp.ewpsp.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;

@Repository("drRevenueDao")
public class DRRevenueDao {

    @Autowired
    private SqlSessionTemplate sqlSession;

    public List getDRRevenueList(HashMap param) {
        List resultList = sqlSession.selectList("drRevenue.getDRRevenueList", param);
        return resultList;
    }

    public List getDRRevenueTexList(HashMap param) {
        List resultList = sqlSession.selectList("drRevenue.getDRRevenueTexList", param);
        return resultList;
    }

    public List getDRRevenueChartList(HashMap param) {
        List resultList = sqlSession.selectList("drRevenue.getDRRevenueChartList", param);
        return resultList;
    }

}
