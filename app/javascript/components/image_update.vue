<template>
  <div id="image-update" class="flex justify-center relative z-60">
    <a @click="switchImageEdit" id="show" class="btn btn-secondary">キャンセル</a>
    <a @click="update" id="update" class="btn btn-primary">登録</a>
  </div>
</template>

<script>
import api from '../modules/api'

export default {
  name: 'ImageUpdate',
  inject: [
    'roomId'
  ],
  props: [
    'id',
    'formData',
    'targetModel'
  ],
  methods: {
    async update() {
      const response = await api.actions.update(`/api/rooms/${this.roomId}/${this.targetModel}s/${this.id}`, this.formData)
      location.href = `/rooms/${this.roomId}/${this.targetModel}s/${response.id}/edit`
    },
    switchImageEdit() {
      this.$emit('switchImageEdit', false)
    }
  }
}
</script>
