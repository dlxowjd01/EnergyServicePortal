package kr.co.ewp.ewpsp.service;

import kr.co.ewp.ewpsp.dao.DRResultDao;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("drResultService")
public class DRResultServiceImpl implements DRResultService {

    @Resource(name = "drResultDao")
    private DRResultDao drResultDao;

    public List getDRResultList(HashMap param) {
        return drResultDao.getDRResultList(param);
    }

    public Map getCbl(HashMap param) {
        return drResultDao.getCbl(param);
    }

}
