<template>
    <div v-if="show" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Link Permissions Table for : ({{gdlink.id}}) {{ gdlink.refName }} </h3>
                <button class="close-btn" @click="close">✖</button>
            </div>

            <div class="table-container">
                <table class="permissions-table">
                    <thead>
                        <tr>

                            <th>User Email</th>
                            <th>Role Name</th>
                            <th>Can Read</th>
                            <th>Can Update</th>
                            <th>Can Delete</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(row, index) in permissions" :key="index">
                            <td>{{ row.user_email }}</td>
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

                        <!-- New Row for Adding Permissions -->
                        <tr>
                            <td><input v-model="newPermission.user_email" placeholder="User email" /></td>
                            <td><input v-model="newPermission.role_name" placeholder="Role name" /></td>
                            <td>
                                <input type="checkbox" v-model="newPermission.can_read" />
                            </td>
                            <td>
                                <input type="checkbox" v-model="newPermission.can_update" />
                            </td>
                            <td>
                                <input type="checkbox" v-model="newPermission.can_delete" />
                            </td>
                            <td>
                                <button class="btn add" @click="saveNewPermission">Add</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="modal-actions">

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
        gdlink: {
            type: Object,
            required: true
        },
    },
    data() {
        return {
            permissions: [],
            roles: [],

            newPermission: {
                user_email: "",
                role_name: "",
                can_read: false,
                can_update: false,
                can_delete: false,
            },
            userOptions: [],
            emailOptions: [],
        };
    },
    methods: {
        async fetchPermissions() {
            const sessionId = localStorage.getItem('session_id');
            if (!sessionId) {
                alert("Missing session, semester, or category data.");
                return;
            }

            const payload = {
                session_id: sessionId.replace(/['"]+/g, ""),
                gdlink_id: this.gdlink.id,
            };
            try {
                const response = await fetch("http://localhost/getLinkPermission", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json",
                    },
                    body: JSON.stringify(payload),
                });

                const data = await response.json();
                console.log("Server response:", data);

                if (response.ok) {
                    // Assuming response.result is an array of permission rows, map it into the desired format
                    this.permissions = data.result.map(item => ({
                        gdlink_id: item[3],

                        user_email: item[4] || "-",
                        role_name: item[5] || "-",
                        can_read: item[6] === 1,  // Assuming 1 means can read
                        can_update: item[7] === 1,  // Assuming 1 means can update
                        can_delete: item[8] === 1,  // Assuming 1 means can delete
                    }));
                } else {
                    alert(data.error || "Failed to fetch category permissions.");
                }
            } catch (error) {
                console.error("Failed to fetch category permissions:", error);
            }
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



        async saveNewPermission() {

            const newPermission = {
                insert_user_email: this.newPermission.user_email || 'No email provided',
                insert_user_role: this.newPermission.role_name || 'No role provided',
                can_read: this.newPermission.can_read || false,
                can_update: this.newPermission.can_update || false,
                can_delete: this.newPermission.can_delete || false,
                gdlink_id: this.gdlink.id,
                session_id: JSON.parse(localStorage.getItem('session_id')),

            };

            let fixedNewPermission = {
                    insert_user_email: this.newPermission.user_email || 'No email provided',
                    insert_user_role: this.newPermission.role_name || 'No role provided',
                    can_read: this.newPermission.can_read || false,
                    can_update: this.newPermission.can_update || false,
                    can_delete: this.newPermission.can_delete || false,
                    gdlink_id: this.gdlink.id,
                    session_id: JSON.parse(localStorage.getItem('session_id')),
                };

            // Handle submission logic here
            console.log('New Permission:', newPermission);

            // Optional: Reset the form fields after submission
            
            try {

                // Send request to API to add new permission
                const response = await fetch("http://localhost/createLinkPermission", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json",
                    },
                    body: JSON.stringify(fixedNewPermission),
                });

                // Check for errors in response
                if (!response.ok) {
                    throw new Error(`HTTP ${response.status}: ${response.statusText}`);
                }

                const result = await response.json();

                // Alert success message and add the new permission to the list
                alert(result.message || "Permission added successfully!");

                this.permissions.push({ ...this.newPermission }); // Add new permission to the list

                this.resetForm(); // Reset form inputs after adding permission
            } catch (error) {
                console.error("Error adding permission:", error);
                alert("Failed to add permission.");
                this.resetForm();
            }

            
        },

        // Optional: Reset the form after submitting the new permission
        resetForm() {
            this.newPermission = {
                user_email: '',
                role_name: '',
                can_read: false,
                can_update: false,
                can_delete: false,
            };
        },

        async updatePermission(row) {
            try {

                const updatedRow = {
                    ...row,
                    session_id: JSON.parse(localStorage.getItem('session_id')),
                    selected_user_email: row.user_email === "-" ? "" : row.user_email,
                    selected_user_role: row.role_name === "-" ? "" : row.role_name,
                };
                const response = await fetch("http://localhost/updateLinkPermission", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json",
                    },
                    body: JSON.stringify(updatedRow),
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
                console.error("Error updating permission:", error);
                alert("Failed to update permission.");
            }
        },

        async deletePermission(row) {
            try {

                const updatedRow = {
                    ...row,
                    session_id: JSON.parse(localStorage.getItem('session_id')),
                    selected_user_email: row.user_email === "-" ? "" : row.user_email,
                    selected_user_role: row.role_name === "-" ? "" : row.role_name,
                };
                const response = await fetch("http://localhost/deleteLinkPermission", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json",
                    },
                    body: JSON.stringify(updatedRow),
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
                console.error("Error updating permission:", error);
                alert("Failed to update permission.");
            }
        },

        close() {

            this.resetForm();
            this.$emit("close");
        },
    },
    mounted() {

        this.fetcRoleOptions();
        this.fetchEmailOptions();
    },
    watch: {
        show(newVal) {
            if (newVal) {
                this.fetchPermissions(); // Fetch permissions when modal is opened
            }
        },
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
    background-color: rgba(0, 0, 0, 0.2);
    /* Changed to semi-transparent */
    backdrop-filter: blur(2px);
    /* Optional: adds a slight blur to background */
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