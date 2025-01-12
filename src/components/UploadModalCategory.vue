<template>
    <div v-if="show" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Create New Category</h2>
                <button class="close-btn" @click="closeModal">X</button>
            </div>
            <div class="modal-body">
                <label for="categoryName">
                    <span>Category Name:</span>
                    <input type="text" v-model="formData.categoryName" id="categoryName"
                        placeholder="Enter Category Name" required />
                </label>
            </div>
            <div class="modal-footer">
                <button class="cancel-btn" @click="closeModal">Cancel</button>
                <button class="save-btn" @click="handleSubmit">Save</button>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    props: {
        show: {
            type: Boolean,
            required: true,
        },
    },
    data() {
        return {
            formData: {
                categoryName: "",
            },
        };
    },
    methods: {
        closeModal() {
            this.$emit("close");
        },
        async handleSubmit() {
            const session_id = localStorage
                .getItem("session_id")
                ?.replace(/['"]+/g, "");
            const semester_id = sessionStorage
                .getItem("semester")
                ?.replace(/['"]+/g, "");

            if (!session_id || !semester_id) {
                alert("Missing session or semester data. Please log in again.");
                return;
            }

            const payload = {
                session_id: session_id.trim(),
                semester_id: semester_id.trim(),
                category_name: this.formData.categoryName.trim(),
            };

            try {
                const response = await fetch("http://localhost/createCategory", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json",
                    },
                    body: JSON.stringify(payload),
                });

                const result = await response.json();
                console.log("Server Response:", result);

                if (response.ok && result.message) {
                    alert(result.message); // Success message
                    this.$emit("save", this.formData); // Notify parent component
                    this.resetForm(); // Reset form after successful submission
                } else {
                    alert(result.error || "Failed to create category. Please try again."); // Error message
                }
            } catch (error) {
                console.error("Error creating category:", error);
                alert("An unexpected error occurred. Please try again."); // Unexpected error message
            }
        },

        resetForm() {
            this.formData = {
                categoryName: "",
            };
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

.modal-content {
    background: #fff;
    padding: 30px;
    border-radius: 8px;
    width: 400px;
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
    font-size: 18px;
    font-weight: 500;
}

.close-btn {
    background: none;
    border: none;
    font-size: 20px;
    cursor: pointer;
    color: #666;
}

.modal-body label {
    display: block;
    margin-bottom: 12px;
    font-size: 14px;
    font-weight: 500;
    color: #333;
}

.modal-body input[type="text"] {
    width: 100%;
    padding: 12px 16px;
    margin-top: 4px;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 14px;
    font-family: "Roboto", sans-serif;
    color: #333;
}

.modal-footer {
    display: flex;
    justify-content: flex-end;
    margin-top: 24px;
}

.save-btn,
.cancel-btn {
    padding: 12px 20px;
    border: none;
    border-radius: 4px;
    font-size: 14px;
    cursor: pointer;
    font-family: "Roboto", sans-serif;
}

.save-btn {
    background-color: #007bff;
    color: white;
    margin-left: 12px;
}

.save-btn:hover {
    background-color: #0056b3;
}

.cancel-btn {
    background-color: #f1f1f1;
    color: #333;
}

.cancel-btn:hover {
    background-color: #e1e1e1;
}
</style>
