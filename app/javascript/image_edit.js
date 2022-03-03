import "core-js/stable";
import "regenerator-runtime/runtime";

import { createApp } from 'vue';
import ImageEdit from './image_edit.vue';

document.addEventListener('turbo:load', () => {
  const selector = '#image-edit'
  const image_edits = document.querySelector(selector)
  if (image_edits) {
    createApp(ImageEdit).mount(selector)
  }
});
