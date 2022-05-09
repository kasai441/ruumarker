<template>
  <div id="image-update" class="flex justify-center relative z-60">
    <a @click="back" id="show" class="btn btn-secondary">＜</a>
    <a @click="update" id="update" class="btn btn-primary">変更</a>
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
      await api.actions.update(`/api/rooms/${this.roomId}/${this.targetModel}s/${this.id}`, this.formData)
      location.href = `/rooms/${this.roomId}`
    },
    back() {
      location.href = `/rooms/${this.roomId}`
    }
  }
}
</script>
