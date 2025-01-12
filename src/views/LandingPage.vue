<template>
    <div>
        <!-- Navbar -->
        <nav class="navbar">
            <div class="navbar-logo">
                <img src="https://i.imgur.com/VbGFqnd.png" alt="UTM Logo" />
            </div>
            <div class="navbar-links">
                <router-link to="/login" class="login-button">Log In</router-link>
            </div>
        </nav>

        <!-- Header Section -->
        <header class="header">
            <h1>StudySync - Google Drive Resource Sharing System</h1>
            <p>Synchronize your academic world, effortlessly</p>
        </header>

        <!-- Banner Section -->
        <section class="banner">
            <div class="banner-content">
                <h2>Welcome to StudySync</h2>
                <p>Effortlessly manage and share academic resources in one platform.</p>
            </div>
        </section>

        <!-- Features Section -->
        <section class="features">
            <h2>Why Choose StudySync?</h2>
            <div class="feature-list">
                <div class="feature-item">
                    <img src="https://i.imgur.com/J0to7gM.png" alt="Structured Management" />
                    <h3>Structured Management</h3>
                    <p>
                        Organized file and folder management for efficient resource
                        tracking.
                    </p>
                </div>
                <div class="feature-item">
                    <img src="https://i.imgur.com/CQH61SM.png" alt="Real-Time Notifications" />
                    <h3>Real-Time Notifications</h3>
                    <p>
                        Stay updated instantly with real-time notifications for new posts.
                    </p>
                </div>
                <div class="feature-item">
                    <img src="https://i.imgur.com/b2lGFbI.png" alt="Mobile Friendly" />
                    <h3>Mobile Friendly</h3>
                    <p>Access resources anytime, anywhere with mobile compatibility.</p>
                </div>
            </div>
        </section>

        <!-- Footer Section -->
        <footer class="footer">
            <p>&copy; 2025 StudySync. All Rights Reserved.</p>
        </footer>
    </div>
</template>

<script>
export default {
    name: "LandingPage",
};

function clearStorage() {
    // Clear localStorage
    localStorage.clear();

    // Clear sessionStorage
    sessionStorage.clear();

}

clearStorage();
</script>

<style scoped>
body {
    margin: 0;
    font-family: Arial, sans-serif;
    background-color: #ffffff;
    color: #333;
}

.navbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 10px 20px;
    background-color: #ffffff;
    border-bottom: 1px solid #ddd;
}

.navbar-logo img {
    height: 50px;
}

.navbar-links {
    display: flex;
    align-items: center;
}

.login-button {
    background-color: #333;
    color: white;
    padding: 10px 20px;
    border-radius: 5px;
    text-decoration: none;
    font-size: 16px;
    transition: background-color 0.3s;
}

.login-button:hover {
    background-color: #555;
}

.header {
    background-color: #ffffff;
    color: #333;
    text-align: center;
    padding: 20px;
}

.header h1 {
    font-size: 36px;
    margin: 0;
}

.header p {
    margin: 5px 0;
    font-size: 18px;
}

.banner {
    position: relative;
    text-align: center;
    color: #fff;
    background: url("https://i.imgur.com/J3XIuiq.jpeg") no-repeat center center/cover;
    height: 500px;
    overflow: hidden;
}

.banner::before {
    content: "";
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: inherit;
    filter: blur(8px);
    z-index: 0;
}

.banner-content {
    position: relative;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    text-align: center;
    z-index: 1;
}

.banner-content h2 {
    font-size: 48px;
    margin: 0;
}

.banner-content p {
    margin: 20px 0;
    font-size: 18px;
}

.features {
    text-align: center;
    padding: 50px 20px;
    background-color: #ffffff;
}

.features h2 {
    font-size: 32px;
    margin-bottom: 20px;
    color: #333;
}

.features .feature-list {
    display: flex;
    justify-content: center;
    flex-wrap: wrap;
    gap: 30px;
    margin-top: 20px;
}

.features .feature-item {
    width: 250px;
    text-align: center;
    background-color: #f9f9f9;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    padding: 20px;
    border-radius: 10px;
    transition: transform 0.3s;
}

.features .feature-item:hover {
    transform: translateY(-10px);
}

.features .feature-item img {
    width: 200px;
    /* Ensures all images are the same width */
    height: 120px;
    /* Ensures all images are the same height */
    object-fit: cover;
    /* Maintains aspect ratio and avoids distortion */
    margin-bottom: 10px;
    border-radius: 5px;
    /* Optional: Adds a slight rounding to the corners */
}

.features .feature-item h3 {
    font-size: 20px;
    margin-bottom: 10px;
    color: #333;
}

.features .feature-item p {
    font-size: 16px;
    color: #555;
}

.footer {
    background-color: #ffffff;
    color: #333;
    text-align: center;
    padding: 20px 0;
    border-top: 1px solid #ddd;
}

.footer p {
    margin: 0;
    font-size: 14px;
}
</style>
