<template>
  <section id="image-update">
    <div>{{ trimming }}</div>
    <a @click="switchImageEdit" id="show" class="btn btn-secondary">キャンセル</a>
    <a @click="update" id="submit" class="btn btn-primary">登録</a>
  </section>
</template>

<script>
import api from '../modules/api'

export default {
  name: 'ImageUpdate',
  props: [
    'roomId',
    'mapId',
    'formData',
    'targetModel'
  ],
  data() {
    return {
      trimming: this.formData.get('map[trimming]')
    }
  },
  methods: {
    async update() {
      // this.formData.append('map[trimming]', 'wowow')
      const response = await api.actions.update(`/api/${this.targetModel}s/${this.mapId}`, this.formData)
      location.href = `/rooms/${this.roomId}/maps/${response.id}/edit`
    },
    switchImageEdit() {
      this.$emit('switchImageEdit', false)
    }
  }
}
</script>
