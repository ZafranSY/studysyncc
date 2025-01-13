<template>
    <div class="layout">
        <!-- Sidebar -->
        <NavbarView />

        <!-- Main Content -->
        <div class="main-content">
            <!-- Header Section -->
            <div class="header">
                <h1 class="page-title">Semesters</h1>
                <div class="user-info">
                    <div>
                        <span class="user-name">{{ userName }}</span>
                        <span class="user-role">({{ userRole }})</span>
                    </div>
                </div>

                <h2 class="section-title">/</h2>
            </div>

            <!-- Filter Section -->
            <div class="filter-section">
                <!-- Search Box with Icon -->
                <div class="search-wrapper">
                    <span class="search-icon">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none"
                            stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="11" cy="11" r="8"></circle>
                            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                        </svg>
                    </span>
                    <input type="text" v-model="searchQuery" placeholder="Search..." class="filter-input" />
                </div>
            </div>

            <!-- Semester Cards -->
            <div class="card-grid">
                <SemesterCard v-for="semester in filteredSemesters" :key="semester.id" :title="semester.title"
                    :subtitle="semester.subtitle" :bgColor="semester.bgColor" @click="setSemester(semester.title)"
                    @delete-semester="removeSemester"
                    img="https://elearning-archive.utm.my/21223/pluginfile.php/1/theme_moove/sliderimage1/1663554195/2021202203.jpg" />
            </div>

            <!-- Floating Action Button -->
            <div v-if="userRole == 'Academic Officer'">
                <button class="fab-btn" @click="openSemesterModal">
                    <span>+</span>
                </button>
            </div>

            <!-- Modal for Adding a New Semester -->
            <UploadModalSemester v-if="showUploadModal" :show="showUploadModal" @close="closeSemesterModal" @save="saveSemester" />
        </div>
    </div>
</template>

<script>
import NavbarView from "@/components/NavBar.vue";
import SemesterCard from "@/components/SemesterCard.vue";
import UploadModalSemester from "@/components/UploadModalSemester.vue";

export default {
    props: ['semesterURL'],
    components: { NavbarView, SemesterCard, UploadModalSemester },
    data() {
        return {
            userName:"",
            userRole:"",
            selectedFilter: "All",
            searchQuery: "",
            semesters: [],
            showUploadModal: false,
            name: null,
            description: null,
        };
    },
    computed: {
        filteredSemesters() {
            return this.semesters.filter((semester) => {
                const matchesFilter =
                    this.selectedFilter === "All" ||
                    semester.title.startsWith(this.selectedFilter);
                const matchesSearch =
                    semester.title
                        .toLowerCase()
                        .includes(this.searchQuery.toLowerCase()) ||
                    semester.subtitle
                        .toLowerCase()
                        .includes(this.searchQuery.toLowerCase());
                return matchesFilter && matchesSearch;
            });
        },
    },
    mounted() {
        const sessionData = JSON.parse(localStorage.getItem("utmwebfc_session"));
        sessionStorage.clear();

        if (sessionData) {
            this.userName = sessionData.full_name;
            this.userRole = sessionData.description;
        }
        fetch("http://localhost/getSemester")
            .then((response) => response.json())
            .then((data) => {
                this.semesters = data.map((semester, index) => ({
                    id: index + 1,
                    title: semester,
                    subtitle: `${semester} `,
                    bgColor: this.getRandomColor(),
                }));
            })
            .catch((error) => {
                console.error("Error fetching semesters:", error);
            });
    },
    methods: {
        getRandomColor() {
            const letters = "0123456789ABCDEF";
            let color = "#";
            for (let i = 0; i < 6; i++) {
                color += letters[Math.floor(Math.random() * 16)];
            }
            return color;
        },
        transformSemester(semester) {
            // Split the semester string into parts
            const [part1, part2] = semester.split('/'); // "xxyy" and "aabb-1"

            // Extract the relevant substrings
            const yy = part1.slice(2);   // Take the last two characters of "xxyy"
            const bb = part2.slice(2);   // Take the last two characters of "xxyy"
            const bb1 = bb.replace('-', ''); // Remove the dash from "aabb-1"

            // Concatenate the parts to form "yybb1"
            return yy + bb1;
        },
        setSemester(semester) {
            sessionStorage.setItem("semester", JSON.stringify(semester));
            const semesterURL=this.transformSemester(semester);
            this.$router.push(`/${semesterURL}`);
        },
        openSemesterModal() {
            this.showUploadModal = true;
        },
        closeSemesterModal() {
            this.showUploadModal = false;
        },
        saveSemester(data) {
            this.semesters.push({
                id: this.semesters.length + 1,
                title: data.semesterName,
                subtitle: `${data.semesterName} `,
                bgColor: this.getRandomColor(),
            });
            this.showUploadModal = false;
        },
        removeSemester(semesterTitle) {
            const index = this.semesters.findIndex((s) => s.title === semesterTitle);
            if (index !== -1) {
                this.semesters.splice(index, 1); // Remove the semester from the list
            }
        },
    },
};
</script>

<style scoped>
.layout {
    display: flex;
    height: 100vh;
}

.main-content {
    flex-grow: 1;
    padding: 20px;
    margin-left: 260px;
    background-color: #f9f9f9;
    overflow-y: auto;
    display: flex;
    flex-direction: column;
    position: relative;
}

.header {
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    border-bottom: 2px solid #ddd;
    padding-bottom: 10px;
    margin-bottom: 20px;
}

.page-title {
    font-size: 28px;
    font-weight: 500;
    color: #000;
}

.user-info {
    display: flex;
    align-items: center;
    gap: 15px;
    margin-top: 10px;
    margin-bottom: 10px;
}

.user-avatar {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    border: 2px solid #ccc;
    object-fit: cover;
}

.user-name {
    font-size: 18px;
    font-weight: 500;
    color: #333;
}

.user-role {
    font-size: 16px;
    font-weight: 400;
    color: #666;
    margin-left: 5px;
}

.section-title {
    font-size: 18px;
    font-weight: bold;
    color: #333;
}

.page-title {
    font-size: 28px;
    font-weight: 500;
    color: #000;
}

.section-title {
    font-size: 18px;
    font-weight: bold;
    color: #333;
}

.filter-section {
    display: flex;
    align-items: center;
    gap: 12px;
    margin-bottom: 20px;
}

.search-wrapper {
    position: relative;
    width: 254px;
}

.search-icon {
    position: absolute;
    top: 50%;
    left: 10px;
    transform: translateY(-50%);
    color: #999;
}

.filter-input {
    width: 100%;
    height: 39px;
    padding: 6px 12px 6px 38px;
    /* Add padding-left to make space for the icon */
    border: 1px solid #ccc;
    border-radius: 6px;
    font-size: 14px;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

.card-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(306px, 1fr));
    gap: 34px 37px;
    justify-content: center;
    max-width: 1200px;
    margin: 0 auto;
}

.fab-btn {
    position: fixed;
    right: 30px;
    bottom: 30px;
    width: 64px;
    height: 64px;
    border-radius: 50%;
    background-color: #007bff;
    color: white;
    font-size: 32px;
    border: none;
    display: flex;
    justify-content: center;
    align-items: center;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
    cursor: pointer;
    transition: background-color 0.3s ease;
}

.fab-btn:hover {
    background-color: #0056b3;
}

.fab-btn span {
    display: inline-block;
    font-size: 32px;
    line-height: 1;
}

@media (max-width: 768px) {
    .main-content {
        margin-left: 0;
    }

    .filter-section {
        flex-direction: column;
    }
}
</style>
