<template>
  <section>
    <div class="flex justify-center">
      <div class="edit-screen flex flex-col items-center">
        <div class="w-full mt-6 flex flex-col items-center overflow-hidden">
          <image-edit :form-data="formData" :locators-json="marks"
                      :is-loading="isLoading" @emit-form-data="getFormData"></image-edit>
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
        <model-update :room-id="roomId" :form-data="formData"
                      @emit-is-loading="getIsLoading"></model-update>
      </div>
    </div>
  </section>
</template>

<script>
import ImageEdit from '../components/image_edit.vue'
import ImageUpload from '../components/image_upload.vue'
import ImageRotate from '../components/image_rotate.vue'
import ImageExpand from '../components/image_expand.vue'
import ModelUpdate from '../components/model_update.vue'
import params from '../modules/params'
import visuals from '../modules/visuals'

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
    ModelUpdate
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
  updated() {
    visuals.loadingFilter(this.isLoading)
  }
}
</script>
