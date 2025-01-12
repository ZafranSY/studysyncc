<template>
    <div class="page-container">
      <NavbarView class="navbar" />
      <div class="content-container">
        <div class="header-container">
          <div class="header-left">
            <h1>Course File</h1>
            <h2>{{ semester_id }}: {{ category_name }}</h2>
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
                  <button v-if="userRole === 'Pelajar FSKSM'" @click="editRecord(file)" class="icon-button">
                    <img
                      :src="require('@/assets/edit.png')"
                      alt="Edit"
                      class="icon"
                    />
                  </button>
                  <button v-if="userRole === 'Pelajar FSKSM'" @click="deleteRecord(file.id)" class="icon-button">
                    <img
                      :src="require('@/assets/delete.png')"
                      alt="Delete"
                      class="icon"
                    />
                  </button>
                  <button @click="goToFile(file)" class="icon-button">
                    <img
                      :src="require('@/assets/goto.png')"
                      alt="Go To"
                      class="icon"
                    />
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
  
          <!-- Edit Modal (Only for Pelajar FSKSM) -->
          <div v-if="showEditModal && userRole === 'Pelajar FSKSM'" class="modal">
            <div class="modal-content">
              <h3>Edit Link Details</h3>
              <form @submit.prevent="updateRecord">
                <label for="refName">Ref Name:</label>
                <input
                  v-model="editForm.refName"
                  id="refName"
                  placeholder="Enter Ref Name"
                  required
                />
  
                <label for="description">Description:</label>
                <input
                  v-model="editForm.linkDescription"
                  id="description"
                  placeholder="Enter Description"
                  required
                />
  
                <label for="owner">Owner:</label>
                <input
                  v-model="editForm.owner"
                  id="owner"
                  placeholder="Enter Owner"
                  required
                />
  
                <label for="url">URL:</label>
                <input
                  v-model="editForm.url"
                  id="url"
                  placeholder="Enter URL"
                  required
                />
  
                <div class="modal-actions">
                  <button type="submit" class="btn save">Update</button>
                  <button
                    type="button"
                    class="btn cancel"
                    @click="closeEditModal"
                  >
                    Cancel
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>
  
        <!-- No Upload Button for Students -->
      </div>
    </div>
  </template>
  
  <script>
  import NavbarView from "@/components/NavBar.vue";
  
  export default {
    name: "CourseDetailsViewStudent",
    components: {
      NavbarView,
    },
    data() {
      return {
        searchQuery: "",
        showEditModal: false,
        selectedFile: null,
        files: [], // Store files fetched from the API
        semester_id: null,
        category_name: null,
        userRole: null,
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
      // Fetch data based on category and session
      fetchFiles() {
        const session_id = JSON.parse(localStorage.getItem("session_id"));
        this.semester_id = JSON.parse(sessionStorage.getItem("semester"));
        this.category_name = JSON.parse(sessionStorage.getItem("category"));
  
        if (!session_id || !this.semester_id || !this.category_name) {
          console.error("Missing session, semester, or category information.");
          return;
        }
  
        const url = "http://localhost/getLink";
  
        fetch(url, {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            session_id,
            semester_id: this.semester_id,
            category_name: this.category_name,
          }),
        })
          .then((response) => {
            if (!response.ok) {
              throw new Error(`HTTP ${response.status}: ${response.statusText}`);
            }
            return response.json();
          })
          .then((data) => {
            if (data.linkViewable) {
              this.files = data.linkViewable.map((file) => ({
                id: file[0] || "N/A",
                refName: file[1] || "No Name",
                linkDescription: file[4] || "No Description",
                linkPosted: file[2] || "Not Available",
                owner: file[5] || "Unknown",
                url: file[6] || "#",
              }));
            } else {
              this.files = [];
            }
          })
          .catch((error) => {
            console.error("Error fetching links:", error.message);
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
        const index = this.files.findIndex(
          (file) => file.id === this.editForm.id
        );
        if (index !== -1) {
          this.files.splice(index, 1, { ...this.editForm });
        }
        this.closeEditModal();
      },
  
      deleteRecord(id) {
        const confirmed = confirm("Are you sure you want to delete this link?");
        if (confirmed) {
          this.files = this.files.filter((file) => file.id !== id);
        }
      },
  
      goToFile(file) {
        const validUrl = /^https?:\/\//i.test(file.url)
          ? file.url
          : `http://${file.url}`;
        window.open(validUrl, "_blank");
      },
  
      searchFiles() {
        console.log("Searching for files with query:", this.searchQuery);
      },
    },
    mounted() {
      this.userRole = localStorage.getItem("user_role"); // Fetch the user role from localStorage
      this.fetchFiles(); // Initialize page by fetching data
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
  margin-left: 20px;
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
  background-color: #630a0a;
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
  background-color: #7a003b;
  color: #fff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.action-btn:hover {
  background-color: #0056b3;
}

add-button {
  position: fixed;
  width: 70px;
  height: 70px;
  bottom: 30px;
  right: 30px;
  border-radius: 50%;
  background-color: #d9d9d9;
  display: flex;
  justify-content: center;
  align-items: center;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
  cursor: pointer;
}
.add-button {
  position: fixed;
  width: 70px;
  height: 70px;
  bottom: 30px;
  right: 30px;
  border-radius: 50%;
  background-color: #d9d9d9;
  display: flex;
  justify-content: center;
  align-items: center;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
  cursor: pointer;
}

.add-button svg {
  width: 40px;
  height: 40px;
  fill: #5c001e;
}
.upload-circle-btn:hover {
  background-color: #0056b3;
}

.modal {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
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
  background: white;
  border-radius: 16px;
  padding: 32px;
  width: 90%;
  max-width: 500px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  position: relative;
  animation: modalSlideIn 0.3s ease-out;
}

@keyframes modalSlideIn {
  from {
    transform: translateY(-20px);
    opacity: 0;
  }
  to {
    transform: translateY(0);
    opacity: 1;
  }
}

.modal-content h3 {
  margin: 0 0 24px 0;
  font-size: 24px;
  color: #2c3e50;
  font-weight: 600;
  text-align: left;
}

/* Form styling */
.modal-content form {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

/* Label styling */
.modal-content label {
  font-size: 14px;
  font-weight: 500;
  color: #4a5568;
  margin-bottom: 4px;
  display: block;
}

/* Input styling */
.modal-content input {
  width: 100%;
  padding: 12px 16px;
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  font-size: 14px;
  transition: all 0.2s;
  background: #f8fafc;
}

.modal-content input:focus {
  outline: none;
  border-color: #3b82f6;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
  background: white;
}

/* Button container */
.modal-actions {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  margin-top: 24px;
}
.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
}

.modal-header h2 {
  margin: 0;
  font-size: 18px;
  font-weight: 500;
  color: #1a1a1a;
}

.btn {
  padding: 10px 20px;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
  border: none;
}

.btn.save {
  background-color: #3b82f6;
  color: white;
}

.btn.save:hover {
  background-color: #2563eb;
}

.btn.cancel {
  background-color: #e2e8f0;
  color: #4a5568;
}

.btn.cancel:hover {
  background-color: #cbd5e1;
}

.close-btn {
  background: none;
  border: none;
  font-size: 18px;
  cursor: pointer;
  color: #000;
  padding: 0;
}

.form-group {
  margin-bottom: 20px;
  text-align: center;
}

.label {
  font-size: 14px;
  color: #1a1a1a;
  margin-bottom: 8px;
  display: block;
  text-align: center;
}

input {
  width: 100%;
  padding: 10px 15px;
  border: 1px solid #e0e0e0;
  border-radius: 6px;
  font-size: 14px;
  box-sizing: border-box;
  margin-top: 5px;
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

.icon {
  width: 20px; /* Adjust size as needed */
  height: 20px; /* Adjust size as needed */
  transition: opacity 0.2s;
}

.icon-button:hover .icon {
  opacity: 0.7; /* Slight fade on hover for better feedback */
}

input::placeholder {
  color: #757575;
}

.modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  margin-top: 30px;
}

.save-btn,
.cancel-btn {
  padding: 8px 25px;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
  font-weight: normal;
}

.save-btn {
  background-color: rgb(40, 167, 69);
  color: white;
}

.cancel-btn {
  background-color: rgb(220, 53, 69);
  color: white;
}

.form-group:last-of-type {
  margin-bottom: 0;
}
  </style>
  