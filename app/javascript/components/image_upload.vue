<template>
  <section>

    <div class="bg-slate-900">
      <div class="image" style="width:400px; height:300px;">
        <div class="flex items-center justify-center" style="height:100%; width:100%">
          <img id="uploaded" style="height:100%; width:100%; object-fit:cover;">
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
  },
  mounted() {
    const uploadedTag = document.getElementById( 'uploaded' )
    uploadedTag.src = '/assets/logo.png?w=160&h=160'
  }
}
</script>
