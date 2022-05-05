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

export default {
  name: 'ImageUpload',
  props: [
    'targetModel',
  ],
  methods: {
    upload(e) {
      e.preventDefault()
      const uploadedTag = document.getElementById( 'uploaded' )
      const imageFile = e.target.files[0]
      params.readImageUrl(uploadedTag, imageFile)

      this.initForm(imageFile)
    },
    initForm(imageFile) {
      const formData = new FormData()
      if (imageFile !== null) {
        formData.append(`${this.targetModel}[image]`, imageFile)
      }
      this.$emit('emitFormData', formData)
    }
  }
}
</script>
