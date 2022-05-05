<template>
  <section>
    <div class="flex justify-center">
      <div id="upload-field" class="edit-size rounded-lg bg-slate-100 outline outline-4 outline-lime-500">
        <img id="uploaded" src="/sample.png" class="object-contain edit-size rounded-lg">
      </div>
    </div>
    <div class="p-4 text-sm">
      <input type="file" id="upload-image" name="upload-image" accept="image/png,image/jpeg" @change="upload" />
    </div>
  </section>
</template>

<script>
import params from '../modules/params'
import api from '../modules/api'

export default {
  name: 'ImageUpload',
  inject: [
    'roomId'
  ],
  props: [
    'targetModel'
  ],
  methods: {
    async upload(e) {
      e.preventDefault()
      const imageFile = e.target.files[0]
      const formData = new FormData()
      if (imageFile) formData.append(`${this.targetModel}[image]`, imageFile)

      if (this.targetModel === 'map') {
        await api.actions.create(`/api/rooms/${this.roomId}/${this.targetModel}s`, formData)
        location.href = `/rooms/${this.roomId}`
      } else {
        const uploadedTag = document.getElementById( 'uploaded' )
        params.readImageUrl(uploadedTag, imageFile)
        this.$emit('emitFormData', formData)
      }
    }
  }
}
</script>
