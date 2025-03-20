# MRI

A new Flutter project.

## Application Documentation

### Overview

The **MRI** project is a Flutter-based application designed to provide a seamless cross-platform experience. This document outlines the setup requirements, including the necessary versions of Gradle and Java, to ensure a smooth development and build process.

---

### Prerequisites

#### 1. Flutter SDK

Ensure you have Flutter installed on your system. You can download it from the [official Flutter website](https://flutter.dev/docs/get-started/install).

- **Recommended Flutter Version**: Stable channel (latest version)

Run the following command to verify your Flutter installation:

```bash
flutter doctor
```

#### 2. Java Development Kit (JDK)

The Android build system requires Java to compile the project.

- **Required Java Version**: JDK 11  
  You can download JDK 11 from AdoptOpenJDK or Oracle.

To verify your Java installation, run:

```bash
java -version
```

Expected output:

```
java version "11.x.x"
Java(TM) SE Runtime Environment (build 11.x.x)
Java HotSpot(TM) 64-Bit Server VM (build x.x.x, mixed mode)
```

#### 3. Gradle

Gradle is used as the build system for the Android portion of the Flutter project.

- **Required Gradle Version**: 7.4 or higher  
  Gradle is typically managed automatically by the Android Gradle Plugin. However, you can manually install Gradle if needed. Download it from the [Gradle website](https://gradle.org/).

To verify your Gradle installation, run:

```bash
gradle -v
```

Expected output:

```
------------------------------------------------------------
Gradle 7.4
------------------------------------------------------------
Build time:   YYYY-MM-DD HH:mm:ss UTC
Revision:     xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

Kotlin:       x.x.x
Groovy:       x.x.x
Ant:          x.x.x
JVM:          11.x.x (Oracle Corporation xx.x.x)
OS:           Your OS
```

---

### Project Setup

#### 1. Clone the Repository

Clone the project repository to your local machine:

```bash
git clone <repository-url>
cd mri
```

#### 2. Install Dependencies

Run the following command to install Flutter dependencies:

```bash
flutter pub get
```

#### 3. Configure Android

Ensure the Android environment is properly configured:

- Open the `android/build.gradle.kts` file and verify the Gradle version.
- Open the `android/gradle.properties` file to configure any additional properties.

#### 4. Build the Project

To build the project, run:

```bash
flutter build apk
```

---

### Additional Notes

- Ensure your IDE (e.g., Visual Studio Code or Android Studio) is configured with the Flutter and Dart plugins.
- Regularly update your dependencies by running:

```bash
flutter pub upgrade
```

---

### Troubleshooting

If you encounter issues, refer to the following resources:

- [Flutter Documentation](https://flutter.dev/docs)
- [Gradle Documentation](https://docs.gradle.org)
- [Java Documentation](https://docs.oracle.com/en/java/)
