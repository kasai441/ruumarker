<template>
  <section id="image-update">
    <div class="flex justify-center">
      <a @click="back" id="show" class="btn btn-secondary">＜</a>
      <a @click="update" id="update" class="btn btn-primary">変更</a>
    </div>
  </section>
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
