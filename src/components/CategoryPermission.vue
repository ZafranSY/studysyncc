<template>
  <div v-if="show" class="modal-overlay">
    <div class="modal-content">
      <div class="modal-header">
        <h2>Manage Permissions for {{ categoryTitle }}</h2>
        <button class="close-btn" @click="closeModal">X</button>
      </div>
      <div class="modal-body">
        <label for="permissionDetails">
          <span>Permission Details:</span>
          <input
            type="text"
            v-model="formData.permissionDetails"
            id="permissionDetails"
            placeholder="Enter permission details..."
            required
          />
        </label>
        <label for="accessLevel">
          <span>Access Level:</span>
          <select v-model="formData.accessLevel" id="accessLevel" required>
            <option value="">Select access level</option>
            <option value="Read">Read</option>
            <option value="Write">Write</option>
            <option value="Admin">Admin</option>
          </select>
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
      formData: {
        permissionDetails: "",
        accessLevel: "",
      },
    };
  },
  methods: {
    closeModal() {
      this.$emit("close");
    },
    handleSubmit() {
      if (!this.formData.permissionDetails || !this.formData.accessLevel) {
        alert("Please fill in all fields.");
        return;
      }
      alert(`Permissions saved for ${this.categoryTitle}`);
      this.$emit("save", this.formData);
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
  background: white;
  padding: 30px;
  border-radius: 8px;
  width: 400px;
}
.close-btn {
  background: none;
  border: none;
  font-size: 20px;
  cursor: pointer;
  color: #666;
}
.save-btn {
  background-color: #007bff;
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 5px;
}
</style>
