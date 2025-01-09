<template>
    <div v-if="show" class="modal-overlay">
      <div class="modal-content">
        <div class="modal-header">
          <h2>Upload Link Details</h2>
          <button class="close-btn" @click="closeModal">X</button>
        </div>
        <div class="modal-body">
          <label>
            Ref Name:
            <input type="text" v-model="formData.refName" placeholder="Enter Ref Name" />
          </label>
          <label>
            Description:
            <input type="text" v-model="formData.description" placeholder="Enter Description" />
          </label>
          <label>
            Created:
            <input type="text" v-model="formData.created" placeholder="Enter Created Date" />
          </label>
          <label>
            Owner:
            <input type="text" v-model="formData.owner" placeholder="Enter Owner" />
          </label>
          <label>
            URL:
            <input type="text" v-model="formData.url" placeholder="Enter URL" />
          </label>
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
          refName: "",
          description: "",
          created: "",
          owner: "",
          url: "",
        },
      };
    },
    methods: {
      closeModal() {
        this.$emit("close");
      },
      saveData() {
        if (
          !this.formData.refName ||
          !this.formData.description ||
          !this.formData.created ||
          !this.formData.owner ||
          !this.formData.url
        ) {
          alert("Please fill in all fields!");
          return;
        }
        this.$emit("save", this.formData);
        this.resetForm();
        this.closeModal();
      },
      resetForm() {
        this.formData = {
          refName: "",
          description: "",
          created: "",
          owner: "",
          url: "",
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
    width: 500px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    font-family: Arial, sans-serif;
  }
  
  .modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
  }
  
  .modal-header h2 {
    font-size: 18px;
    font-weight: bold;
  }
  
  .close-btn {
    background: none;
    border: none;
    font-size: 20px;
    cursor: pointer;
  }
  
  .modal-body label {
    display: block;
    margin-bottom: 12px;
    font-size: 14px;
  }
  
  .modal-body input {
    width: 100%;
    padding: 10px;
    margin-top: 5px;
    border: 1px solid #ddd;
    border-radius: 4px;
  }
  
  .modal-footer {
    display: flex;
    justify-content: flex-end;
    margin-top: 20px;
  }
  
  .cancel-btn,
  .save-btn {
    padding: 10px 15px;
    border: none;
    border-radius: 4px;
    font-size: 14px;
    cursor: pointer;
  }
  
  .cancel-btn {
    background-color: #f90303;
    margin-right: 10px;
  }
  
  .save-btn {
    background-color: #08c832;
    color: white;
  }
  
  .save-btn:hover {
    background-color: #0056b3;
  }
  </style>
  