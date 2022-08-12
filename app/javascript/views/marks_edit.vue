<template>
  <section>
    <div class="flex justify-center">
      <div class="pt-6 flex flex-col items-center main-screen">
        <div class="w-full relative flex flex-row items-center">
          <div class="w-full flex justify-center items-center relative">
            <img src="/locators.png" style="width: 40px; height: 40px" class="relative">
            <h1 class="text-white text-2xl font-bold absolute">{{ markNumber }}</h1>
          </div>
          <div class="absolute">
            <a @pointerdown="back" class="text-xl text-slate-400 btn btn-ghost">＜</a>
          </div>
        </div>
        <h2 class="w-full font-h2">キズの概要</h2>
        <div class="w-full">
          <description-edit :form-data.="formData" @emit-form-data="getFormData"></description-edit>
        </div>
        <h2 class="w-full font-h2">キズの写真</h2>
        <div class="w-full flex flex-col items-center overflow-hidden">
          <image-edit :form-data="formData" :is-loading="isLoading"
                      @emit-form-data="getFormData"></image-edit>
        </div>
        <div class="w-field flex flex-row items-center">
          <image-upload :form-data="formData" target-model="mark"
                        @emit-form-data="getFormData"
                        @emit-is-loading="getIsLoading"
                        class="w-4/12"></image-upload>
          <image-expand :form-data="formData"
                        @emit-form-data="getFormData"
                        class="w-1/2"></image-expand>
          <image-rotate :form-data="formData"
                        @emit-form-data="getFormData"
                        class="w-1/6"></image-rotate>
        </div>
        <h2 class="w-full font-h2">キズの位置</h2>
        <p class="w-full">間取り図をドラッグ&ドロップで動かしてキズの位置を
          <img src="/locator.png" width="30" class="inline-block align-middle">
          に指定します。
        </p>
        <div class="bg-slate-300 w-full flex flex-col items-center overflow-hidden">
          <location-edit :field-form-data="mapFormData"
                         :locator-form-data="formData" locator-image="/locator.png"
                         :locators-json="marks"
                         @emit-form-data="getFormData"></location-edit>
        </div>
        <model-update :room-id="roomId" :form-data="formData"></model-update>
      </div>
    </div>
  </section>
</template>

<script>
import ImageEdit from '../components/image_edit.vue'
import ImageUpload from '../components/image_upload.vue'
import ImageRotate from '../components/image_rotate.vue'
import ImageExpand from '../components/image_expand.vue'
import DescriptionEdit from '../components/description_edit.vue'
import LocationEdit from '../components/location_edit.vue'
import ModelUpdate from '../components/model_update.vue'
import params from '../modules/params'
import visuals from '../modules/visuals'

export default {
  name: 'MarksEdit',
  inject: [
    'roomId',
    'marks',
    'mark',
    'map'
  ],
  data() {
    return {
      formData: null,
      markNumber: 0,
      mapFormData: null,
      isLoading: false
    }
  },
  components: {
    ImageEdit,
    ImageUpload,
    ImageRotate,
    ImageExpand,
    DescriptionEdit,
    LocationEdit,
    ModelUpdate
  },
  methods: {
    getFormData(formData) {
      this.formData = formData
    },
    getIsLoading(bool) {
      this.isLoading = bool
    },
    back() {
      location.href = `/rooms/${this.roomId}`
    }
  },
  created() {
    if (this.formData) return

    this.formData = params.initFormData(this.mark)

    const imageUrl = this.formData.get('mark[image_url]')
    if (!imageUrl) this.formData.append('mark[image_url]', '/sample_locator.png')

    const markId = this.formData.get('mark[id]')
    const marks = this.marks ? JSON.parse(this.marks) : []
    marks.forEach((mark, index) => {
      if (mark.id == markId) this.markNumber = index + 1
    })

    this.mapFormData = params.initFormData(this.map)
  },
  updated() {
    visuals.loadingFilter(this.isLoading)
  }
}
</script>
