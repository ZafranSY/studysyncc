<!-- categoryEditModal.vue -->
<template>
    <teleport to="body">
        <div v-if="show" class="modal-overlay">
            <div class="modal-content">
                <h2>Editing {{ categoryData.title }}</h2>
                <form @submit.prevent="handleSubmit">
                    <div class="form-group">
                        <label for="newcategoryId">New Category name:</label>
                        <input type="text" id="newcategoryId" v-model="formData.newcategoryId" class="form-input"
                            required placeholder="Enter new category ID" />
                    </div>
                    <div class="button-group">
                        <button type="submit" class="save-button">Save</button>
                        <button type="button" @click="closeModal" class="cancel-button">Cancel</button>
                    </div>
                </form>
            </div>
        </div>
    </teleport>
</template>

<script>
export default {
    name: 'categoryEditModal',
    emits: ['close', 'category-updated'],
    props: {
        show: {
            type: Boolean,
            required: true
        },
        categoryData: {
            type: Object,
            required: true
        }
    },
    data() {
        return {
            formData: {
                newcategoryId: ''
            }
        }
    },
    watch: {
        show(newVal) {
            if (newVal) {
                this.formData.newcategoryId = this.categoryData.title
                document.body.style.overflow = 'hidden'
            } else {
                document.body.style.overflow = 'auto'
            }
        }
    },
    methods: {
        async handleSubmit() {
            try {
                // Get session_id from localStorage
                const sessionId = JSON.parse(localStorage.getItem('session_id'));

                if (!sessionId) {
                    alert('Session ID not found. Please log in again.');
                    return;
                }

                let payload;
                const newcategoryId = this.formData.newcategoryId;

                payload = {
                    session_id: sessionId,
                    semester_id: JSON.parse(sessionStorage.getItem('semester')), 
                    category_name: this.categoryData.title,  // old category id
                    new_category_name: newcategoryId
                };

                
                const response = await fetch('http://localhost/updateCategory', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(payload)
                });

                const result = await response.json();

                if (result.message) {
                    alert(result.message);
                    this.$emit('category-updated');
                    this.closeModal();
                    location.reload();
                } else if (result.error) {
                    alert(result.error);
                }
            } catch (error) {
                alert('Failed to connect to server');
            }

        },
        closeModal() {
            this.$emit('close');
        }
    }
}
</script>

<style scoped>
.modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: rgba(0, 0, 0, 0.5);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 9999;
}

.modal-content {
    background-color: white;
    padding: 2rem;
    border-radius: 8px;
    width: 90%;
    max-width: 500px;
    position: relative;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.form-group {
    margin-bottom: 1.5rem;
}

.form-group label {
    display: block;
    margin-bottom: 0.5rem;
    font-weight: 500;
}

.form-input {
    width: 100%;
    padding: 0.75rem;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 1rem;
}

.form-input:focus {
    outline: none;
    border-color: #007bff;
    box-shadow: 0 0 0 2px rgba(0, 123, 255, 0.25);
}

.button-group {
    display: flex;
    gap: 1rem;
    justify-content: flex-end;
    margin-top: 2rem;
}

.save-button,
.cancel-button {
    padding: 0.75rem 1.5rem;
    border-radius: 4px;
    border: none;
    cursor: pointer;
    font-size: 1rem;
    transition: background-color 0.2s;
}

.save-button {
    background-color: #007bff;
    color: white;
}

.save-button:hover {
    background-color: #0056b3;
}

.cancel-button {
    background-color: #6c757d;
    color: white;
}

.cancel-button:hover {
    background-color: #5a6268;
}

h2 {
    margin-top: 0;
    margin-bottom: 1.5rem;
    font-size: 1.5rem;
    color: #333;
}
</style>