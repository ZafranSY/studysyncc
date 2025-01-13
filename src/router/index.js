import { createRouter, createWebHistory } from "vue-router";

const routes = [
    {
        path: "/",
        name: "landingPage",
        component: () =>
            import(/* webpackChunkName: "about" */ "../views/LandingPage.vue"),
    },
    {
        path: "/login",
        name: "login",
        component: () => import("../views/LoginPage.vue"),
    },
    {
        path: "/homeview",
        name: "homeview",
        component: () => import("../views/HomeView.vue"),
        meta: { requiresAuth: true }, // Lazy loaded
    },

    {
        path: "/homeview/category/:title",
        name: "CourseFiles",
        component: () => import("@/views/CourseFileView.vue"),
    },
    {
        path: "/:semesterURL",
        name: "CategoryView",
        component: () => import("@/views/CategoryView.vue"),
        props : true,
    },
    {
        path: "/:semesterURL/:categoryURL",
        name: "CourseDetails",
        component: () => import("@/views/CourseDetailsView.vue"),

        navigateToDetails(id) {
            console.log(`Navigating to details of file ID: ${id}`);
            this.$router.push(`/course-files/${id}`);
        },
    },

    {
        path: "/category/:title/student",
        name: "CourseDetailsStudent",
        component: () => import("@/views/CourseDetailViewStudent.vue"),
        meta: { requiresAuth: true, allowedRoles: ["Pelajar FSKSM"] },
    },


    {
        path: "/allfile",
        name: "AllFile",
        component: () => import("@/views/AllFile.vue"),
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
