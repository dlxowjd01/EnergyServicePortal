package kr.co.ewp.api.dao;

import java.util.Date;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.co.ewp.api.dao.base.BaseDao;
import kr.co.ewp.api.entity.PredictPeak;
import kr.co.ewp.api.util.PrettyLog;

@Mapper
public interface PredictPeakDao extends BaseDao<PredictPeak, String> {

  PredictPeak selectOneLastPredictPeak(@Param("siteId") String siteId, PrettyLog prettyLog);

  PredictPeak selectOneByUnique(@Param("siteId") String siteId, @Param("stdTimestamp") Date stdTimestamp, Object object);
}
