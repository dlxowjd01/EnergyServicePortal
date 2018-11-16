package kr.co.ewp.api.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.ewp.api.dao.DrResultDao;
import kr.co.ewp.api.entity.Cbl;
import kr.co.ewp.api.entity.DrResult;
import kr.co.ewp.api.util.PrettyLog;

@Service
@Transactional
public class DrService {
  private Logger logger = LoggerFactory.getLogger(DrService.class);
  @Autowired
  private DrResultDao drResultDao;

  public int addOrModDrReusltList(List<DrResult> essChargeList, PrettyLog prettyLog) {
    int result = 0;
    for (DrResult essCharge : essChargeList) {
      drResultDao.insert(essCharge, null);
      if (++result % 100 == 0) {
        logger.info("addOrModDrReusltList,{},{}", new Object[] { essCharge.getSiteId(), result });
      }
    }
    return result;
  }
  
  public int addOrModCbl(Cbl cbl, PrettyLog prettyLog) {
	  int result = 0;
	  Cbl selectOneByUnique = drResultDao.selectOneByUniqueCbl(cbl.getSiteId(), cbl.getStartTimestamp(), cbl.getEndTimestamp(), null);
      if (selectOneByUnique == null) {
    	  drResultDao.insertCbl(cbl, null);
      } else {
    	  cbl.setCblIdx(selectOneByUnique.getCblIdx());
    	  drResultDao.updateCbl(cbl, null);
      }
      result++;
      if (result % 100 == 0) {
        logger.info("addOrModCbl,{},{}", new Object[] { cbl.getSiteId(), result });
      }
	  return result;
  }

}
