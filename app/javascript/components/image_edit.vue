<template>
  <div>
    <h2>ImageEdit</h2>
    <div>{{ trimming }}</div>
  </div>
</template>

<script>

export default {
  name: 'ImageEdit',
  props: [
    'formData'
  ],
  data() {
    return {
      trimming: this.formData.get('trimming'),
    }
  },
  methods: {
  },
  created() {
    console.log(this.formData.get('trimming'))
  },
  updated() {
    this.$emit('emitFormData', this.formData)
  }
}
</script>
