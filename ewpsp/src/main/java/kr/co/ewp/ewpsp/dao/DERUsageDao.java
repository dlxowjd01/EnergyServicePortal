package kr.co.ewp.ewpsp.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;

@Repository("derUsageDao")
public class DERUsageDao {

    @Autowired
    private SqlSessionTemplate sqlSession;

    public List getESSUsageList(HashMap param) {
        List resultList = sqlSession.selectList("derUsage.getESSUsageList", param);
        return resultList;
    }

    public List getPVUsageList(HashMap param) {
        List resultList = sqlSession.selectList("derUsage.getPVUsageList", param);
        return resultList;
    }

}
