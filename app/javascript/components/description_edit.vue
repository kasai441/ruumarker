<template>
  <section id="description-edit">
    <div class="form-control w-full">
      <label class="label">
        <span class="label-text">キズの概要を記入してください</span>
      </label>
      <input type="text" placeholder="キズ概要" v-model="description" id="edit-description" class="input input-bordered w-full" />
    </div>
  </section>
</template>
<script>
export default {
  name: 'DescriptionEdit',
  props: [
    'formData',
    'targetModel'
  ],
  data() {
    return {
      description: null
    }
  },
  mounted() {
    this.description = this.formData.get(`${this.targetModel}[description]`)
  },
  updated() {
    this.formData.set(`${this.targetModel}[description]`, this.description)
    this.$emit('emitFormData', this.formData)
  }
}
</script>
