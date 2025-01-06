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
          <input
            type="text"
            v-model="formData.refName"
            placeholder="Enter Ref Name"
          />
        </label>
        <label>
          Description:
          <input
            type="text"
            v-model="formData.description"
            placeholder="Enter Description"
          />
        </label>

        <label>
          Owner:
          <input
            type="text"
            v-model="formData.owner"
            placeholder="Enter Owner"
          />
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
    async saveData() {
      const data = {
        refName: this.formData.refName,
        description: this.formData.description,
        owner: this.formData.owner,
        url: this.formData.url,
      };

      try {
        console.log("DEBUG: Sending data:", data);

        const response = await fetch("http://localhost/save_coursefile", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify(data),
        });

        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }

        const result = await response.json();
        console.log("DEBUG: Response from server:", result);

        alert(result.message || "Data saved successfully!");
      } catch (error) {
        console.error("Error during fetch:", error);
        alert("Failed to save data. Please check your connection.");
      }
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
  background-color: #f0f0f0;
  margin-right: 10px;
}

.save-btn {
  background-color: #007bff;
  color: white;
}

.save-btn:hover {
  background-color: #0056b3;
}
</style>
