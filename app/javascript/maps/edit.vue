<template>
  <div id="maps-edit">
    <section v-if="isImageEdit">
      <image-edit
        :form-data="formData"
        @emitFormData="getFormData"
      ></image-edit>
      <image-update
        :room-id="roomId"
        :map-id="mapId"
        :form-data="formData"
        target-model="map"
        @switchImageEdit="switchImageEdit"
      ></image-update>
    </section>
    <section v-else>
      <image-show
        :map-id="mapId"
        target-model="map"
        @emitFormData="getFormData"
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
  inject: ['roomId', 'mapId'],
  data() {
    return {
      isImageEdit: false,
      formData: null,
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
