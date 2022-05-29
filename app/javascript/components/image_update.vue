<template>
  <section id="image-update">
    <div class="flex justify-center p-4">
      <div class="w-field flex items-center">
        <a @click="back" id="show" class="w-1/3 text-xl text-slate-400 btn btn btn-ghost">＜</a>
        <a @click="update" id="update" class="w-1/3 btn btn-lime">変更</a>
        <div class="w-1/3"></div>
      </div>
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
