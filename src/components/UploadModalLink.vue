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
            v-model="formData.link_refName"
            placeholder="Enter Ref Name"
          />
        </label>
        <label>
          Description:
          <input
            type="text"
            v-model="formData.link_desc"
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
        link_refName: "",
        link_desc: "",
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
      // Retrieve session storage values
      const category = JSON.parse(sessionStorage.getItem("category") || "{}");
      const semester = sessionStorage.getItem("semester");
      const courseFile = sessionStorage.getItem("courseFile");

      // Validate session storage values
      if (!category.title || !semester || !courseFile) {
        console.error("Missing session storage values", {
          category,
          semester,
          courseFile,
        });
        alert("Unable to fetch required session values. Please try again.");
        return this.$emit("save", data);
      }

      // Validate form inputs
      const requiredFields = [
        this.formData.link_refName,
        this.formData.link_desc,
        this.formData.owner,
        this.formData.url,
        semester,
        category.title,
        courseFile,
      ];

      if (requiredFields.includes("") || requiredFields.includes(null)) {
        alert("Please fill out all required fields.");
        return;
      }

      // Prepare data payload
      const data = {
        refName: this.formData.link_refName,
        description: this.formData.link_desc,
        owner: this.formData.owner,
        url: this.formData.url,
        sessem: semester,
        category: category.title,
        courseFile: courseFile,
      };

      try {
        console.log("DEBUG: Sending data:", data);

        // Send data to the backend
        const response = await fetch("http://localhost:80/save_coursefile", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify(data),
        });

        if (!response.ok) {
          console.error("HTTP Error:", response.status, response.statusText);
          throw new Error(`HTTP error! Status: ${response.status}`);
        }

        // Parse the response from the server
        const result = await response.json();
        console.log("DEBUG: Response from server:", result);

        // Notify user of success or error
        if (result.message) {
          alert(result.message);
          this.closeModal(); // Close the modal on success
        } else {
          alert("Data saved successfully!");
          this.closeModal();
        }
      } catch (error) {
        console.error("Error during fetch:", error);
        alert(
          "Failed to save data. Please check your connection or try again later."
        );
      }
    },

    // Save selected sessem and category in sessionStorage
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
