import kr.co.ewp.api.util.PrettyLog;

public class PrettyLogTest {
  public static void main(String[] args) {
    PrettyLog prettyLog = new PrettyLog("PrettyLogTest");
    Controller.getCarView("1004", prettyLog);
    prettyLog.stop();
    System.out.println(prettyLog.prettyPrint());
  }

  public static class Controller {
    public static void getCarView(String carNo, PrettyLog prettyLog) {
      prettyLog.start("Controller.getCarView");
      prettyLog.append("PARAM", "carNo:" + carNo);
      String carName = Service.getCar(carNo, prettyLog);
      prettyLog.append("RESULT", carName);
      prettyLog.stop();
    }
  }

  public static class Service {
    public static String getCar(String carNo, PrettyLog prettyLog) {
      prettyLog.start("Service.getCar");
      prettyLog.append("PARAM", "carNo:" + carNo);
      String carName = Dao.selectCar(carNo, prettyLog);
      prettyLog.append("RESULT", carName);
      prettyLog.stop();
      return carName;
    }
  }

  public static class Dao {
    public static String selectCar(String carNo, PrettyLog prettyLog) {
      String carName = "BoongBoong";
      prettyLog.start("Dao.selectCar");
      prettyLog.append("PARAM", "carNo:" + carNo);
      prettyLog.append("RESULT", carName);
      prettyLog.stop();
      return carName;
    }
  }
}
