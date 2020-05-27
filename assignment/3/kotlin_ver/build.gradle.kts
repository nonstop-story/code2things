plugins {
    kotlin("jvm") version "1.3.72"
}

group = "com.imkiva"
version = "1.0-SNAPSHOT"

java {
    sourceCompatibility = JavaVersion.VERSION_11
    targetCompatibility = JavaVersion.VERSION_11
}

repositories {
    mavenCentral()
}

dependencies {
    implementation(kotlin("stdlib-jdk8"))
    implementation(group = "com.github.cqjjjzr", name = "charlie.bililivelib", version = "rv5") {
        exclude(module = "kotlin-stdlib")
    }
}

tasks {
    compileKotlin {
        kotlinOptions.jvmTarget = "1.8"
    }
    compileTestKotlin {
        kotlinOptions.jvmTarget = "1.8"
    }
}