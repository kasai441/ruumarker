<template>
  <div class="flex justify-center">
    <div id="preview-field" class="edit-size rounded-lg bg-white outline outline-3 outline-slate-200">
      <img id="preview-image" :src="previewImage" class="object-contain edit-size rounded-lg">
    </div>
  </div>
</template>

<script>
import params from '../modules/params'

export default {
  name: 'ImagePreview',
  props: [
    'sampleImage',
    'targetModel',
    'formData'
  ],
  data() {
    return {
      previewImage: this.sampleImage,
    }
  },
  methods: {
    preview(imageFile) {
      const previewImage = document.getElementById( 'preview-image' )
      params.readImageUrl(previewImage, imageFile)
    }
  },
  updated() {
    if (!this.formData) return

    const imageFile = this.formData.get(`${this.targetModel}[image]`)
    const imageUrl = this.formData.get(`${this.targetModel}[image_url]`)
    if (imageFile) {
      this.preview(imageFile)
    } else if (imageUrl) {
      this.previewImage = imageUrl
    }
  }
}
</script>
