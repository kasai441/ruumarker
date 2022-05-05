<template>
  <div id="image-update" class="flex justify-center relative z-60">
    <a @click="switchImageEdit" id="show" class="btn btn-secondary">キャンセル</a>
    <a @click="update" id="update" class="btn btn-primary">登録</a>
  </div>
</template>

<script>
import api from '../modules/api'

export default {
  name: 'ImageUpdate',
  props: [
    'roomId',
    'mapId',
    'trimming',
    'imageFile',
    'imageUrl',
    'targetModel'
  ],
  methods: {
    async update() {
      const formData = new FormData()
      formData.append('map[trimming]', JSON.stringify(this.trimming))
      if (this.imageFile) formData.append('map[image]', this.imageFile)
      formData.append('map[image_url]', this.imageUrl)

      const response = await api.actions.update(`/api/rooms/${this.roomId}/${this.targetModel}s/${this.mapId}`, formData)
      location.href = `/rooms/${this.roomId}/maps/${response.id}/edit`
    },
    switchImageEdit() {
      this.$emit('switchImageEdit', false)
    }
  }
}
</script>
