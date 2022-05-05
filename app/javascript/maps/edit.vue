<template>
  <section id="maps-edit" class="w-full">
    <div v-if="isImageEdit" @touchmove.prevent>
      <image-edit
        :trimming="trimming"
        :image-file="imageFile"
        :image-url="imageUrl"
        @emitTrimming="getTrimming"
      ></image-edit>
      <image-update
        :room-id="roomId"
        :map-id="mapId"
        :trimming="trimming"
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
        @switchImageEdit="switchImageEdit"
        @emitTrimming="getTrimming"
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
      trimming: null,
      imageFile: null,
      imageUrl: null,
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
    getTrimming(trimming) {
      this.trimming = trimming
    },
    getImageFile(imageFile) {
      if (imageFile !== null) {
        this.imageFile = imageFile
      }
    },
    getImageUrl(imageUrl) {
      if (imageUrl !== null) {
        this.imageUrl = imageUrl
      }
    }
  }
}
</script>
