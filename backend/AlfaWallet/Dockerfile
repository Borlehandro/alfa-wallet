FROM bellsoft/liberica-openjdk-debian:17.0.4
LABEL author="borlehandro"

WORKDIR /sitebackend
COPY "target/alfawallet.jar" ./alfawallet.jar

ENTRYPOINT ["java", "-jar",\
            "-XX:MaxDirectMemorySize=50M", \
            "-XX:MaxMetaspaceSize=120M", \
            "-XX:ReservedCodeCacheSize=120M", \
            "-Xss512K", \
            "-Xms340M", "-Xmx440M", \
            "-XX:+AlwaysActAsServerClassMachine", \
            "-XX:+UnlockExperimentalVMOptions", \
            "--enable-preview", \
            "alfawallet.jar"]