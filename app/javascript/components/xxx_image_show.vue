<template>
  <div>
    <h2>MapShow</h2>
    <div class="image">
      <h3 v-if="image">{{ image.trimming }}</h3>
      <img v-if="image" :src="image"/>
      <div class="submit_container">
        <a :href="room_path" class="btn btn-secondary">登録</a>
        <a @click="onImageEdit">編集</a>
      </div>
    </div>
  </div>
</template>

<script>
import api from '../modules/api'

export default {
  name: 'MapShow',
  inject: ['roomId'],
  props: [
    'image',
  ],
  data() {
    return {
      map: '',
      trimming: '',
      room_path: `/rooms/${this.roomId}`,
    }
  },
  methods: {
    window:onload = async function() {
      this.map = await api.actions.show('')
    },
    onImageEdit() {
      this.$emit('imageEdit', true)
    }
  }
}
</script>
