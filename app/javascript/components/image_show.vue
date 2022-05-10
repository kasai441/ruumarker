<template>
  <section id="image-show">
    <div class="flex flex-col items-center">
      <div id="show-field" class="my-8 edit-size rounded-lg relative">
        <div class="absolute -z-10 edit-size rounded-lg bg-transparent bg-transparent outline outline-3 outline-slate-200"></div>
        <div class="absolute -z-20 edit-size rounded-lg bg-transparent bg-transparent outline outline-112 outline-white"></div>
        <img :src="imageUrl" id="show-image" class="rounded-lg absolute -z-30 edit-size w-full object-contain">
      </div>
      <div class="submit_container relative z-60">
        <a @click="mapEdit" id="map-edit" class="btn btn-primary">マップ編集</a>
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
    'roomId'
  ],
  props: [
    'id',
    'targetModel'
  ],
  data() {
    return {
      formData: new FormData(),
      imageUrl: null,
      showFieldWidth: 0,
      showFieldHeight: 0
    }
  },
  methods: {
    mapEdit() {
      location.href = `/rooms/${this.roomId}/${this.targetModel}s/${this.id}/edit`
    },
    getFieldSize() {
      const showField = document.getElementById('show-field')
      if (showField) {
        const showFieldLeft = Math.floor(showField.getBoundingClientRect().left)
        const showFieldTop = Math.floor(showField.getBoundingClientRect().top)
        this.showFieldWidth = Math.floor(showField.getBoundingClientRect().right) - showFieldLeft
        this.showFieldHeight = Math.floor(showField.getBoundingClientRect().bottom) - showFieldTop

        const showImage = document.getElementById('show-image')
        const trimming = params.trimming(this.formData, this.targetModel)
        showImage.style.left = Math.floor(this.showFieldWidth * trimming.x) + 'px'
        showImage.style.top = Math.floor(this.showFieldHeight * trimming.y) + 'px'
      }
    },
    handleResize() {
      this.getFieldSize()
    }
  },
  async created() {
    const response = await api.actions.show(`/api/rooms/${this.roomId}/${this.targetModel}s/${this.id}.json`)
    this.formData.append(`${this.targetModel}[trimming]`, response.trimming)
    this.formData.append(`${this.targetModel}[image_url]`, response.image_url)
    this.$emit('emitFormData', this.formData)
    this.imageUrl = response.image_url
  },
  mounted() {
    window.addEventListener('resize', this.handleResize)
  },
  updated() {
    this.getFieldSize()
  },
  beforeDestroy: () => {
    window.removeEventListener('resize', this.handleResize)
  }
}
</script>
