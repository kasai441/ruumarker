<template>
  <div id="image-create">
    <section v-if="formData" class="submit_container">
      <a @click="create(room_path)" id="submit" class="btn btn-primary">登録</a>
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
  data() {
    return {
      room_path: `/rooms/${this.roomId}`,
    }
  },
  methods: {
    async create(path) {
      this.formData.append('room_id', this.roomId)
      const response = await api.actions.create(`/api/${this.targetModel}s`, this.formData)

      path ||= `/rooms/${this.roomId}/maps/${response.id}/edit`
      location.href = path
    },
    edit() {
      this.create(null)
    }
  }
}
</script>
