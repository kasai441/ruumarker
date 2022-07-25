<template>
  <section id="image-update">
    <div class="flex justify-center py-4">
      <div class="w-field flex items-center">
        <a @click="back" id="show" class="w-1/3 text-xl text-slate-400 btn btn btn-ghost">＜</a>
        <a @click="update" id="update" class="w-1/3 btn btn-lime">保存</a>
        <div class="w-1/3"></div>
      </div>
    </div>
  </section>
</template>

<script>
import api from '../modules/api'

export default {
  name: 'ModelUpdate',
  props: [
    'roomId',
    'formData'
  ],
  methods: {
    async update() {
      const target = this.formData.get('target')
      const id = this.formData.get(`${target}[id]`)
      await api.actions.update(`/api/rooms/${this.roomId}/${target}s/${id}`, this.formData)
      location.href = `/rooms/${this.roomId}`
    },
    back() {
      location.href = `/rooms/${this.roomId}`
    }
  }
}
</script>
