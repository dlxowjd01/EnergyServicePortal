package kr.co.ewp.ewpsp.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository("drResultDao")
public class DRResultDao {

    @Autowired
    private SqlSessionTemplate sqlSession;

    public List getDRResultList(HashMap param) {
        List resultList = sqlSession.selectList("drResult.getDRResultList", param);
        return resultList;
    }

    public Map getCbl(HashMap param) {
        Map result = sqlSession.selectOne("drResult.getCbl", param);
        return result;
    }

}
