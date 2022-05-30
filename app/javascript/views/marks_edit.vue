<template>
  <section>
    <div class="pt-6 flex flex-col items-center">
      <div class="w-full relative flex flex-row items-center">
        <div class="w-full flex justify-center items-center relative">
          <img src="/locators.png" style="width: 50px; height: 50px" class="relative">
          <h1 class="text-white text-2xl font-bold absolute">{{ markNumber }}</h1>
        </div>
        <div class="absolute">
          <a @pointerdown="back" class="text-xl text-slate-400 btn btn-ghost">＜</a>
        </div>
      </div>
      <div class="w-full">
        <description-edit :form-data.="formData" target-model="mark" @emit-form-data="getFormData"></description-edit>
      </div>
      <div class="w-full flex flex-col items-center overflow-hidden">
        <image-edit :form-data="formData" target-model="mark"
                    @emit-form-data="getFormData"></image-edit>
      </div>
      <image-upload :form-data="formData" target-model="mark" @emit-form-data="getFormData"></image-upload>
      <h2 class="w-full font-h2">キズの位置</h2>
      <div class="bg-slate-300 w-full flex flex-col items-center overflow-hidden">
        <location-edit :locator-form-data="formData" locator-model="mark" locator-image="/locator.png"
                       :locators-json="marks"
                       :field-form-data="mapFormData" field-model="map"
                       @emit-form-data="getFormData"></location-edit>
      </div>
      <image-update :room-id="roomId" :form-data="formData" target-model="mark"></image-update>
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
    'marks',
    'mark',
    'map'
  ],
  data() {
    return {
      formData: null,
      markNumber: 128,
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
    },
    back() {
      location.href = `/rooms/${this.roomId}`
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
