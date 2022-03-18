<template>
  <div>
    <h2>ImageEdit</h2>
    <div>{{ imageUrl }}</div>
  </div>
</template>

<script>

export default {
  name: 'ImageEdit',
  props: [
    'imageUrl',
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
