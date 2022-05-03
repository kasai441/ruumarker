<template>
  <section>
    <div class="flex flex-col items-center">
      <h2 class="font-bold text-3xl">ImageShow</h2>
      <div id="show-field" class="my-16 edit-size relative">
        <div class="absolute -z-10 edit-size bg-transparent bg-transparent outline outline-4 outline-lime-500"></div>
        <div class="absolute -z-20 edit-size bg-transparent bg-transparent outline outline-240 outline-slate-200"></div>
        <img v-if="imageUrl"
             :src="imageUrl"
             id="show-image"
             class="absolute -z-30 edit-size w-full object-contain">
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

export default {
  name: 'ImageShow',
  props: [
    'roomId',
    'mapId',
    'targetModel',
  ],
  data() {
    return {
      imageUrl: null,
      trimming: null
    }
  },
  methods: {
    switchImageEdit() {
      this.$emit('switchImageEdit', true)
    },
  },
  async created() {
    const response = await api.actions.show(`/api/rooms/${this.roomId}/${this.targetModel}s/${this.mapId}.json`)
    this.imageUrl = response.image_url

    this.formData = new FormData()
    this.formData.append('map[image_url]', response.image_url)
    this.formData.append('map[trimming]', response.trimming)

    try {
      this.trimming = JSON.parse(response.trimming)
    } finally {
      this.trimming ||= {x: 0, y: 0}
    }
  },
  updated() {
    this.$emit('emitFormData', this.formData)

    const showImage = document.getElementById('show-image')
    showImage.style.left = this.trimming.x + 'px'
    showImage.style.top = this.trimming.y + 'px'
  }
}
</script>
