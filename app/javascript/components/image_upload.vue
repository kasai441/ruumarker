<template>
  <div class="p-4 text-sm">
    <input type="file" id="upload-image" name="upload-image" accept="image/png,image/jpeg" @change="upload" />
  </div>
</template>

<script>
export default {
  name: 'ImageUpload',
  props: [
    'targetModel'
  ],
  methods: {
    async upload(e) {
      e.preventDefault()
      const imageFile = e.target.files[0]
      const formData = new FormData()
      if (imageFile) formData.append(`${this.targetModel}[image]`, imageFile)
      this.$emit('emitFormData', formData)
    }
  }
}
</script>
