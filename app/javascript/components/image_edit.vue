<template>
  <div>
    <h2>ImageEdit</h2>
    <div>{{ formData }}</div>
  </div>
</template>

<script>

export default {
  name: 'ImageEdit',
  props: [
    'formData',
  ],
  data() {
    return {
      trimming: ''
    }
  },
  methods: {
  }
}
</script>
