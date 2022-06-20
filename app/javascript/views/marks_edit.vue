<template>
  <section>
    <div class="flex justify-center">
      <div class="pt-6 flex flex-col items-center main-screen">
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
        <image-rotate :form-data="formData" target-model="mark" @emit-form-data="getFormData"></image-rotate>
        <image-expand :form-data="formData" target-model="mark" @emit-form-data="getFormData"></image-expand>
        <h2 class="w-full font-h2">キズの位置</h2>
        <div class="bg-slate-300 w-full flex flex-col items-center overflow-hidden">
          <location-edit :locator-form-data="formData" locator-model="mark" locator-image="/locator.png"
                         :locators-json="marks"
                         :field-form-data="mapFormData" field-model="map"
                         @emit-form-data="getFormData"></location-edit>
        </div>
        <image-update :room-id="roomId" :form-data="formData" target-model="mark"></image-update>
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
      markNumber: 0,
      mapFormData: null
    }
  },
  components: {
    ImageEdit,
    ImageUpload,
    ImageRotate,
    ImageExpand,
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
  created() {
    if (this.formData) return

    this.formData = params.initFormData(this.mark)

    const imageUrl = this.formData.get('mark[image_url]')
    if (!imageUrl) this.formData.append('mark[image_url]', '/sample.png')

    const markId = this.formData.get('mark[id]')
    const marks = this.marks ? JSON.parse(this.marks) : []
    marks.forEach((mark, index) => {
      if (mark.id == markId) this.markNumber = index + 1
    })

    this.mapFormData = params.initFormData(this.map)
  },
  mounted() {
    const div = document.getElementById('screen-scroll')
    div.classList.add('overflow-scroll', 'h-screen')
  }
}
</script>
