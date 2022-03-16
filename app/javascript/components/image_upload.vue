<template>
  <div>
    <h2>ImageUpload</h2>
    <section>
      <label for="image">image: </label>
      <input type="file" id="image" name="image" accept="image/png,image/jpeg" @change="setImage" />
    </section>
    <section>
      <button type="submit" @click="upload">upload</button>
    </section>
    <router-link to="/image/edit">編集</router-link>

  </div>
</template>

<script>
import api from '../modules/api'

export default {
  name: 'ImageUpload',
  inject: ['roomId'],
  props: [
    'targetModel',
  ],
  data() {
    return {
      imageFile: null
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
      if (this.imageFile !== null) {
        formData.append(`${this.targetModel}[image]`, this.imageFile)
      }
      const response = await api.actions.create(`/api/${this.targetModel}s`, formData)
      this.resetForm()
      this.$emit('upload', response)
    },
    resetForm() {
      this.imageFile = null
    }
  }
}
</script>
