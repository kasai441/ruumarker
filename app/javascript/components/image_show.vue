<template>
  <div>
    <h2>ImageShow</h2>
    <div class="image">
      <img v-if="imageUrl" :src="imageUrl"/>
      <div class="submit_container">
        <div>{{ response }}</div>
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
    'targetModel'
  ],
  data() {
    return {
      imageUrl: null,
      response: null
    }
  },
  methods: {
    switchImageEdit() {
      this.$emit('switchImageEdit', true)
    }
  },
  mounted: {
    window:onload = async function() {
      // this.response = await api.actions.show(`/api/${this.targetModel}s/${this.mapId}`)
      this.response = await api.actions.show('/api/maps/73.json')
      console.log(this.response)
      const formData = new FormData
      // formData.append('room_id', this.roomId)
      // formData.append(`${this.targetModel}[image]`, imageFile)
    }
  }
}
</script>
