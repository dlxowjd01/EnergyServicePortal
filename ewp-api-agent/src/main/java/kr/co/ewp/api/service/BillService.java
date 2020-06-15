package kr.co.ewp.api.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.ewp.api.dao.BillDao;
import kr.co.ewp.api.dao.DrRevenueDao;
import kr.co.ewp.api.dao.GenRevenueDao;
import kr.co.ewp.api.entity.Bill;
import kr.co.ewp.api.entity.DrRevenue;
import kr.co.ewp.api.entity.GenRevenue;
import kr.co.ewp.api.util.PrettyLog;

@Service
@Transactional
public class BillService {

  private Logger logger = LoggerFactory.getLogger(BillService.class);
  @Autowired
  private BillDao billDao;
  @Autowired
  private GenRevenueDao genRevenueDao;
  @Autowired
  private DrRevenueDao drRevenueDao;

  public int addOrModBillList(List<Bill> billList, PrettyLog prettyLog) {
    int result = 0;
    for (Bill bill : billList) {
      Bill selectOneByUnique = billDao.selectOneByUnique(bill.getSiteId(), bill.getSvcSdate(), prettyLog);
      if (selectOneByUnique == null) {
        billDao.insert(bill, null);
      } else {
        bill.setBillIdx(selectOneByUnique.getBillIdx());
        billDao.update(bill, null);
      }
      result++;
      if (result % 100 == 0) {
        logger.info("addOrModBillList,{},{}", new Object[] { bill.getSiteId(), result });
      }
    }
    return result;
  }
  
  public int addOrModBillDayList(List<Bill> billList, PrettyLog prettyLog) {
	  int result = 0;
	  for (Bill bill : billList) {
		  Bill selectOneByUnique = billDao.selectOneByUniqueBillDay(bill.getSiteId(), bill.getSvcStimestamp(), prettyLog);
		  if (selectOneByUnique == null) {
			  billDao.insertBillDay(bill, null);
		  } else {
			  bill.setBillIdx(selectOneByUnique.getBillIdx());
			  billDao.updateBillDay(bill, null);
		  }
		  result++;
		  if (result % 100 == 0) {
			  logger.info("addOrModBillDayList,{},{}", new Object[] { bill.getSiteId(), result });
		  }
	  }
	  return result;
  }

  public int addOrModGenRevenueList(List<GenRevenue> getnRevenueList, PrettyLog prettyLog) {
    int result = 0;
    for (GenRevenue genRevenue : getnRevenueList) {
      // BATCH INSERT
      // genRevenueDao.insert(genRevenue, prettyLog);
      GenRevenue selectOneByUnique = genRevenueDao.selectOneByUnique(genRevenue.getSiteId(), genRevenue.getGenType(), genRevenue.getStdTimestamp(), prettyLog);
      if (selectOneByUnique == null) {
        genRevenueDao.insert(genRevenue, null);
      } else {
        genRevenue.setGenRevnIdx(selectOneByUnique.getGenRevnIdx());
        genRevenueDao.update(genRevenue, null);
      }
      result++;
      if (result % 100 == 0) {
        logger.info("addOrModGenRevenueList,{},{}", new Object[] { genRevenue.getSiteId(), result });
      }
    }
    return result;
  }

  public int addOrModDrRevenueList(List<DrRevenue> drRevenueList, PrettyLog prettyLog) {
    int result = 0;
    for (DrRevenue drRevenue : drRevenueList) {
      // BATCH INSERT
      // drRevenueDao.insert(drRevenue, prettyLog);
      DrRevenue selectOneByUnique = drRevenueDao.selectOneByUnique(drRevenue.getSiteId(), drRevenue.getStdTimestamp(), drRevenue.getReductStimestamp(), prettyLog);
      if (selectOneByUnique == null) {
        drRevenueDao.insert(drRevenue, null);
      } else {
        drRevenue.setDrRevnIdx(selectOneByUnique.getDrRevnIdx());
        drRevenueDao.update(drRevenue, null);
      }
      result++;
      if (result % 100 == 0) {
        logger.info("addOrModDrRevenueList,{},{}", new Object[] { drRevenue.getSiteId(), result });
      }
    }
    return result;
  }

  public GenRevenue getLastGenRevenue(String siteId, PrettyLog prettyLog) {
    return genRevenueDao.selectOneLast(siteId, prettyLog);
  }

  public DrRevenue getLastDrRevenue(String siteId, PrettyLog prettyLog) {
    return drRevenueDao.selectOneLast(siteId, prettyLog);
  }

}
