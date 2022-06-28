<template>
  <section>
    <div v-if="isLoading" class="fixed z-50 w-full h-full flex justify-center items-center bg-white/50">
      <div class="flex justify-center my-20">
        <div class="animate-ping h-4 w-4 bg-white rounded-full"></div>
        <div class="animate-ping h-4 w-4 bg-white rounded-full mx-8"></div>
        <div class="animate-ping h-4 w-4 bg-white rounded-full"></div>
      </div>
    </div>
    <div class="flex justify-center">
      <div class="main-screen flex flex-col items-center">
        <div class="w-full mt-6 flex flex-col items-center overflow-hidden">
          <image-edit :form-data="formData" :locators-json="marks"
                      @emit-form-data="getFormData"></image-edit>
        </div>
        <div class="w-field flex flex-row items-center">
          <image-upload :form-data="formData" target-model="map"
                        @emit-form-data="getFormData"
                        @emit-is-loading="getIsLoading"
                        class="w-4/12"></image-upload>
          <image-expand :form-data="formData" :locators-json="marks"
                        @emit-form-data="getFormData"
                        class="w-1/2"></image-expand>
          <image-rotate :form-data="formData"
                        @emit-form-data="getFormData"
                        class="w-1/6"></image-rotate>
        </div>
        <image-update :room-id="roomId" :form-data="formData"
                      @emit-is-loading="getIsLoading"></image-update>
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
      formData: null,
      isLoading: false
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
    },
    getIsLoading(bool) {
      this.isLoading = bool
    }
  },
  created() {
    if (this.formData) return

    this.formData = params.initFormData(this.map)
  },
  mounted() {
    const div = document.getElementById('screen-scroll')
    div.classList.add('overflow-scroll', 'h-screen')
  }
}
</script>
