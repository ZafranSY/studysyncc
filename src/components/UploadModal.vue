<template>
<<<<<<< HEAD
  <div v-if="show" class="modal-overlay">
    <div class="modal-content">
      <div class="modal-header">
        <h2>Link Upload</h2>
        <button class="close-btn" @click="closeModal">X</button>
      </div>
      <div class="modal-body">
        <label class="left-aligned">
          Category:
          <input type="text" v-model="formData.category" placeholder="Enter category" />
        </label>
        <label class="left-aligned">
          URL:
          <div class="url-input-container">
            <input type="text" v-model="formData.url" placeholder="Enter URL" />
            <button class="upload-btn">Upload</button>
          </div>
        </label>
        <label class="left-aligned">
          Reference Name:
          <input type="text" v-model="formData.refName" placeholder="Enter reference name" />
        </label>
        <label class="left-aligned">
          Description:
          <textarea v-model="formData.description" placeholder="Enter description"></textarea>
        </label>
      </div>
      <div class="modal-footer">
        <button class="cancel-btn" @click="closeModal">Cancel</button>
        <button class="save-btn" @click="saveData">Save</button>
      </div>
    </div>
  </div>
=======
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
>>>>>>> 43fdbaaab80a6d12975d0ca0045339a5293af8d2
</template>

<script>
export default {
<<<<<<< HEAD
  props: {
    show: {
      type: Boolean,
      required: true,
    },
    file: {
      type: Object,
      required: false,
    },
  },
  data() {
    return {
      formData: {
        category: "",
        url: "",
        refName: "",
        description: "",
      },
    };
  },
  methods: {
    closeModal() {
      this.$emit("close");
    },
    saveData() {
      console.log("Form data:", this.formData);
      this.closeModal();
    },
  },
=======
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
>>>>>>> 43fdbaaab80a6d12975d0ca0045339a5293af8d2
};
</script>

<style scoped>
<<<<<<< HEAD
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
  width: 500px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  font-family: 'Roboto', sans-serif;
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

.left-aligned {
  text-align: left;
}

.modal-body input[type="text"],
.modal-body textarea {
  width: 100%;
  padding: 12px 16px;
  margin-top: 4px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
  font-family: 'Roboto', sans-serif;
  color: #333;
}

.modal-body textarea {
  resize: none;
  height: 80px;
}

.url-input-container {
  display: flex;
  align-items: center;
}

.url-input-container input {
  flex: 1;
  margin-right: 12px;
}

.upload-btn {
  padding: 10px 16px;
  background-color: #007bff;
  color: #fff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
  font-family: 'Roboto', sans-serif;
}

.upload-btn:hover {
  background-color: #0056b3;
}

.modal-footer {
  display: flex;
  justify-content: flex-end;
  margin-top: 24px;
=======
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
>>>>>>> 43fdbaaab80a6d12975d0ca0045339a5293af8d2
}

.save-btn,
.cancel-btn {
<<<<<<< HEAD
  padding: 12px 20px;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
  font-family: 'Roboto', sans-serif;
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
=======
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
>>>>>>> 43fdbaaab80a6d12975d0ca0045339a5293af8d2
}
</style>