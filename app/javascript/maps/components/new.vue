<template>
  <div id="map-item">
    <div>{{ roomId }}</div>
    <p>{{ response }}</p>
    <map-form @upload="fromForm"></map-form>
    <map-show v-bind:response="response" parent-message="response"></map-show>
  </div>
</template>

<script>
import mapForm from './form.vue'
import mapShow from './show.vue'

export default {
  name: 'MapItem',
  inject: ['roomId'],
  data() {
    return {
      image: '',
      imageFile: null,
      response: null,
      hoge: 'hoge'
    }
  },
  // provide() {
  //   return {
  //     roomId: this.roomId
  //   }
  // },
  components: {
    mapForm,
    mapShow
  },
  methods: {
    fromForm(response){
      console.log('hoge')
      this.response = response
    }
  }
}
</script>
