import { createRouter, createWebHistory } from "vue-router";
import HomeView from "../views/HomeView.vue";

const routes = [
  {
    path: "/",
    name: "home",
    component: HomeView,
  },
  {
    path: "/about",
    name: "about",
    component: () =>
      import(/* webpackChunkName: "about" */ "../views/AboutView.vue"),
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
    path: "/course-files",
    name: "CourseFiles",
    component: () => import("@/views/CourseFileView.vue"),
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

export default router;
