<template>
  <section>
    <div class="flex justify-center">
      <div class="image edit-size rounded-lg bg-slate-100 outline outline-4 outline-lime-300">
        <img id="uploaded" src="/assets/logo.png" class="object-none edit-size rounded-lg">
      </div>
    </div>
    <div class="p-4 text-sm">
      <input type="file" id="image" name="image" accept="image/png,image/jpeg" @change="upload" />
    </div>
  </section>
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
