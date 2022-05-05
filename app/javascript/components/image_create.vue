<template>
  <div id="image-create">
    <div v-if="formData" class="submit_container">
      <div @click="create" id="submit" class="btn btn-primary">登録</div>
    </div>
  </div>
</template>

<script>
import api from '../modules/api'

export default {
  name: 'ImageCreate',
  inject: [
    'roomId'
  ],
  props: [
    'targetModel',
    'formData'
  ],
  methods: {
    async create() {
      await api.actions.create(`/api/rooms/${this.roomId}/${this.targetModel}s`, this.formData)
      location.href = `/rooms/${this.roomId}`
    }
  }
}
</script>
