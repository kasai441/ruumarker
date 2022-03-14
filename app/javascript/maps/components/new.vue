<template>
  <div id="map-item">
<!--    <Demo />-->
    <div>{{ roomId }}</div>
  </div>
</template>

<script>
// import Demo from './demo.vue'
// import Api from '../../api/api'

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
    // Demo
  },
}
</script>
