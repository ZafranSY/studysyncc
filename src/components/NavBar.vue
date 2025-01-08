<template>
  <div class="container">
    <div class="sidebar">
      <div class="logo">
        <img src="../assets/utm_logo.png" alt="UTM Logo" />
        <!-- <span>UTM</span> -->
      </div>

      <div class="menu-section">
        <div class="menu-header">MAIN</div>
        <router-link to="/allfile" class="menu-item">
          
          <span>🏠</span>
          All
        </router-link>
        <a href="#" class="menu-item">
          <span>⭐</span>
          Favourite
        </a>
        <a href="#" class="menu-item">
          <span>↗️</span>
          Shared with me
        </a>
        <a href="#" class="menu-item">
          <span>🕒</span>
          New
        </a>
      </div>
      <div class="menu-section">
        <div class="menu-header">SETTINGS</div>
        <a href="#" class="menu-item">
          <span>🔔</span>
          Notification
        </a>
        <a href="#" class="menu-item">
          <span>⚙️</span>
          Settings
        </a>
      </div>

      <div class="theme-toggle">
        <span>🌞 Light</span>
        <span>🌙 Dark</span>
      </div>
    </div>
  </div>
</template>
<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
  font-family: Arial, sans-serif;
}

body {
  background-color: #f5f5f5;
}
.container {
  display: flex;
  min-height: 100vh;
}
.sidebar {
  width: 250px;
  background-color: white;
  padding: 20px;
  box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
  position: fixed;
  height: 1000px;
}
.logo {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 30px;
}

.logo img {
  width: auto;
  height: 50px;
}

.menu-section {
  margin-bottom: 30px;
}

.menu-header {
  color: #666;
  font-size: 15px;
  margin-bottom: 10px;
  text-align: left;
  text-transform: uppercase;
}

.menu-item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 10px;
  color: #333;
  text-decoration: none;
  border-radius: 5px;
  margin-bottom: 5px;
  font-size: 14px;
}

.menu-item:hover {
  background-color: #f0f0f0;
}
.theme-toggle {
  display: flex;
  gap: 10px;
  margin-top: auto;
  padding: 10px;
  font-size: 14px;
  position: fixed;
  bottom: 20px;
  width: 210px;
  background: #f5f5f5;
  border-radius: 5px;
  justify-content: space-around;
}
</style>

<script>
export default {
  name: "NavbarView",
};
</script>
