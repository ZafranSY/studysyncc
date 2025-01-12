<template>
    <div v-if="show" class="modal-overlay">
      <div class="modal-content">
        <div class="modal-header">
          <h3>Link Permissions Table</h3>
          <button class="close-btn" @click="close">✖</button>
        </div>
        <table class="permissions-table">
          <thead>
            <tr>
              <th>Link Perm ID</th>
              <th>Category</th>
              <th>Semester ID</th>
              <th>Google Link ID</th>
              <th>User Email</th>
              <th>Role Name</th>
              <th>Can Read</th>
              <th>Can Update</th>
              <th>Can Delete</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(row, index) in permissions" :key="index">
              <td>{{ row.link_perm_id }}</td>
              <td>{{ row.category }}</td>
              <td>{{ row.semester_id }}</td>
              <td>{{ row.gdlink_id }}</td>
              <td>{{ row.user_email || "Everyone" }}</td>
              <td>{{ row.role_name }}</td>
              <td>{{ row.can_read ? "Yes" : "No" }}</td>
              <td>{{ row.can_update ? "Yes" : "No" }}</td>
              <td>{{ row.can_delete ? "Yes" : "No" }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
                
  </template>
  
  <script>
  export default {
    name: "LinkPermissionPopup",
    props: {
  show: {
    type: Boolean,
    default: false, // Should be false by default
  },
},
    data() {
      return {
        permissions: [], // Store permissions fetched from API
      };
    },
    methods: {
      fetchPermissions() {
        const url = "http://localhost/getLinkPermissions"; // Your API endpoint
        fetch(url)
          .then((response) => response.json())
          .then((data) => {
            this.permissions = data.permissions || [];
          })
          .catch((error) => {
            console.error("Failed to fetch link permissions:", error);
          });
      },
      close() {
          console.log("Close button clicked!");
        this.$emit("close");
      },
    },
    mounted() {
      this.fetchPermissions();
    },
  };
  </script>
  
  <style scoped>
  .modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.5);
    display: flex;
    justify-content: center;
    align-items: center;
  }
  
  .modal-content {
    background: white;
    padding: 20px;
    border-radius: 8px;
    width: 80%;
    max-width: 600px;
  }
  
  .permissions-table {
    width: 100%;
    border-collapse: collapse;
  }
  
  .permissions-table th,
  .permissions-table td {
    padding: 8px;
    text-align: left;
    border-bottom: 1px solid #ddd;
  }
  
  .close-btn {
    background: none;
    border: none;
    font-size: 18px;
    cursor: pointer;
  }
  </style>
  