<template>
  <div id="image-create">
    <section v-if="formData" class="submit_container">
      <a @click="submit" id="submit" class="btn btn-primary">登録</a>
      <a @click="edit" id="edit" class="btn btn-secondary">編集</a>
    </section>
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
    submit() {
      this.create()
      location.href = `/rooms/${this.roomId}`
    },
    async edit() {
      const response = await this.create()
      location.href = `/rooms/${this.roomId}/maps/${response.id}/edit`
    },
    async create() {
      this.formData.append('room_id', this.roomId)
      return await api.actions.create(`/api/${this.targetModel}s`, this.formData)
    }
  }
}
</script>
