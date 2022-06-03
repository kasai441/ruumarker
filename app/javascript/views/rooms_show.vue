<template>
  <section>
      <image-show :room-id="roomId" :id="mapId" field-model="map" :image-url="mapImageUrl" :trimming="mapTrimming"
                  locators-model="mark" :locators-json="marks"
                  @emit-form-data="getFormData"></image-show>
      <div class="flex flex-col items-center">
        <div class="absolute w-field h-48 flex flex-row-reverse items-end">
          <img src="/new_mark.png" @click='newMark' @pointerdown="unbindHalfvanish" @pointerup="halfvanish"
             id="create-mark" class="absolute z-10" width="50">
        </div>
      </div>
  </section>
</template>

<script>
import ImageShow from '../components/image_show.vue'
import tags from '../modules/tags'

export default {
  name: 'RoomsShow',
  inject: [
    'roomId',
    'marks',
    'map',
  ],
  data() {
    return {
      mapId: null,
      mapImageUrl: null,
      mapTrimming: null,
      formData: null
    }
  },
  components: {
    ImageShow
  },
  methods: {
    getFormData(formData) {
      this.formData = formData
    },
    newMark() {
      location.href = `/rooms/${this.roomId}/marks/new`
    },
    halfvanish(e) {
      tags.parent('IMG', e.target).classList.add('animate-halfvanish')
    },
    unbindHalfvanish(e) {
      tags.parent('IMG', e.target).classList.remove('animate-halfvanish')
    },
    print() {
      window.print()
    }
  },
  created() {
    const map = JSON.parse(this.map)
    this.mapId = map['id']
    this.mapImageUrl = map['image_url']
    this.mapTrimming = map['trimming']
  },
  mounted() {
    const download = document.getElementById('download')
    download.classList.remove('hidden')
    download.addEventListener('click', this.print)
  },
  beforeDestroy() {
    const download = document.getElementById('download')
    download.removeEventListener('click', this.print)
  }
}
</script>
