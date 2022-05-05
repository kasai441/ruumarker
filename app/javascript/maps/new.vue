<template>
  <div id="maps-new">
    <image-upload target-model="map" @emitFormData="getFormData"></image-upload>
    <image-create target-model="map" :form-data="formData"></image-create>
  </div>
</template>

<script>
import ImageUpload from '../components/image_upload.vue'
import ImageCreate from '../components/image_create.vue'

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
    ImageUpload,
    ImageCreate
  },
  methods: {
    getFormData(formData) {
      this.formData = formData
    }
  }
}
</script>
