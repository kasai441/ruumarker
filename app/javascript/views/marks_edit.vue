<template>
  <section>
    <div class="flex flex-col items-center" @touchmove.prevent>
      <div>{{ markTrimming }}</div>
      <div>{{ mapTrimming }}</div>
<!--      <image-edit :form-data="formData" target-model="mark" @emit-form-data="getFormData"></image-edit>-->
<!--      <image-upload target-model="mark" @emit-form-data="getFormData"></image-upload>-->
<!--      <image-update :room-id="roomId" :id="markId" :form-data="formData" target-model="mark"></image-update>-->
    </div>
  </section>
</template>

<script>
import ImageEdit from '../components/image_edit.vue'
import ImageUpload from '../components/image_upload.vue'
import ImageUpdate from '../components/image_update.vue'

export default {
  name: 'MarksEdit',
  inject: [
    'roomId',
    'markId',
    'markImageUrl',
    'markTrimming',
    'mapId',
    'mapImageUrl',
    'mapTrimming'
  ],
  data() {
    return {
      formData: null
    }
  },
  components: {
    ImageEdit,
    ImageUpload,
    ImageUpdate
  },
  methods: {
    getFormData(formData) {
      this.formData = formData
    }
  },
  async created() {
    if (this.formData) return

    this.formData = new FormData()
    this.formData.append('map[image_url]', this.mapImageUrl)
    this.formData.append('map[trimming]', this.mapTrimming)
  }
}
</script>
