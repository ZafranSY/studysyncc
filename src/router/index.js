import { createRouter, createWebHistory } from "vue-router";
import HomeView from "../views/HomeView.vue";

const routes = [
  {
    path: "/",
    name: "home",
    component: HomeView,
    meta: { requiresAuth: true }
  },
  {
    path: "/about",
    name: "about",
    component: () =>
      import(/* webpackChunkName: "about" */ "../views/AboutView.vue"),
    meta: { requiresAuth: true }
  },
  {
    path: "/login",
    name: "login",
    component: () => import("../views/LoginPage.vue"),
  },
  {
    path: "/coursecoordination",
    name: "coursecoordination",
    component: () => import("../views/CourseCoordination.vue"), // Lazy loaded
  },
  {
    path: "/coursecoordination",
    name: "coursecoordination",
    component: () => import("../views/CourseCoordination.vue"), // Lazy loaded
    meta: { requiresAuth: true }
  },

  {
    path: "/course-files/:id",
    name: "CourseDetails",
    component: () => import("@/views/CourseDetailsView.vue"),
  
    navigateToDetails(id) {
      console.log(`Navigating to details of file ID: ${id}`);
      this.$router.push(`/course-files/${id}`);
    }
  },
];

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});

// Navigation Guard
router.beforeEach((to, from, next) => {
    const isLoggedIn = localStorage.getItem("utmwebfc_session");
  
    if (to.meta.requiresAuth && !isLoggedIn) {
      // If the route requires authentication and the user is not logged in
      console.log("Authentication required. Redirecting to login...");
      next("/login");
    } else {
      // Proceed to the next route
      next();
    }
  });

export default router;
