<template>
<<<<<<< HEAD
  <div class="file-list">
    <h1>Course File</h1>
    <h2>Courses SEM 20/21 1</h2>
    <table class="courses-table">
      <thead>
        <tr>
          <th>Ref Name</th>
          <th>Description</th>
          <th>Created</th>
          <th>Owner</th>
        </tr>
      </thead>
      <tbody>
        <tr
          v-for="file in files"
          :key="file.id"
          @click="navigateToDetails(file.id)"
          class="clickable-row"
        >
          <td>
            <img
              src="https://upload.wikimedia.org/wikipedia/commons/3/31/Folder_icon.svg"
              alt="Folder"
              class="icon"
            />
            {{ file.ref }}
          </td>
          <td>{{ file.description }}</td>
          <td>{{ file.created }}</td>
          <td>{{ file.owner }}</td>
        </tr>
      </tbody>
    </table>
    <div class="add-button" @click="addNewFile">
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
        <path d="M13 11h8v2h-8v8h-2v-8H3v-2h8V3h2v8Z" />
      </svg>
    </div>
  </div>
=======
    <div class="file-list">
      <h1>Course File</h1>
      <h2>Courses SEM 20/21 1</h2>
      <table class="courses-table">
        <thead>
          <tr>
            <th>Ref Name</th>
            <th>Description</th>
            <th>Created</th>
            <th>Owner</th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="file in files"
            :key="file.id"
            @click="navigateToDetails(file.id)"
            class="clickable-row"
          >
            <td>
              <img
                src="https://upload.wikimedia.org/wikipedia/commons/3/31/Folder_icon.svg"
                alt="Folder"
                class="icon"
              />
              {{ file.ref }}
            </td>
            <td>{{ file.description }}</td>
            <td>{{ file.created }}</td>
            <td>{{ file.owner }}</td>
          </tr>
        </tbody>
      </table>
      <div class="add-button" @click="addNewFile">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
          <path d="M13 11h8v2h-8v8h-2v-8H3v-2h8V3h2v8Z" />
        </svg>
      </div>
    </div>
<<<<<<< HEAD
>>>>>>> 43fdbaaab80a6d12975d0ca0045339a5293af8d2
</template>

<script>
import { useRouter } from "vue-router";

export default {
<<<<<<< HEAD
  name: "FileList",
  data() {
    return {
      files: [
        { id: 1, ref: "SECJ0001", description: "Computer Science 101", created: "2021-10-31 17:24", owner: "Noriman" },
        { id: 2, ref: "SECJ0002", description: "Computer Science 503", created: "2021-10-31 17:24", owner: "Tivnesh" },
        { id: 3, ref: "SECJ0003", description: "Computer Science 404", created: "2021-10-31 17:24", owner: "Abdul" },
      ],
    };
  },
  setup() {
    const router = useRouter();
    const navigateToDetails = (id) => {
      router.push(`/course-files/${id}`);
    };
    const addNewFile = () => {
      alert("Add new file functionality coming soon!");
    };
    return { navigateToDetails, addNewFile };
  },
=======
=======
  </template>
  
  <script>
  import { useRouter } from "vue-router";
  
  export default {
>>>>>>> a28b483c70988e9b1abed6926d464989045ea39a
    name: "FileList",
    data() {
      return {
        files: [
          { id: 1, ref: "SECJ0001", description: "Computer Science 101", created: "2021-10-31 17:24", owner: "Noriman" },
          { id: 2, ref: "SECJ0002", description: "Computer Science 503", created: "2021-10-31 17:24", owner: "Tivnesh" },
          { id: 3, ref: "SECJ0003", description: "Computer Science 404", created: "2021-10-31 17:24", owner: "Abdul" },
        ],
      };
    },
    setup() {
      const router = useRouter();
      const navigateToDetails = (id) => {
        router.push(`/course-files/${id}`);
      };
      const addNewFile = () => {
        alert("Add new file functionality coming soon!");
      };
      return { navigateToDetails, addNewFile };
    },
<<<<<<< HEAD
>>>>>>> 43fdbaaab80a6d12975d0ca0045339a5293af8d2
};
</script>

<style scoped>
.file-list {
<<<<<<< HEAD
  padding: 20px;
  font-family: Arial, sans-serif;
=======
    padding: 20px;
    font-family: Arial, sans-serif;
>>>>>>> 43fdbaaab80a6d12975d0ca0045339a5293af8d2
}

.file-list h1,
.file-list h2 {
<<<<<<< HEAD
  font-size: 24px;
  margin-bottom: 20px;
}

.courses-table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 20px;
=======
=======
  };
  </script>
  
  <style scoped>
  .file-list {
    padding: 20px;
    font-family: Arial, sans-serif;
  }
  
  .file-list h1,
  .file-list h2 {
>>>>>>> a28b483c70988e9b1abed6926d464989045ea39a
    font-size: 24px;
    margin-bottom: 20px;
  }
  
  .courses-table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
<<<<<<< HEAD
>>>>>>> 43fdbaaab80a6d12975d0ca0045339a5293af8d2
}

.courses-table th,
.courses-table td {
<<<<<<< HEAD
  text-align: left;
  padding: 15px;
  border-bottom: 1px solid #e6e6e6;
}

.courses-table th {
  background-color: #f8f8f8;
  font-weight: bold;
}

.courses-table td img.icon {
  width: 24px;
  height: 24px;
  margin-right: 10px;
}

.clickable-row {
  cursor: pointer;
  transition: background-color 0.2s ease;
}

.clickable-row:hover {
  background-color: #f8f8f8;
}

.add-button {
  position: fixed;
  width: 70px;
  height: 70px;
  bottom: 30px;
  right: 30px;
  border-radius: 50%;
  background-color: #d9d9d9;
  display: flex;
  justify-content: center;
  align-items: center;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
  cursor: pointer;
}

.add-button svg {
  width: 40px;
  height: 40px;
  fill: #5c001e;
}
</style>
=======
=======
  }
  
  .courses-table th,
  .courses-table td {
>>>>>>> a28b483c70988e9b1abed6926d464989045ea39a
    text-align: left;
    padding: 15px;
    border-bottom: 1px solid #e6e6e6;
  }
  
  .courses-table th {
    background-color: #f8f8f8;
    font-weight: bold;
  }
  
  .courses-table td img.icon {
    width: 24px;
    height: 24px;
    margin-right: 10px;
  }
  
  .clickable-row {
    cursor: pointer;
    transition: background-color 0.2s ease;
  }
  
  .clickable-row:hover {
    background-color: #f8f8f8;
  }
  
  .add-button {
    position: fixed;
    width: 70px;
    height: 70px;
    bottom: 30px;
    right: 30px;
    border-radius: 50%;
    background-color: #d9d9d9;
    display: flex;
    justify-content: center;
    align-items: center;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    cursor: pointer;
  }
  
  .add-button svg {
    width: 40px;
    height: 40px;
    fill: #5c001e;
<<<<<<< HEAD
}
</style>
>>>>>>> 43fdbaaab80a6d12975d0ca0045339a5293af8d2
=======
  }
  </style>
  
>>>>>>> a28b483c70988e9b1abed6926d464989045ea39a
