<template>
  <div class="page-container">
    <NavbarView class="navbar" />
    <div class="content-container">
      <div class="header-container">
        <div class="header-left">
          <h1>Course File</h1>
          <h2>{{ categoryTitle }}: {{ categoryDescription }}</h2>
        </div>
        <div class="header-right">
          <router-link to="/">Home</router-link> |
          <router-link to="/login">Login</router-link>
        </div>
      </div>

      <div class="details-container">
        <div class="search-bar">
          <input type="text" placeholder="Search..." v-model="searchQuery" />
          <button @click="searchFiles">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
              <path
                d="M21.71 20.29l-3.88-3.88A8 8 0 1016 18l3.88 3.88a1 1 0 001.41 0 1 1 0 00.42-.83 1 1 0 00-.58-.76ZM10 16a6 6 0 110-12 6 6 0 010 12Z"
              />
            </svg>
          </button>
        </div>

        <table class="files-table">
          <thead>
            <tr>
              <th>Ref Name</th>
              <th>Description</th>
              <th>Created</th>
              <th>Owner</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="file in filteredFiles" :key="file.id">
              <td>
                <img
                  :src="require('@/assets/link.png')"
                  alt="Folder"
                  class="icon"
                />
                {{ file.refName }}
              </td>
              <td>{{ file.linkDescription }}</td>
              <td>{{ file.linkPosted }}</td>
              <td>{{ file.owner }}</td>
              <td>
                <!-- Updated Go To Button -->
                <button class="action-btn" @click="goToFile(file)">
                  Go To
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- Circle Button for Upload -->
      <button class="upload-circle-btn" @click="openUploadModal">+</button>

      <!-- Upload Modal -->
      <UploadModalLink
        v-if="showModal"
        :show="showModal"
        :file="selectedFile"
        @close="closeModal"
        @save="addFile"
        @saveSuccess="fetchFiles"
      />
    </div>
  </div>
</template>

<script>
import NavbarView from "@/components/NavBar.vue";
import UploadModalLink from "@/components/UploadModalLink.vue";

export default {
  name: "CourseDetailsView",
  components: {
    NavbarView,
    UploadModalLink,
  },
  data() {
    return {
      searchQuery: "",
      showModal: false,
      selectedFile: null,
      files: [], // Store files data fetched from the API
      categoryTitle: "",
      categoryDescription: "",
    };
  },
  computed: {
    filteredFiles() {
      return !this.searchQuery
        ? this.files
        : this.files.filter((file) =>
            file.linkDescription
              .toLowerCase()
              .includes(this.searchQuery.toLowerCase())
          );
    },
  },
  methods: {
    fetchFiles() {
      const courseId = sessionStorage.getItem("link_refName"); // Ensure session storage value is used
      if (!courseId) {
        console.error("Missing course ID in session storage.");
        return;
      }

      const url = `http://localhost:80/getFilesByCourse?courseId=${encodeURIComponent(
        courseId
      )}`;
      fetch(url)
        .then((response) => {
          if (!response.ok) {
            throw new Error(`Failed to fetch files: ${response.statusText}`);
          }
          return response.json();
        })
        .then((data) => {
          this.files = data.map((file) => ({
            id: file.refName, // Ensure this matches the backend response
            refName: file.refName,
            linkDescription: file.description,
            linkPosted: file.created || "N/A",
            owner: file.owner,
            url: file.url,
          }));
          console.log("Files fetched successfully:", this.files);
        })
        .catch((error) => {
          console.error("Error fetching files:", error);
        });
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

    openUploadModal() {
      console.log("Opening upload modal");
      this.showModal = true;
    },
    closeModal() {
      console.log("Closing modal");
      this.showModal = false;
      this.selectedFile = null;
    },
    addFile(newFile) {
      this.files.push({
        id: newFile.refName,
        refName: newFile.refName,
        linkDescription: newFile.description,
        linkPosted: newFile.created || new Date().toISOString(), // Provide a default date if missing
        owner: newFile.owner,
        url: newFile.url,
      });
    },

    searchFiles() {
      console.log("Searching for files with query:", this.searchQuery);
    },
    setLink_refName(link_refName) {
      sessionStorage.setItem("link_refName", JSON.stringify(link_refName));
      console.log(`link_refName set: ${JSON.stringify(link_refName)}`);
      // Optionally, navigate to the next page
      this.$router.push("/course-files/SECJ2013-03");
    },
  },
  mounted() {
    const category = JSON.parse(sessionStorage.getItem("category")); // Category object
    const courseFile = sessionStorage.getItem("courseFile"); // Course file refName
    const semester = sessionStorage.getItem("semester"); // Semester (sessem)

    // Ensure all necessary data is available
    if (!category || !category.title || !courseFile || !semester) {
      console.error("Missing required session storage values.");
      return;
    }

    // Construct the API URL with the required query parameters
    const url = `http://127.0.0.1/getlink?sessem=${encodeURIComponent(
      semester
    )}&category=${encodeURIComponent(
      category.title
    )}&courseFile_refName=${encodeURIComponent(courseFile)}`;

    console.log("Fetching files from URL:", url);

    // Make the API call
    fetch(url)
      .then((response) => {
        if (!response.ok) {
          throw new Error(`Failed to fetch files: ${response.statusText}`);
        }
        return response.json();
      })
      .then((data) => {
        // Map the API response to match the table format
        this.files = data.map((file) => ({
          id: file.link_refName, // Use link_refName as unique ID
          refName: file.link_refName,
          linkDescription: file.link_description,
          linkPosted: file.link_posted || "N/A", // Default to "N/A" if not provided
          owner: file.owner,
          url: file.link_url,
        }));
        console.log("Files fetched successfully:", this.files);
      })
      .catch((error) => {
        console.error("Error fetching files:", error);
      });
  },
};
</script>

<style scoped>
.page-container {
  display: flex; /* Sidebar and content side by side */
}

.content-container {
  flex: 1;
  padding: 20px;
  margin-left: 230px; /* Ensure content does not overlap with sidebar */
  overflow: auto;
}

.navbar {
  flex-shrink: 0;
}

.header-container {
  display: flex;
  justify-content: space-between; /* Align left and right sections */
  align-items: flex-end; /* Align bottom edges of h1 and h2 */
  margin-bottom: 20px;
}

.header-left {
  text-align: left; /* Align both headers to the left */
}

.header-left h1 {
  font-size: 32px;
  margin-bottom: 5px; /* Adjust space between h1 and h2 */
}

.header-left h2 {
  font-size: 24px;
  margin-top: 0; /* Remove extra margin at the top of h2 */
}

.header-right {
  font-size: 16px;
}

.details-container {
  background: #f9f9f9;
  border: 1px solid #ddd;
  border-radius: 8px;
  padding: 20px;
  font-family: Arial, sans-serif;
  font-size: 18px;
}

.search-bar {
  display: flex;
  margin-bottom: 20px;
  align-items: center;
}

.search-bar input {
  flex: 1;
  width: flex;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
}

.search-bar button {
  margin-left: 10px;
  padding: 10px;
  background-color: #0072ec;
  color: #fff;
  border: none;
  border-radius: 10px;
  cursor: pointer;
}

.search-bar button:hover {
  background-color: #000000;
}

.files-table {
  width: 100%;
  border-collapse: collapse;
}

.files-table th,
.files-table td {
  text-align: left;
  padding: 10px;
  border-bottom: 1px solid #e6e6e6;
}

.files-table th {
  background-color: #f8f8f8;
  font-weight: bold;
}

.files-table td img.icon {
  width: 24px;
  height: 24px;
  margin-right: 10px;
}

.files-table td .file-link {
  color: #007bff;
  text-decoration: none;
}

.files-table td .file-link:hover {
  text-decoration: underline;
}

.action-btn {
  padding: 5px 10px;
  background-color: #007bff;
  color: #fff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.action-btn:hover {
  background-color: #0056b3;
}
.upload-circle-btn {
  position: fixed;
  bottom: 20px;
  right: 20px;
  width: 60px;
  height: 60px;
  border-radius: 50%;
  background-color: #007bff;
  color: white;
  font-size: 24px;
  border: none;
  display: flex;
  justify-content: center;
  align-items: center;
  cursor: pointer;
  box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
}

.upload-circle-btn:hover {
  background-color: #0056b3;
}
</style>
