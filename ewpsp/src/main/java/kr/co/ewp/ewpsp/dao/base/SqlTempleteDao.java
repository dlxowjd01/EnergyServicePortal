package kr.co.ewp.ewpsp.dao.base;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;

public class SqlTempleteDao {

    @Autowired
    private SqlSessionTemplate sqlSession;

}
