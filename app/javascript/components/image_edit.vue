<template>
  <section>
    <h2>ImageEdit</h2>
    <div>{{ trimming }}</div>
      <img :src="imageUrl"/>
    <div></div>
  </section>
</template>

<script>

export default {
  name: 'ImageEdit',
  props: [
    'formData'
  ],
  data() {
    return {
      trimming: null,
      imageUrl: null
    }
  },
  methods: {
  },
  created() {
    this.trimming = this.formData.get('[map]trimming')
    this.imageUrl = this.formData.get('[map]image_url')
  },
  updated() {
    this.$emit('emitFormData', this.formData)
  }
}
</script>
