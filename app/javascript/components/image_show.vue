<template>
  <div>
    <h2>MapShow</h2>
    <div>
      <h3 v-if="response">{{ response.trimming }}</h3>
      <img v-if="response" :src="response.image_url" />
      <img v-else />
      <div class="submit_container">
        <a :href="room_path" class="btn btn-secondary">登録</a>
        <router-link to="/image/edit">編集</router-link>
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
    'response',
  ],
  data() {
    return {
      map: '',
      trimming: '',
      room_path: `/rooms/${this.roomId}`
    }
  },
  methods: {
    window:onload = async function() {
      this.map = await api.actions.show('')
    },
  }
}
</script>
