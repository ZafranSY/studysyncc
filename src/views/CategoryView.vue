<template>
    <div class="layout">
        <!-- Sidebar -->
        <NavbarView />

        <!-- Main Content -->
        <div class="main-content">
            <!-- Header Section -->
            <div class="header">
                <h1 class="page-title">Categories</h1>
                <div class="user-info">
                    <div>
                        <span class="user-name">{{ this.userName }}</span>
                        <span class="user-role">({{ this.userRole }})</span>
                    </div>
                </div>

                <h2 class="section-title">/ {{ this.semester_id }} </h2>
            </div>

            <!-- Filter Section -->
            <div class="filter-section">
                <div class="search-bar">
                    <!-- Icon -->
                    <span class="search-icon">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
                            <path
                                d="M11 2a9 9 0 1 0 6.28 15.28l4.41 4.42 1.41-1.41-4.41-4.42A9 9 0 0 0 11 2zm0 16a7 7 0 1 1 7-7 7 7 0 0 1-7 7z" />
                        </svg>
                    </span>
                    <!-- Search Input -->
                    <input type="text" v-model="searchQuery" placeholder="Search..." class="filter-input" />
                </div>
            </div>

            <!-- Category Cards -->
            <div v-if="categories.length === 0">No categories found.</div>
            <div class="card-grid">
                <CategoryCard v-for="category in filteredCategories" :key="category.id" :title="category.title"
                    :subtitle="category.subtitle" :bgColor="category.bgColor" @manage-permissions="showPermissionModal"
                    @click="navigateToDetails(category.title)" />
            </div>

            <!-- Plus Button -->
            <div class="add-button" @click="openCategoryModal" v-if="onlyAcademicOfficer">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                    <path d="M13 11h8v2h-8v8h-2v-8H3v-2h8V3h2v8Z" />
                </svg>
            </div>

            <!-- Upload Category Modal -->
            <UploadModalCategory v-if="showCategoryModal" :show="showCategoryModal" @close="closeCategoryModal"
                @save="addCategory" />

            <!-- Permission Modal -->
            <CategoryPermission :show="isPermissionModalOpen" :categoryTitle="selectedCategoryTitle"
                @close="closePermissionModal" @save="handlePermissionSave" />
        </div>
    </div>
</template>

<script>
import NavbarView from "@/components/NavBar.vue";
import UploadModalCategory from "@/components/UploadModalCategory.vue";
import CategoryCard from "@/components/CategoryCard.vue";
import CategoryPermission from "@/components/CategoryPermission.vue"; // Import the permission modal

export default {
    props: ['categoryURL'],
    components: { NavbarView, CategoryCard, UploadModalCategory, CategoryPermission },
    data() {
        return {
            userName:"",
            userRole:"",
            searchQuery: "",
            categories: [],
            showCategoryModal: false,
            semester_id: null,
            selectedCategoryTitle: "", // Holds the selected category title for the modal
            isPermissionModalOpen: false, // Controls the visibility of the permission modal
        };
    },
    computed: {
        filteredCategories() {
            return this.categories.filter((category) => {
                if (!category || !category.title || !category.subtitle) {
                    return false;
                }
                return (
                    category.title.toLowerCase().includes(this.searchQuery.toLowerCase()) ||
                    category.subtitle.toLowerCase().includes(this.searchQuery.toLowerCase())
                );
            });
        },
        onlyAcademicOfficer() {
            return localStorage.getItem('role') === '"Academic Officer"';
        }
    },
    mounted() {
        const session_id = JSON.parse(localStorage.getItem("session_id"));
        this.semester_id = JSON.parse(sessionStorage.getItem("semester")) || this.transformToSemester(this.$route.params.semesterURL);
        console.log("Session ID:", session_id);
        console.log("Semester ID:", this.semester_id);
        const userDat = JSON.parse(localStorage.getItem("utmwebfc_session"));
        this.userName = userDat.full_name;
        this.userRole = userDat.description;
        sessionStorage.removeItem("category");

        fetch("http://localhost/getCategory", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
            },
            body: JSON.stringify({
                session_id,
                semester_id: this.semester_id,
            }),
        })
            .then((response) => {
                console.log("Raw Response:", response);
                if (!response.ok) {
                    return response.json().then((err) => {
                        console.error("Backend Error:", err);
                        throw new Error(err.error || "Unknown error occurred");
                    });
                }
                return response.json();
            })
            .then((data) => {
                console.log("API Data:", data);
                this.categories = (data.categoriesPermission || [])
                    .filter((category) => category)
                    .map((category, index) => ({
                        id: index + 1,
                        title: category,
                        subtitle: category,
                        bgColor: this.getRandomColor(),
                    }));
                console.log("Transformed Categories:", this.categories);
            })
            .catch((error) => {
                console.error("Error fetching categories:", error.message);
                alert(`Error: ${error.message}`);
            });
    },

    methods: {
        navigateToDetails(id) {
            this.$router.push(`/${this.$route.params.semesterURL}/${encodeURIComponent(id)}`);
            this.setCategory(id);
        },
        transformToSemester(input) {
            // Extract the components
            const aa = input.slice(0, 2); // First two characters: "aa"
            const bb = input.slice(2, 4); // Next two characters: "bb"
            const y = input.slice(4);     // Last character: "y"

            // Format the result
            const semester = `20${aa}/20${bb}-${y}`;
            return semester;
        },
        getRandomColor() {
            const letters = "0123456789ABCDEF";
            let color = "#";
            for (let i = 0; i < 6; i++) {
                color += letters[Math.floor(Math.random() * 16)];
            }
            return color;
        },
        setCategory(category) {
            console.log("category session :", category);
            sessionStorage.setItem("category", JSON.stringify(category));
        },
        openCategoryModal() {
            this.showCategoryModal = true;
        },
        closeCategoryModal() {
            this.showCategoryModal = false;
        },
        addCategory(newCategory) {
            const newCategoryEntry = {
                id: this.categories.length + 1,
                title: newCategory.categoryName,
                subtitle: newCategory.categoryName,
                bgColor: this.getRandomColor(),
            };
            this.categories.push(newCategoryEntry);
            this.showCategoryModal = false;
        },
        async confirmAndRemoveCategory(categoryTitle) {
            if (window.confirm(`Are you sure you want to delete "${categoryTitle}"?`)) {
                const sessionId = sessionStorage.getItem('session_id');
                const semesterId = sessionStorage.getItem('semester');

                if (!sessionId || !semesterId) {
                    alert("Missing session or semester data. Please log in again.");
                    return;
                }

                const index = this.categories.findIndex((c) => c.title === categoryTitle);

                if (index !== -1) {
                    // Temporarily remove the category from the UI
                    const removedCategory = this.categories.splice(index, 1);

                    const payload = {
                        session_id: sessionId.replace(/['"]+/g, ""),
                        semester_id: semesterId.replace(/['"]+/g, ""),
                        category_name: categoryTitle,
                    };

                    try {
                        const response = await fetch("http://localhost/deleteCategory", {
                            method: "POST",
                            headers: {
                                "Content-Type": "application/json",
                            },
                            body: JSON.stringify(payload),
                        });

                        if (!response.ok) {
                            throw new Error("Failed to delete category.");
                        }

                        const result = await response.json();
                        console.log("Category deleted successfully:", result);
                    } catch (error) {
                        console.error("Error deleting category:", error);
                        alert("Deletion failed. Please try again.");
                        // Revert the category back to the list on error
                        this.categories.splice(index, 0, ...removedCategory);
                    }
                }
            }
        },
        // Show the permission modal
        showPermissionModal(categoryTitle) {
            console.log(`Opening permission modal for: ${categoryTitle}`);
            this.selectedCategoryTitle = categoryTitle;
            this.isPermissionModalOpen = true;
        },
        // Close the permission modal
        closePermissionModal() {
            console.log("Closing permission modal");
            this.isPermissionModalOpen = false;
            this.selectedCategoryTitle = "";
        },
        // Handle saving permissions
        handlePermissionSave(formData) {
            console.log("Permissions saved for:", formData);
            this.closePermissionModal();
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
    margin: 0;
    color: #333;
}

.filter-section {
    display: flex;
    align-items: center;
    gap: 12px;
    margin-bottom: 20px;
}

.search-bar {
    display: flex;
    align-items: center;
    position: relative;
    width: 254px;
}

.search-icon {
    position: absolute;
    left: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    width: 24px;
    height: 24px;
    color: #666;
}

.filter-input {
    width: 100%;
    height: 39px;
    padding: 6px 12px 6px 40px;
    /* Adding space for the icon */
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

.add-button {
    position: fixed;
    width: 70px;
    height: 70px;
    bottom: 30px;
    right: 30px;
    border-radius: 50%;
    background-color: #007bff;
    display: flex;
    justify-content: center;
    align-items: center;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    cursor: pointer;
    color: white;
}

.add-button svg {
    width: 40px;
    height: 40px;
    fill: white;
}
</style>