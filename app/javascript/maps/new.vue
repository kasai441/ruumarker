<template>
  <div id="maps-new">
    <div v-if="isImageEdit">
      <image-edit v-bind:response="response" targetModel="map"></image-edit>
    </div>
    <div v-else>
      <image-show v-if="response" v-bind:response="response" @imageEdit="imageEdit" @upload="result"></image-show>
      <image-upload v-else targetModel="map" @upload="result"></image-upload>
    </div>
  </div>
</template>

<script>
import ImageEdit from '../components/image_edit.vue'
import ImageShow from '../components/image_show.vue'
import ImageUpload from '../components/image_upload.vue'

export default {
  name: 'MapsNew',
  inject: ['roomId'],
  data() {
    return {
      image: '',
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
    result(response) {
      this.response = response
    },
    imageEdit(boolean) {
      this.isImageEdit = boolean
    }
  }
}
</script>
