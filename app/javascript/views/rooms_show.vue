<template>
  <section>
    <div class="flex flex-col items-center">
      <h2 class="w-field font-h2">キズ点検表</h2>
      <image-show :room-id="roomId" :form-data="formData"
                  locators-model="mark" :locators-json="marks"
                  @emit-form-data="getFormData"></image-show>
      <div v-if="marksPresent">
        <locators-index :room-id="roomId" :locators="marks" locators-model="mark"></locators-index>
      </div>
      <div v-else class="w-field h-28 rounded-lg bg-slate-100 flex justify-center items-center">
        キズを追加できます
      </div>
    </div>
    <a id="create-mark" @click='newMark'
        @pointerdown="unbindHalfvanish" @pointerup="halfvanish"
        class="new-mark fixed z-10 flex flex-col items-center">
      <img src="/new_mark.png" width="50">
      <svg viewBox="0 0 52 17" width="52" height="17">
        <text x="0" y="0" dominant-baseline="text-before-edge" class="font-btn font-bg">キズ追加</text>
        <text x="0" y="0" dominant-baseline="text-before-edge" class="font-btn fill-lime-600">キズ追加</text>
      </svg>
    </a>
    <div class="h-20"></div>
  </section>
</template>

<script>
import ImageShow from '../components/image_show.vue'
import LocatorsIndex from '../components/locators_index.vue'
import tags from '../modules/tags'
import params from '../modules/params'

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
      formData: null,
      marksPresent: this.areMarks()
    }
  },
  components: {
    LocatorsIndex,
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
    areMarks() {
      return JSON.parse(this.marks).length > 0
    },
    print() {
      location.href = `/rooms/${this.roomId}/reports`
    },
  },
  created() {
    this.formData = params.initFormData(this.map)
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
