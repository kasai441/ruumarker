<template>
  <div id="maps-edit">
    <div v-if="isImageEdit">
      <image-edit v-bind:response="response" targetModel="map"></image-edit>
    </div>
    <div v-else>
      <image-show @imageEdit="imageEdit"></image-show>
      <image-upload targetModel="map" @form="form"></image-upload>
    </div>
  </div>
</template>

<script>
import ImageEdit from '../components/image_edit.vue'
import ImageShow from '../components/image_show.vue'
import ImageUpload from '../components/image_upload.vue'

export default {
  name: 'MapsEdit',
  inject: ['roomId', 'mapId', 'imageUrl'],
  data() {
    return {
      formData: null,
      response: null,
      isImageEdit: false
    }
  },
  components: {
    ImageEdit,
    ImageShow,
    ImageUpload
  },
  methods: {
    form(data) {
      this.formData = data
    },
    imageEdit(boolean) {
      this.isImageEdit = boolean
    }
  }
}
</script>
