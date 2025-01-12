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
                    <!-- Editable Checkboxes for Permissions -->
                    <td>
                    <input type="checkbox" v-model="row.can_read" />
                    </td>
                    <td>
                    <input type="checkbox" v-model="row.can_update" />
                    </td>
                    <td>
                    <input type="checkbox" v-model="row.can_delete" />
                    </td>
                </tr>
                </tbody>
            </table>
            </div>
    
            <div class="modal-actions">
            <!-- Cancel Button -->
            <button class="btn cancel" @click="close">Cancel</button>
            <!-- Update Button -->
            <button class="btn save" @click="updatePermissions">Update</button>
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
            default: false, // Default to false to hide modal initially
        },
        },
        data() {
        return {
            permissions: [], // Store permissions fetched from API
        };
        },
        methods: {
        fetchPermissions() {
            const url = "http://localhost/getLinkPermissions"; // API endpoint
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
            this.$emit("close"); // Emits the "close" event to close the modal
        },
        async updatePermissions() {
            const url = "http://localhost/updateLinkPermissions";
            try {
            const response = await fetch(url, {
                method: "POST",
                headers: {
                "Content-Type": "application/json",
                },
                body: JSON.stringify({
                permissions: this.permissions, // Send updated permissions
                }),
            });
    
            if (!response.ok) {
                throw new Error(`HTTP ${response.status}: ${response.statusText}`);
            }
    
            const result = await response.json();
            alert(result.message || "Permissions updated successfully!");
            this.close(); // Close modal after successful update
            } catch (error) {
            console.error("Error updating permissions:", error);
            alert("Failed to update permissions.");
            }
        },
        },
        mounted() {
        this.fetchPermissions();
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