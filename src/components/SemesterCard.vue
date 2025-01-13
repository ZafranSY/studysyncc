<template>
    <div class="semester-card" @mouseover="hover = true" @mouseleave="hover = false">
        <div class="card-header" :style="{ backgroundColor: bgColor }">
            <h1 class="title">{{ title }}</h1>
        </div>
        <div class="card-footer">
            <p class="subtitle">
                {{ subtitle }} : {{ this.viewableCategoryCount }} viewable Category
            </p>
        </div>

        <!-- Edit and Delete Buttons (visible on hover for Academic Officer only) -->
        <div class="hover-buttons" v-if="hover && role_desc == 'Academic Officer'">
            <button class="edit-button" @click.stop="editSemester">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                    <path
                        d="M5 21h14v2H5v-2Zm0-4.2L15.8 6 18 8.2 7.2 19H5v-2.2ZM19.7 5l-1.7 1.7-2.3-2.3L17.3 2.7c.4-.4 1-.4 1.4 0l1 1c.4.4.4 1 0 1.4Z" />
                </svg>
            </button>
            <button class="delete-button" @click.stop="deleteSemester">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                    <path
                        d="M5 20q-.825 0-1.413-.588Q3 18.825 3 18V5h2V3.5q0-.625.438-1.062Q5.875 2 6.5 2h11q.625 0 1.062.438Q19 2.875 19 3.5V5h2v13q0 .825-.587 1.412Q19.825 20 19 20ZM7 17h2v-9H7Zm4 0h2v-9h-2Zm4 0h2v-9h-2Zm-9-12h10V4h-10Zm0 0V4v1Z" />
                </svg>
            </button>
        </div>

        <SemesterEditModal
            :show="showEditModal"
            :semester-data="{ title, subtitle, bgColor }"
            @close="showEditModal = false"
            @semester-updated="handleSemesterUpdated"
        />
    </div>
</template>

<script>
import SemesterEditModal from './EditModalSemester.vue';
export default {
    components: {
        SemesterEditModal
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
    },
    data() {
        return {
            hover: false, // Track hover state to show/hide buttons
            role_desc: null,
            viewableCategoryCount: null,
            showEditModal: false,
        };
    },
    methods: {
        async fetchViewableCategoryCount() {
            const session_id = localStorage
                .getItem("session_id")
                ?.replace(/['"]+/g, "");
            // const semester = sessionStorage.getItem("semester");

            console.log("session id ", session_id)?.replace(/['"]+/g, "");
            console.log("semester ", this.title);

            const payload = {
                session_id: session_id.trim(),
                semester_id: this.title,
            };
            try {
                const response = await fetch(
                    "http://localhost/getViewableCategoriesWithinSemesterCount",
                    {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/json",
                        },
                        body: JSON.stringify(payload),
                    }
                );
                const result = await response.json();
                console.log("server response : ", result);
                this.viewableCategoryCount = result;
                if (response.ok && result.message) {
                    alert(result.message);
                } else if (result.error) {
                    alert(result.error);
                }
            } catch (error) {
                console.error("Error creating semester:", error);
            }
        },
        editSemester() {
            this.showEditModal = true;
        },

        handleSemesterUpdated() {
            // Emit event to parent to refresh data
            this.$emit('refresh-data');
            // You might want to reload the page or update the component data
            location.reload();
        },
        async deleteSemester() {
            const confirmation = confirm(
                `Are you sure you want to delete "${this.title}"? WARNING: Deleting this category will also delete everything inside it.`
            );
            if (confirmation) {
                const sessionId = localStorage.getItem('session_id');
                const semesterId = this.title;
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
                    const response = await fetch("http://localhost/deleteSemester", {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/json",
                        },
                        body: JSON.stringify(payload),
                    });

                    const result = await response.json();
                    console.log("Server response:", result);

                    if (response.ok) {
                        alert(result.message);
                    } else {
                        alert(result.error || "Failed to delete category. Please try again.");
                    }
                    location.reload();
                } catch (error) {
                    console.error("Error deleting category:", error);
                    alert("Failed to connect to the server.");
                }
            }
        },
        getRole() {
            const sessionData = JSON.parse(localStorage.getItem("utmwebfc_session"));

            if (sessionData) {
                this.role_desc = sessionData.description;
                console.log("Role Description:", this.role_desc); // Debug log
            }
        },
    },
    mounted() {
        this.getRole();
        this.fetchViewableCategoryCount();
    },
};
</script>

<style>
.semester-card {
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

.semester-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 6px 10px rgba(0, 0, 0, 0.15);
}

.card-header {
    height: 70%;
    display: flex;
    justify-content: center;
    align-items: center;
    font-family: "Indie Flower", cursive;
    /* Optional font */
    font-size: 23px;
    /* Adjusted font size */
    color: white;
    text-align: center;
    font-weight: bold;
    word-wrap: break-word;
    line-height: 1.2;
}

.card-footer {
    height: 30%;
    background-color: white;
    display: flex;
    justify-content: center;
    align-items: center;
}

.subtitle {
    font-size: 11x;
    color: #666;
    margin: 0;
}

.hover-buttons {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    display: flex;
    gap: 12px;
    z-index: 10;
}

button {
    background-color: transparent;
    border: none;
    cursor: pointer;
}

.edit-button svg {
    fill: #007bff;
    /* Blue for Edit */
}

.delete-button svg {
    fill: #dc3545;
    /* Red for Delete */
}

button svg {
    width: 32px;
    height: 32px;
}

button:hover svg {
    opacity: 0.8;
}
</style>
