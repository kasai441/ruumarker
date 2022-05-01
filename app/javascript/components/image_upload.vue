<template>
  <section>
    <div class="bg-slate-900 border-slate-900 flex">
      <div class="image flex w-96 h-64">
        <div class="flex items-center justify-center">
          <img id="uploaded" src="/assets/logo.png" class="object-none w-96 h-64">
        </div>
      </div>
    </div>
    <div class="p-4">
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
