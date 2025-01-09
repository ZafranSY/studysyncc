<template>
  <div class="layout">
    <!-- Sidebar -->
    <NavbarView />

    <!-- Main Content -->
    <div class="main-content">
      <!-- Header Section -->
      <div class="header">
        <h1 class="page-title">Home</h1>
        <h2 class="section-title">Category</h2>
      </div>

      <!-- Filter Section -->
      <div class="filter-section">
        <div class="search-bar">
          <!-- Icon -->
          <span class="search-icon">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
              <path d="M11 2a9 9 0 1 0 6.28 15.28l4.41 4.42 1.41-1.41-4.41-4.42A9 9 0 0 0 11 2zm0 16a7 7 0 1 1 7-7 7 7 0 0 1-7 7z" />
            </svg>
          </span>
          <!-- Search Input -->
          <input
            type="text"
            v-model="searchQuery"
            placeholder="Search..."
            class="filter-input"
          />
        </div>
      </div>

      <!-- Semester Cards -->
      <div class="card-grid">
        <CategoryCard
          v-for="semester in filteredSemesters"
          :key="semester.id"
          :title="semester.title"
          :subtitle="semester.subtitle"
          :bgColor="semester.bgColor"
          :link="'/homeview/category/' + semester.title.replace(/\s+/g, '-')"
          @click="setCategory(semester)"
        />
      </div>

      <!-- Plus Button -->
      <div class="add-button" @click="openCategoryModal">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
          <path d="M13 11h8v2h-8v8h-2v-8H3v-2h8V3h2v8Z" />
        </svg>
      </div>

      <!-- Upload Category Modal -->
      <UploadModalCategory
        v-if="showCategoryModal"
        :show="showCategoryModal"
        @close="closeCategoryModal"
        @save="addCategory"
      />
    </div>
  </div>
</template>

<script>
import NavbarView from "@/components/NavBar.vue";
import UploadModalCategory from "@/components/UploadModalCategory.vue"; // Import category modal
import CategoryCard from "@/components/CategoryCard.vue";

export default {
  components: { NavbarView, CategoryCard, UploadModalCategory },
  data() {
    return {
      selectedFilter: "All",
      searchQuery: "",
      semesters: [],
      showCategoryModal: false, // Control visibility of category modal
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
    // Fetch categories from the API when the component is created
    var sem = sessionStorage.getItem("semester");
    if (sem.startsWith('"') && sem.endsWith('"')) {
      sem = sem.slice(1, -1);
    }
    const url = `http://localhost/getCategoryBySemester?semester=${encodeURIComponent(
      sem
    )}`;
    console.log(url);
    fetch(url)
      .then((response) => response.json())
      .then((data) => {
        this.semesters = data.map((category, index) => ({
          id: index + 1,
          title: category,
          subtitle: ` ${category}`,
          bgColor: this.getRandomColor(),
        }));
      })
      .catch((error) => {
        console.error("Error fetching categories:", error);
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
    setCategory(category) {
      sessionStorage.setItem("category", JSON.stringify(category));
      const formattedTitle = category.title.replace(/\s+/g, "-");
      console.log(`Category set: ${JSON.stringify(category)}`);
      this.$router.push(`/homeview/category/${formattedTitle}`);
    },
    openCategoryModal() {
      this.showCategoryModal = true;
    },
    closeCategoryModal() {
      this.showCategoryModal = false;
    },
    addCategory(newCategory) {
      const newCategoryEntry = {
        id: this.semesters.length + 1,
        title: newCategory.categoryName,
        subtitle: ` ${newCategory.categoryName}`,
        bgColor: this.getRandomColor(),
      };
      this.semesters.push(newCategoryEntry);
      this.showCategoryModal = false;
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
  margin: 0 0 4px 0;
  color: #000;
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
  padding: 6px 12px 6px 40px; /* Adding space for the icon */
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
