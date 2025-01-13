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
                        <input type="text" v-model="searchTerm" class="search-input"
                            placeholder="Search by email or role..." @input="filterPermissions" />
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
                                    <th class="centered-column">Actions</th> <!-- New column for actions -->
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-if="filteredPermissions.length === 0">
                                    <td colspan="6" class="no-permissions-text">
                                        <!-- Adjust colspan for the new column -->
                                        No permissions found.
                                    </td>
                                </tr>
                                <tr v-for="(permission, index) in filteredPermissions"
                                    :key="permission.category_perm_id">
                                    <td>{{ index + 1 }}</td>
                                    <td>{{ permission.user_email || "N/A" }}</td>
                                    <td>{{ permission.role_name || "N/A" }}</td>
                                    <td class="centered-column">
                                        <input type="checkbox" :checked="permission.can_read_category"
                                            v-model="permission.can_read_category" />
                                    </td>
                                    <td class="centered-column">
                                        <input type="checkbox" :checked="permission.can_create_links"
                                            v-model="permission.can_create_links" />
                                    </td>
                                    <td class="centered-column">
                                        <button class="update-btn" @click="updatePermission(permission)">Update</button>
                                        <button class="delete-btn" @click="deletePermission(permission)">Delete</button>
                                    </td> <!-- New actions column -->
                                </tr>
                                <!-- New permission row -->
                                <tr>
                                    <td>
                                        <select v-model="newPermission.role_type" @change="handleRoleTypeChange">
                                            <option value="" disabled selected>Select email or role</option>
                                            <option value="email">Email</option>
                                            <option value="group">Role</option>
                                        </select>
                                    </td>

                                    <td>
                                        <select v-model="newPermission.user_email"
                                            :disabled="roleIsGroup || !newPermission.role_type">
                                            <option value="" disabled selected>Select email</option>
                                            <option v-for="email in emailOptions" :key="email" :value="email">{{ email
                                                }}</option>
                                        </select>
                                    </td>

                                    <td>
                                        <select v-model="newPermission.user_role"
                                            :disabled="roleIsEmail || !newPermission.role_type">
                                            <option value="" disabled selected>Select role</option>
                                            <option v-for="user in userOptions" :key="user" :value="user">{{ user }}
                                            </option>
                                        </select>
                                    </td>

                                    <td class="centered-column">
                                        <input type="checkbox" v-model="newPermission.can_read_category" />
                                    </td>
                                    <td class="centered-column">
                                        <input type="checkbox" v-model="newPermission.can_create_links" />
                                    </td>
                                    <td class="centered-column">
                                        <button class="add-btn" @click="addPermission">Add Permission</button>
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
            newPermission: {
                role_type: "",
                user_email: "",
                user_role: "",
                can_read_category: false,
                can_create_links: false,
            },
            emailOptions: [], // Example emails
            userOptions: [], // Example users
            roleIsGroup: false, // To disable email select if user is selected
            roleIsEmail: false, // To disable user select if email is selected
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
        transformToSemester(input) {
            // Extract the components
            const aa = input.slice(0, 2); // First two characters: "aa"
            const bb = input.slice(2, 4); // Next two characters: "bb"
            const y = input.slice(4);     // Last character: "y"

            // Format the result
            const semester = `20${aa}/20${bb}-${y}`;
            return semester;
        },
        async fetchEmailOptions() {
            fetch('http://localhost/getAllEmails', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                }
            })
                .then(response => response.json())  // Parse the JSON response
                .then(data => {
                    this.emailOptions = data.result;
                })
                .catch(error => {
                    console.error("Error fetching email options:", error);
                });
        },
        async fetcRoleOptions() {
            fetch('http://localhost/getAllRoles', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                }
            })
                .then(response => response.json())  // Parse the JSON response
                .then(data => {
                    this.userOptions = data.result;
                })
                .catch(error => {
                    console.error("Error fetching email options:", error);
                });
        },
        handleRoleTypeChange() {


            if (this.newPermission.role_type === 'email') {
                this.roleIsEmail = true;
                this.roleIsGroup = false;
                this.newPermission.user_email = '';
            } else if (this.newPermission.role_type === 'group') {
                this.roleIsEmail = false;
                this.roleIsGroup = true;
                this.newPermission.user_role = '';
            }
        },
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

                const response = await fetch("http://localhost/getCategoryPermission", {
                    method: "POST",
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
                    // Convert `1` to `true` and `0` to `false` for boolean fields
                    this.permissionList = data.categoriesPermission.map(permission => ({
                        ...permission,
                        can_read_category: permission.can_read_category === 1,
                        can_create_links: permission.can_create_links === 1,
                    }));
                    this.filteredPermissions = [...this.permissionList];
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
                    (permission.user_role?.toLowerCase().includes(term) || "N/A".includes(term))
                );
            });
        },

        async updatePermission(permission) {
            // Implement your update logic here
            try {
                const session_id = localStorage.getItem("session_id")?.replace(/['"]+/g, "");
                const semester_id = JSON.parse(sessionStorage.getItem("semester")) || this.transformToSemester(this.$route.params.semesterURL);

                if (!session_id || !semester_id) {
                    alert("Session or semester information is missing. Please log in again.");
                    return;
                }
                const payload = {
                    session_id: session_id.trim(),
                    semester_id: semester_id.trim(),
                    category_name: this.categoryTitle,
                    selected_user_role: permission.role_name,
                    selected_user_email: permission.user_email,
                    can_read_category: permission.can_read_category,
                    can_create_links: permission.can_create_links,
                };

                console.log(payload)
                const response = await fetch("http://localhost/updateCategoryPermission", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json",
                    },
                    body: JSON.stringify(payload),
                });

                if (!response.ok) {
                    throw new Error(`Server responded with status ${response.status}`);
                }

                const data = await response.json();

                // Handle response message
                if (data.result.message) {

                    alert(data.result.message);
                } else if (data.result.error) {
                    alert(data.result.error);
                }
            } catch (error) {
                console.error("Error deleting permission:", error);
                alert("Failed to delete permission. Please try again later.");
            } finally {
                this.fetchPermissions();
            }
        },

        async deletePermission(permission) {
            // Implement your delete logic here
            if (confirm("Are you sure you want to delete this permission?")) {
                try {
                    const session_id = localStorage.getItem("session_id")?.replace(/['"]+/g, "");
                    const semester_id = JSON.parse(sessionStorage.getItem("semester")) || this.transformToSemester(this.$route.params.semesterURL);

                    if (!session_id || !semester_id) {
                        alert("Session or semester information is missing. Please log in again.");
                        return;
                    }

                    const payload = {
                        session_id: session_id.trim(),
                        semester_id: semester_id.trim(),
                        category_name: this.categoryTitle,
                        selected_user_role: permission.role_name,
                        selected_user_email: permission.user_email,
                    };

                    const response = await fetch("http://localhost/deleteCategoryPermission", {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/json",
                        },
                        body: JSON.stringify(payload),
                    });

                    if (!response.ok) {
                        throw new Error(`Server responded with status ${response.status}`);
                    }

                    const data = await response.json();

                    // Handle response message
                    if (data.result.message) {

                        alert(data.result.message);
                    } else if (data.result.error) {
                        alert(data.result.error);
                    }
                } catch (error) {
                    console.error("Error deleting permission:", error);
                    alert("Failed to delete permission. Please try again later.");
                } finally {
                    this.fetchPermissions();
                }
            }
        },
        async addPermission() {
            try {
                const session_id = localStorage.getItem("session_id")?.replace(/['"]+/g, "");
                const semester_id = sessionStorage.getItem("semester")?.replace(/['"]+/g, "");

                if (!session_id || !semester_id) {
                    alert("Session or semester information is missing. Please log in again.");
                    return;
                }

                const payload = {
                    session_id: session_id.trim(),
                    semester_id: semester_id.trim(),
                    category_name: this.categoryTitle,
                    insert_user_email: this.newPermission.user_email,
                    insert_user_role: this.newPermission.user_role,
                    can_read_category: this.newPermission.can_read_category ? 1 : 0,
                    can_create_links: this.newPermission.can_create_links ? 1 : 0,
                };

                // Show loading indicator or disable button here, if needed.

                const response = await fetch("http://localhost/createCategoryPermission", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json",
                    },
                    body: JSON.stringify(payload),
                });

                // Check if response was successful
                if (!response.ok) {
                    throw new Error(`Server responded with status ${response.status}`);
                }

                const data = await response.json();

                // Handle response message
                if (data.result.message) {

                    alert(data.result.message);
                } else if (data.result.error) {
                    alert(data.result.error);
                }

            } catch (error) {
                // Log the error and alert the user
                console.error("Error adding permission:", error);
                alert(`Error: ${error.message}`);
            } finally {
                this.fetchPermissions();
                this.resetNewPermission(); // Ensure this is always called
                // Hide loading indicator or re-enable button here, if needed.
            }
        },


        resetNewPermission() {
            this.newPermission = {
                user_email: "",
                user_role: "",
                can_read_category: false,
                can_create_links: false,
            };
        },
    },
    mounted() {
        // Fetch email options when the component is mounted
        this.fetchEmailOptions();
        this.fetcRoleOptions();
    },

};
</script>


<style scoped>
/* Modal Overlay */
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

/* Modal Content */
.modal-content.large {
    background: #fff;
    padding: 30px;
    border-radius: 10px;
    width: 90%;
    max-width: 1000px;
    /* Increased container width */
    max-height: 80vh;
    overflow-y: auto;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
    font-family: "Roboto", sans-serif;
}

/* Modal Header */
.modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
}

.modal-header h2 {
    font-size: 24px;
    font-weight: 600;
}

/* Close Button */
.close-btn {
    background: none;
    border: none;
    font-size: 20px;
    cursor: pointer;
    color: #666;
}

/* Modal Body */
.modal-body {
    padding-bottom: 20px;
}

/* Loading Container */
.loading-container {
    display: flex;
    justify-content: center;
    padding: 20px;
    font-size: 18px;
    color: #666;
}

/* Search Container */
.search-container {
    margin-bottom: 20px;
}

/* Search Input */
.search-input {
    width: 100%;
    padding: 14px 18px;
    border: 1px solid #ccc;
    border-radius: 8px;
    font-size: 16px;
    outline: none;
}

/* Table Container */
.table-container {
    background-color: white;
    padding: 20px;
    border-radius: 10px;
    /* Added more radius for a smoother look */
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    overflow-x: auto;
    /* Fix for table overflow */
    max-width: 100%;
    margin-top: 15px;
}

/* Permissions Table */
.permissions-table {
    width: 100%;
    border-collapse: collapse;
    table-layout: auto;
    /* Auto layout to avoid overflow */
}

.permissions-table th,
.permissions-table td {
    padding: 20px 20px;
    /* Increased padding to increase row height */
    text-align: center;
    border-bottom: 1px solid #eee;
    word-wrap: break-word;
    max-width: 200px;
}

.permissions-table th {
    background-color: #f4f4f4;
    font-weight: 600;
}

.permissions-table tr {
    min-height: 50px;
    /* Set a minimum height for each row */
}

.permissions-table select {
    width: auto;
    /* Allows the dropdown to adjust its width to fit the content */
    min-width: 200px;
    /* Optional: Set a minimum width to prevent the dropdown from being too small */
}

.permissions-table option {
    white-space: nowrap;
    /* Prevents wrapping inside options */
}

/* Centered Column */
.centered-column {
    width: 180px;
}

/* Checkbox Styling */
input[type="checkbox"] {
    width: 20px;
    height: 20px;
}

/* No Permissions Text */
.no-permissions-text {
    text-align: center;
    color: #666;
    padding: 20px;
}

/* Cancel Button */
.cancel-btn {
    padding: 12px 24px;
    border: none;
    border-radius: 6px;
    /* Rounded corners */
    font-size: 14px;
    cursor: pointer;
    background-color: #f1f1f1;
    color: #333;
    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
    /* Subtle shadow */
}

.cancel-btn:hover {
    background-color: #e1e1e1;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
    /* Darker shadow on hover */
}

/* General button styling */
button {
    padding: 8px 16px;
    font-size: 14px;
    border-radius: 4px;
    border: none;
    cursor: pointer;
    transition: background-color 0.3s ease, transform 0.3s ease;
}

/* Space between buttons */
.centered-column button {
    margin-right: 12px;
    /* Space between buttons */
}

/* Remove margin from the last button */
.centered-column button:last-child {
    margin-right: 0;
}

/* Update button - Blue */
button.update-btn {
    background-color: #5C6BC0;
    /* Blue color */
    color: white;
}

button.update-btn:hover {
    background-color: #3F51B5;
    /* Darker blue on hover */
}

button.update-btn:active {
    background-color: #3949AB;
    /* Even darker blue when clicked */
}

/* Delete button - Red */
button.delete-btn {
    background-color: #EF5350;
    /* Red color */
    color: white;
}

button.delete-btn:hover {
    background-color: #E53935;
    /* Darker red on hover */
}

button.delete-btn:active {
    background-color: #C62828;
    /* Even darker red when clicked */
}

/* Add button - Green */
button.add-btn {
    background-color: #66BB6A;
    /* Green color */
    color: white;
}

button.add-btn:hover {
    background-color: #43A047;
    /* Darker green on hover */
}

button.add-btn:active {
    background-color: #388E3C;
    /* Even darker green when clicked */
}

/* Style for table data (td) */
td {
    padding: 12px 15px;
    /* Padding for each cell */
    text-align: center;
    /* Center align text inside the cells */
}

/* Input fields styling */
input[type="email"],
input[type="text"] {
    width: 100%;
    /* Full width to fill the cell */
    padding: 10px 15px;
    /* Padding for the input field */
    font-size: 14px;
    /* Text size */
    border: 1px solid #ccc;
    /* Light border color */
    border-radius: 4px;
    /* Rounded corners */
    background-color: #f9f9f9;
    /* Light background color */
    outline: none;
    /* Remove default outline */
    transition: border-color 0.3s ease;
    /* Smooth transition for border color */
}

/* Focus effect for input fields */
input[type="email"]:focus,
input[type="text"]:focus {
    border-color: #5C6BC0;
    /* Border color when focused (Blue) */
    background-color: #ffffff;
    /* White background on focus */
}

/* Placeholder text styling */
input::placeholder {
    color: #888;
    /* Gray color for placeholder text */
    font-style: italic;
    /* Italicized placeholder text */
}

/* Style for select dropdowns */
select {
    width: 100%;
    /* Full width to fill the cell */
    padding: 10px 15px;
    /* Padding for the select element */
    font-size: 14px;
    /* Text size */
    border: 1px solid #ccc;
    /* Light border color */
    border-radius: 4px;
    /* Rounded corners */
    background-color: #f9f9f9;
    /* Light background color */
    outline: none;
    /* Remove default outline */
    appearance: none;
    /* Removes default dropdown arrow on some browsers */
    transition: border-color 0.3s ease, background-color 0.3s ease;
    /* Smooth transitions */
    white-space: nowrap;
    /* Prevent text wrapping inside dropdown */
    overflow: hidden;
    /* Prevent text overflow */
    text-overflow: ellipsis;
    /* Add ellipsis (…) if the text is too long */
}

/* Focus effect for select dropdown */
select:focus {
    border-color: #5C6BC0;
    /* Blue border on focus */
    background-color: #ffffff;
    /* White background on focus */
}

/* Custom dropdown arrow (for browsers that support appearance:none) */
select::-ms-expand {
    display: none;
    /* Hide default dropdown arrow for IE */
}

select::after {
    content: '▼';
    /* Custom arrow */
    font-size: 14px;
    color: #888;
    margin-left: 10px;
}

/* Styling for the select options */
option {
    padding: 10px;
    font-size: 14px;
    background-color: #f9f9f9;
    white-space: nowrap;
    /* Prevent text wrapping in the dropdown items */
}

/* Placeholder for select (this is the disabled selected option) */
option[disabled] {
    color: #888;
    /* Gray color for the placeholder option */
}
</style>
