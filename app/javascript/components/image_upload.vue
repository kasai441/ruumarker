<template>
  <div>
    <h2>ImageUpload</h2>
    <section class="image">
      <img id="uploaded" width="200">
    </section>
    <section>
      <label for="image">image: </label>
      <input type="file" id="image" name="image" accept="image/png,image/jpeg" @change="upload" />
    </section>
  </div>
</template>

<script>

export default {
  name: 'ImageUpload',
  props: [
    'targetModel',
  ],
  methods: {
    upload(e) {
      e.preventDefault()
      const imageFile = e.target.files[0]
      const uploadedTag = document.getElementById( 'uploaded' )

      const reader = new FileReader()
      reader.onload = function () {
        uploadedTag.src = this.result
      }
      reader.readAsDataURL(imageFile)

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
