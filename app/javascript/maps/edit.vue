<template>
  <div id="maps-new">
    <div v-if="isImageEdit">
      <image-edit v-bind:response="response" targetModel="map"></image-edit>
    </div>
    <div v-else>
      <image-show v-if="imageFile" v-bind:image="image" @imageEdit="imageEdit"></image-show>
      <image-upload targetModel="map" @form="form"></image-upload>
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
