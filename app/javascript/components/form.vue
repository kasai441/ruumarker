<template>
  <div>
    <h2>MapForm</h2>
    <section>
      <label for="trimming">trimming: </label>
      <input type="text" id="trimming" name="trimming" v-model="trimming" placeholder="trimming" />
    </section>
    <section>
      <label for="image">image: </label>
      <input type="file" id="image" name="image" accept="image/png,image/jpeg" @change="setImage" />
    </section>
    <section>
      <button type="submit" @click="upload">upload</button>
    </section>
  </div>
</template>

<script>
import api from '../modules/api'

export default {
  name: 'MapForm',
  inject: ['roomId'],
  data() {
    return {
      trimming: '',
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
      formData.append('map[trimming]', this.trimming)
      if (this.imageFile !== null) {
        formData.append('map[image]', this.imageFile)
      }
      const response = await api.actions.create('/api/maps', formData)
      this.resetForm()
      this.$emit('upload', response)
    },
    resetForm() {
      this.trimming = ''
      this.imageFile = null
    }
  }
}
</script>
