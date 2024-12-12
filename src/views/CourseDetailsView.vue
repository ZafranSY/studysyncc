<template>
    <div class="page-container">
      <NavbarView class="navbar" />
      <div class="content-container">
        <div class="header-container">
          <div class="header-left">
            <h1>Course File</h1>
            <h2>{{ details.ref }}: {{ details.description }}</h2>
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
                    :src="require('@/assets/folderimg.png')"
                    alt="Folder"
                    class="icon"
                  />
                  {{ file.ref }}
                </td>
                <td>{{ file.description }}</td>
                <td>{{ file.created }}</td>
                <td>{{ file.owner }}</td>
                <td>
                  <button
                    class="action-btn"
                    @click="navigateToDetails(file.id)"
                  >
                    Go To
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        <UploadModal v-if="showModal" :file="selectedFile" @close="closeModal" />
      </div>
    </div>
  </template>
  
  <script>
  import NavbarView from "@/components/NavBar.vue";
  import UploadModal from "@/components/UploadModal.vue";
  
  export default {
    name: "CourseDetailsView",
    components: {
      NavbarView,
      UploadModal,
    },
    data() {
      return {
        searchQuery: "",
        showModal: false,
        selectedFile: null,
        details: {
          id: 1,
          ref: "SECJ0001",
          description: "Computer Science 101",
          created: "2021-10-31 17:24",
          owner: "Noriman",
          files: [
            {
              id: 1,
              ref: "Topic1_Intro",
              description: "Intro to computer science",
              created: "2021-10-31 17:24",
              owner: "Noriman",
            },
            {
              id: 2,
              ref: "Topic2_condition",
              description: "Conditional statements",
              created: "2021-10-31 17:24",
              owner: "Noriman",
            },
          ],
        },
      };
    },
    computed: {
      filteredFiles() {
        return !this.searchQuery
          ? this.details.files
          : this.details.files.filter((file) =>
              file.description.toLowerCase().includes(this.searchQuery.toLowerCase())
            );
      },
    },
    methods: {
      navigateToDetails(id) {
        console.log(`Navigating to file with ID: ${id}`); // Debugging log
        this.$router.push(`/course-files/${id}`); // Navigate to the file's details page
      },
      openModal(file) {
  console.log("Opening modal for file:", file);
  this.selectedFile = file;
  this.showModal = true;
},

      closeModal() {
        this.showModal = false;
        this.selectedFile = null;
      },
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
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 4px;
  }
  
  .search-bar button {
    margin-left: 10px;
    padding: 10px;
    background-color: #007bff;
    color: #fff;
    border: none;
    border-radius: 4px;
    cursor: pointer;
  }
  
  .search-bar button:hover {
    background-color: #0056b3;
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
  </style>
  