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
      imageFile: null,
      formData:null
    }
  },
  methods: {
    setImage(e) {
      e.preventDefault()
      this.imageFile = e.target.files[0]
      this.setForm(this.imageFile)
    },
    setForm(image) {
      this.formData = new FormData()
      this.formData.append('room_id', this.roomId)
      if (image !== null) {
        this.formData.append(`${this.targetModel}[image]`, image)
      }
    },
    async upload() {
      const response = await api.actions.create(`/api/${this.targetModel}s`, this.formData)
      this.$emit('upload', response)
      this.resetForm()
    },
    resetForm() {
      this.imageFile = null
    }
  }
}
</script>
