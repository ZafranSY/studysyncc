<template>
  <div v-if="show" class="modal-overlay">
    <div class="modal-content large">
      <div class="modal-header">
        <h2>Manage Permissions for {{ categoryTitle }}</h2>
        <button class="close-btn" @click="closeModal">X</button>
      </div>
      <div class="modal-body">
        <div v-if="loading" class="loading-container">
          <p>Loading permissions...</p>
        </div>
        <div v-else>
          <div class="search-container">
            <input
              type="text"
              v-model="searchTerm"
              class="search-input"
              placeholder="Search by email or role..."
              @input="filterPermissions"
            />
          </div>
          <div class="table-container">
            <table class="permissions-table">
              <thead>
                <tr>
                  <th>No.</th>
                  <th>User Email</th>
                  <th>Role</th>
                  <th class="centered-column">Can Read Category</th>
                  <th class="centered-column">Can Create Links</th>
                </tr>
              </thead>
              <tbody>
                <tr v-if="filteredPermissions.length === 0">
                  <td colspan="5" class="no-permissions-text">
                    No permissions found.
                  </td>
                </tr>
                <tr
                  v-for="(permission, index) in filteredPermissions"
                  :key="permission.category_perm_id"
                >
                  <td>{{ index + 1 }}</td>
                  <td>{{ permission.user_email || "N/A" }}</td>
                  <td>{{ permission.role_name || "N/A" }}</td>
                  <td class="centered-column">
                    <input type="checkbox" disabled :checked="permission.can_read_category === 1" />
                  </td>
                  <td class="centered-column">
                    <input type="checkbox" disabled :checked="permission.can_create_links === 1" />
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button class="cancel-btn" @click="closeModal">Close</button>
      </div>
    </div>
  </div>
</template>

---

### **Script Section**

```javascript
<script>
export default {
  name: "CategoryPermission",
  props: {
    show: {
      type: Boolean,
      required: true,
    },
    categoryTitle: {
      type: String,
      required: true,
    },
  },
  data() {
    return {
      permissionList: [], // Full permission list fetched from the API
      filteredPermissions: [], // Filtered list based on search input
      searchTerm: "", // User input for searching permissions
      loading: false, // Indicates when the data is being fetched
    };
  },
  watch: {
    show(newVal) {
      if (newVal) {
        this.fetchPermissions(); // Fetch permissions when modal is opened
      }
    },
  },
  methods: {
    closeModal() {
      this.$emit("close");
      this.searchTerm = ""; // Clear search term when closing modal
    },
    async fetchPermissions() {
      this.loading = true;
      try {
        const session_id = localStorage.getItem("session_id")?.replace(/['"]+/g, "");
        const semester_id = sessionStorage.getItem("semester")?.replace(/['"]+/g, "");

        if (!session_id || !semester_id) {
          alert("Session or semester information is missing. Please log in again.");
          this.loading = false;
          return;
        }

        const payload = {
          session_id: session_id.trim(),
          semester_id: semester_id.trim(),
          category_name: this.categoryTitle,
        };

        console.log("Sending POST request to /getCategoryPermission");

        const response = await fetch("http://localhost/getCategoryPermission", {
          method: "POST", // Ensure POST request
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify(payload),
        });

        if (!response.ok) {
          throw new Error(`HTTP ${response.status}: ${response.statusText}`);
        }

        const data = await response.json();

        if (data.categoriesPermission) {
          this.permissionList = data.categoriesPermission;
          this.filteredPermissions = [...this.permissionList]; // Show all permissions initially
        } else {
          this.permissionList = [];
          this.filteredPermissions = [];
        }
      } catch (error) {
        console.error("Error fetching permissions:", error);
        alert("Failed to load permissions. Please check your network or try again later.");
      } finally {
        this.loading = false;
      }
    },

    filterPermissions() {
      const term = this.searchTerm.trim().toLowerCase();
      this.filteredPermissions = this.permissionList.filter((permission) => {
        return (
          (permission.user_email?.toLowerCase().includes(term) || "N/A".includes(term)) ||
          (permission.role_name?.toLowerCase().includes(term) || "N/A".includes(term))
        );
      });
    },
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
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal-content.large {
  background: #fff;
  padding: 30px;
  border-radius: 8px;
  width: 800px;
  max-height: 80vh;
  overflow-y: auto;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  font-family: "Roboto", sans-serif;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.modal-header h2 {
  font-size: 22px;
  font-weight: bold;
}

.close-btn {
  background: none;
  border: none;
  font-size: 20px;
  cursor: pointer;
  color: #666;
}

.modal-body {
  padding-bottom: 20px;
}

.loading-container {
  display: flex;
  justify-content: center;
  padding: 20px;
  font-size: 18px;
  color: #666;
}

.search-container {
  margin-bottom: 20px;
}

.search-input {
  width: 100%;
  padding: 12px 16px;
  border: 1px solid #ccc;
  border-radius: 4px;
  font-size: 16px;
  outline: none;
}

.table-container {
  background-color: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.permissions-table {
  width: 100%;
  border-collapse: collapse;
}

.permissions-table th,
.permissions-table td {
  padding: 12px 15px;
  text-align: center;
  border-bottom: 1px solid #eee;
}

.permissions-table th {
  background-color: #f4f4f4;
  font-weight: 600;
}

.centered-column {
  width: 180px;
}

input[type="checkbox"] {
  width: 20px;
  height: 20px;
}

.no-permissions-text {
  text-align: center;
  color: #666;
  padding: 20px;
}

.cancel-btn {
  padding: 12px 20px;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
  background-color: #f1f1f1;
  color: #333;
}

.cancel-btn:hover {
  background-color: #e1e1e1;
}
</style>
