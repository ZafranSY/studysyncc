<template>
  <div class="navbar">
    <NavbarView />
  </div>
  <div class="home">
    <!-- <img alt="Vue logo" src="../assets/logo.png" /> -->
    <router-link to="/">Home</router-link> |
    <router-link to="/login">Login</router-link>
  </div>
</template>
<style>
.navbar {
  position: fixed;
}
.home {
  font-size: 20px;
  font-family: "Courier New", Courier, monospace;
}
.home a {
  font-style: none;
  margin: 10px 5px;
  text-decoration: none;
}
</style>
<script>
// @ is an alias to /src
import NavbarView from "@/components/NavBar.vue";

export default {
  name: "HomeView",
  components: {
    NavbarView,
  },
};
</script>
