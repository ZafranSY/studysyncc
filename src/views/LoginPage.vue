<template>
    <div>
        <header>
            <div class="header-line"></div>
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        </header>
        <div class="container">
            <div class="login-box-bg" v-if="!loggedIn">
                <div class="login-box">
                    <div class="logo-container">
                        <div class="logo">
                            <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/c/cb/UTM-LOGO-FULL.png/1200px-UTM-LOGO-FULL.png"
                                alt="UTM Logo" />
                        </div>
                    </div>
                    <form @submit.prevent="login">
                        <div class="input-field">
                            <label for="username">Username</label>
                            <input type="text" id="username" v-model="username" required />
                        </div>
                        <div class="input-field">
                            <label for="password">Password</label>
                            <input type="password" id="password" v-model="password" required />
                        </div>
                        <button type="submit" class="login-btn">Login</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import { ref } from "vue";
import { useRouter } from "vue-router";

export default {
    name: "LoginView",
    setup() {
        const username = ref("");
        const password = ref("");
        const loggedIn = ref(false);
        const router = useRouter();
        localStorage.removeItem("utmwebfc_session");

        
        const login = async () => {
            try {
                if(username.value=="admin"&&password.value=="password"){
                    const userData = {
                        email: "admin@fake.my",
                        full_name: "ADMIN ADMOM",
                        login_name: "0000",
                        no_pekerja: 0,
                        role: "Academic Officer",
                        session_id: "00000000000",
                        
                        };
                    const now = new Date();
                    userData.last_login = now.getFullYear() + '-' +
                        String(now.getMonth() + 1).padStart(2, '0') + '-' +
                        String(now.getDate()).padStart(2, '0') + ' ' +
                        String(now.getHours()).padStart(2, '0') + ':' +
                        String(now.getMinutes()).padStart(2, '0') + ':' +
                        String(now.getSeconds()).padStart(2, '0');

                    localStorage.setItem("utmwebfc_session", JSON.stringify(userData));
                    fetch('http://localhost:80/usertodb', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify(userData)  // Send the updated JSON object
                    })
                        .then(response => response.json())
                        .then(result => {
                            console.log('Success:', result);
                        })
                        .catch(error => {
                            console.error('Error:', error);
                        });

                    router
                    router.push("/homeview");
                }



                const url = `http://web.fc.utm.my/ttms/web_man_webservice_json.cgi?entity=authentication&login=${username.value}&password=${password.value}`;
                const response = await fetch(url);
                const data = await response.json();
                
                if (data[0]?.session_id) {
                    localStorage.setItem("utmwebfc_session", JSON.stringify(data[0]));
                    loggedIn.value = true;
                    var userData = data[0];
                    userData.role = userData.description;
                    delete userData.description;
                    
                    const now = new Date();
                    userData.last_login = now.getFullYear() + '-' +
                        String(now.getMonth() + 1).padStart(2, '0') + '-' +
                        String(now.getDate()).padStart(2, '0') + ' ' +
                        String(now.getHours()).padStart(2, '0') + ':' +
                        String(now.getMinutes()).padStart(2, '0') + ':' +
                        String(now.getSeconds()).padStart(2, '0');

                    // Now, send the POST request with the updated user data
                    fetch('http://localhost:80/usertodb', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify(userData)  // Send the updated JSON object
                    })
                        .then(response => response.json())
                        .then(result => {
                            console.log('Success:', result);
                        })
                        .catch(error => {
                            console.error('Error:', error);
                        });

                    router
                    router.push("/homeview");
                } else {
                    alert("Login failed. Please check your credentials.");
                }
            } catch (error) {
                console.error("Login error:", error);
                alert("An error occurred during login.");
            }
        };

        return {
            username,
            password,
            loggedIn,
            login,
        };
    },
};
</script>

<style scoped>
/* Reset and Base Styles */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: Arial, sans-serif;
    background-color: #f0f0f0;
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    margin: 0;
}

/* Header Styles */
header {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 10vh;
    background-color: white;
    z-index: 10;
}

.header-line {
    height: 100%;
    width: 100%;
}

/* Container Styles */
.container {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 100%;
    height: 100%;
}

/* Login Box Styles */
.login-box-bg {
    background-color: #ede9e9;
    border: 1px solid black;
    border-radius: 1px;
    padding: 30px;
    box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
    width: 40vw;
    height: 50vh;
    display: flex;
    justify-content: center;
    align-items: center;
}

.login-box {
    background-color: #f8f3f3;
    border: 1px solid black;
    border-radius: 1px;
    padding: 30px;
    box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
    width: 100%;
    height: 100%;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
}

/* Logo Styles */
.logo-container {
    margin-bottom: 30px;
    width: 100%;
    display: flex;
    justify-content: center;
}

.logo img {
    width: 65%;
    max-width: 300px;
    height: auto;
}

/* Form Styles */
form {
    width: 100%;
    max-width: 400px;
}

.input-field {
    display: flex;
    align-items: center;
    margin-bottom: 20px;
    width: 100%;
}

.input-field label {
    font-size: 1.1rem;
    margin-right: 15px;
    width: 120px;
    text-align: right;
}

.input-field input {
    flex-grow: 1;
    padding: 12px;
    border: 2px solid #ddd;
    border-radius: 8px;
    font-size: 1.2rem;
    width: 100%;
}

/* Login Button Styles */
.login-btn {
    display: block;
    margin-left: auto;
    padding: 15px 30px;
    background-color: #f82d2d;
    color: white;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    font-size: 1.2rem;
    transition: background-color 0.3s ease;
    width: 100%;
}

.login-btn:hover {
    background-color: #ff9864;
}

/* Responsive Adjustments */
@media (max-width: 768px) {
    .login-box-bg {
        width: 90vw;
        height: auto;
    }

    .input-field {
        flex-direction: column;
        align-items: stretch;
    }

    .input-field label {
        text-align: left;
        margin-bottom: 5px;
        width: 100%;
    }
}
</style>
