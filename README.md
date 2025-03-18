
# StudySync Project
<p>Go to <a href ="http://107.175.189.118:8080/login">StudySync Live</a>
</p>
<br/>
[StudySync Live](http://107.175.189.118:8080/login) is hosted using linux VPS by racknerd
StudySync is an integrated platform that combines a Perl-based backend (using Mojolicious) with a Vue.js front end. It provides robust academic data management, real-time communication, and a clean user interface.

---

## Table of Contents

- [Overview](#overview)
- [Goals](#goals)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation and Setup](#installation-and-setup)
  - [Backend (Perl) Setup](#backend-perl-setup)
  - [Frontend (Vue.js) Setup](#frontend-vuejs-setup)
- [Running the Project](#running-the-project)
  - [Starting the Backend](#starting-the-backend)
  - [Starting the Frontend](#starting-the-frontend)
- [Folder Structure](#folder-structure)
- [Testing](#testing)
- [Contribution Guide](#contribution-guide)
- [License](#license)
- [Contact](#contact)
- [Acknowledgments](#acknowledgments)

---

## Overview

StudySync is designed to streamline academic processes and enhance communication between students and lecturers. The project is split into two major parts:

- **Perl Backend:** Provides RESTful APIs, integrates with a MariaDB database, and supports real-time notifications.
- **Vue.js Frontend:** Delivers a responsive, modern user interface for interacting with the backend services.

---

## Goals

1. **Reliability:** Ensure robust handling of API requests and data management.
2. **Integration:** Seamlessly interact with the MariaDB database.
3. **Scalability:** Support a growing user base and feature set.
4. **User Experience:** Provide an intuitive and responsive front end.

---

## Features

- **RESTful APIs:** Manage user authentication, data operations, and notifications.
- **Database Integration:** Efficient CRUD operations with MariaDB.
- **Real-Time Communication:** WebSocket support for live updates.
- **Secure Data Handling:** Implement best practices for user management and data security.
- **Modern Frontend:** Built with Vue.js for a smooth, responsive experience.

---

## Prerequisites

- **Operating System:** Linux, macOS, or Windows (WSL recommended for Linux commands)
- **Docker:** Installed and running (used for MariaDB and optionally for backend)
- **Perl (v5.10+):** With [Mojolicious](https://mojolicious.org/)
- **Node.js & npm:** Required for the Vue.js front end
- **Vue CLI (Optional):** For local development and build tasks

---

## Installation and Setup

### Backend (Perl) Setup

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/yourusername/studysync.git
   cd studysync/backend
   ```

2. **Set Up MariaDB Using Docker:**
   Start a MariaDB container with the following command:
   ```bash
   docker run --name studysync-mariadb \
     -e MYSQL_ROOT_PASSWORD=yourpassword \
     -e MYSQL_DATABASE=studysync \
     -p 3306:3306 \
     -d mariadb:latest
   ```
   If using Docker Compose:
   ```bash
   docker-compose up --build
   ```

3. **Install Perl Dependencies:**
   Install the required modules using CPAN (or cpanminus):
   ```bash
   cpan Mojolicious DBI DBD::mysql
   ```
   *Tip:* Use `sudo` if you encounter permission issues.

4. **Configure the Database Connection:**
   Edit the file `config/database.conf` with your database settings:
   ```ini
   [database]
   host = 127.0.0.1
   port = 3306
   user = root
   password = yourpassword
   database = studysync
   ```

### Frontend (Vue.js) Setup

1. **Navigate to the Frontend Directory:**
   ```bash
   cd ../frontend
   ```

2. **Install Node Modules:**
   ```bash
   npm install
   ```

3. **Verify Available Scripts:**
   Check which npm scripts are available:
   ```bash
   npm run
   ```
   Typically, you should see a `"serve"` (or `"start"`) script for development. If you prefer a `dev` script, add it to your `package.json`:
   ```json
   "scripts": {
     "serve": "vue-cli-service serve",
     "build": "vue-cli-service build"
   }
   ```

---

## Running the Project

### Starting the Backend

- **Direct Execution:**
  From the `backend` directory:
  ```bash
  perl working.pl daemon -l http://*:80
  ```
  Access the backend at [http://localhost:80](http://localhost:80).

- **Using Docker Compose:**
  If your `docker-compose.yml` sets up both the backend and database:
  ```bash
  docker-compose up --build
  ```

### Starting the Frontend

- **Development Mode:**
  In the `frontend` directory, run:
  ```bash
  npm run serve
  ```
  The Vue.js app typically runs at [http://localhost:8080](http://localhost:8080) (or another port as specified).

- **Production Build:**
  Build the static files:
  ```bash
  npm run build
  ```
  Serve the files with your preferred web server.

---

## Folder Structure

### Root Directory
- **.dockerignore:** Lists files/directories to ignore in Docker builds.
- **.gitattributes:** Configures repository file handling.
- **.github/**: Contains GitHub workflows and CI/CD configurations.
- **Dockerfile:** Builds the backend Docker image.
- **docker-compose.yml:** Manages multi-container setups (backend and MariaDB).
- **README.md:** This documentation file.

### Backend Specific
- **/lib:** Mojolicious controllers and helper modules.
- **/public:** Static assets (images, JavaScript, CSS).
- **/templates:** Embedded Perl templates for views.
- **/config:** Configuration files (including database settings).
- **working.pl / server.pl:** Main scripts to launch the backend.

### Frontend Specific
- **/src:** Vue.js application source code.
- **/public:** Public static files for the Vue.js app.
- **package.json:** Contains dependencies and npm scripts.

### SQL Files
- **createtable.sql:** Script to create necessary tables.
- **droptable.sql:** Script to drop tables (for resets).
- **dummydata.sql:** Sample data for testing.

### Other Files
- **postTest.js:** Script for API endpoint testing.
- **exampleEndpointOutput.md:** Sample output documentation.

---

## Testing

### API Testing (Backend)
- **Using postTest.js:**
  ```bash
  node postTest.js
  ```
- **Using curl:**
  ```bash
  curl -X POST http://localhost:80/api/exampleEndpoint \
       -d '{"key":"value"}' \
       -H "Content-Type: application/json"
  ```
- **Using Postman:** Import and test API endpoints interactively.

### Frontend Testing
- Open the Vue.js application in your browser.
- Use Vue DevTools or similar tools to debug and inspect API calls.

---

## Contribution Guide

1. **Fork and Clone the Repository:**
   ```bash
   git clone https://github.com/yourusername/studysync.git
   cd studysync
   ```

2. **Create a New Branch:**
   ```bash
   git checkout -b feature-name
   ```

3. **Make Changes and Test:**
   - Use `postTest.js`, `curl`, or Postman for backend changes.
   - Run the frontend locally to test UI updates.

4. **Commit and Push:**
   ```bash
   git commit -m "Add feature-name"
   git push origin feature-name
   ```

5. **Submit a Pull Request** for review.

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

---

## Contact

For further inquiries, please contact us at [zafranzafran0234@gmail.com](mailto:zafranzafran0234@gmail.com).

---

## Acknowledgments

- **University of Technology Malaysia (UTM):** For inspiration and support.
- **Perl Community:** For the Mojolicious framework and robust documentation.
- **Vue.js Community:** For continuous improvements in the frontend ecosystem.
```

---

This version uses a cleaner layout, precise instructions, and improved wording so that anyone can easily set up and run the project without confusion. Adjust any paths or configuration details as needed for your specific environment.
