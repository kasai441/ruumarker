<template>
  <div id="maps-edit">
    <section v-if="isImageEdit">
      <image-edit v-bind:response="response" targetModel="map" @emitFormData="getFormData"></image-edit>
    </section>
    <section v-else>
      <image-show :image-url="imageUrl" @switchImageEdit="switchImageEdit"></image-show>
    </section>
  </div>
</template>

<script>
import ImageShow from '../components/image_show.vue'
import ImageEdit from '../components/image_edit.vue'

export default {
  name: 'MapsEdit',
  inject: ['roomId', 'mapId', 'imageUrl'],
  data() {
    return {
      isImageEdit: false,
      formData: null
    }
  },
  components: {
    ImageEdit,
    ImageShow
  },
  methods: {
    switchImageEdit(bool) {
      this.isImageEdit = bool
    },
    getFormData(formData) {
      this.formData = formData
    }
  }
}
</script>
