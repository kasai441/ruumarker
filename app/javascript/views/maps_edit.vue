<template>
  <section>
    <div class="flex justify-center">
      <div class="main-screen">
        <div class="w-full mt-6 flex flex-col items-center overflow-hidden">
          <image-edit :form-data="formData" target-model="map" :locators-json="marks"
                      @emit-form-data="getFormData"></image-edit>
        </div>
        <image-upload :form-data="formData" target-model="map" @emit-form-data="getFormData"></image-upload>
        <image-rotate :form-data="formData" target-model="map" @emit-form-data="getFormData"></image-rotate>
        <image-expand :form-data="formData" target-model="map" @emit-form-data="getFormData"></image-expand>
        <image-update :room-id="roomId" :form-data="formData" target-model="map"></image-update>
      </div>
    </div>
  </section>
</template>

<script>
import ImageEdit from '../components/image_edit.vue'
import ImageUpload from '../components/image_upload.vue'
import ImageRotate from '../components/image_rotate.vue'
import ImageExpand from '../components/image_expand.vue'
import ImageUpdate from '../components/image_update.vue'
import params from '../modules/params'

export default {
  name: 'MapsEdit',
  inject: [
    'roomId',
    'marks',
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
    ImageRotate,
    ImageExpand,
    ImageUpdate
  },
  methods: {
    getFormData(formData) {
      this.formData = formData
    }
  },
  created() {
    if (this.formData) return

    this.formData = params.initFormData(this.map, 'map')
  },
  mounted() {
    const div = document.getElementById('screen-scroll')
    div.classList.add('overflow-scroll', 'h-screen')
  }
}
</script>
