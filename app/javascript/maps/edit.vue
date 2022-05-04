<template>
  <section id="maps-edit" class="w-full">
    <div>{{ trimming }}</div>
    <div v-if="isImageEdit" @touchmove.prevent>
      <image-edit
        :form-data="formData"
        :image-file="imageFile"
        :image-url="imageUrl"
        @emitFormData="getFormData"
      ></image-edit>
      <image-update
        :room-id="roomId"
        :map-id="mapId"
        :form-data="formData"
        :image-file="imageFile"
        :image-url="imageUrl"
        target-model="map"
        @switchImageEdit="switchImageEdit"
      ></image-update>
    </div>
    <div v-else>
      <image-show
        :room-id="roomId"
        :map-id="mapId"
        target-model="map"
        @emitFormData="getFormData"
        @switchImageEdit="switchImageEdit"
        @emitImageFile="getImageFile"
        @emitImageUrl="getImageUrl"
      ></image-show>
    </div>
  </section>
</template>

<script>
import ImageEdit from '../components/image_edit.vue'
import ImageUpdate from '../components/image_update.vue'
import ImageShow from '../components/image_show.vue'

export default {
  name: 'MapsEdit',
  inject: ['roomId', 'mapId'],
  data() {
    return {
      isImageEdit: false,
      formData: null,
      trimming: null,
      imageFile: null,
      imageUrl: null
    }
  },
  components: {
    ImageShow,
    ImageEdit,
    ImageUpdate
  },
  methods: {
    switchImageEdit(bool) {
      this.isImageEdit = bool
    },
    getFormData(formData) {
      this.formData = formData
    },
    getImageFile(imageFile) {
      if (imageFile !== null) {
        this.imageFile = imageFile
        console.log('edit:')
        console.log(this.imageFile)
      }
    },
    getImageUrl(imageUrl) {
      if (imageUrl !== null) {
        this.imageUrl = imageUrl
        console.log('url:')
        console.log(this.imageUrl)
      }
    }
  }
}
</script>
