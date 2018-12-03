FROM tomcat:8.0.20-jre8

COPY simple_web_app/target/simple_web_app.war /usr/local/tomcat/webapps/simple_web_app.war