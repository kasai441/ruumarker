<template>
  <section class="items-center flex flex-col">
    <h2 class="font-bold text-3xl">ImageShow</h2>
    <div id="show-field"
      style="width: 300px; height:200px; background-color: black;"
    >
      <img v-if="imageUrl"
           :src="imageUrl"
           id="show-image"
           width="200"
        style="position: relative"
      />
    </div>
    <div class="submit_container">
      <a @click="switchImageEdit" id="edit"
         class="rounded-lg py-3 px-5 bg-blue-600 text-white block font-medium"
      >編集</a>
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
