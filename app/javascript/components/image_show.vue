<template>
  <section>
    <div class="flex flex-col items-center">
      <div id="show-field" class="my-16 edit-size relative">
        <div class="absolute -z-10 edit-size bg-transparent bg-transparent outline outline-4 outline-lime-500"></div>
        <div class="absolute -z-20 edit-size bg-transparent bg-transparent outline outline-240 outline-slate-200"></div>
        <img v-if="imageUrl"
             :src="imageUrl"
             id="show-image"
             class="absolute -z-30 edit-size w-full object-contain">
      </div>
      <div class="p-4 text-sm">
        <input type="file" id="upload-image" name="upload-image" accept="image/png,image/jpeg" @change="upload" />
      </div>
      <div class="submit_container relative z-60">
        <a @click="switchImageEdit" id="edit"
           class="btn btn-primary">編集</a>
      </div>
    </div>
  </section>
</template>
<script>
import api from '../modules/api'
import params from '../modules/params'

export default {
  name: 'ImageShow',
  inject: [
    'roomId',
    'mapId'
  ],
  props: [
    'targetModel'
  ],
  data() {
    return {
      formData: new FormData(),
      imageUrl: null
    }
  },
  methods: {
    switchImageEdit() {
      this.$emit('switchImageEdit', true)
    },
    upload(e) {
      e.preventDefault()
      const uploadedTag = document.getElementById( 'show-image' )
      const imageFile = e.target.files[0]

      params.readImageUrl(uploadedTag, imageFile)

      if (imageFile) this.formData.set(`${this.targetModel}[image]`, imageFile)
      this.$emit('emitFormData', this.formData)
    }
  },
  async created() {
    const response = await api.actions.show(`/api/rooms/${this.roomId}/${this.targetModel}s/${this.mapId}.json`)

    this.formData.append(`${this.targetModel}[trimming]`, response.trimming)
    this.formData.append(`${this.targetModel}[image_url]`, response.image_url)
    this.$emit('emitFormData', this.formData)

    this.imageUrl = response.image_url
  },
  updated() {
    const showImage = document.getElementById('show-image')
    const trimming = params.trimming(this.formData)
    showImage.style.left = trimming.x + 'px'
    showImage.style.top = trimming.y + 'px'
  }
}
</script>
