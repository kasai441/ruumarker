import "core-js/stable";
import "regenerator-runtime/runtime";

import { createApp } from 'vue';
import Home from './home.vue';

console.log("lehoo wordl")

document.addEventListener('DOMContentLoaded', () => {
  createApp(Home).mount('#app');
});
