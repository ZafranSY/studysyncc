<template>
    <div v-if="show" class="modal-overlay" role="dialog" aria-labelledby="modal-title">
      <div class="modal-content">
        <div class="modal-header">
          <h2 id="modal-title">Create New Semester</h2>
          <button class="close-btn" @click="closeModal">X</button>
        </div>
        <div class="modal-body">
          <label>
            Semester Name:
            <input
              type="text"
              v-model="formData.semesterName"
              placeholder="Enter Semester Name"
            />
          </label>
          <span v-if="formError" class="error-text">{{ formError }}</span>
        </div>
        <div class="modal-footer">
          <button class="cancel-btn" @click="closeModal">Cancel</button>
          <button class="save-btn" @click="saveData">Save</button>
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
          semesterName: "", // For semester-specific name input
        },
        formError: "", // Stores validation error messages
      };
    },
    methods: {
      closeModal() {
        this.$emit("close");
      },
      saveData() {
        if (!this.formData.semesterName.trim()) {
          this.formError = "Please enter a semester name!";
          return;
        }
        this.formError = ""; // Clear the error when input is valid
        this.$emit("save", this.formData); // Emit the form data
        this.formData.semesterName = ""; // Reset the form fields
        this.closeModal();
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
  
  .modal-body input[type="text"] {
    width: 100%;
    padding: 12px 16px;
    margin-top: 4px;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 14px;
    font-family: 'Roboto', sans-serif;
    color: #333;
  }
  
  .error-text {
    color: red;
    font-size: 12px;
    margin-top: 4px;
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
  }
  </style>
  