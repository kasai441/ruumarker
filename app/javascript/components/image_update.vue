<template>
  <div id="image-update">
    <a @click="switchImageEdit" id="show" class="btn btn-secondary">キャンセル</a>
    <a @click="update" id="submit" class="btn btn-primary">登録</a>
  </div>
</template>

<script>
import api from '../modules/api'

export default {
  name: 'ImageUpdate',
  props: [
    'roomId',
    'formData',
    'targetModel'
  ],
  methods: {
    async update() {
      this.formData.append('room_id', this.roomId)
      const response = await api.actions.update(`/api/${this.targetModel}s`, this.formData)
      location.href = `/rooms/${this.roomId}/maps/${response.id}/edit`
    },
    switchImageEdit() {
      this.$emit('switchImageEdit', false)
    }
  }
}
</script>
