Below is a copy of my Second Year Software Engineering Project. I worked as Project Manager on this project and have made this copy with the intention of completing some of the changes we have mentioned in the 'Next Steps' section of our Handover documentation. 


# Gut Health Monitoring App - Second Year Group Software Engineering Project
<img width="650" height="175" alt="image" src="https://storage.googleapis.com/msgsndr/xYCrZNFIGAeWEm3RsHo3/media/6501a1ba892e5d3dde740127.png" /><br><br>

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![Java](https://img.shields.io/badge/Java-007396?style=for-the-badge&logo=java&logoColor=white)](https://www.java.com/)
[![Spring Boot](https://img.shields.io/badge/Spring_Boot-6DB33F?style=for-the-badge&logo=springboot&logoColor=white)](https://spring.io/projects/spring-boot)
[![Android Studio](https://img.shields.io/badge/Android_Studio-3DDC84?style=for-the-badge&logo=android-studio&logoColor=white)](https://developer.android.com/studio)
[![Xcode](https://img.shields.io/badge/Xcode-007ACC?style=for-the-badge&logo=Xcode&logoColor=white)](https://developer.apple.com/xcode/)
[![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)](https://www.nginx.com/)
[![Amazon AWS](https://img.shields.io/badge/Amazon_AWS-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)](https://aws.amazon.com/)
![Docker](https://img.shields.io/badge/Docker-2CA5E0?style=for-the-badge&logo=docker&logoColor=white)
[![App Store](https://img.shields.io/badge/App_Store-0D96F6?style=for-the-badge&logo=app-store&logoColor=white)](https://apps.apple.com/gb/app/marine-conservation-app/id6477784808)
[![Google Play](https://img.shields.io/badge/Google_Play-414141?style=for-the-badge&logo=google-play&logoColor=white)](https://play.google.com/store)

## Table Of Contents
+ [Project Overview](#project-overview)

+ [Project Structure](#project-structure)

+ [Project instructions](#project-instructions)
  
+ [User instructions](#user-instructions)

+ [Stakeholders](#stake-holders)

+ [User Stories](#user-stories)

+ [Key Features](#features)

+ [Tech Stack](#tech-Stack)

+ [Team Members](#team-members)

## <a id="project-overview"></a>Project Overview 

**Project Title**: Development of a gut health monitoring app

**Client**: Ferryx

**Description**:
This project involves the development of a mobile application to replace 
Ferryx's current email-based survey system for their 12-week product trial 
of Ferrocalm, a next-generation probiotic. The existing system suffers 
from low user engagement and data inaccuracies, leading to a low trial 
completion rate.

The application aims to address these issues by providing a user-friendly 
platform for participants to complete health surveys, receive automated 
reminders, and track their symptom progress over time.

## <a id="project-structure"></a>Project Structure
```
2025-GutHealthMonitoringApp
├─ docs (Contains all documents and diagrams)
├─ guthealth (Backend)
├─ guthealth_app (Frontend)
├─ LICENSE.txt
└─ README.md
```

## <a id="project-instructions"></a>Project Instructions
The following steps will help you run the complete Flutter frontend locally.

### Prerequisites
- Flutter 3.24+ (supporting Dart 3.9), along with an Android Studio/VS Code emulator or a physical device debugging environment.
- Firebase is used for app notifications. The repo already includes the current project configuration files:
  - `guthealth_app/lib/firebase_options.dart`
  - `guthealth_app/android/app/google-services.json`
  - `guthealth_app/ios/Runner/GoogleService-Info.plist`
- If the team needs to switch to a different Firebase project later, these files must be regenerated or replaced before running the app.
- For iOS builds on macOS, install Xcode and CocoaPods.

### Frontend (Flutter)
1) Get dependencies and run:

```bash
cd guthealth_app
flutter pub get
flutter run -d <device-id>   # e.g. emulator-5554 / chrome / ios
```  
2) If you want to specify a different entry screen, you can add `-t lib/main.dart`to the command(the default entry point is the Home screen in `lib/main.dart`)

### Backend (spring boot)
1) Install dependencies
```bash
mvn clean install
```
2) Configure environment variable  
- Implement the following in `application.properties`
```bash
spring.datasource.url=${DB_URL}
spring.datasource.username=${DB_USERNAME}
spring.datasource.password=${DB_PASSWORD}

spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
```
- Set required variables in `.env` file
```bash
DB_URL=url
DB_USERNAME=yourusername
DB_PASSWORD=yourpassword
```
3) Database Setup (PostgreSQL) -- no need for this ?
```bash
CREATE DATABASE surveydb;
```
Ensure your username and password match your `.env` or config  
5) Start Development Server
```bash
./mvnw spring-boot:run -Dspring-boot.run.profiles=dev
```
- The backend runs at 
```bash
http://ec2-51-21-76-143.eu-north-1.compute.amazonaws.com:8080
```
## <a id="user-instructions"></a>User Instructions

### How to install the app: 

Complete the following steps

    cd guthealth_app
    flutter build apk 

Connect your phone to your device using a USB and the run the following command

    flutter install

- Instructions will be added after we deploy our application!

### How to use our application: Written Instructions (Diagrammatic Instructions below)

1) Survey Component:
   - Click complete survey on the home page after opening the application.
   - Slide the slider to select the score for each symptom and click next when you are ready to continue.
   - Once you've reached the last question you'll be redirected to the home page again.
     
2) View Previous/Completed Surveys: TBA
   - Click the view previous data section this should show a list of the surveys you've completed in date order (most to least recent). You can view individual responses or see a chart showing you the progression of each symptom across the surveys.
     
3) Mood Log Compoent:
   - Click the symbol that says 'Mood log' in the blue bar at the bottom of the screen. This will navigate you to a page with different emojis you can choose to reflect your mood.
   - Click the previous button to view your previous day's / past mood logs. This will take you to a page where your current mood is at the top and your previous day's mood is below it allowing for a visual comparison between the days. 

   - If you click continue on the main mood log page you will be redirected to same page as the previous button.

4) Recipe Bank:
   + Consists of links to IBS friendly recipies provided by Ferryx.

### How to use our application: Diagrammatic Instructions

<img width="595" height="763" alt="image" src="https://github.com/user-attachments/assets/cad5553f-f0d8-495a-89cb-ba2c29c2aeb2" />

### Common Issues
- To package the mobile application, you can execute flutter build apk or flutter build ipa from the Flutter directory. Before proceeding, ensure that you have completed the necessary platform signing and configuration steps.
=======
2) If you want to specify a different entry screen, you can add `-t lib/screens/survey_screen.dart`to the command (the default entry point is the Home screen in `lib/main.dart`)


## <a id="stake-holders"></a>Stake holders

**Developers of Ferrocalm**

The team behind the development and distribution of the probiotic. 
They are interested in user behaviour, product adherence, and overall 
patient outcomes in real-world use, as gathered through anonymised app 
data.

**Users of Ferrocalm**

These are individuals suffering from IBS who are taking the Ferryx 
probiotic. They are the primary users of the app. It allows them to 
track their symptoms, log their meals, and receive reminders to take 
their medication, helping them to better manage their condition.

**Legislators & Ethics Boards**

Data protection authorities (UK GDPR regulators) and academic 
ethics committees who ensure user data is handled responsibly, 
ethically and in compliance with legal standards.

**Development Team**

The student engineers and designers building the application. 
They are responsible for implementing features, ensuring a good user 
experience, and complying with privacy and security requirements.

**University Staff**

University staff in charge of the students need to ensure the project meets academic standards and learning outcomes for the software engineering project module.


## <a id="user-stories"></a>User Stories

### Data analyst  
+ As a Ferrocalm analyst, I want to export trial data easily in CSV format so that I can analyse responses efficiently.
### Admin
+ As a Ferrocalm admin, I want to manage user accounts securely and ensure GDPR compliance so that personal data is protected.
### Ferrocalm team member
+ As a Ferrocalm team member, I want surveys to be sent automatically following purchase so that participants are enrolled without manual intervention.

### Ferrocalm customer
+ As a customer, I want to receive notifications when surveys are due or overdue so that I don’t miss any and can stay on track. I want to easily access and review my previous survey responses so that I can provide accurate answers and see progress. I want to see my symptom scores and progress in a clear chart so that I can understand my improvement over time.

## <a id="features"></a>Features

| **Feature**                                 | **Front End**                                                                                                                                   | **Back End**                                                                                                                 | **Database**                                                                        |
| ------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------- |
| **Surveys**                                 | Notifications for completion<br>Viewing progress as a graph| Collect data from survey<br>Generate progress data to be sent to the frontend.                     | Store survey responses and completion status                          |
| **Graph Visualisation** | Display graphs using charting libraries.                                                              | Process and format raw data into JSON suitable for graph rendering.                                                          | Store tabular survey data that can be queried and converted into graph form. |
| **Encryption of Customer Data Input**       | Secure data entry forms (SSL/TLS, input validation).                                                                                            | Encrypt and hash sensitive data before saving                                                      | Store encrypted customer information (account number, email, etc.)                |
| **Health Tracker (Food/Mood Diary)**        | Notifications for filling this in.<br>Interactive diary interface for daily entries.                                                            | Allow users to add symptoms in their log                                                       | Store daily food/mood entries and related symptoms per user.                        |
| **Recipe Bank**                             | View recipes as a list with logos for dietary requirements.<br>Enable search                                                     | Integrate with internal recipe data.<br>Fetch historical recipe usage data for weekly graph views. | Store recipe details, dietary tags, user preferences, and historical usage.         |
| **Filter Recipes / Favourites**             | Allow users to filter recipes by category or dietary requirement.<br>Option to mark favourites.                                                 | Handle filtering logic and favourites management on user request.                                                            | Store user favourites and filter metadata for recipes.                              |

## <a id="tech-Stack"></a>Tech Stack  
**Frontend**
- Flutter 

**Backend**
- Java using the Springboot Framework

**Database**
- PostgreSQL 
- Utilise AWS cloud

<img width="650" alt="image" src="docs/asserts/Techstack_Diagram.png" /><br><br>


## <a id="team-members"></a>Team Members  
| Name | Email |
| --- | --------------------------- |
| Lingyi Lu | mc24977@bristol.ac.uk |
| Ananyalakshmi Srinivasan | ud24421@bristol.ac.uk |
| Yuan Liu | po24675@bristol.ac.uk |
| Niyor Gogoi - Client Liaison | kk24343@bristol.ac.uk |





 



 



 






