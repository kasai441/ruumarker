<template>
  <section id="description-edit">
    <div class="form-control w-full p-4">
      <input type="text" placeholder="キズ概要" v-model="description"
             @blur="emitData" id="edit-description"
             :maxlength="maxLength"
             class="input input-bordered w-full" />
      <label class="label flex justify-end">
        <span id="text-length" class="label-text-alt">{{ String(description).length }}/{{ maxLength }}</span>
      </label>
    </div>
  </section>
</template>
<script>
import params from '../modules/params'

export default {
  name: 'DescriptionEdit',
  props: [
    'formData',
    'targetModel'
  ],
  data() {
    return {
      description: null,
      maxLength: 60
    }
  },
  methods: {
    emitData() {
      const formData = params.renewFormData(this.formData)
      formData.set(`${this.targetModel}[description]`, this.description)
      this.$emit('emitFormData', formData)
    }
  },
  mounted() {
    this.description = this.formData.get(`${this.targetModel}[description]`)
  }
}
</script>
