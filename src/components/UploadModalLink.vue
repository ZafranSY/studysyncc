<template>
  <div v-if="show" class="modal">
    <div class="modal-content">
      <h3>Upload Link Details</h3>
      <form @submit.prevent="handleSubmit">
        <label for="refName">Ref Name:</label>
        <input
          v-model="formData.refName"
          id="refName"
          placeholder="Enter Ref Name"
          required
        />

        <label for="description">Description:</label>
        <input
          v-model="formData.description"
          id="description"
          placeholder="Enter Description"
          required
        />

        <label for="created">Created:</label>
        <input
          v-model="formData.created"
          id="created"
          type="datetime-local"
          required
        />

        <label for="owner">Owner:</label>
        <input
          v-model="formData.owner"
          id="owner"
          placeholder="Enter Owner"
          required
        />

        <label for="url">URL:</label>
        <input
          v-model="formData.url"
          id="url"
          placeholder="Enter URL"
          required
        />

        <div class="modal-actions">
          <button type="button" class="btn cancel" @click="$emit('close')">Cancel</button>
          <button type="submit" class="btn save">Save</button>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
export default {
  name: 'UploadModalLink',
  props: {
    show: Boolean,
    file: Object
  },
  data() {
    return {
      formData: {
        refName: '',
        description: '',
        created: '',
        owner: '',
        url: ''
      }
    }
  },
  methods: {
    handleSubmit() {
      this.$emit('save', { ...this.formData })
      this.$emit('close')
      this.resetForm()
    },
    resetForm() {
      this.formData = {
        refName: '',
        description: '',
        created: '',
        owner: '',
        url: ''
      }
    }
  }
}
</script>
  
<style scoped>
/* Modal base */
.modal {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
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
  max-width: 500px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  position: relative;
  animation: modalSlideIn 0.3s ease-out;
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

/* Header styling */
.modal-content h3 {
  margin: 0 0 24px 0;
  font-size: 24px;
  color: #2c3e50;
  font-weight: 600;
  text-align: left;
}

/* Form styling */
.modal-content form {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

/* Label styling */
.modal-content label {
  font-size: 14px;
  font-weight: 500;
  color: #4a5568;
  margin-bottom: 4px;
  display: block;
}

/* Input styling */
.modal-content input {
  width: 100%;
  padding: 12px 16px;
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  font-size: 14px;
  transition: all 0.2s;
  background: #f8fafc;
}

.modal-content input:focus {
  outline: none;
  border-color: #3b82f6;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
  background: white;
}

/* Button container */
.modal-actions {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  margin-top: 24px;
}

/* Button styling */
.btn {
  padding: 10px 20px;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
  border: none;
}

.btn.save {
  background-color: #3b82f6;
  color: white;
}

.btn.save:hover {
  background-color: #2563eb;
}

.btn.cancel {
  background-color: #e2e8f0;
  color: #4a5568;
}

.btn.cancel:hover {
  background-color: #cbd5e1;
}

input::placeholder {
  color: #94a3b8;
}
</style>