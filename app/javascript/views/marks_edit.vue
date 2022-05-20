<template>
  <section>
    <div class="flex flex-col items-center">
      <h1 class="w-full bg-white text-center p-4 text-2xl font-bold relative z-50 outline outline-white outline-32">キズ情報</h1>
      <h2 class="w-full relative z-50 h2-font">キズ画像を編集してください</h2>
      <div @touchmove.prevent class="flex flex-col items-center">
        <image-edit :form-data="formData" target-model="mark" @emit-form-data="getFormData"></image-edit>
        <image-upload :form-data="formData" target-model="mark" @emit-form-data="getFormData"></image-upload>
      </div>
      <h2 class="w-full relative z-50 h2-font">キズの概要を記入してください</h2>
      <div class="w-full relative z-50">
        <div id="bg-description" class="w-full bg-white h-24 absolute"></div>
        <description-edit :form-data="formData" target-model="mark" @emit-form-data="getFormData"></description-edit>
      </div>
      <h2 class="w-full relative z-50 h2-font">キズの位置を編集してください</h2>
      <div @touchmove.prevent class="bg-slate-300 w-full flex flex-col items-center overflow-hidden">
        <location-edit :form-data="formData" :map-form-data="mapFormData" target-model="mark" @emit-form-data="getFormData"></location-edit>
      </div>
      <div class="w-full relative z-50">
        <div id="bg-update" class="w-full h-24 bg-white absolute"></div>
        <image-update :room-id="roomId" :form-data="formData" target-model="mark"></image-update>
      </div>
    </div>
  </section>
</template>

<script>
import ImageEdit from '../components/image_edit.vue'
import ImageUpload from '../components/image_upload.vue'
import DescriptionEdit from '../components/description_edit.vue'
import LocationEdit from '../components/location_edit.vue'
import ImageUpdate from '../components/image_update.vue'
import params from '../modules/params'

export default {
  name: 'MarksEdit',
  inject: [
    'roomId',
    'mark',
    'map'
  ],
  data() {
    return {
      formData: null,
      mapFormData: null
    }
  },
  components: {
    ImageEdit,
    ImageUpload,
    DescriptionEdit,
    LocationEdit,
    ImageUpdate
  },
  methods: {
    getFormData(formData) {
      this.formData = formData
    }
  },
  async created() {
    console.log('MarksEdit#created')

    if (this.formData) return

    this.formData = params.initFormData(this.mark, 'mark')
    const imageUrl = this.formData.get('mark[image_url]')
    if (!imageUrl) this.formData.append('mark[image_url]', '/sample.png')

    this.mapFormData = params.initFormData(this.map, 'map')
  }
}
</script>
