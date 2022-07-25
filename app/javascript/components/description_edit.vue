<template>
  <section id="description-edit">
    <div class="form-control w-full px-4">
      <input type="text" placeholder="キズ概要" v-model="description"
             @blur="emitData" id="edit-description"
             :maxlength="maxLength"
             class="input input-bordered w-full" />
      <label class="label flex justify-end">
        <span id="text-length" class="label-text-alt">{{ descriptionLength }}/{{ maxLength }}</span>
      </label>
    </div>
  </section>
</template>
<script>
import params from '../modules/params'

export default {
  name: 'DescriptionEdit',
  props: [
    'formData'
  ],
  data() {
    return {
      description: null,
      descriptionLength: 0,
      maxLength: 60
    }
  },
  methods: {
    emitData() {
      const formData = params.renewFormData(this.formData)
      const target = formData.get('target')
      formData.set(`${target}[description]`, this.description)
      this.$emit('emitFormData', formData)
    }
  },
  mounted() {
    const target = this.formData.get('target')
    this.description = this.formData.get(`${target}[description]`)
  },
  updated() {
    this.descriptionLength = this.description ? this.description.length : 0
  }
}
</script>
