<template>
  <div id="maps-new">
    <image-upload targetModel="map" @form="form"></image-upload>
    <section v-if="formData" class="submit_container">
      <a @click="create(room_path)" id="submit" class="btn btn-primary">登録</a>
      <a @click="edit" id="edit" class="btn btn-secondary">編集</a>
    </section>
  </div>
</template>

<script>
import api from '../modules/api'
import ImageUpload from '../components/image_upload.vue'

export default {
  name: 'MapsNew',
  inject: ['roomId'],
  data() {
    return {
      formData: null,
      isCreated: false,
      isImageEdit: false,
      room_path: `/rooms/${this.roomId}`,
    }
  },
  components: {
    ImageUpload
  },
  methods: {
    form(data) {
      this.formData = data
    },
    imageEdit(boolean) {
      this.isImageEdit = boolean
    },
    async create(path) {
      this.formData.append('room_id', this.roomId)
      const response = await api.actions.create('/api/maps', this.formData)

      path ||= `/rooms/${this.roomId}/maps/${response.id}/edit`
      location.href = path
    },
    edit() {
      this.create(null)
    }
  }
}
</script>
