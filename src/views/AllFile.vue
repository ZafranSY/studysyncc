<template>
  <div class="main-container">
    <!-- Navbar Component -->
    <NavbarView />
    <!-- Main Content -->
    <div class="content-wrapper">
      <!-- Page Title -->
      <h2 class="page-title">All Links</h2>
      <!-- Search Bar -->
      <div class="search-container">
        <div class="search-bar-with-icon">
          <i class="search-icon">&#128269;</i>
          <input
            type="text"
            v-model="searchTerm"
            class="search-input"
            placeholder="Search by category, session, name, description, owner, or link..."
            @input="filterFiles"
          />
        </div>
      </div>
      <!-- Files Table -->
      <div class="table-container">
        <table class="file-table">
          <thead>
            <tr>
              <th>Category</th>
              <th>Session</th>
              <th>Name</th>
              <th>Description</th>
              <th>Owner</th>
              <th>Link</th>
            </tr>
          </thead>
          <tbody>
            <!-- Display Rows if Files Exist -->
            <tr v-for="file in filteredFiles" :key="file.ref_name + file.sessem">
              <td>{{ file.category || "N/A" }}</td>
              <td>{{ file.sessem || "N/A" }}</td>
              <td>{{ file.ref_name || "N/A" }}</td>
              <td>{{ file.description || "No description available" }}</td>
              <td>{{ file.owner || "Unknown owner" }}</td>
              <td>
                <a
                  v-if="file.link"
                  :href="file.link"
                  target="_blank"
                  rel="noopener noreferrer"
                  class="action-btn"
                >
                  View File
                </a>
                <span v-else>No link</span>
              </td>
            </tr>
            <!-- No Files Message -->
            <tr v-if="filteredFiles.length === 0">
              <td colspan="6" class="no-files-text">No files found.</td>
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
      files: [], // Stores all files
      filteredFiles: [], // Stores filtered files for search
      searchTerm: "", // Search term entered by user
    };
  },
  methods: {
  fetchAllFiles() {
    fetch("http://localhost/getlink")  // Fetch from the backend
      .then((response) => {
        if (!response.ok) {
          throw new Error(`HTTP error! Status: ${response.status}`);
        }
        return response.json();  // Convert the response to JSON
      })
      .then((data) => {
        console.log("Fetched files:", data);  // Log the fetched data for debugging
        // Map files to a proper structure if needed
        this.files = data.map((file, index) => ({
          id: index + 1,
          category: file.category || "N/A",
          ref_name: file.ref_name || "N/A",
          sessem: file.sessem || "N/A",
          description: file.description || "No description available",
          owner: file.owner || "Unknown owner",
          link: file.link || null,
        }));
        this.filteredFiles = this.files;  // Set filtered files for table display
      })
      .catch((error) => {
        console.error("Error fetching files:", error);
        alert("Failed to load files.");
      });
  },

  filterFiles() {
    const term = this.searchTerm.toLowerCase();  // Convert search term to lowercase
    this.filteredFiles = this.files.filter(
      (file) =>
        file.description?.toLowerCase().includes(term) ||
        file.category?.toLowerCase().includes(term) ||
        file.ref_name?.toLowerCase().includes(term) ||
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
  text-align: left; /* Left-align the heading */
}
.search-container {
  margin-bottom: 20px;
}

.search-bar-with-icon {
  display: flex;
  align-items: center;
  border: 1px solid #ddd;
  border-radius: 4px;
  padding: 10px;
  background-color: white;
}

.search-icon {
  font-size: 18px;
  margin-right: 10px;
  color: #888;
}

.search-input {
  width: 100%;
  border: none;
  outline: none;
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
  text-decoration: none;
  display: inline-block;
}
</style>

