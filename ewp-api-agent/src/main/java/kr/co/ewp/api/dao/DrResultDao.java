package kr.co.ewp.api.dao;
import java.util.Date;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.co.ewp.api.dao.base.BaseDao;
import kr.co.ewp.api.entity.Cbl;
import kr.co.ewp.api.entity.DrResult;
import kr.co.ewp.api.util.PrettyLog;
@Mapper
public interface DrResultDao extends BaseDao<DrResult, String> {
	
	int insertCbl(@Param("cbl") Cbl cbl, PrettyLog prettyLog);
	int updateCbl(@Param("cbl") Cbl cbl, PrettyLog prettyLog);
	
	Cbl selectOneByUniqueCbl(@Param("siteId") String siteId, @Param("startTimestamp") Date startTimestamp, @Param("endTimestamp") Date endTimestamp, PrettyLog prettyLog);
}
