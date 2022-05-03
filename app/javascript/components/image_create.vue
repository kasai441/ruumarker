<template>
  <div id="image-create">
    <div v-if="formData" class="submit_container">
      <div @click="submit" id="submit" class="btn btn-primary">登録</div>
      <div @click="edit" id="edit" class="btn btn-secondary">編集</div>
    </div>
  </div>
</template>

<script>
import api from '../modules/api'

export default {
  name: 'ImageCreate',
  props: [
    'targetModel',
    'roomId',
    'formData'
  ],
  methods: {
    async submit() {
      await this.create()
      location.href = `/rooms/${this.roomId}`
    },
    async edit() {
      const response = await this.create()
      location.href = `/rooms/${this.roomId}/maps/${response.id}/edit`
    },
    async create() {
      this.formData.append('room_id', this.roomId)
      return await api.actions.create(`/api/rooms/${this.roomId}/${this.targetModel}s`, this.formData)
    }
  }
}
</script>
