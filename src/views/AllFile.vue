<template>
  <div class="main-container">
    <NavbarView />
    <div class="content-wrapper">
      <h2 class="page-title">All Links</h2>
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
      <div class="table-container">
        <table class="file-table">
          <thead>
            <tr>
              <th>No.</th>
              <!-- Added No. column -->
              <th>Category</th>
              <th>Session</th>
              <th>Name</th>
              <th>Description</th>
              <th>Owner</th>
              <th>Link</th>
            </tr>
          </thead>
          <tbody>
            <tr
              v-for="(file, index) in filteredFiles"
              :key="file.refName + file.linkPosted"
              @click="goToFile(file)"
            >
              <td>{{ index + 1 }}</td>
              <!-- Display row number -->
              <td>{{ file.category || "N/A" }}</td>
              <td class="session-column">{{ file.linkPosted || "N/A" }}</td>
              <td>{{ file.refName || "No Name" }}</td>
              <td>{{ file.linkDescription || "No Description" }}</td>
              <td>{{ file.owner || "Unknown" }}</td>
              <td>
                <!-- <a
                  v-if="file.url"
                  :href="file.url"
                  target="_blank"
                  rel="noopener noreferrer"
                  class="action-btn"
                >
                  View File
                </a> -->

                <button
                  v-if="file.url"
                  :href="file.url"
                  @click="goToFile(file)"
                  class="icon-button"
                >
                  <img
                    :src="require('@/assets/goto.png')"
                    alt="Go To"
                    class="icon"
                  />
                </button>
                <span v-else>No link</span>
              </td>
            </tr>
            <tr v-if="filteredFiles.length === 0">
              <td colspan="7" class="no-files-text">No files found.</td>
              <!-- Updated colspan to 7 -->
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script>
import NavbarView from "@/components/NavBar.vue"; // Import Navbar Component

export default {
  components: {
    NavbarView,
  },
  data() {
    return {
      files: [], // Stores all fetched files
      filteredFiles: [], // Stores filtered files for search
      searchTerm: "", // Search term entered by user
    };
  },
  methods: {
    fetchAllFiles() {
      const session_id = JSON.parse(localStorage.getItem("session_id"));
      // const semester_id = JSON.parse(sessionStorage.getItem("semester"));
      // const category_name = sessionStorage.getItem("category");
      console.log("session id", session_id);

      const url = "http://localhost/getAllLink";

      fetch(url, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ session_id }),
      })
        .then((response) => {
          if (!response.ok) {
            throw new Error(`HTTP ${response.status}: ${response.statusText}`);
          }
          return response.json();
        })
        .then((data) => {
          console.log("Backend response:", data.allLinks);
          if (data.allLinks && data.allLinks.length > 0) {
            this.files = data.allLinks.map((file) => ({
              id: file[0] || "N/A",
              category: file[1] || "N/A",
              linkPosted: file[2] || "Not Available",
              refName: file[3] || "No Name",
              linkDescription: file[4] || "No Description",
              owner: file[5] || "Unknown",
              url: file[6] || "#",
            }));
            console.log("Mapped Files:", this.files);
            this.filteredFiles = this.files;
          } else {
            console.warn("No links found.");
            this.files = [];
            this.filteredFiles = [];
          }
        })
        .catch((error) => {
          console.error("Error fetching links:", error.message);
          alert("Failed to load links. Please try again.");
        });
    },

    filterFiles() {
      const term = this.searchTerm.toLowerCase();
      this.filteredFiles = this.files.filter(
        (file) =>
          file.linkDescription?.toLowerCase().includes(term) ||
          file.category?.toLowerCase().includes(term) ||
          file.refName?.toLowerCase().includes(term) ||
          file.owner?.toLowerCase().includes(term)
      );
    },
    goToFile(file) {
      if (!file.url) {
        alert("No URL provided.");
        return;
      }
      const validUrl = /^https?:\/\//i.test(file.url)
        ? file.url
        : `http://${file.url}`;
      window.open(validUrl, "_blank");
    },
  },
  mounted() {
    this.fetchAllFiles(); // Automatically fetch files when the component is mounted
  },
};
</script>

<style scoped>
tr {
  cursor: pointer;
}
.icon {
  width: 24px; /* Adjust width as needed */
  height: 24px; /* Adjust height as needed */
  object-fit: contain; /* Ensures the image fits within the box */
}

.icon-button {
  background: none;
  border: none;
  padding: 0;
  margin: 0;
  cursor: pointer;
  display: inline-flex;
  align-items: center;
  justify-content: center;
}
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
.file-table td.session-column {
  white-space: nowrap; /* Prevent line breaks */
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
