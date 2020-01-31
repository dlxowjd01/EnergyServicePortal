package kr.co.ewp.ewpsp.service;

import kr.co.ewp.ewpsp.dao.SMPDao;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("SMPService")
public class SMPServiceImpl implements SMPService{

    @Resource(name = "SMPDao")
    private SMPDao SMPDao;

    private static final Logger logger = LoggerFactory.getLogger(SMPServiceImpl.class);

    public Map getFixedSMPMarketPrice(HashMap param, HttpServletRequest request) {

        List list = SMPDao.getFixedSMPMarketPrice(param);

        logger.debug("/getFixedSMPMarketPriceServiceImpl + {}", list);

        Map resultMap = new HashMap();

        if(list == null || list.isEmpty()){
            return null;
        } else {
            resultMap.put(param.get("market_id"), list);
            return resultMap;
        }
    }
}
