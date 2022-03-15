<template>
  <div>
    <h2>ImageEdit</h2>
  </div>
</template>

<script>
import api from '../modules/api'

export default {
  name: 'ImageEdit',
  inject: ['roomId'],
  props: [
    'targetModel',
  ],
  data() {
    return {
      trimming: ''
    }
  },
  methods: {
    setImage(e) {
      e.preventDefault()
      this.imageFile = e.target.files[0]
    },
    async upload() {
      let formData = new FormData()
      formData.append('room_id', this.roomId)
      formData.append(`${this.targetModel}[trimming]`, this.trimming)
      const response = await api.actions.create(`/api/${this.targetModel}s`, formData)
      this.resetForm()
      this.$emit('upload', response)
    },
    resetForm() {
      this.trimming = ''
    }
  }
}
</script>
