package kr.co.ewp.api.dao;

import java.util.Date;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.co.ewp.api.dao.base.BaseDao;
import kr.co.ewp.api.entity.Bill;
import kr.co.ewp.api.util.PrettyLog;

@Mapper
public interface BillDao extends BaseDao<Bill, String> {

  Bill selectOneByUnique(@Param("siteId") String siteId, @Param("svcSdate") String billYearm, PrettyLog prettyLog);
  
  Bill selectOneByUniqueBillDay(@Param("siteId") String siteId, @Param("svcStimestamp") Date svcStimestamp, PrettyLog prettyLog);
  
  int insertBillDay(@Param("bill") Bill bill, PrettyLog prettyLog);
	int updateBillDay(@Param("bill") Bill bill, PrettyLog prettyLog);
}
