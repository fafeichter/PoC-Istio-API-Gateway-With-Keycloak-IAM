plugins {
    java
}



java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(21)
    }
}

configurations {
    compileOnly {
        extendsFrom(configurations.annotationProcessor.get())
    }
}


subprojects {
    apply(plugin = "java")

    repositories {
        mavenCentral()
    }

    group = "com.ecommerce"
    version = "0.0.1-SNAPSHOT"

    tasks.test {
        useJUnitPlatform()
    }

}