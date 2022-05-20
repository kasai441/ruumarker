<template>
  <section id="image-update">
    <div class="flex justify-center p-4 relative z-60">
      <a @click="back" id="show" class="btn btn-secondary">＜</a>
      <a @click="update" id="update" class="btn btn-primary">変更</a>
    </div>
  </section>
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
      const id = this.formData.get(`${this.targetModel}[id]`)
      await api.actions.update(`/api/rooms/${this.roomId}/${this.targetModel}s/${id}`, this.formData)
      location.href = `/rooms/${this.roomId}`
    },
    back() {
      location.href = `/rooms/${this.roomId}`
    }
  }
}
</script>
