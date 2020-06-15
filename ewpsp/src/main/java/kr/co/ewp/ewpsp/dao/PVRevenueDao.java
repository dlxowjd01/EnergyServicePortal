package kr.co.ewp.ewpsp.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;

@Repository("pvRevenueDao")
public class PVRevenueDao {

    @Autowired
    private SqlSessionTemplate sqlSession;

    public List getPVRevenueList(HashMap param) {
        List resultList = sqlSession.selectList("pvRevenue.getPVRevenueList", param);
        return resultList;
    }

    public List getPVRevenueTexList(HashMap param) {
        List resultList = sqlSession.selectList("pvRevenue.getPVRevenueTexList", param);
        return resultList;
    }

}
