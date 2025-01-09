<template>
    <div v-if="show" class="modal-overlay">
      <div class="modal-content">
        <div class="modal-header">
          <h2>Edit Link Details</h2>
          <button class="close-btn" @click="closeModal">&times;</button>
        </div>
        <div class="modal-body">
          <div class="form-group">
            <label for="refName">Ref Name:</label>
            <input type="text" id="refName" v-model="formData.ref_name" placeholder="Enter Ref Name" />
          </div>
          <div class="form-group">
            <label for="description">Description:</label>
            <textarea id="description" v-model="formData.description" placeholder="Enter Description"></textarea>
          </div>
          <div class="form-group">
            <label for="owner">Owner:</label>
            <input type="text" id="owner" v-model="formData.owner" placeholder="Enter Owner" />
          </div>
          <div class="form-group">
            <label for="url">URL:</label>
            <input type="text" id="url" v-model="formData.url" placeholder="Enter URL" />
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn cancel-btn" @click="closeModal">Cancel</button>
          <button class="btn save-btn" @click="submitEdit">Update</button>
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
    formData: {
      type: Object,
      required: true,
    },
  },
  methods: {
    closeModal() {
      this.$emit("close");
    },
    submitEdit() {
      if (!this.formData.ref_name || !this.formData.description || !this.formData.owner || !this.formData.url) {
        alert("Please fill in all fields!");
        return;
      }
      this.$emit("update", this.formData);
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
  padding: 25px;
  border-radius: 12px;
  width: 500px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
}

.modal-header h2 {
  margin: 0;
  font-size: 18px;
  font-weight: 500;
  color: #1a1a1a;
}

.close-btn {
  background: none;
  border: none;
  font-size: 18px;
  cursor: pointer;
  color: #000;
  padding: 0;
}

.form-group {
  margin-bottom: 20px;
  text-align: center;
}

.label {
  font-size: 14px;
  color: #1a1a1a;
  margin-bottom: 8px;
  display: block;
  text-align: center;
}

input {
  width: 100%;
  padding: 10px 15px;
  border: 1px solid #e0e0e0;
  border-radius: 6px;
  font-size: 14px;
  box-sizing: border-box;
  margin-top: 5px;
}

input::placeholder {
  color: #757575;
}

.modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  margin-top: 30px;
}

.save-btn, 
.cancel-btn {
  padding: 8px 25px;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
  font-weight: normal;
}

.save-btn {
  background-color: rgb(40, 167, 69);
  color: white;
}

.cancel-btn {
  background-color: rgb(220, 53, 69);
  color: white;
}

.form-group:last-of-type {
  margin-bottom: 0;
}
</style>