<template>
    <div v-if="show" class="modal-overlay">
      <div class="modal-content">
        <div class="modal-header">
          <h3>Link Permissions Table</h3>
          <button class="close-btn" @click="close">✖</button>
        </div>
  
        <div class="table-container">
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
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <!-- Existing Permissions Rows -->
              <tr v-for="(row, index) in permissions" :key="index">
                <td>{{ row.link_perm_id }}</td>
                <td>{{ row.category }}</td>
                <td>{{ row.semester_id }}</td>
                <td>{{ row.gdlink_id }}</td>
                <td>{{ row.user_email || "Everyone" }}</td>
                <td>{{ row.role_name }}</td>
                <td>
                  <input type="checkbox" v-model="row.can_read" />
                </td>
                <td>
                  <input type="checkbox" v-model="row.can_update" />
                </td>
                <td>
                  <input type="checkbox" v-model="row.can_delete" />
                </td>
                <td>
                  <button class="btn update" @click="updatePermission(row)">Update</button>
                  <button class="btn delete" @click="deletePermission(row)">Delete</button>
                </td>
              </tr>
  
              <!-- Add New Permission Row -->
              <tr v-if="isAddingNew">
                <!-- Hide Link Perm ID, Category, Semester ID, and Google Link ID in the Add Form -->
                <td colspan="4" class="empty-col">Adding new permission...</td>
                <td><input v-model="newPermission.user_email" placeholder="Enter User Email" /></td>
                <td>
                  <select v-model="newPermission.role_name">
                    <option disabled value="">Select Role</option>
                    <option v-for="role in roles" :key="role" :value="role">{{ role }}</option>
                  </select>
                </td>
                <td><input type="checkbox" v-model="newPermission.can_read" /></td>
                <td><input type="checkbox" v-model="newPermission.can_update" /></td>
                <td><input type="checkbox" v-model="newPermission.can_delete" /></td>
                <td>
                  <button class="btn save" @click="saveNewPermission">Save</button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
  
        <div class="modal-actions">
          <button class="btn add" @click="addRow">Add New Permission</button>
          <button class="btn cancel" @click="close">Cancel</button>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    name: "LinkPermissionPopup",
    props: {
      show: {
        type: Boolean,
        default: false,
      },
    },
    data() {
      return {
        permissions: [],
        roles: [],
        isAddingNew: false,
        newPermission: {
          user_email: "",
          role_name: "",
          can_read: false,
          can_update: false,
          can_delete: false,
        },
      };
    },
    methods: {
      fetchPermissions() {
        fetch("http://localhost/getLinkPermissions")
          .then((response) => response.json())
          .then((data) => {
            this.permissions = data.permissions || [];
          })
          .catch((error) => {
            console.error("Failed to fetch link permissions:", error);
          });
      },
  
      fetchRoles() {
        fetch("http://localhost/getAllRoles")
          .then((response) => response.json())
          .then((data) => {
            this.roles = data.result || [];
          })
          .catch((error) => {
            console.error("Failed to fetch roles:", error);
          });
      },
  
      addRow() {
        this.isAddingNew = true;
      },
  
      async saveNewPermission() {
        try {
          const response = await fetch("http://localhost/addLinkPermission", {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
            },
            body: JSON.stringify(this.newPermission),
          });
  
          if (!response.ok) {
            throw new Error(`HTTP ${response.status}: ${response.statusText}`);
          }
  
          const result = await response.json();
          alert(result.message || "Permission added successfully!");
          this.permissions.push({ ...this.newPermission });
          this.isAddingNew = false;
          this.resetForm();
        } catch (error) {
          console.error("Error adding permission:", error);
          alert("Failed to add permission.");
        }
      },
  
      resetForm() {
        this.newPermission = {
          user_email: "",
          role_name: "",
          can_read: false,
          can_update: false,
          can_delete: false,
        };
      },
  
      async updatePermission(row) {
        try {
          await fetch("http://localhost/updateLinkPermissions", {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
            },
            body: JSON.stringify(row),
          });
          alert("Permission updated successfully!");
        } catch (error) {
          console.error("Error updating permission:", error);
          alert("Failed to update permission.");
        }
      },
  
      async deletePermission(row) {
        try {
          await fetch(`http://localhost/deleteLinkPermission/${row.link_perm_id}`, {
            method: "DELETE",
          });
          this.permissions = this.permissions.filter(
            (perm) => perm.link_perm_id !== row.link_perm_id
          );
          alert("Permission deleted successfully!");
        } catch (error) {
          console.error("Error deleting permission:", error);
          alert("Failed to delete permission.");
        }
      },
  
      close() {
        this.isAddingNew = false;
        this.resetForm();
        this.$emit("close");
      },
    },
    mounted() {
      this.fetchPermissions();
      this.fetchRoles();
    },
  };
  </script>
  
    
    <style scoped>
    .modal {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: rgba(0, 0, 0, 0.2); /* Changed to semi-transparent */
    backdrop-filter: blur(2px); /* Optional: adds a slight blur to background */
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
    max-width: 900px;
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
    position: relative;
    animation: modalSlideIn 0.3s ease-out;
    }

    .close-btn {
    position: absolute;
    top: 20px;
    right: 20px;
    background: none;
    border: none;
    font-size: 20px;
    cursor: pointer;
    color: #666;
    padding: 5px;
    }

    .close-btn:hover {
    color: #000;
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

    .table-container {
    max-height: 400px;
    overflow-y: auto;
    margin-bottom: 24px;
    }

    .permissions-table {
    width: 100%;
    border-collapse: collapse;
    background: #fff;
    }

    .permissions-table th,
    .permissions-table td {
    text-align: left;
    padding: 12px;
    border-bottom: 1px solid #e6e6e6;
    font-size: 14px;
    }

    .permissions-table th {
    background-color: #f8f8f8;
    font-weight: bold;
    color: #4a5568;
    position: sticky;
    top: 0;
    z-index: 1;
    }

    .permissions-table tr:hover {
    background-color: #f1f5f9;
    }

    .modal-actions {
    display: flex;
    justify-content: flex-end;
    gap: 12px;
    margin-top: 24px;
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

    .btn.cancel {
    background-color: #e2e8f0;
    color: #4a5568;
    }

    .btn.cancel:hover {
    background-color: #cbd5e1;
    }
    </style>