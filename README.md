![CircleCI](https://circleci.com/gh/EncoredTech/EWPServicePortal/tree/master.svg?style=svg&circle-token=65974ecc3ab2fdbe30572287aa426ac40394a9dc)

# Set up to develop on a local environment in iDERMS-SaaS branch
You have to change the following code to the absolute path of globals.properties file in your local

`EWPServicePortal/ewpsp/src/main/webapp/WEB-INF/config/spring-servlet.xml`

> Before
```
<util:properties id="local" location="file:/home/ec2-user/app/git/EWPServicePortal/ewpsp/src/main/resources/properties/globals.properties"/>
```
> After
```
<util:properties id="local" location="file:<:your local path>/EWPServicePortal/ewpsp/src/main/resources/properties/globals.properties"/>
```
