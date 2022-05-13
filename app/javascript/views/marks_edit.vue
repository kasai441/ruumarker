<template>
  <section>
    <div class="flex flex-col items-center">
      <h1>キズ情報</h1>
      <div @touchmove.prevent>
        <image-edit :form-data="formData" target-model="mark" @emit-form-data="getFormData"></image-edit>
        <image-upload target-model="mark" @emit-form-data="getFormData"></image-upload>
        <image-update :room-id="roomId" :id="markId" :form-data="formData" target-model="mark"></image-update>
      </div>
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
    this.markImageUrl ||= '/sample.png'
    this.formData.append('mark[image_url]', this.markImageUrl)
    this.formData.append('mark[trimming]', this.markTrimming)
  }
}
</script>
