<template>
  <header>
    <div class="header-line"></div>
  </header>
  <div class="container">
    <div class="login-box-bg" id="loginPage">
      <div class="login-box">
        <div class="logo-container">
          <div class="logo">
            <img
              src="https://upload.wikimedia.org/wikipedia/commons/thumb/c/cb/UTM-LOGO-FULL.png/1200px-UTM-LOGO-FULL.png"
              alt="UTM Logo"
            />
          </div>
        </div>
        <form id="loginForm" method="POST" action="login">
          <div class="input-field">
            <label for="username">Username</label>
            <input type="text" id="username" name="username" required />
          </div>
          <div class="input-field">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" required />
          </div>
          <button type="button" id="btnLogin" class="login-btn">Login</button>
        </form>
      </div>
    </div>

    <div id="userPage">
      <h2>Welcome, <span id="fullname"></span></h2>
      <p>User Group: <span id="usergroup"></span></p>
      <button id="btnLogout" class="login-btn">Logout</button>
    </div>
  </div>
</template>
<style>
/* Reset and Base Styles */
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: Arial, sans-serif;
  background-color: #f0f0f0;
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  margin: 0;
}

/* Header Styles */
header {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 10vh;
  background-color: white;
  z-index: 10;
}

.header-line {
  height: 100%;
  width: 100%;
}

/* Container Styles */
.container {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100%;
}

/* Login Box Styles */
.login-box-bg {
  background-color: #ede9e9;
  border: 1px solid black;
  border-radius: 1px;
  padding: 30px;
  box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
  width: 40vw;
  height: 50vh;
  display: flex;
  justify-content: center;
  align-items: center;
}

.login-box {
  background-color: #f8f3f3;
  border: 1px solid black;
  border-radius: 1px;
  padding: 30px;
  box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}

/* Logo Styles */
.logo-container {
  margin-bottom: 30px;
  width: 100%;
  display: flex;
  justify-content: center;
}

.logo img {
  width: 65%;
  max-width: 300px;
  height: auto;
}

/* Form Styles */
form {
  width: 100%;
  max-width: 400px;
}

.input-field {
  display: flex;
  align-items: center;
  margin-bottom: 20px;
  width: 100%;
}

.input-field label {
  font-size: 1.1rem;
  margin-right: 15px;
  width: 120px;
  text-align: right;
}

.input-field input {
  flex-grow: 1;
  padding: 12px;
  border: 2px solid #ddd;
  border-radius: 8px;
  font-size: 1.2rem;
  width: 100%;
}

/* Login Button Styles */
.login-btn {
  display: block;
  margin-left: auto;
  padding: 15px 30px;
  background-color: #f82d2d;
  color: white;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-size: 1.2rem;
  transition: background-color 0.3s ease;
  width: 100%;
}

.login-btn:hover {
  background-color: #ff9864;
}

/* User Page */
#userPage {
  display: none;
  text-align: center;
}

/* Responsive Adjustments */
@media (max-width: 768px) {
  .login-box-bg {
    width: 90vw;
    height: auto;
  }

  .input-field {
    flex-direction: column;
    align-items: stretch;
  }

  .input-field label {
    text-align: left;
    margin-bottom: 5px;
    width: 100%;
  }
}
</style>
