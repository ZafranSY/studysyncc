<template>
    <div class="main-container">
        <NavbarView />
        <div class="content-wrapper">
            <h2 class="page-title">All Links</h2>
            <div class="search-container">
                <div class="search-bar-with-icon">
                    <select v-model="selectedFilter" @change="filterFiles" class="filter-select">
                        <option value="all">All</option>
                        <option value="category">Category</option>
                        <option value="session">Session</option>
                        <option value="name">Name</option>
                        <option value="description">Description</option>
                        <option value="owner">Owner</option>
                    </select>
                    <i class="search-icon">&#128269;</i>
                    <input type="text" v-model="searchTerm" class="search-input" placeholder="Search..." @input="filterFiles" />
                </div>
            </div>
            <div class="table-container">
                <table class="file-table">
                    <thead>
                        <tr>
                            <th>No.</th>
                            <th>Category</th>
                            <th>Session</th>
                            <th>Name</th>
                            <th>Description</th>
                            <th>Owner</th>
                            <th>Link</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(file, index) in paginatedFiles" :key="file.id">
                            <td>{{ (currentPage - 1) * itemsPerPage + index + 1 }}</td>
                            <td>{{ file.category || "N/A" }}</td>
                            <td class="session-column">{{ file.linkPosted || "N/A" }}</td>
                            <td>{{ file.refName || "No Name" }}</td>
                            <td>{{ file.linkDescription || "No Description" }}</td>
                            <td>{{ file.owner || "Unknown" }}</td>
                            <td>
                                <button v-if="file.url" @click.stop="goToFile(file)" class="icon-button">
                                    <img :src="require('@/assets/goto.png')" alt="Go To" class="icon" />
                                </button>
                                <span v-else>No link</span>
                            </td>
                        </tr>
                        <tr v-if="!filteredFiles.length">
                            <td colspan="7" class="no-files-text">No files found.</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <!-- Pagination Controls -->
            <div class="pagination-controls">
                <button :disabled="currentPage === 1" @click="prevPage">Previous</button>
                <span>Page {{ currentPage }} of {{ totalPages }}</span>
                <button :disabled="currentPage === totalPages" @click="nextPage">Next</button>
            </div>
        </div>
    </div>
</template>

<script>
import NavbarView from "@/components/NavBar.vue";

export default {
    components: {
        NavbarView,
    },
    data() {
        return {
            files: [],
            filteredFiles: [],
            searchTerm: "",
            selectedFilter: "all",
            currentPage: 1, // Pagination state
            itemsPerPage: 50, // Number of items to show per page
        };
    },
    computed: {
        totalPages() {
            return Math.ceil(this.filteredFiles.length / this.itemsPerPage);
        },
        paginatedFiles() {
            const start = (this.currentPage - 1) * this.itemsPerPage;
            const end = start + this.itemsPerPage;
            return this.filteredFiles.slice(start, end);
        },
    },
    methods: {
        async fetchAllFiles() {
            try {
                const session_id = JSON.parse(localStorage.getItem("session_id"));
                const response = await fetch("http://localhost/getAllLink", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json",
                    },
                    body: JSON.stringify({ session_id }),
                });

                if (!response.ok) {
                    throw new Error(`HTTP ${response.status}: ${response.statusText}`);
                }

                const data = await response.json();

                if (data.allLinks?.length) {
                    this.files = data.allLinks.map((file, index) => ({
                        id: index + 1,
                        category: file[1] || "N/A",
                        linkPosted: file[2] || "N/A",
                        refName: file[3] || "No Name",
                        linkDescription: file[4] || "No Description",
                        owner: file[5] || "Unknown",
                        url: file[6] || "#",
                    }));
                    this.filteredFiles = [...this.files];
                } else {
                    this.files = [];
                    this.filteredFiles = [];
                }
            } catch (error) {
                console.error("Error fetching links:", error);
                alert("Failed to load links. Please try again.");
            }
        },

        filterFiles() {
            const term = this.searchTerm.trim().toLowerCase();
            this.filteredFiles = this.files.filter((file) => {
                const fieldsToCheck = {
                    category: file.category,
                    session: file.linkPosted,
                    name: file.refName,
                    description: file.linkDescription,
                    owner: file.owner,
                };

                if (this.selectedFilter === "all") {
                    return Object.values(fieldsToCheck).some((value) =>
                        value?.toLowerCase().includes(term)
                    );
                }

                return fieldsToCheck[this.selectedFilter]?.toLowerCase().includes(term);
            });
            this.currentPage = 1; // Reset to first page after filtering
        },

        goToFile(file) {
            if (!file.url) {
                alert("No URL provided.");
                return;
            }

            const validUrl = /^https?:\/\//i.test(file.url) ? file.url : `http://${file.url}`;
            window.open(validUrl, "_blank");
        },

        nextPage() {
            if (this.currentPage < this.totalPages) {
                this.currentPage++;
            }
        },

        prevPage() {
            if (this.currentPage > 1) {
                this.currentPage--;
            }
        },
    },
    mounted() {
        this.fetchAllFiles();
    },
};
</script>

<style scoped>
.main-container {
    display: flex;
    min-height: 100vh;
}

.content-wrapper {
    flex: 1;
    padding: 20px 40px;
    background-color: #f9f9f9;
    margin-left: 250px;
}

.page-title {
    font-size: 1.8em;
    margin-bottom: 20px;
    color: #2c3e50;
}

.search-container {
    margin-bottom: 20px;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.search-bar-with-icon {
    display: flex;
    align-items: center;
    border: 1px solid #ddd;
    border-radius: 4px;
    padding: 10px;
    background-color: white;
    width: 100%;
}

.filter-select {
    margin-right: 10px;
    padding: 8px;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 14px;
}

.search-icon {
    font-size: 18px;
    margin-right: 10px;
    color: #888;
}

.search-input {
    width: 100%;
    border: none;
    outline: none;
    font-size: 16px;
}

.table-container {
    background-color: white;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.file-table {
    width: 100%;
    border-collapse: collapse;
}

.file-table th,
.file-table td {
    padding: 12px 15px;
    text-align: left;
    border-bottom: 1px solid #eee;
}

.file-table th {
    background-color: #f4f4f4;
    font-weight: 600;
}

.file-table td.session-column {
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    max-width: 120px;
}

.no-files-text {
    text-align: center;
    color: #666;
    padding: 20px;
}

.icon {
    width: 24px;
    height: 24px;
    object-fit: contain;
}

.icon-button {
    background: none;
    border: none;
    padding: 0;
    margin: 0;
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    justify-content: center;
}

.pagination-controls {
    display: flex;
    justify-content: center;
    align-items: center;
    margin-top: 20px;
}

.pagination-controls button {
    padding: 8px 16px;
    margin: 0 10px;
    border: none;
    border-radius: 4px;
    background-color: #007bff;
    color: white;
    cursor: pointer;
}

.pagination-controls button:disabled {
    background-color: #ccc;
    cursor: not-allowed;
}
</style>
