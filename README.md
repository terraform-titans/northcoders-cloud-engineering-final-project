# Northcoders Learners API

This is the API for adding/editing/deleting learners from our system.

## Running the app

The instructions assume you have Java and Maven installed locally.

Instructions have been tested against Java version `openjdk 17.0.6` and Maven `3.8.4`

To run the application use the command

```
mvn spring-boot:run
```

## Testing the app

To run the tests for the API you can run:

```
mvn test
```

## App config

The application config is stored in [application.yml](./src/main/resources/application.yml) file.

We've shared a sample config for a Postgres database as well.

## Metrics and health

We've added Spring actuator and enabled prometheus so there is a [health endpoint](http://localhost:8080/actuator/health) and [prometheus metrics](http://localhost:8080/actuator/prometheus)