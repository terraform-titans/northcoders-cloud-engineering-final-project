FROM maven:3.8.4-openjdk-17 as base
WORKDIR /app
COPY pom.xml ./
RUN mvn dependency:resolve
COPY src ./src

FROM base as development
CMD ["mvn", "spring-boot:run", "-Dspring-boot.run.jvmArguments='-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:8000'"]

