<template>
  <div id="map-item">
    <map-show v-if="response" v-bind:response="response"></map-show>
    <map-form v-else @upload="fromForm"></map-form>
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
