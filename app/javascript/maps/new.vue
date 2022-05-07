<template>
  <section>
    <image-preview sample-image="/sample.png" target-model="map" :form-data="formData"></image-preview>
    <image-upload target-model="map" @emitFormData="getFormData"></image-upload>
  </section>
</template>

<script>
import ImageUpload from '../components/image_upload.vue'
import ImagePreview from '../components/image_preview.vue'

export default {
  name: 'MapsNew',
  inject: [
    'roomId'
  ],
  data() {
    return {
      formData: null,
    }
  },
  components: {
    ImagePreview,
    ImageUpload
  },
  methods: {
    getFormData(formData) {
      this.formData = formData
      // create
    }
  }
}
</script>
