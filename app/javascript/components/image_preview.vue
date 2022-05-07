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
    'formData',
    'targetModel'
  ],
  data() {
    return {
      previewImage: null,
    }
  } ,
  created() {
    const imageFile = this.formData.get(`${this.targetModel}[image]`)
    const imageUrl = this.formData.get(`${this.targetModel}[image_url]`)
    if (imageFile) {
      const previewImage = document.getElementById( 'preview-image' )
      params.readImageUrl(previewImage, this.formData.get(`${this.targetModel}[image]`))
    } else if (imageUrl) {
      this.previewImage = imageUrl
    } else {
      this.previewImage = this.sampleImage
    }
  }
}
</script>
