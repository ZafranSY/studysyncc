<template>
    <div class="page-container">
        <NavbarView class="navbar" />
        <div class="content-container">
            <div class="header-container">
                <div class="header-left">
                    <h1>Course File</h1>
                    <h2>Courses {{ files.length > 0 ? files[0]?.sessem || "N/A" : "N/A" }}</h2>
                </div>
                <div class="header-right">
                    <router-link to="/">Home</router-link> |
                    <router-link to="/login">Login</router-link>
                </div>
            </div>
            <div class="search-bar">
                <input type="text" placeholder="Search..." v-model="searchQuery" />
                <button @click="searchFiles">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                        <path
                            d="M21.71 20.29l-3.88-3.88A8 8 0 1016 18l3.88 3.88a1 1 0 001.41 0 1 1 0 00.42-.83 1 1 0 00-.58-.76ZM10 16a6 6 0 110-12 6 6 0 010 12Z" />
                    </svg>
                </button>
            </div>
            <div class="details-container">
                <table class="files-table">
                    <thead>
                        <tr>
                            <th>Ref No</th>
                            <th>Description</th>
                            <th>Created</th>
                            <th>Owner</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="file in filteredFiles" :key="file.id"
                            @click="navigateToDetails(file.id); setLink_refName(file.ref_name)" class="clickable-row">
                            <td>
                                <img :src="require('@/assets/folderimg.png')" alt="Folder" class="icon" />
                                {{ file.ref_name }}
                            </td>
                            <td>{{ file.description }}</td>
                            <td>{{ file.sessem }}</td>
                            <td>{{ file.owner }}</td>
                        </tr>
                    </tbody>
                </table>

                <!-- Plus Button -->
                <div class="add-button" @click="openUploadModal">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                        <path d="M13 11h8v2h-8v8h-2v-8H3v-2h8V3h2v8Z" />
                    </svg>
                </div>
            </div>

            <!-- Upload Modal -->
            <UploadModal v-if="showModal" :show="showModal" @close="closeUploadModal" @save="addFile" />
        </div>
    </div>
</template>

<script>
import NavbarView from "@/components/NavBar.vue";
import UploadModal from "@/components/UploadModal.vue";

export default {
    name: "CourseFileView",
    components: {
        NavbarView,
        UploadModal,
    },
    data() {
        return {
            searchQuery: "",
            files: [], // Ensure files is initialized as an empty array
            showModal: false, // Modal visibility
        };
    },
    computed: {
        filteredFiles() {
            const searchQueryLower = this.searchQuery.trim().toLowerCase();

            // Filter based on search query
            const filtered = !searchQueryLower
                ? this.files
                : this.files.filter((file) =>
                    file.description.toLowerCase().includes(searchQueryLower)
                );

            // Remove duplicates based on ref_name, description, sessem, and owner
            const uniqueFiles = [];
            const seen = new Set();

            filtered.forEach((file) => {
                const uniqueKey = `${file.ref_name}-${file.description}-${file.sessem}-${file.owner}`;
                if (!seen.has(uniqueKey)) {
                    seen.add(uniqueKey);
                    uniqueFiles.push(file);
                }
            });

            return uniqueFiles;
        },
    },
    methods: {
        saveCourseFile() {
            // Create payload for the new course file
            const payload = {
                link_refName: this.newCourseFile.refName,
                link_description: this.newCourseFile.description,
                link_url: this.newCourseFile.url,
                owner: this.newCourseFile.owner,
            };

            // Make an API call to the backend
            fetch("http://localhost:3000/save_coursefile", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                },
                body: JSON.stringify(payload),
            })
                .then((response) => {
                    if (!response.ok) {
                        throw new Error("Failed to save the course file");
                    }
                    return response.json();
                })
                .then((data) => {
                    alert(data.message);
                    this.files.push(payload); // Update local data
                    this.closeUploadModal(); // Close the modal
                })
                .catch((error) => {
                    console.error("Error:", error);
                    alert("Failed to save data!");
                });
        },
        navigateToDetails(id) {
            this.$router.push(`/course-files/${id}`);
        },
        searchFiles() {
            console.log(this.searchQuery);
        },
        setLink_refName(link_refName) {
            sessionStorage.setItem("link_refName", JSON.stringify(link_refName));
            console.log(`link_refName set: ${JSON.stringify(link_refName)}`);
            this.$router.push("/course-files/SECJ2013-03");
        },
        openUploadModal() {
            this.showModal = true;
        },
        closeUploadModal() {
            this.showModal = false;
        },
        addFile(newFile) {
            // Add the new file to the `files` array and save it to the database
            const payload = {
                refNo: newFile.refNo,
                description: newFile.description,
                created: new Date().toISOString(),
                owner: newFile.owner,
            };

            fetch("http://localhost:3000/save_coursefile", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                },
                body: JSON.stringify(payload),
            })
                .then((response) => response.json())
                .then((data) => {
                    if (data.error) {
                        alert(`Error: ${data.error}`);
                    } else {
                        alert("Data saved successfully!");
                        this.files.push({
                            ref_name: payload.refNo,
                            description: payload.description,
                            sessem: payload.created || "N/A",
                            owner: payload.owner,
                        });
                    }
                })
                .catch((error) => {
                    console.error("Error saving data:", error);
                    alert("Failed to save data!");
                });

            this.closeUploadModal();
        },
    },
    mounted() {
        // Fetch data when the component is mounted
        const sem = sessionStorage.getItem("category");
        if (sem) {
            const categoryTitle = JSON.parse(sem).title;

            const url = `http://localhost/getRefnameByCategory?category=${encodeURIComponent(
                categoryTitle
            )}`;

            fetch(url)
                .then((response) => response.json())
                .then((data) => {
                    this.files = data.map((file) => ({
                        id: file.id || file.ref_name,
                        ref_name: file.ref_name,
                        sessem: file.sessem || "N/A",
                        description: file.description,
                        owner: file.owner,
                    }));
                })
                .catch((error) => {
                    console.error("Error fetching categories:", error);
                    this.files = []; // Ensure files is always defined
                });
        } else {
            this.files = []; // Handle case where session storage is empty
        }
    },
};
</script>

---

### **Backend Endpoint Reminder (`server.pl`)**
Ensure that the `server.pl` contains the `/save_coursefile` route:
```perl
post '/save_coursefile' => sub ($c) {
my $json = $c->req->json; # Receive JSON payload
my $refName = $json->{refNo};
my $description = $json->{description};
my $created = $json->{created} // 'CURRENT_TIMESTAMP';
my $owner = $json->{owner};

# Insert into the database
my $sth = $dbh->prepare(
"INSERT INTO link_details (link_refName, link_description, link_posted, owner)
VALUES (?, ?, NOW(), ?)"
);

eval {
$sth->execute($refName, $description, $owner);
$c->render(json => { message => 'Data saved successfully' });
} or do {
my $error = $@ || 'Unknown error';
print "Error occurred: $error\n";
$c->render(json => { error => $error }, status => 500);
};
};



<style scoped>
.page-container {
    display: flex;
    /* Sidebar and content side by side */
}

.content-container {
    flex: 1;
    padding: 20px;
    margin-left: 230px;
    /* Ensure content does not overlap with sidebar */
    overflow: auto;
}

.navbar {
    flex-shrink: 0;
}

.header-container {
    display: flex;
    justify-content: space-between;
    /* Align left and right sections */
    align-items: flex-end;
    /* Align bottom edges of h1 and h2 */
    margin-bottom: 20px;
}

.header-left {
    text-align: left;
    /* Align both headers to the left */
}

.header-left h1 {
    font-size: 32px;
    margin-bottom: 5px;
    /* Adjust space between h1 and h2 */
}

.header-left h2 {
    font-size: 24px;
    margin-top: 0;
    /* Remove extra margin at the top of h2 */
}

.header-right {
    font-size: 16px;
}

.search-bar {
    display: flex;
    margin-bottom: 20px;
    align-items: center;
}

.search-bar input {
    flex: 1;
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 4px;
}

.search-bar button {
    margin-left: 10px;
    padding: 10px;
    background-color: #007bff;
    color: #fff;
    border: none;
    border-radius: 4px;
    cursor: pointer;
}

.search-bar button:hover {
    background-color: #0056b3;
}

.details-container {
    background: #f9f9f9;
    border: 1px solid #ddd;
    border-radius: 8px;
    padding: 20px;
    font-family: Arial, sans-serif;
    font-size: 18px;
}

.files-table {
    width: 100%;
    border-collapse: collapse;
}

.files-table th,
.files-table td {
    text-align: left;
    padding: 10px;
    border-bottom: 1px solid #e6e6e6;
}

.files-table th {
    background-color: #f8f8f8;
    font-weight: bold;
}

.files-table td img.icon {
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