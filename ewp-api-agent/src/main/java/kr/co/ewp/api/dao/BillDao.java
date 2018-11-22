package kr.co.ewp.api.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.co.ewp.api.dao.base.BaseDao;
import kr.co.ewp.api.entity.Bill;
import kr.co.ewp.api.util.PrettyLog;

@Mapper
public interface BillDao extends BaseDao<Bill, String> {

  Bill selectOneByUnique(@Param("siteId") String siteId, @Param("svcSdate") String billYearm, PrettyLog prettyLog);
}
