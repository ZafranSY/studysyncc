
# StudySync Project

This repository contains the full StudySync project, including both the Perl backend (built with Mojolicious) and the Vue.js front end.
<a href="http://107.175.189.118:8080/login"> StudySync.com</a>
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

**StudySync** is a platform designed to manage academic data and enable real-time communication between students and lecturers. The project is split into two parts:

- **Perl Backend:** Provides RESTful APIs, integrates with a MariaDB database, and handles real-time notifications.
- **Vue.js Frontend:** Offers a responsive user interface to interact with the backend services.

---

## Goals

1. **Reliability:** Robust server-side logic for handling API requests and data transfer.
2. **Integration:** Seamless interaction with the MariaDB database.
3. **Scalability:** Supports a growing user base and evolving feature set.
4. **User-Friendly:** Clean and intuitive front-end built with Vue.js.

---

## Features

- **RESTful APIs:** Endpoints for user authentication, data management, and notifications.
- **Database Integration:** Efficient CRUD operations with MariaDB.
- **Real-Time Communication:** WebSocket support for live updates.
- **Secure Data Handling:** Best practices in user management and access control.
- **Modern Frontend:** Vue.js-based interface for a smooth user experience.

---

## Prerequisites

- **Operating System:** Linux, macOS, or Windows (with WSL recommended for Linux commands)
- **Docker:** Installed and running (for MariaDB and optionally for backend)
- **Perl (v5.10 or later):** Including [Mojolicious](https://mojolicious.org/)
- **Node.js & npm:** For the Vue.js front end
- **Vue CLI (optional):** If you plan to run and build the Vue app locally

---

## Installation and Setup

### Backend (Perl) Setup

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/yourusername/studysync.git
   cd studysync/backend
   ```

2. **Set Up MariaDB Using Docker:**
   Run the following command to start a MariaDB container:
   ```bash
   docker run --name studysync-mariadb \
     -e MYSQL_ROOT_PASSWORD=yourpassword \
     -e MYSQL_DATABASE=studysync \
     -p 3306:3306 \
     -d mariadb:latest
   ```
   Alternatively, if you have a `docker-compose.yml` file, run:
   ```bash
   docker-compose up --build
   ```

3. **Install Perl Dependencies:**
   Use CPAN (or cpanminus) to install the required Perl modules:
   ```bash
   cpan Mojolicious DBI DBD::mysql
   ```
   *Tip:* If you encounter permission issues, consider running as a user with proper privileges or use `sudo` if needed.

4. **Configure the Database Connection:**
   Edit `config/database.conf` with your database settings:
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

3. **Check the Available Scripts:**
   To see what scripts are available, run:
   ```bash
   npm run
   ```
   Typically, the Vue.js project will have a script such as `"serve"` or `"start"` for development. If you need a `dev` script and it’s missing, update your `package.json` under the `"scripts"` section. For example:
   ```json
   "scripts": {
     "serve": "vue-cli-service serve",
     "build": "vue-cli-service build"
   }
   ```

---

## Running the Project

### Starting the Backend

- **Directly (without Docker Compose):**
  From the `backend` directory:
  ```bash
  perl working.pl daemon -l http://*:80
  ```
  The backend server will run and be accessible at [http://localhost:80](http://localhost:80).

- **Using Docker Compose:**
  If you have configured `docker-compose.yml` for both backend and database:
  ```bash
  docker-compose up --build
  ```

### Starting the Frontend

- **Development Mode:**
  In the `frontend` directory, start the development server (using the correct npm script):
  ```bash
  npm run serve
  ```
  The Vue.js app will typically run on [http://localhost:8080](http://localhost:8080) (or another port as specified).

- **Production Build:**
  To build the frontend for production:
  ```bash
  npm run build
  ```
  Then, you can serve the static files with a web server of your choice.

---

## Folder Structure

### Root Directory
- **.dockerignore:** Files and directories ignored during Docker builds.
- **.gitattributes:** Repository file handling settings.
- **.github/**: GitHub workflows and configuration for CI/CD.
- **Dockerfile:** Defines how to build the backend Docker image.
- **docker-compose.yml:** Orchestrates multi-container setups (backend and MariaDB).
- **README.md:** This file.

### Backend Specific
- **/lib:** Mojolicious controllers and helper modules.
- **/public:** Static assets (images, JS, CSS).
- **/templates:** Embedded Perl templates for rendering views.
- **/config:** Configuration files (including database settings).
- **working.pl / server.pl:** Main server script(s) to launch the backend.

### Frontend Specific
- **/src:** Source code for the Vue.js application.
- **/public:** Public static files for the Vue.js app.
- **package.json:** Contains the scripts and dependencies for the Vue.js project.

### SQL Files
- **createtable.sql:** SQL script to create necessary tables.
- **droptable.sql:** SQL script to drop tables (useful for resets).
- **dummydata.sql:** Dummy data for testing.

### Other Files
- **postTest.js:** Script to test API endpoints.
- **exampleEndpointOutput.md:** Sample output documentation from various endpoints.

---

## Testing

### API Testing (Backend)
1. **Using postTest.js:**
   ```bash
   node postTest.js
   ```
2. **Using curl:**
   ```bash
   curl -X POST http://localhost:80/api/exampleEndpoint \
        -d '{"key":"value"}' \
        -H "Content-Type: application/json"
   ```
3. **Using Postman:**
   Import the API endpoints and test interactively.

### Frontend Testing
- Use the browser (or tools like Vue DevTools) to interact with the running Vue.js app.
- Ensure API calls are properly routed to the backend.

---

## Contribution Guide

1. **Fork and Clone:**
   ```bash
   git clone https://github.com/yourusername/studysync.git
   cd studysync
   ```
2. **Create a New Branch:**
   ```bash
   git checkout -b feature-name
   ```
3. **Make Changes and Test:**
   Use `postTest.js`, `curl`, or Postman for backend testing and run the frontend locally for UI changes.
4. **Commit and Push:**
   ```bash
   git commit -m "Add feature-name"
   git push origin feature-name
   ```
5. **Submit a Pull Request** for review.

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## Contact

For further inquiries, please contact us at [zafranzafran0234@gmail.com](mailto:zafranzafran0234@gmail.com).

---

## Acknowledgments

- **University of Technology Malaysia (UTM):** For inspiration and support.
- **Perl Community:** For the Mojolicious framework and related documentation.
- **Vue.js Community:** For continuous improvements to the frontend ecosystem.
```

---

This README now provides clear instructions for setting up both the backend and front end, including Docker-based MariaDB configuration, Perl dependency installation, and Vue.js development steps. You can adjust paths and commands as needed for your environment.
