import { createApp } from 'vue'
import App from './App.vue'
import router from './router'

createApp(App).use(router).provide('serverHost','107.175.189.118:80').mount('#app')
