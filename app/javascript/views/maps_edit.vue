<template>
  <section>
    <div class="flex flex-col items-center" @touchmove.prevent>
      <image-edit :form-data="formData" target-model="map" @emit-form-data="getFormData"></image-edit>
      <image-upload target-model="map" @emit-form-data="getFormData"></image-upload>
      <image-update :room-id="roomId" :form-data="formData" target-model="map"></image-update>
    </div>
  </section>
</template>

<script>
import ImageEdit from '../components/image_edit.vue'
import ImageUpload from '../components/image_upload.vue'
import ImageUpdate from '../components/image_update.vue'
import params from '../modules/params'

export default {
  name: 'MapsEdit',
  inject: [
    'roomId',
    'map'
  ],
  data() {
    return {
      formData: null
    }
  },
  components: {
    ImageEdit,
    ImageUpload,
    ImageUpdate
  },
  methods: {
    getFormData(formData) {
      this.formData = formData
    }
  },
  async created() {
    if (this.formData) return

    this.formData = params.initFormData(this.map, 'map')
  }
}
</script>
