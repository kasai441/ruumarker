<template>
  <div>
    <h2>ImageShow</h2>
    <div class="image">
      <img v-if="imageUrl" :src="imageUrl"/>
      <div class="submit_container">
        <a @click="switchImageEdit">編集</a>
      </div>
    </div>
  </div>
</template>

<script>
import api from '../modules/api'

export default {
  name: 'ImageShow',
  props: [
    'mapId',
    'targetModel',
  ],
  data() {
    return {
      imageUrl: null,
    }
  },
  methods: {
    switchImageEdit() {
      this.$emit('switchImageEdit', true)
    },
  },
  async created() {
    this.formData = new FormData()
    const response = await api.actions.show(`/api/${this.targetModel}s/${this.mapId}.json`)
    this.imageUrl = response.image_url
    this.formData.append('imageUrl', response.image_url)
    // console.log(response)
    this.formData.append('trimming', response.trimming)
  },
  updated() {
    this.$emit('emitFormData', this.formData)
  }
}
</script>
