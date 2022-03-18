<template>
  <div id="maps-edit">
    <section v-if="isImageEdit">
      <image-edit
        :image-url="imageUrl"
        @emitFormData="getFormData"
      ></image-edit>
      <image-update
        :room-id="roomId"
        :map-id="mapId"
        target-model="map"
        @switchImageEdit="switchImageEdit"
        @emitFormData="getFormData"
      ></image-update>
    </section>
    <section v-else>
      <image-show
        :image-url="imageUrl"
        @switchImageEdit="switchImageEdit"
      ></image-show>
    </section>
  </div>
</template>

<script>
import ImageEdit from '../components/image_edit.vue'
import ImageUpdate from '../components/image_update.vue'
import ImageShow from '../components/image_show.vue'

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
    }
  }
}
</script>
