<template>
  <div class="main-container">
    <!-- Navbar Component -->
    <NavbarView />

    <!-- Main Content -->
    <div class="content-wrapper">
      <!-- Page Title -->
      <h2 class="page-title">All Files</h2>

      <!-- Search Bar -->
      <div class="search-container">
        <input
          type="text"
          v-model="searchTerm"
          class="search-input"
          placeholder="Search by Description..."
          @input="filterFiles"
        />
      </div>

      <!-- Files Table -->
      <div class="table-container">
        <table class="file-table">
          <thead>
            <tr>
              <th>Description</th>
              <th>Created</th>
              <th>Owner</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <!-- Display Rows if Files Exist -->
            <tr v-for="file in filteredFiles" :key="file.id">
              <td>{{ file.description || "No description available" }}</td>
              <td>{{ formatDate(file.created) || "Unknown date" }}</td>
              <td>{{ file.owner || "Unknown owner" }}</td>
              <td>
                <button class="action-btn">View</button>
              </td>
            </tr>

            <!-- No Files Message -->
            <tr v-if="filteredFiles.length === 0">
              <td colspan="4" class="no-files-text">No files found.</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script>
import NavbarView from "@/components/NavBar.vue"; // Importing Navbar Component

export default {
  components: {
    NavbarView,
  },
  data() {
    return {
      files: [],
      filteredFiles: [],
      searchTerm: "",
    };
  },
  methods: {
    async fetchAllFiles() {
      try {
        const response = await fetch("http://localhost:3000/getAllLinks");
        if (!response.ok) {
          throw new Error(`Error: ${response.statusText}`);
        }
        const data = await response.json();
        this.files = data;
        this.filteredFiles = this.files;
      } catch (error) {
        console.error("Error fetching files:", error);
        alert("Failed to load files.");
      }
    },
    formatDate(dateString) {
      if (!dateString) return "N/A";
      const date = new Date(dateString);
      return date.toLocaleDateString("en-GB");
    },
    filterFiles() {
      const term = this.searchTerm.toLowerCase();
      this.filteredFiles = this.files.filter(
        (file) =>
          file.description?.toLowerCase().includes(term) ||
          file.owner?.toLowerCase().includes(term)
      );
    },
  },
  mounted() {
    this.fetchAllFiles(); // Fetch data when component loads
  },
};
</script>

<style scoped>
.main-container {
  display: flex;
  min-height: 100vh;
}

.content-wrapper {
  flex: 1;
  padding: 20px 40px;
  background-color: #f9f9f9;
  margin-left: 250px;
}

.page-title {
  font-size: 1.8em;
  margin-bottom: 20px;
  color: #2c3e50;
}

.search-container {
  margin-bottom: 20px;
}

.search-input {
  width: 100%;
  padding: 10px;
  border-radius: 4px;
  border: 1px solid #ddd;
  font-size: 16px;
}

.table-container {
  background-color: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.file-table {
  width: 100%;
  border-collapse: collapse;
}

.file-table th,
.file-table td {
  padding: 12px 15px;
  text-align: left;
  border-bottom: 1px solid #eee;
}

.file-table th {
  background-color: #f4f4f4;
  font-weight: 600;
}

.no-files-text {
  text-align: center;
  color: #666;
  padding: 20px;
}

.action-btn {
  padding: 6px 12px;
  background-color: #1890ff;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}
</style>
