<template>
  <section id="maps-edit" class="w-full">
    <div v-if="isImageEdit" @touchmove.prevent>
      <image-edit
        :formData="formData"
        target-model="map"
        @emitFormData="getFormData"
      ></image-edit>
      <image-update
        :id="mapId"
        :formData="formData"
        target-model="map"
      ></image-update>
    </div>
    <div v-else>
      <image-show
        :id="mapId"
        target-model="map"
        @switchImageEdit="switchImageEdit"
        @emitFormData="getFormData"
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
  inject: [
    'roomId',
    'mapId'
  ],
  data() {
    return {
      isImageEdit: false,
      formData: null,
    }
  },
  components: {
    ImageShow,
    ImageEdit,
    ImageUpdate,
  },
  methods: {
    switchImageEdit(bool) {
      this.isImageEdit = bool
    },
    getFormData(formData) {
      this.formData = formData
    },
  }
}
</script>
