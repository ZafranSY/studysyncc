<template>
    <div v-if="show" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Link Upload</h2>
                <button class="close-btn" @click="closeModal">X</button>
            </div>
            <div class="modal-body">
                <label>
                    Category:
                    <input type="text" v-model="formData.category" placeholder="Enter category" />
                </label>
                <label>
                    URL:
                    <input type="text" v-model="formData.url" placeholder="Enter URL" />
                </label>
                <label>
                    Reference Name:
                    <input type="text" v-model="formData.referenceName" placeholder="Enter reference name" />
                </label>
                <label>
                    Description:
                    <textarea v-model="formData.description" placeholder="Enter description"></textarea>
                </label>
            </div>
            <div class="modal-footer">
                <button class="save-btn" @click="saveData">Save</button>
                <button class="cancel-btn" @click="closeModal">Cancel</button>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    name: "UploadModal",
    props: {
        show: {
            type: Boolean,
            required: true,
        },
    },
    data() {
        return {
            formData: {
                category: "",
                url: "",
                referenceName: "",
                description: "",
            },
        };
    },
    methods: {
        closeModal() {
            this.$emit("close");
        },
        saveData() {
            console.log("Form Data:", this.formData);
            this.$emit("save", this.formData);
            this.closeModal();
        },
    },
};
</script>

<style scoped>
.modal {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    z-index: 1000;
    /* Ensure it's above other elements */
    background: white;
    border-radius: 8px;
    padding: 20px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}

.modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.5);
    z-index: 999;
    /* Ensure it's just behind the modal */
}

.modal-content {
    background: #fff;
    padding: 20px;
    border-radius: 8px;
    width: 400px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}

.modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
}

.modal-header h2 {
    margin: 0;
}

.close-btn {
    background: transparent;
    border: none;
    font-size: 18px;
    cursor: pointer;
}

.modal-body label {
    display: block;
    margin-bottom: 15px;
}

.modal-body input,
.modal-body textarea {
    width: 100%;
    padding: 8px;
    margin-top: 5px;
    border: 1px solid #ddd;
    border-radius: 4px;
}

.modal-footer {
    display: flex;
    justify-content: flex-end;
    gap: 10px;
}

.save-btn,
.cancel-btn {
    padding: 8px 15px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
}

.save-btn {
    background-color: #007bff;
    color: #fff;
}

.save-btn:hover {
    background-color: #0056b3;
}

.cancel-btn {
    background-color: #ddd;
}

.cancel-btn:hover {
    background-color: #bbb;
}
</style>