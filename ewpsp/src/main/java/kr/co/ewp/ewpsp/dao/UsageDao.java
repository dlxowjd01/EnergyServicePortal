package kr.co.ewp.ewpsp.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;

@Repository("usageDao")
public class UsageDao {

    @Autowired
    private SqlSessionTemplate sqlSession;

    public List getUsageRealList(HashMap param) {
        List resultList = sqlSession.selectList("usage.getUsageRealList", param);
        return resultList;
    }

    public List getUsageFutureList(HashMap param) {
        List resultList = sqlSession.selectList("usage.getUsageFutureList", param);
        return resultList;
    }

}
