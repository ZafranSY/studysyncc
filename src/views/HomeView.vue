<template>
  <div class="layout">
    <!-- Sidebar -->
    <NavbarView />

    <!-- Main Content -->
    <div class="main-content">
      <!-- Header Section -->
      <div class="header">
        <h1 class="page-title">Home</h1>
        <h2 class="section-title">Semester</h2>
      </div>

      <!-- Filter Section -->
      <div class="filter-section">
        <!-- Dropdown -->
        <select v-model="selectedFilter" class="filter-dropdown">
          <option value="All">All</option>
          <option value="20/21">20/21</option>
          <option value="21/22">21/22</option>
          <option value="22/23">22/23</option>
        </select>

        <!-- Search Box -->
        <input
          type="text"
          v-model="searchQuery"
          placeholder="Search..."
          class="filter-input"
        />
      </div>

      <!-- Semester Cards -->
      <div class="card-grid">
        <SemesterCard
          v-for="semester in filteredSemesters"
          :key="semester.id"
          :title="semester.title"
          :subtitle="semester.subtitle"
          :bgColor="semester.bgColor"
          :link="'/semester/' + semester.id"
        />
      </div>
    </div>
  </div>
</template>

<script>
import NavbarView from "@/components/NavBar.vue";
import SemesterCard from "@/components/SemesterCard.vue";

export default {
  components: { NavbarView, SemesterCard },
  data() {
    return {
      selectedFilter: "All",
      searchQuery: "",
      semesters: [
        { id: 1, title: "20/21 1", subtitle: "Sem 20211", bgColor: "#4CB5F5" },
        { id: 2, title: "20/21 2", subtitle: "Sem 20212", bgColor: "#D3D3D3" },
        { id: 3, title: "21/22 1", subtitle: "Sem 21221", bgColor: "#CC6666" },
        { id: 4, title: "21/22 2", subtitle: "Sem 21222", bgColor: "#6A5ACD" },
        { id: 5, title: "22/23 1", subtitle: "Sem 22231", bgColor: "#DDA0DD" },
        { id: 6, title: "22/23 2", subtitle: "Sem 22232", bgColor: "#8FBC8F" },
      ],
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
  border-bottom: 2px solid #ddd; /* Subtle underline */
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
  font-weight: bold; /* Bold "Course Coordination" */
  margin: 0;
  color: #333;
}

.filter-section {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 20px;
}

.filter-dropdown {
  padding: 6px 12px;
  border: 1px solid #ccc;
  border-radius: 6px;
  font-size: 14px;
  background-color: #fff;
  width: 100px;
  height: 39px;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

.filter-input {
  width: 254px;
  height: 39px;
  padding: 6px 12px;
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
</style>
