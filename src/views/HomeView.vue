<template>
  <div class="home">
    <!-- <img alt="Vue logo" src="../assets/logo.png" /> -->
    <NavbarView />
  </div>
</template>

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
