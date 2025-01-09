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
                <button @click="editRecord(file)">Edit</button>
                <button @click="deleteRecord(file.id)">Delete</button>
                <button class="action-btn" @click="goToFile(file)">
                  Go To
                </button>
              </td>
            </tr>
          </tbody>
        </table>

        <!-- Edit Modal -->
        <div v-if="showEditModal" class="modal">
          <div class="modal-content">
            <h3>Edit Link Details</h3>
            <form @submit.prevent="updateRecord">
              <label for="refName">Ref Name:</label>
              <input v-model="editForm.refName" id="refName" placeholder="Enter Ref Name" required />

              <label for="description">Description:</label>
              <input v-model="editForm.linkDescription" id="description" placeholder="Enter Description" required />

              <label for="owner">Owner:</label>
              <input v-model="editForm.owner" id="owner" placeholder="Enter Owner" required />

              <label for="url">URL:</label>
              <input v-model="editForm.url" id="url" placeholder="Enter URL" required />

              <div class="modal-actions">
                <button type="submit" class="btn save">Update</button>
                <button type="button" class="btn cancel" @click="closeEditModal">Cancel</button>
              </div>
            </form>
          </div>
        </div>

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
      showEditModal: false,
      selectedFile: null,
      files: [], // Store files data fetched from the API
      categoryTitle: "",
      categoryDescription: "",
      editForm: {
        id: null,
        refName: "",
        linkDescription: "",
        owner: "",
        url: "",
      },
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
    openUploadModal() {
      this.showModal = true;
    },
    closeModal() {
      this.showModal = false;
      this.selectedFile = null;
    },
    addFile(newFile) {
      this.files.push({
        id: newFile.refName, // Generate a unique ID based on the Ref Name
        refName: newFile.refName,
        linkDescription: newFile.description,
        linkPosted: newFile.created,
        owner: newFile.owner,
        url: newFile.url, // This field holds the URL
      });
    },
    editRecord(file) {
      this.editForm = { ...file };
      this.showEditModal = true;
    },
    closeEditModal() {
      this.showEditModal = false;
      this.editForm = {
        id: null,
        refName: "",
        linkDescription: "",
        owner: "",
        url: "",
      };
    },
    updateRecord() {
      const index = this.files.findIndex((file) => file.id === this.editForm.id);
      if (index !== -1) {
        this.files.splice(index, 1, { ...this.editForm });
      }
      this.closeEditModal();
    },
    deleteRecord(id) {
      this.files = this.files.filter((file) => file.id !== id);
    },
    goToFile(file) {
      if (!file.url) {
        alert("No URL provided.");
        return;
      }

      const validUrl = /^https?:\/\//i.test(file.url) ? file.url : `http://${file.url}`;
      window.open(validUrl, "_blank");
    },
    searchFiles() {
      console.log("Searching for files with query:", this.searchQuery);
    },
  },
  mounted() {
    const sem = sessionStorage.getItem("link_refName");
    console.log(sem); // Check the value in sessionStorage

    if (sem) {
      // Parse the category data and update the page
      const parsedSem = JSON.parse(sem);
      console.log(parsedSem); // Check the parsed object
      this.link_refName = parsedSem.title; // Extract the category title
      this.categoryDescription = parsedSem.description; // Extract description

      // Now make the API call based on the category
      const url = `http://127.0.0.1/getlinkbyRefname?link_refName=${encodeURIComponent(
        parsedSem
      )}`;

      console.log(url); // Ensure the URL is formed correctly

      // Fetch the data based on link_refName
      fetch(url)
        .then((response) => response.json())
        .then((data) => {
          this.files = data.map((file) => ({
            id: file.link_refName, // Use link_refName for unique id
            refName: file.link_refName,
            linkDescription: file.link_description,
            linkPosted: file.link_posted,
            linkUrl: file.link_url,
            owner: file.owner,
          }));
          console.log(this.files); // Ensure the data is loaded correctly
        })
        .catch((error) => {
          console.error("Error fetching links:", error);
        });
    }
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

.modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
}

.modal-content {
  background: white;
  padding: 20px;
  border-radius: 8px;
  width: 400px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}

.modal-actions {
  display: flex;
  justify-content: space-between;
}

.btn.save {
  background-color: #3904e7;
  color: white;
}

.btn.cancel {
  background-color: #6c757d;
  color: white;
}

.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal-content {
  background: #fff;
  padding: 20px;
  border-radius: 8px;
  width: 450px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 25px;
}

.modal-header h2 {
  margin: 0;
  font-size: 16px;
  font-weight: bold;
  color: #333;
}

.close-btn {
  background: none;
  border: none;
  font-size: 16px;
  cursor: pointer;
  color: #333;
}

.form-group {
  margin-bottom: 15px;
}

.label {
  font-size: 14px;
  color: #333;
  margin-bottom: 5px;
}

input {
  width: 100%;
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
  box-sizing: border-box;
}

input::placeholder {
  color: #999;
}

.modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  margin-top: 20px;
}

.save-btn, 
.cancel-btn {
  padding: 8px 20px;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
  font-weight: normal;
}

.save-btn {
  background-color: #000100;
  color: white;
}

.cancel-btn {
  background-color: #dc3545;
  color: white;
}
</style>
  