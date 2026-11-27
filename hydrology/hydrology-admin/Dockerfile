FROM eclipse-temurin:17.0.21.1_2-jdk

WORKDIR /project

COPY target/hydrology-admin.jar /project/

COPY src/main/resources/ /project/resources/

ENV LOG_FILE=/opt/my-app/logs/app.log

RUN mkdir -p /opt/my-app/logs

ENV JAVA_OPTS="-Dlogging.file=${LOG_FILE} \
-Duser.timezone=Asia/Shanghai \
-Xms1g -Xmx1g \
-XX:MetaspaceSize=256M -XX:MaxMetaspaceSize=384M \
-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/opt/my-app/logs \
-Xlog:gc*,gc+heap=debug,gc+age=trace,gc+ref=debug:file=/opt/my-app/logs/gc.log:time,uptime,level,tags:filecount=5,filesize=100M \
-XX:NewRatio=2 -XX:SurvivorRatio=8 \
-XX:+UseParallelGC \
-XX:+DisableExplicitGC"

EXPOSE 18890
EXPOSE 18861

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar hydrology-admin.jar --spring.config.location=file:resources/application.yml"]
