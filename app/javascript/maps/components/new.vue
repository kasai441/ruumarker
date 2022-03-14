<template>
  <div id="map-item">
    <div>{{ roomId }}</div>
    <Form />
  </div>
</template>

<script>
import Form from './form.vue'

export default {
  name: 'MapItem',
  inject: ['roomId'],
  data() {
    return {
      roomId: this.roomId,
      image: '',
      imageFile: null
    }
  },
  provide() {
    return {
      roomId: this.roomId
    }
  },
  components: {
    Form
  },
}
</script>
