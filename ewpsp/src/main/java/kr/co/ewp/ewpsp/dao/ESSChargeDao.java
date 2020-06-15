package kr.co.ewp.ewpsp.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository("essChargeDao")
public class ESSChargeDao {

    @Autowired
    private SqlSessionTemplate sqlSession;

    public Map getESSChargeSum(HashMap param) {
        Map result = sqlSession.selectOne("essCharge.getESSChargeSum", param);
        return result;
    }

    public List getESSChargeRealList(HashMap param) {
        List resultList = sqlSession.selectList("essCharge.getESSChargeRealList", param);
        return resultList;
    }

    public List getESSChargeFutureList(HashMap param) {
        List resultList = sqlSession.selectList("essCharge.getESSChargeFutureList", param);
        return resultList;
    }

}
