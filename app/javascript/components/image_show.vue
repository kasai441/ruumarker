<template>
  <div>
    <h2>ImageShow</h2>
    <div class="image">
      <img v-if="imageUrl" :src="imageUrl"/>
      <div class="submit_container">
        <a @click="switchImageEdit">編集</a>
      </div>
    </div>
  </div>
</template>

<script>

export default {
  name: 'ImageShow',
  props: [
    'imageUrl',
  ],
  methods: {
    switchImageEdit() {
      this.$emit('switchImageEdit', true)
    }
  }
}
</script>
