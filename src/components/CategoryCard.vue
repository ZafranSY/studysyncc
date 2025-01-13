<template>
    <div class="category-card" @mouseover="hover = true" @mouseleave="hover = false">
        <div class="card-header" :style="{ backgroundColor: bgColor }">
            <!-- Display the title as a heading -->
            <h1 class="title">{{ title }}</h1>
        </div>
        <div class="card-footer">
            <p class="subtitle">
                {{ subtitle }} : {{ this.viewAbleLinkCount }} Links
            </p>
        </div>

        <!-- Hover buttons for editing, deleting, and managing permissions -->
        <div class="hover-buttons" v-if="hoverAndAcademicOfficer">
            <button class="edit-button" @click.stop="editCategory">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                    <path
                        d="M5 21h14v2H5v-2Zm0-4.2L15.8 6 18 8.2 7.2 19H5v-2.2ZM19.7 5l-1.7 1.7-2.3-2.3L17.3 2.7c.4-.4 1-.4 1.4 0l1 1c.4.4.4 1 0 1.4Z" />
                </svg>
            </button>
            <button class="delete-button" @click.stop="deleteCategory">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                    <path
                        d="M5 20q-.825 0-1.413-.588Q3 18.825 3 18V5h2V3.5q0-.625.438-1.062Q5.875 2 6.5 2h11q.625 0 1.062.438Q19 2.875 19 3.5V5h2v13q0 .825-.587 1.412Q19.825 20 19 20ZM7 17h2v-9H7Zm4 0h2v-9h-2Zm4 0h2v-9h-2Zm-9-12h10V4h-10Zm0 0V4v1Z" />
                </svg>
            </button>
            <button class="permission-button" @click.stop="managePermissions">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                    <path
                        d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8zm-1-13h2v6h-2zm0 8h2v2h-2z" />
                </svg>
            </button>
        </div>

        <CategoryEditModal
            :show="showEditModal"
            :category-data="{ title, subtitle, bgColor }"
            @close="showEditModal = false"
            @category-updated="handlecategoryUpdated"
        />


    </div>
</template>

<script>
import CategoryEditModal from './EditModalCategory.vue';
export default {
    components: {
        CategoryEditModal
    },
    props: {
        title: {
            type: String,
            required: true,
        },
        subtitle: {
            type: String,
            required: true,
        },
        bgColor: {
            type: String,
            required: true,
        },
        img: {
            type: String,
            default: "",
        },
    },
    data() {
        return {
            hover: false,
            viewAbleLinkCount: null,
            showEditModal: false,
        };
    },
    computed: {
        hoverAndAcademicOfficer() {
            return this.hover && localStorage.getItem('role') === '"Academic Officer"';
        },
    },
    methods: {
        transformToSemester(input) {
            // Extract the components
            const aa = input.slice(0, 2); // First two characters: "aa"
            const bb = input.slice(2, 4); // Next two characters: "bb"
            const y = input.slice(4);     // Last character: "y"

            // Format the result
            const semester = `20${aa}/20${bb}-${y}`;
            return semester;
        },
        editCategory() {
            this.showEditModal = true;
        },

        handlecategoryUpdated() {
            // Emit event to parent to refresh data
            this.$emit('refresh-data');
            // You might want to reload the page or update the component data
            location.reload();
        },
        async deleteCategory() {
            const confirmation = confirm(
                `Are you sure you want to delete "${this.title}"?`
            );
            if (confirmation) {
                const sessionId = localStorage.getItem('session_id') || sessionStorage.getItem('session_id');
                const semesterId = JSON.parse(sessionStorage.getItem("semester")) || this.transformToSemester(this.$route.params.semesterURL);

                if (!sessionId || !semesterId) {
                    alert("Missing session or semester data. Please log in again.");
                    return;
                }

                const payload = {
                    session_id: sessionId.replace(/['"]+/g, ""),
                    semester_id: semesterId.replace(/['"]+/g, ""),
                    category_name: this.title,
                };

                try {
                    const response = await fetch("http://localhost/deleteCategory", {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/json",
                        },
                        body: JSON.stringify(payload),
                    });

                    const result = await response.json();
                    console.log("Response Body:", result);

                    if (!response.ok) {
                        throw new Error(result.error || "Failed to delete category.");
                    }

                    alert(`Category "${this.title}" deleted successfully.`);
                    location.reload();
                    // Optionally, remove the category from the local list if needed
                    this.$emit("category-deleted", this.title); // Update the parent component's state
                } catch (error) {
                    console.error("Error deleting category:", error);
                    alert("Deletion failed. Please try again.");
                }
            }
        },

        managePermissions() {
            // alert(`Managing permissions for: ${this.title}`);
            this.$emit("manage-permissions", this.title);
        },
        async fetchViewAbleLinkCount() {
            const session_id = localStorage
                .getItem("session_id")
                ?.replace(/['"]+/g, "");

            const semester = JSON.parse(sessionStorage.getItem("semester")) || this.transformToSemester(this.$route.params.semesterURL);

            const payload = {
                session_id: session_id?.trim(),
                semester_id: semester?.trim(),
                category_name: this.title,
            };

            console.log("Payload sent:", payload);

            try {
                const response = await fetch(
                    "http://localhost/getViewableLinksWithinCategoryCount",
                    {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/json",
                        },
                        body: JSON.stringify(payload),
                    }
                );

                const result = await response.json();
                console.log("Server response:", result);

                if (response.ok && typeof result === "number") {
                    this.viewAbleLinkCount = result;
                } else if (result.error) {
                    console.error("Server error:", result.error);
                    alert(result.error);
                }
            } catch (error) {
                console.error("Fetch error:", error);
                alert("An error occurred while fetching the viewable link count.");
            }
        },
    },
    mounted() {
        this.fetchViewAbleLinkCount();
    },
};
</script>

<style scoped>
.category-card {
    position: relative;
    width: 306px;
    height: 192px;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    padding: 0;
    border: none;
    cursor: pointer;
    background: transparent;
    transition: transform 0.2s, box-shadow 0.2s;
}

.category-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 6px 10px rgba(0, 0, 0, 0.15);
}

.card-header {
    height: 70%;
    display: flex;
    justify-content: center;
    align-items: center;
    font-family: "Indie Flower", cursive;
    font-size: 40px;
    color: white;
    text-align: center;
    font-weight: bold;
}

.title {
    margin: 0;
    font-size: 35px;
}

.card-footer {
    height: 30%;
    background-color: white;
    display: flex;
    justify-content: center;
    align-items: center;
}

.subtitle {
    font-size: 16px;
    color: #666;
}

.hover-buttons {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    display: flex;
    gap: 12px;
}

button {
    background-color: transparent;
    border: none;
    cursor: pointer;
}

.edit-button svg {
    fill: #007bff;
}

.delete-button svg {
    fill: #dc3545;
}

.permission-button svg {
    fill: #28a745;
}

button svg {
    width: 32px;
    height: 32px;
}

button:hover svg {
    opacity: 0.8;
}
</style>
