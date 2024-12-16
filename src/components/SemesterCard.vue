<template>
<<<<<<< HEAD
    <button class="semester-card" @click="handleClick">
<<<<<<< HEAD
      <div class="card-header" :style="{ backgroundColor: bgColor }">
        <h3 class="title">{{ title }}</h3>
      </div>
      <div class="card-footer">
        <p class="subtitle">{{ subtitle }}</p>
      </div>
    </button>
  </template>
  
  <script>
  export default {
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
      link: {
        type: String,
        default: "#", // Default to "#" if no link is provided
      },
    },
    methods: {
      handleClick() {
        if (this.link) {
          window.location.href = this.link; // Navigate to the specified URL
        }
      },
    },
  };
  </script>
  
  <style scoped>
  @import url('https://fonts.googleapis.com/css2?family=Indie+Flower&display=swap');
  
  .semester-card {
=======
        <div class="card-header" :style="{ backgroundColor: bgColor }">
            <h3 class="title">{{ title }}</h3>
        </div>
        <div class="card-footer">
            <p class="subtitle">{{ subtitle }}</p>
        </div>
    </button>
=======
  <button class="semester-card" @click="handleClick">
    <div class="card-header" :style="{ backgroundColor: bgColor }">
      <h3 class="title">{{ title }}</h3>
    </div>
    <div class="card-footer">
      <p class="subtitle">{{ subtitle }}</p>
    </div>
  </button>
>>>>>>> a28b483c70988e9b1abed6926d464989045ea39a
</template>

<script>
export default {
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
    link: {
      type: String,
      default: "#", // Default to "#" if no link is provided
    },
  },
  methods: {
    handleClick() {
      if (this.link) {
        window.location.href = this.link; // Navigate to the specified URL
      }
    },
  },
};
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Indie+Flower&display=swap');

.semester-card {
<<<<<<< HEAD
>>>>>>> 43fdbaaab80a6d12975d0ca0045339a5293af8d2
    width: 306px;
    height: 192px;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    padding: 0;
    border: none;
<<<<<<< HEAD
    cursor: pointer; /* Make the card clickable */
    text-align: left;
    background: transparent;
    transition: transform 0.2s, box-shadow 0.2s;
  }
  
  .semester-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 6px 10px rgba(0, 0, 0, 0.15);
  }
  
  .card-header {
=======
    cursor: pointer;
    /* Make the card clickable */
    text-align: left;
    background: transparent;
    transition: transform 0.2s, box-shadow 0.2s;
=======
  width: 306px;
  height: 192px;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  padding: 0;
  border: none;
  cursor: pointer; /* Make the card clickable */
  text-align: left;
  background: transparent;
  transition: transform 0.2s, box-shadow 0.2s;
>>>>>>> a28b483c70988e9b1abed6926d464989045ea39a
}

.semester-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 6px 10px rgba(0, 0, 0, 0.15);
}

.card-header {
<<<<<<< HEAD
>>>>>>> 43fdbaaab80a6d12975d0ca0045339a5293af8d2
    height: 70%;
    display: flex;
    justify-content: center;
    align-items: center;
<<<<<<< HEAD
    font-family: 'Indie Flower', cursive; /* Indie Flower Font */
    font-size: 60px; /* Updated font size */
    color: white;
    text-align: center;
    font-weight: bold;
    word-wrap: break-word; /* Prevent overflow */
    line-height: 1; /* Reduce line height for tighter fit */
  }
  
  .card-footer {
=======
    font-family: 'Indie Flower', cursive;
    /* Indie Flower Font */
    font-size: 60px;
    /* Updated font size */
    color: white;
    text-align: center;
    font-weight: bold;
    word-wrap: break-word;
    /* Prevent overflow */
    line-height: 1;
    /* Reduce line height for tighter fit */
}

.card-footer {
>>>>>>> 43fdbaaab80a6d12975d0ca0045339a5293af8d2
    height: 30%;
    background-color: white;
    display: flex;
    justify-content: center;
    align-items: center;
<<<<<<< HEAD
  }
  
  .subtitle {
    font-size: 16px;
    color: #666;
    margin: 0;
  }
  </style>
  
=======
=======
  height: 70%;
  display: flex;
  justify-content: center;
  align-items: center;
  font-family: 'Indie Flower', cursive; /* Indie Flower Font */
  font-size: 60px; /* Updated font size */
  color: white;
  text-align: center;
  font-weight: bold;
  word-wrap: break-word; /* Prevent overflow */
  line-height: 1; /* Reduce line height for tighter fit */
}

.card-footer {
  height: 30%;
  background-color: white;
  display: flex;
  justify-content: center;
  align-items: center;
>>>>>>> a28b483c70988e9b1abed6926d464989045ea39a
}

.subtitle {
  font-size: 16px;
  color: #666;
  margin: 0;
}
</style>
>>>>>>> 43fdbaaab80a6d12975d0ca0045339a5293af8d2
