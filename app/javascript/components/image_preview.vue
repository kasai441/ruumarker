<template>
  <section id="image-preview">
    <div class="flex justify-center">
      <div id="preview-field" class="edit-size rounded-lg bg-white outline outline-3 outline-slate-200">
        <img id="preview-image" :src="imageSrc" class="object-contain edit-size rounded-lg">
      </div>
    </div>
  </section>
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
      imageSrc: this.sampleImage,
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
      this.imageSrc = imageUrl
    }
  }
}
</script>
